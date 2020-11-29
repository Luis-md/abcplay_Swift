//
//  ProfessoresViewController.swift
//  abcplay
//
//  Created by Luis Domingues on 28/11/20.
//  Copyright © 2020 Luis Domingues. All rights reserved.
//
import UIKit

class ProfessoresViewController: UIViewController {
    var professores: [String:User.Professores]?
    let viewModel = HomeViewModel()
    private var state: State = .success {
      didSet {
        switch state {
        case .ready(let user):
            loading.stopLoading(vc: self)
            self.professores = user.professores
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
    
    let emptyProfessores: UILabel = {
        let label = UILabel()
        label.text = "Você não possui professores adicionados"
        label.textColor = UIColor.Colors.emptyGray
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let tableView: UITableView = {
        let tb = UITableView(frame: .zero, style: .grouped)
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.separatorStyle = .none
        tb.backgroundColor = .clear
        tb.allowsSelection = false
        tb.register(ProfessoresTableViewCell.self, forCellReuseIdentifier: "cell")
        return tb
    }()
    
    let loading = LoadingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        self.navigationController?.addCustomBackButton(title: "Voltar")
        self.navigationController?.navigationBar.tintColor = UIColor.Colors.blueTitle
        self.navigationItem.title = "MEUS PROFESSORES"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.Colors.blueTitle]
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.initialSetup()
        self.layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadUser()
    }
    
    private func initialSetup() {
        self.loadUser()
    }
    
    @objc private func addTapped() {
        let vc = AddProfessorViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ProfessoresViewController {
  enum State {
    case loading
    case ready(User)
    case error
    case success
    case empty
  }
}

extension ProfessoresViewController {
    func layout() {
        self.view.backgroundColor = .white
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
            
//            self.emptyProfessores.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
//            self.emptyProfessores.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 16),
//            self.emptyProfessores.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: -16),
        ])
    }
}

extension ProfessoresViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let userProfessores = self.professores {
            return userProfessores.count
        } else {
            return 0
        }
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let userProfessores = professores {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProfessoresTableViewCell
            let val = Array(userProfessores.values)[indexPath.row]
            cell.bind(name: val.username, email: val.email, pos: indexPath.row)
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

