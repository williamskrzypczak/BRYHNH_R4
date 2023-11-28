//
//  TabbedView.swift
//  SwiftUI Webview List
//
//  Created by Bill Skrzypczak on 11/28/23.
//

import SwiftUI

struct TabbedContentView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("News", systemImage: "newspaper")
                }
            
            Text("Another Tab")
                .tabItem {
                    Label("More", systemImage: "ellipsis.circle")
                }
        }
    }
}

struct TabbedView_Previews: PreviewProvider {
    static var previews: some View {
        TabbedContentView()
    }
}
