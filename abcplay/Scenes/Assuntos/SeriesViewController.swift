//
//  AssuntosViewController.swift
//  abcplay
//
//  Created by Luis Domingues on 25/10/20.
//  Copyright © 2020 Luis Domingues. All rights reserved.
//

import UIKit

class SeriesViewController: UIViewController {
    var assuntos: [Assunto]?
    private var state: State = .success {
      didSet {
        switch state {
        case .ready(let questoes):
            loading.stopLoading(vc: self)
            let vc = QuestoesViewController()
            vc.questoes = questoes
            self.navigationController?.pushViewController(vc, animated: true)
        case .success:
            loading.stopLoading(vc: self)
        case .loading:
            loading.startLoading(vc: self)
        case .error:
            loading.stopLoading(vc: self)
        }
      }
    }
            
    let tableView: UITableView = {
        let tb = UITableView(frame: .zero, style: .grouped)
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.separatorStyle = .singleLine
        tb.backgroundColor = .clear
        tb.register(SeriesTableViewCell.self, forCellReuseIdentifier: "cell")
        return tb
    }()
    
    let loading = LoadingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.addCustomBackButton(title: "Voltar")
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.title = "SÉRIE"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.initialSetup()
        self.layout()
    }
    
    private func initialSetup() {
        self.hideKeyboardWhenTappedAround()
    }
    
}

extension SeriesViewController {
  enum State {
    case loading
    case ready([Assunto.Questoes])
    case error
    case success
  }
}

extension SeriesViewController {
    func layout() {
        self.view.backgroundColor = UIColor(red: 67/255.0, green: 159/255.0, blue: 104/255.0, alpha: 1.0)
        self.view.addSubview(tableView)

        if #available(iOS 11.0, *) {
            self.tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            self.tableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        }
        NSLayoutConstraint.activate([
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
        ])
    }
}

extension SeriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let assunt = assuntos {
            return assunt.count
        } else {
            return 0
        }
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let assunt = assuntos {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SeriesTableViewCell
            cell.bind(txt: assunt[indexPath.row].serie)
            cell.tintColor = .white
            return cell
        } else {
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let assunt = assuntos else { return }
        self.state = .ready(assunt[indexPath.row].assuntos)
        print(assunt[indexPath.row].assuntos)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
}

