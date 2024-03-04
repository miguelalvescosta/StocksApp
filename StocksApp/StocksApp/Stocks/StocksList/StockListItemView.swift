//
//  StockListItemView.swift
//  StocksApp
//
//  Created by Miguel Costa on 04.03.24.
//

import SwiftUI
struct StockListItemView: View {
    private let item: StockItemProtocol
    
    var regularMarketChangeColor: Color {
        item.isNegativeMarketValue ? .red : .green
    }


    init(item: StockItemProtocol) {
        self.item = item
    }

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Spacer()
                Text(item.shortName)
                    .multilineTextAlignment(.leading)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.white)
                Text(item.fullName)
                    .multilineTextAlignment(.leading)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.white)
                Spacer()
            }
            Spacer()

            VStack(alignment: .trailing) {
                Text(item.currentValue)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.white)
                Text(item.regularMarketChange)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(regularMarketChangeColor)
                        )
            }
        }.padding()
    }
}
