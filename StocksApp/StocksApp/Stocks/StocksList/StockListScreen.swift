//
//  StockListScreen.swift
//  StocksApp
//
//  Created by Miguel Costa on 04.03.24.
//

import SwiftUI

struct StockListScreen: View {
    @Environment(\.locale) private var locale
    @ObservedObject private var viewModel: StockListViewModel
    @State private var name = ""
    private let gridSpacing: CGFloat = 16
    init(viewModel: StockListViewModel = .init()) {
        self.viewModel = viewModel
    }
    var body: some View {
        NavigationView {
            ZStack {
                switch viewModel.state {
                case .initial:
                    ProgressView()
                case .loaded:
                    listStocksView()
                case .error:
                    Button("Retry", action: {
                        performFetchStocks()
                    })
                default:
                    EmptyView()
                }
            }.onAppear {
                performFetchStocks()
            }
            .background(.black)
        }
    }

    private func performFetchStocks() {
        Task {
            await viewModel.fetchStocks()
            await viewModel.fetchQuotes()
        }
    }

    private func listStocksView() -> some View {
        ScrollView {
            VStack {
                if let items = viewModel.stocksList {
                    ForEach(items) { item in
                        StockListItemView(item: item)
                        Divider()
                            .background(Color.white)
                    }
                }
            }
            .padding()
        }.navigationBarHidden(false)
    }
}
