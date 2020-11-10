//
//  SeriessTableViewCell.swift
//  abcplay
//
//  Created by Luis Domingues on 25/10/20.
//  Copyright © 2020 Luis Domingues. All rights reserved.
//
import UIKit
class SeriesTableViewCell: UITableViewCell {
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.config()
        self.accessoryType = .disclosureIndicator
     }
     required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        self.config()
     }
    
    let textContent: UILabel = {
        let txt = UILabel()
        txt.lineBreakMode = .byWordWrapping
        txt.numberOfLines = 0
        txt.textColor = .white
        txt.font = UIFont.systemFont(ofSize: 24)
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    func bind(txt: String) {
        self.textContent.text = txt
    }
    
    private func config() {
        self.configLayout()
    }
    
    private func configLayout() {
        self.addSubview(self.textContent)
        self.backgroundColor = UIColor(red: 67/255.0, green: 159/255.0, blue: 104/255.0, alpha: 1.0)
        NSLayoutConstraint.activate([
            self.textContent.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            self.textContent.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            self.textContent.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            self.textContent.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16)
        ])
    }
}
