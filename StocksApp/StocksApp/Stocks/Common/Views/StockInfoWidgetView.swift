//
//  StockInfoWidgetView.swift
//  StocksApp
//
//  Created by Miguel Costa on 05.03.24.
//

import SwiftUI

struct StockInfoWidgetItem: Identifiable {
    var id = UUID()
    var value: String
    var title: String
}

struct StockInfoWidgetView: View {
    let items: [StockInfoWidgetItem]

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                ForEach(items) { item in
                    HStack {
                        Text(item.title)
                            .padding(.trailing, PaddingConstants.xxs)
                            .foregroundColor(.gray)
                        Text(item.value)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .frame(height: 100)
    }
}
