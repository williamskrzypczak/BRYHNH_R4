//
//  ContentView.swift
//  SwiftUI Webview List
//
//  Created by Bill Skrzypczak on 11/13/23.
//

import SwiftUI
import WebKit
import AVKit

//---------------------------------------------]
//
// Setup the main Content View
//
//---------------------------------------------]

struct ContentView: View {
    @State private var items: [RSSItem] = []

    var body: some View {
        NavigationView {
            List(items, id: \.title) { item in
                if #available(iOS 15.0, *) {
                    if #available(iOS 16.0, *) {
                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(.headline)
                            
                            WebViewWrapper(htmlContent: item.htmlContent)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            
                            
                        } .listRowSeparatorTint(.red, edges: .all).frame(minHeight: 305)
                            .scrollContentBackground(.hidden)
                            .background(Color.yellow.edgesIgnoringSafeArea(.all))
                    } else {
                        // Fallback on earlier versions
                    }
                } else {
                    // Fallback on earlier versions
                }
                
            }
            .navigationTitle("BRYHNH")
            .onAppear {
                fetchRSSFeed()
            }
        }
    }

    
//---------------------------------------------------]
//
// Grab the stuff I need from the RSS feed
//
//---------------------------------------------------]

    func fetchRSSFeed() {
        if let url = URL(string: "https://www.bestradioyouhaveneverheard.com/podcasts/index.xml") {
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let data = data {
                    parseRSS(data: data)
                } else if let error = error {
                    print("Error fetching RSS feed: \(error.localizedDescription)")
                }
            }
            task.resume()
        }
    }

    func parseRSS(data: Data) {
        let parser = XMLParser(data: data)
        let rssParserDelegate = RSSParserDelegate()
        parser.delegate = rssParserDelegate

        if parser.parse() {
            items = rssParserDelegate.items
        } else {
            print("Error parsing RSS feed.")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct RSSItem: Identifiable {
    let id = UUID()
    var title: String
    var htmlContent: String
    var mp3URL: URL?
}

class RSSParserDelegate: NSObject, XMLParserDelegate {
    var currentItem: RSSItem?
    var currentElement: String = ""
    var items: [RSSItem] = []

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        currentElement = elementName
        if elementName == "item" {
            currentItem = RSSItem(title: "", htmlContent: "")
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if !data.isEmpty {
            switch currentElement {
            case "title":
                currentItem?.title += data
            case "description":
                currentItem?.htmlContent += data
            default:
                break
            }
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            if let item = currentItem {
                items.append(item)
            }
            currentItem = nil
        }
    }
}

struct WebViewWrapper: View {
    let htmlContent: String

    var body: some View {
        WebView(htmlContent: htmlContent)
    }
}

struct WebView: UIViewRepresentable {
    let htmlContent: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlContent, baseURL: nil)
    }
}

struct ContentView1: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
