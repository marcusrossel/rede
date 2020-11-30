//
//  BookmarkReader.swift
//  Rede / App
//
//  Created by Marcus Rossel on 30.11.20.
//

import SwiftUI
import WebView

struct BookmarkReader: View {
    
    @StateObject private var storage: Storage = .shared
    @StateObject private var store = WebViewStore()
    @Environment(\.presentationMode) private var presentationMode
    
    @Binding var bookmark: Bookmark
    
    // `WKWebView` can't open *any* URL, so this is a cheap attempt at making it do so anyway.
    private var openableURL: URL {
        bookmark.url.absoluteString.hasPrefix("https://") ||
        bookmark.url.absoluteString.hasPrefix("http://")
            ? bookmark.url
            : URL(string: "https://" + bookmark.url.absoluteString)!
    }
    
    var body: some View {
        ZStack {
            WebView(webView: store.webView)
                .navigationBarHidden(true)
                .ignoresSafeArea()
                .onAppear {
                    let view = store.webView
                    
                    view.scrollView.contentInset = .init(top: 41, left: 0, bottom: 0, right: 0)
                    view.allowsBackForwardNavigationGestures = true
                    view.load(URLRequest(url: openableURL))
                }
            
            VStack {
                HStack {
                    leadingButtons
                    Spacer()
                    trailingButtons
                }
                .font(.system(size: 20, weight: .medium, design: .rounded))
                .background(Blur().ignoresSafeArea())
                
                Spacer()
            }
        }
    }
    
    private var leadingButtons: some View {
        HStack {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "xmark")
                    .padding(.init(top: 8, leading: 20, bottom: 12, trailing: 10))
                    .contentShape(Rectangle())
            }
            
            Button {
                store.webView.goBack()
            } label: {
                Image(systemName: "chevron.backward")
                    .padding(.init(top: 8, leading: 10, bottom: 12, trailing: 10))
                    .contentShape(Rectangle())
            }
            .disabled(!store.webView.canGoBack)
            
            Button {
                store.webView.goForward()
            } label: {
                Image(systemName: "chevron.forward")
                    .padding(.init(top: 8, leading: 10, bottom: 12, trailing: 10))
                    .contentShape(Rectangle())
            }
            .disabled(!store.webView.canGoForward)
        }
    }
    
    private var trailingButtons: some View {
        HStack {
            Button {
                #warning("Not updating UI.")
                bookmark.readDate = bookmark.isRead ? nil : Date()
                
                if let folderID = bookmark.folderID {
                    let folder = $storage.folders[permanent: folderID]
                    
                    // RACE CONDITION
                    let index = folder.wrappedValue.bookmarks.firstIndex(of: bookmark)!
                    folder.wrappedValue.bookmarks.move(fromOffsets: [index], toOffset: 0)
                }
            } label: {
                Image(systemName: "book\(bookmark.isRead ? ".fill" : "")")
                    .padding(.init(top: 8, leading: 10, bottom: 12, trailing: 10))
                    .contentShape(Rectangle())
            }
            
            Button {
                #warning("Not updating UI.")
                bookmark.isFavorite.toggle()
            } label: {
                Image(systemName: "star\(bookmark.isFavorite ? ".fill" : "")")
                    .padding(.init(top: 8, leading: 10, bottom: 12, trailing: 10))
                    .contentShape(Rectangle())
            }
            
            Link(destination: store.webView.url ?? openableURL) {
                Image(systemName: "safari")
                    .padding(.init(top: 8, leading: 10, bottom: 12, trailing: 20))
                    .contentShape(Rectangle())
            }
        }
    }
}

struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterial
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
