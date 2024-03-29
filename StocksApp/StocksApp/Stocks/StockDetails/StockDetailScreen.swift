//
//  StockDetailScreen.swift
//  StocksApp
//
//  Created by Miguel Costa on 04.03.24.
//

import SwiftUI

struct StockDetailScreen: View {
    let chartViewHeight: CGFloat = 200
    let stockInfoHeight: CGFloat = 80
    let chartProgressViewHeight: CGFloat = 30

    @ObservedObject private var viewModel: StockDetailViewModel

    init(viewModel: StockDetailViewModel) {
        self.viewModel = viewModel
        configureTabs()
    }

    var body: some View {
        NavigationView {
            ZStack {
                switch viewModel.state {
                case .initial, .loading:
                    StocksLoadingView()
                case .loaded, .chartLoading:
                    VStack {
                        headerInfoView
                        segmentedTabsView

                        Group {
                            switch viewModel.selectedTimeInterval {
                            case .day:
                                chartView
                            case .week:
                                chartView
                            case .month:
                                chartView
                            case .ytd:
                                chartView
                            }
                        }

                        stockInfoWidget

                        Spacer()
                    }.background(.black)
                case .error:
                    StocksErrorView(retryAction: {
                        performFetchData()
                    })
                }
            }.onAppear {
                performFetchData()
            }
        }
    }

    var segmentedTabsView: some View {
        Picker(selection: $viewModel.selectedTimeInterval.animation()) {
            ForEach(StockTimeInterval.allCases) { interval in
                Text(interval.rawValue)
            }
        } label: {
            Text("Time interval")
        }
        .pickerStyle(.segmented)
        .padding(.top, PaddingConstants.xl)
        .padding(.horizontal, PaddingConstants.xs)
    }

    @ViewBuilder
    var chartView: some View{
        if viewModel.isChartLoading {
            VStack {
                Spacer()
                ProgressView()
                    .tint(.white)
                    .frame(height: chartProgressViewHeight)
                Spacer()
            }.frame(height: chartViewHeight)
        } else {
            StocksLinearChartView(data: viewModel.chartData, chartUnit: viewModel.chartUnit)
                .frame(height: chartViewHeight)
                .padding(.horizontal, PaddingConstants.xs)
                .padding(.top, PaddingConstants.xs)
        }
    }

    var headerInfoView: some View {
        VStack(alignment: .leading) {
            Text(viewModel.shortName)
                .multilineTextAlignment(.leading)
                .font(.caption.weight(.medium))
                .foregroundColor(.white)
                .padding(.leading, PaddingConstants.xs)
            Text(viewModel.longName)
                .multilineTextAlignment(.leading)
                .font(.caption2)
                .foregroundColor(.white)
                .padding(.leading, PaddingConstants.xs)
            HStack(alignment: .bottom) {
                Text("ISIN:")
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.white)
                    .padding(.leading, PaddingConstants.xs)

                Text(viewModel.isin)
                    .multilineTextAlignment(.leading)
                    .font(.caption2)
                    .foregroundColor(.white)
            }
            Divider()
                .background(.white)

            HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                Text(viewModel.currentValue)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.white)
                    .padding(.leading, PaddingConstants.xs)
                Text(viewModel.regularMarketChange)
                    .font(.caption.weight(.medium))
                    .foregroundColor(viewModel.isNegativeValue ? .red : .green)
                Spacer()
            }
        }
    }

    var stockInfoWidget: some View {
        HStack {
            StockInfoWidgetView(items: viewModel.stockInfoFirstColumn)
            Divider()
                .background(.white)
                .frame(height: stockInfoHeight)
            StockInfoWidgetView(items: viewModel.stockInfoSecondColumn)
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, PaddingConstants.xs)
    }

    private func performFetchData() {
        Task {
            await viewModel.fetchData()
        }
    }
    
    private func configureTabs() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .white
        UISegmentedControl.appearance().backgroundColor = .gray
        UISegmentedControl.appearance().setTitleTextAttributes([.font : UIFont.preferredFont(forTextStyle: .largeTitle)], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor.black], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor.white], for: .normal)
    }
}
