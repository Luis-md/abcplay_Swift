//
//  DialogViewController.swift
//  abcplay
//
//  Created by Luis Domingues on 21/11/20.
//  Copyright © 2020 Luis Domingues. All rights reserved.
//

import UIKit

class DialogViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var container: UIView!
    
    var iconFont: UIFont?
    var textIcon: String?
    var textMsg: String?
    var iconColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupLayout()
    }
    
    private func setupLayout() {
        self.container.layer.cornerRadius = 5
        self.okBtn.layer.cornerRadius = 5
        self.titleLabel.text = textIcon
        self.titleLabel.font = iconFont
        self.titleLabel.textColor = iconColor
        self.msgLabel.text = textMsg
    }
    
    func setupDialog(msg: String, iconType: IconType) {
        self.iconFont = UIFont.fontAwesome(ofSize: 22, style: .solid)
        self.textIcon = setIcon(icon: iconType)
        self.iconColor = setIconColor(icon: iconType)
        self.textMsg = msg
    }
    
    private func setIcon(icon: IconType) -> String {
        switch icon {
        case .error:
            return String.fontAwesomeIcon(name: .exclamationCircle)
        case .success:
            return String.fontAwesomeIcon(name: .checkCircle)
        case .warning:
            return String.fontAwesomeIcon(name: .exclamationTriangle)
        }
    }
    
    @IBAction func btnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    private func setIconColor(icon: IconType) -> UIColor {
        switch icon {
        case .error:
            return .red
        case .success:
            return .green
        case .warning:
            return .yellow
        }
    }
}

enum IconType {
    case error
    case success
    case warning
}
