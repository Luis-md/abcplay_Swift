//
//  LoadingView.swift
//  abcplay
//
//  Created by Luis Domingues on 18/10/20.
//  Copyright © 2020 Luis Domingues. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LoadingView: UIView {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.alpha = 0.75
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let loading: NVActivityIndicatorView = {
        let loading = NVActivityIndicatorView(frame: .zero, type: .lineScale, color: .blue, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        return loading
    }()
    
    public func startLoading(vc: UIViewController) {
        vc.view.addSubview(containerView)
        vc.view.addSubview(loading)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: vc.view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor),
            containerView.leftAnchor.constraint(equalTo: vc.view.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: vc.view.rightAnchor),
        ])
        
        NSLayoutConstraint.activate([
            loading.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            loading.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor),
            loading.widthAnchor.constraint(equalToConstant: 50),
            loading.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        loading.startAnimating()
    }
    
    public func stopLoading(vc: UIViewController) {
        containerView.removeFromSuperview()
        loading.removeFromSuperview()
    }
}
