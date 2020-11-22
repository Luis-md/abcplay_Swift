//
//  DesempenhoCell.swift
//  abcplay
//
//  Created by Luis Domingues on 22/11/20.
//  Copyright © 2020 Luis Domingues. All rights reserved.
//

import UIKit
class DesempenhoCell: UITableViewCell {
    
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
    
    let acertosLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica Neue", size: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let errosLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica Neue", size: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.fontAwesome(ofSize: 40, style: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica Neue", size: 20)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
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
    
    func bind(acertos: Int, erros: Int, title: String, date: String) {
        self.acertosLabel.text = "Acertos: \(acertos)"
        self.errosLabel.text = "Erros: \(erros)"
        self.titleLabel.text = "Título: \(title)"
        self.dateLabel.text = "Realizado em: \(date)"
        
        let aproveitamento = Double((Double(acertos) / Double(acertos + erros)) * 100)
        if aproveitamento > 80 {
            self.container.layer.borderWidth = 2
            self.container.layer.borderColor = UIColor(red: 27/255.0, green: 55/255.0, blue: 133/255.0, alpha: 1.0).cgColor
            self.emojiLabel.text = String.fontAwesomeIcon(name: .laughBeam)
        } else if aproveitamento < 80 && aproveitamento >= 50 {
            self.container.layer.borderWidth = 2
            self.container.layer.borderColor = UIColor(red: 240/255.0, green: 212/255.0, blue: 2/255.0, alpha: 1.0).cgColor
            self.emojiLabel.text = String.fontAwesomeIcon(name: .grinBeamSweat)
        } else {
            self.container.layer.borderWidth = 2
            self.container.layer.borderColor = UIColor(red: 232/255.0, green: 19/255.0, blue: 19/255.0, alpha: 1.0).cgColor
            self.emojiLabel.text = String.fontAwesomeIcon(name: .grimace)
        }
    }
    
    private func config() {
        self.configLayout()
    }
    
    private func configLayout() {
        self.addSubview(container)
        self.container.addSubview(stack)
        self.container.addSubview(emojiLabel)
        self.stack.addArrangedSubview(titleLabel)
        self.stack.addArrangedSubview(acertosLabel)
        self.stack.addArrangedSubview(errosLabel)
        self.stack.addArrangedSubview(dateLabel)
        self.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            self.container.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            self.container.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            self.container.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            self.container.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            
            self.emojiLabel.centerYAnchor.constraint(equalTo: self.container.centerYAnchor),
            self.emojiLabel.rightAnchor.constraint(equalTo: self.container.rightAnchor, constant: -16),
            
            self.stack.topAnchor.constraint(equalTo: self.container.topAnchor, constant: 16),
            self.stack.rightAnchor.constraint(equalTo: self.emojiLabel.leftAnchor, constant: -16),
            self.stack.bottomAnchor.constraint(equalTo: self.container.bottomAnchor, constant: -16),
            self.stack.leftAnchor.constraint(equalTo: self.container.leftAnchor, constant: 16)
        ])
    }
}
