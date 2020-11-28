//
//  AddProfessorCell.swift
//  abcplay
//
//  Created by Luis Domingues on 28/11/20.
//  Copyright © 2020 Luis Domingues. All rights reserved.
//

import UIKit
class AddProfessorCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.config()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.config()
    }
    
    let container: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica Neue", size: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let removeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.fontAwesome(ofSize: 24, style: .solid)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica Neue", size: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    let stack: UIStackView = {
        let st = UIStackView(frame: .zero)
        st.distribution = .fill
        st.alignment = .leading
        st.axis = .vertical
        st.translatesAutoresizingMaskIntoConstraints = false
        st.spacing = 8
        return st
    }()
    
    func bind(name: String, email: String, pos: Int, isAdded: Bool) {
        self.container.backgroundColor = UIColor.Colors.blueTitle
        self.usernameLabel.text = name
        self.emailLabel.text = email
        
        if isAdded {
            removeLabel.text = String.fontAwesomeIcon(name: .userMinus)
            removeLabel.textColor = UIColor.Colors.abcRed
        } else {
            removeLabel.text = String.fontAwesomeIcon(name: .userPlus)
            removeLabel.textColor = UIColor.Colors.abcGreen
        }
    }
    
    private func config() {
        self.configLayout()
    }
    
    private func configLayout() {
        self.addSubview(container)
        self.container.addSubview(stack)
        self.container.addSubview(removeLabel)
        self.stack.addArrangedSubview(usernameLabel)
        self.stack.addArrangedSubview(emailLabel)
        self.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            self.container.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            self.container.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            self.container.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            self.container.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            
            self.removeLabel.centerYAnchor.constraint(equalTo: self.container.centerYAnchor),
            self.removeLabel.rightAnchor.constraint(equalTo: self.container.rightAnchor, constant: -16),
            
            self.stack.topAnchor.constraint(equalTo: self.container.topAnchor, constant: 16),
            self.stack.rightAnchor.constraint(equalTo: self.removeLabel.leftAnchor, constant: -16),
            self.stack.bottomAnchor.constraint(equalTo: self.container.bottomAnchor, constant: -16),
            self.stack.leftAnchor.constraint(equalTo: self.container.leftAnchor, constant: 16)
        ])
    }
}
