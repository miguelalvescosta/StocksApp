//
//  View+Ext.swift
//  StocksApp
//
//  Created by Miguel Costa on 05.03.24.
//

import SwiftUI

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
