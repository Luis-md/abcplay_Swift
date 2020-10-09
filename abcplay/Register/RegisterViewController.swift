//
//  RegisterViewController.swift
//  abcplay
//
//  Created by Luis Domingues on 08/10/20.
//  Copyright © 2020 Luis Domingues. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var userTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    var viewModel: RegisterViewModel = RegisterViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.addCustomBackButton(title: "Voltar")
        self.activity.isHidden = true
        self.loadingView.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerBtn(_ sender: Any) {
        self.loadingView.isHidden = false
        self.activity.isHidden = false
        self.activity.startAnimating()
        
        if let user = userTxtField.text,
           let email = emailTxtField.text,
           let password = passwordTxtField.text,
           let confirmPass = confirmPassword.text,
           !user.isEmpty && !email.isEmpty && !password.isEmpty && !confirmPass.isEmpty {
            if confirmPass != password {
                let alert = UIAlertController(title: "Erro ❌", message: "Campos de senha não estão iguais", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            } else {
                self.viewModel.createUser(user: user, password: password, email: email) { type in
                    if(type == true) {
                        self.loadingView.isHidden = true
                        self.activity.isHidden = true
                        self.activity.stopAnimating()
                        print("user created")
                    }
                }
            }
        }
    }
}
