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
    @IBOutlet weak var cancelarBtn: UIButton!
    @IBOutlet weak var btnStack: UIStackView!
    
    private var iconFont: UIFont?
    private var textIcon: String?
    private var textMsg: String?
    private var iconColor: UIColor?
    private var action = {}
    private var hideCancel: Bool = true
    
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
        if hideCancel {
            btnStack.removeArrangedSubview(self.cancelarBtn)
        }
    }
    
    func setupDialog(msg: String, iconType: IconType, hideCancel: Bool = true, action: @escaping () -> Void) {
        self.iconFont = UIFont.fontAwesome(ofSize: 28, style: .solid)
        self.textIcon = setIcon(icon: iconType)
        self.iconColor = setIconColor(icon: iconType)
        self.action = action
        self.textMsg = msg
        self.hideCancel = hideCancel
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
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnPressed(_ sender: Any) {
        self.action()
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
