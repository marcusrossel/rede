//
//  ShareExtension.Controller.swift
//  Rede / Share Extension
//
//  Created by Marcus Rossel on 11.11.20.
//

import SwiftUI
import UIKit

extension ShareExtension {
    
    @objc(ShareExtensionController)
    final class Controller: UIViewController {
        
        private weak var model: Model?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            Storage.shared.load()
            
            let model = Model(controller: self)
            self.model = model
            
            let dialog = Sheet(model: model)
            
            // Adds the hosting controller that shows the share extension view.
            let hostingController = UIHostingController(rootView: dialog)
            addChild(hostingController)
            hostingController.didMove(toParent: self)
            overlay(view: hostingController.view)
        }
        
        /// A convenience function for completely overlaying the controller's view with a given
        /// view.
        private func overlay(view overlay: UIView) {
            view.addSubview(overlay)
            overlay.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                overlay.widthAnchor.constraint(equalTo: view.widthAnchor),
                overlay.heightAnchor.constraint(equalTo: view.heightAnchor),
                overlay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                overlay.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
    }

}
