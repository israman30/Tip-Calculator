//
//  PreviewView.swift
//  TipCalc
//
//  Created by Israel Manzo on 10/26/23.
//  Copyright © 2023 Israel Manzo. All rights reserved.
//

import SwiftUI

// MARK: - Helper struct will help to display any UIViewController or UIView in a canvas preview within the app

struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
    
    let viewController: ViewController
    
    init(with builder: @escaping() -> ViewController) {
        self.viewController = builder()
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

struct UIViewPreview<View: UIView>: UIViewRepresentable {
   
    let view: View
    
    init(with builder: @escaping() -> View) {
        self.view = builder()
    }
    
    func makeUIView(context: Context) -> UIView {
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}
