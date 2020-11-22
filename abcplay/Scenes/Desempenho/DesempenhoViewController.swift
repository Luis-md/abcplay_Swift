//
//  DesempenhoViewController.swift
//  abcplay
//
//  Created by Luis Domingues on 22/11/20.
//  Copyright © 2020 Luis Domingues. All rights reserved.
//

import UIKit

class DesempenhoViewController: UIViewController {
    var desempenho: [String:User.Desempenho]?
    var total: [User.Desempenho]?
    let viewModel = HomeViewModel()
    private var state: State = .success {
      didSet {
        switch state {
        case .ready(let user):
            loading.stopLoading(vc: self)
            self.desempenho = user.desempenho
            self.tableView.reloadData()
        case .success:
            loading.stopLoading(vc: self)
        case .loading:
            loading.startLoading(vc: self)
        case .error:
            loading.stopLoading(vc: self)
        case .empty:
            loading.stopLoading(vc: self)
        }
      }
    }
    
    private func loadUser() {
        state = .loading
        self.viewModel.getUser { (user, status, error) in
            if let err = error {
                self.state = .error
                print(err.localizedDescription)
            } else {
                if let userLog = user {
                    self.state = .ready(userLog)
                }
            }
        }
    }
    
    let tableView: UITableView = {
        let tb = UITableView(frame: .zero, style: .grouped)
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.separatorStyle = .none
        tb.backgroundColor = .clear
        tb.allowsSelection = false
        tb.register(DesempenhoCell.self, forCellReuseIdentifier: "cell")
        return tb
    }()
    
    let loading = LoadingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.addCustomBackButton(title: "Voltar")
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.title = "DESEMPENHO"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.initialSetup()
        self.layout()
    }
    
    private func initialSetup() {
        self.loadUser()
        self.hideKeyboardWhenTappedAround()
    }
    
}

extension DesempenhoViewController {
  enum State {
    case loading
    case ready(User)
    case error
    case success
    case empty
  }
}

extension DesempenhoViewController {
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

extension DesempenhoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let userDesempenho = self.desempenho {
            return userDesempenho.count
        } else {
            return 0
        }
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let userDesempenho = desempenho {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DesempenhoCell
            let val = Array(userDesempenho.values)[indexPath.row]
            cell.bind(acertos: val.acertos, erros: val.erros, title: val.title, date: val.today)
            cell.tintColor = .white
            return cell
        } else {
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
}

