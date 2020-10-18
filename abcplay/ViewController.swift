//
//  ViewController.swift
//  abcplay
//
//  Created by Luis Domingues on 13/09/20.
//  Copyright © 2020 Luis Domingues. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    private var state: State = .ready {
      didSet {
        switch state {
        case .ready:
            loading.stopLoading(vc: self)
        case .success:
            loading.stopLoading(vc: self)
            let vc = HomeViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        case .loading:
            loading.startLoading(vc: self)
        case .error:
            loading.stopLoading(vc: self)
        }
      }
    }

    
    let loading = LoadingView()
    let viewModel = ViewModel()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    private func initialSetup() {
        self.transparentNavigation()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func registerButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Register", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        state = .loading
        if let email = emailTxtField.text,
           let password = passwordTextField.text,
           !email.isEmpty && !password.isEmpty {
            self.viewModel.login(email: email, password: password) { (success, apiError) in
                if let error = apiError {
                    self.state = .error
                    print(error.localizedDescription)
                } else {
                    if !success {
                        self.state = .error
                    } else {
                        self.state = .success
                    }
                }
            }
        }
    }
    
}

extension ViewController {
  enum State {
    case loading
    case ready
    case error
    case success
  }
}
