//
//  StocksLoadingView.swift
//  StocksApp
//
//  Created by Miguel Costa on 06.03.24.
//

import Foundation
import SwiftUI

struct StocksLoadingView: View {
    let progressHeight: CGFloat = 30
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .frame(height: progressHeight)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
    }
}
