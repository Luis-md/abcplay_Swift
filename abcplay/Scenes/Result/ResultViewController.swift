//
//  ResultViewController.swift
//  abcplay
//
//  Created by Luis Domingues on 08/11/20.
//  Copyright © 2020 Luis Domingues. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    var acertos: Int = 0
    var erros: Int = 0
    var aproveitamento: Double = 0.0
    var assunto = ""
    
    @IBOutlet var alunoLabel: UIView!
    @IBOutlet weak var assuntoLabel: UILabel!
    @IBOutlet weak var acertosLabel: UILabel!
    @IBOutlet weak var errosLabel: UILabel!
    @IBOutlet weak var aproveitamentoLabel: UILabel!
    @IBOutlet weak var fraseLabel: UILabel!
    @IBOutlet weak var returnBtn: UIButton!
    @IBOutlet weak var valuesView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configLabels()
        returnBtn.layer.cornerRadius = 5
        valuesView.layer.cornerRadius = 5
    }
    
    private func configLabels() {
        self.assuntoLabel.text = "Assunto: \(assunto)"
        self.acertosLabel.text = "Acertos: \(acertos)"
        self.errosLabel.text = "Erros: \(erros)"
        self.aproveitamentoLabel.text = "Aproveitamento: \(aproveitamento)%"
        
        if aproveitamento > 80 {
            self.fraseLabel.text = "Muito bem! Você mostrou que tem bom conhecimento de \(assunto)"
        } else if aproveitamento <= 80 && aproveitamento > 60 {
            self.fraseLabel.text = "Bom desempenho..mas você ainda pode melhorar estudando um pouco mais sobre \(assunto)"
        } else {
            self.fraseLabel.text = "Hm..o resultado não foi muito bom, mas com uma boa dose de estudo você irá conseguir melhorar!"
        }
    }
    @IBAction func goToHome(_ sender: Any) {
        var currentVCStack = self.navigationController?.viewControllers
        currentVCStack?.removeSubrange(1...5)
        let vc = HomeViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
