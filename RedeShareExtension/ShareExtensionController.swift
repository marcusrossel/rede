//
//  ShareExtensionController.swift
//  RedeShareExtension
//
//  Created by Marcus Rossel on 29.08.20.
//

import SwiftUI
import UIKit
import Social

@objc(ShareExtensionController)
final class ShareExtensionController: UIHostingController<EmptyView/*ShareExtensionView*/>, ObservableObject {
    
    private let data = ShareExtensionData()
    
    override init(nibName: String?, bundle: Bundle?) {
        super.init(rootView: EmptyView()/*ShareExtensionView(shareExtensionData: data)*/)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        data.update(for: self)
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
