//
//  StockListScreen.swift
//  StocksApp
//
//  Created by Miguel Costa on 04.03.24.
//

import SwiftUI

struct StockListScreen: View {
    @ObservedObject private var viewModel: StockListViewModel

    init(viewModel: StockListViewModel = .init()) {
        self.viewModel = viewModel
    }
    var body: some View {
        NavigationStack {
            ZStack {
                switch viewModel.state {
                case .initial, .loading:
                    ProgressView()
                        .background(.white)
                        .frame(height: 30)
                case .loaded, .refresh:
                    listStocksView()
                case .error:
                    Button("Retry", action: {
                        performFetchStocks()
                    })
                }
            }.onAppear {
                UIRefreshControl.appearance().tintColor = .white
                if viewModel.stocksList.isEmpty {
                    performFetchStocks()
                }
            }
            .refreshable {
                performFetchStocks(.refresh)
            }
            .background(.black)
        }
    }

    private func performFetchStocks(_ state: StockListState = .loading) {
        Task {
            await viewModel.fetchStocks(state)
            await viewModel.fetchQuotes()
        }
    }

    private func listStocksView() -> some View {
        ScrollView {
            VStack {
                ForEach(viewModel.stocksList) { item in
                    NavigationLink(destination: NavigationLazyView(StockDetailScreen(viewModel: .init(stockItem: item)))) {
                        StockListItemView(item: item)
                    }
                    Divider()
                        .background(.white)
                }
            }
            .padding()
        }.navigationBarHidden(false)
    }
}
