//
//  RegisterViewController.swift
//  abcplay
//
//  Created by Luis Domingues on 08/10/20.
//  Copyright © 2020 Luis Domingues. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
class RegisterViewController: UIViewController {
    @IBOutlet weak var userTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    let loading = LoadingView()
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    var viewModel: RegisterViewModel = RegisterViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.addCustomBackButton(title: "Voltar")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerBtn(_ sender: Any) {
        self.loading.startLoading(vc: self)
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
                self.viewModel.createUser(user: user, password: password, email: email) { (success, error)  in
                    if let errorResponse = error {
                        self.loading.stopLoading(vc: self)
                        let alert = UIAlertController(title: "Erro ❌", message: "Tente novamente mais tarde -> \(errorResponse.localizedDescription)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    } else {
                        self.loading.stopLoading(vc: self)
                    }
                }
            }
        }
    }
}
