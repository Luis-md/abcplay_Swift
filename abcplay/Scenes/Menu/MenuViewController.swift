//
//  MenuViewController.swift
//  abcplay
//
//  Created by Luis Domingues on 12/11/20.
//  Copyright © 2020 Luis Domingues. All rights reserved.
//

import UIKit
class MenuViewController: UIViewController {
    @IBOutlet weak var desempenhoIcon: UILabel!
    @IBOutlet weak var desempenhoLabel: UILabel!
    @IBOutlet weak var desempenhoView: UIView!
    
    @IBOutlet weak var professoresView: UIView!
    @IBOutlet weak var professoresIcon: UILabel!
    @IBOutlet weak var professoresLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupIcons()
        setupViewTap()
    }
    
    private func setupIcons() {
        desempenhoView.layer.cornerRadius = 5
        desempenhoIcon.font = UIFont.fontAwesome(ofSize: 50, style: .solid)
        desempenhoIcon.text = String.fontAwesomeIcon(name: .chartLine)
        professoresView.layer.cornerRadius = 5
        professoresIcon.font = UIFont.fontAwesome(ofSize: 50, style: .solid)
        professoresIcon.text = String.fontAwesomeIcon(name: .chalkboardTeacher)
    }
    
    private func setupNavBar() {
        self.navigationController?.addCustomBackButton(title: "Voltar")
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.title = "MENU"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

    }
    private func setupViewTap() {
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(goToDesempenho))
        self.desempenhoView.isUserInteractionEnabled = true
        self.desempenhoView.addGestureRecognizer(viewTap)
    }
    
    @objc private func goToDesempenho() {
        let vc = DesempenhoViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
