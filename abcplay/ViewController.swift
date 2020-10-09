//
//  ViewController.swift
//  abcplay
//
//  Created by Luis Domingues on 13/09/20.
//  Copyright © 2020 Luis Domingues. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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
}

