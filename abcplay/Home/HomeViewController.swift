//
//  HomeViewController.swift
//  abcplay
//
//  Created by Luis Domingues on 18/10/20.
//  Copyright © 2020 Luis Domingues. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let homeViewModel = HomeViewModel()
    
    private var state: State = .ready {
      didSet {
        switch state {
        case .ready:
            loading.stopLoading(vc: self)
        case .success:
            loading.stopLoading(vc: self)
        case .loading:
            loading.startLoading(vc: self)
        case .error:
            loading.stopLoading(vc: self)
        }
      }
    }
    
    let labelTitle: UILabel = {
        let label = UILabel()
        label.text = "Welcome, user"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let loading = LoadingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Home"
        self.initialSetup()
        self.layout()
        self.loadUser()
    }
    
    private func initialSetup() {
        self.transparentNavigation()
        self.hideKeyboardWhenTappedAround()
    }
    
    private func loadUser() {
        state = .loading
        self.homeViewModel.getUser { (user, status, error) in
            if let err = error {
                self.state = .error
                print(err.localizedDescription)
            } else {
                if let userLog = user {
                    self.state = .success(userLog)
                    self.labelTitle.text = "Welcome, \(userLog.username)"
                }
            }
        }

    }
}

extension HomeViewController {
  enum State {
    case loading
    case ready
    case error
    case success(User)
  }
}

extension HomeViewController {
    func layout() {
        self.view.backgroundColor = .white
        self.view.addSubview(labelTitle)
        
        NSLayoutConstraint.activate([
            self.labelTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.labelTitle.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
}
