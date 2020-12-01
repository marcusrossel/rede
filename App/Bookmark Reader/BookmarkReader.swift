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
    
    @State private var showToolbar = true
    @StateObject private var scrollHandler = ScrollHandler()
    
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
        GeometryReader { proxy in
            ZStack {
                WebView(webView: store.webView)
                    .navigationBarHidden(true)
                    .ignoresSafeArea()
                    .onAppear {
                        let view = store.webView
                        
                        scrollHandler.webView = view
                        scrollHandler.onFastScroll = { direction in
                            let directionIsUp = direction == .up
                            guard showToolbar != directionIsUp else { return }
                            withAnimation(.linear(duration: 0.1)) { showToolbar = directionIsUp }
                        }
                        
                        view.scrollView.contentInset =
                            .init(top: proxy.safeAreaInsets.top, left: 0, bottom: 0, right: 0)
                        view.allowsBackForwardNavigationGestures = true
                        view.load(URLRequest(url: openableURL))
                    }
                
                VStack {
                    if showToolbar {
                        HStack {
                            leadingButtons
                            Spacer()
                            trailingButtons
                        }
                        .transition(.move(edge: .top))
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .background(Blur().ignoresSafeArea())
                        
                    // WORKAROUND
                    // Until `.statusBar(hidden:)` is fixed: https://developer.apple.com/forums/thread/653153
                    } else {
                        Blur()
                            .ignoresSafeArea()
                            .frame(maxHeight: 0)
                    }
                    
                    Spacer()
                }
                .onChange(of: showToolbar) { toolbarIsShowing in
                    store.webView.scrollView.contentInset =
                        .init(top: toolbarIsShowing ? proxy.safeAreaInsets.top : 0, left: 0, bottom: 0, right: 0)
                }
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
