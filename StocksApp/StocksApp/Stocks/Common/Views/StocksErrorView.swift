//
//  StocksErrorView.swift
//  StocksApp
//
//  Created by Miguel Costa on 06.03.24.
//

import SwiftUI

struct StocksErrorView: View {
    let radius: CGFloat = 8
    let retryAction: () -> Void

    var body: some View {
        VStack {
            Text("Something went wrong...")
                .font(.headline)
                .foregroundColor(.red)
                .padding()

            Button(action: {
                retryAction()
            }) {
                Text("Retry")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(radius)
            }
            .padding()
        }
    }
}
