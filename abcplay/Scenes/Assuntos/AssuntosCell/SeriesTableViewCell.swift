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

    let textContent: UILabel = {
        let txt = UILabel()
        txt.lineBreakMode = .byWordWrapping
        txt.numberOfLines = 0
        txt.textColor = .white
        txt.font = UIFont.systemFont(ofSize: 20)
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    func bind(txt: String, type: CellType) {
        self.textContent.text = type == CellType.serie ? "\(txt) série" : txt
        self.container.backgroundColor = UIColor.Colors.lightBlueButton
    }
    
    private func config() {
        self.configLayout()
    }
    
    private func configLayout() {
        self.addSubview(self.container)
        self.container.addSubview(self.textContent)

        NSLayoutConstraint.activate([
            self.container.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            self.container.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            self.container.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            self.container.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            
            self.textContent.topAnchor.constraint(equalTo: self.container.topAnchor, constant: 12),
            self.textContent.leftAnchor.constraint(equalTo: self.container.leftAnchor, constant: 15),
            self.textContent.bottomAnchor.constraint(equalTo: self.container.bottomAnchor, constant: -12)
        ])
    }
}

public enum CellType {
    case serie
    case questoes
}
