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
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var register: UIButton!
    
    private var state: State = .ready {
      didSet {
        switch state {
        case .ready:
            loading.stopLoading(vc: self)
        case .success:
            loading.stopLoading(vc: self)
            let vc = HomeViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case .loading:
            loading.startLoading(vc: self)
        case .error(let msg, let type):
            loading.stopLoading(vc: self)
            let storyboard = UIStoryboard(name: "Dialog", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DialogViewController") as! DialogViewController
            vc.setupDialog(msg: msg, iconType: type)
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
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
        self.login.layer.cornerRadius = 5
        self.register.layer.cornerRadius = 5
        self.transparentNavigation()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func registerButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Register", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        if let email = emailTxtField.text,
           let password = passwordTextField.text,
           !email.isEmpty && !password.isEmpty {
            state = .loading
            self.viewModel.login(email: email, password: password) { (success, apiError) in
                if let error = apiError {
                    self.state = .error(msg: error.localizedDescription, type: IconType.warning)
                    print(error.localizedDescription)
                } else {
                    if !success {
                        self.state = .error(msg: "Senha ou usuário incorretos", type: IconType.error)
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
    case error(msg: String, type: IconType)
    case success
  }
}
