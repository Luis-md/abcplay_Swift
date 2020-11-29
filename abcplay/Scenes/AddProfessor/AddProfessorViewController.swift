//
//  AddProfessorViewController.swift
//  abcplay
//
//  Created by Luis Domingues on 28/11/20.
//  Copyright © 2020 Luis Domingues. All rights reserved.
//

import UIKit

class AddProfessorViewController: UIViewController {
    var professores: [Professor]?
    let viewModel = AddProfessorViewModel()
    private var state: State = .success {
      didSet {
        switch state {
        case .ready(let professores):
            loading.stopLoading(vc: self)
            self.professores = professores
            self.tableView.reloadData()
        case .success:
            loading.stopLoading(vc: self)
        case .loading:
            loading.startLoading(vc: self)
        case .error:
            loading.stopLoading(vc: self)
        case .deleteProfessor:
            let vc = self.showDialog()
            vc.setupDialog(msg: "Professor excluído da sua lista com sucesso",
                           iconType: .success) {
                self.loadProfessoresList()
                vc.dismiss(animated: true, completion: nil)
            }
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        case .addProfessor:
            let vc = self.showDialog()
            vc.setupDialog(msg: "Professor adicionado na sua lista com sucesso",
                           iconType: .success) {
                self.loadProfessoresList()
                vc.dismiss(animated: true, completion: nil)
            }
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        case .empty:
            loading.stopLoading(vc: self)
            let vc = self.showDialog()
            vc.setupDialog(msg: "Ocorreu um erro na sua requisição; tente novamente mais tarde",
                           iconType: .error) {
                vc.dismiss(animated: true, completion: nil)
            }
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
      }
    }
    
    private func loadProfessoresList() {
        state = .loading
        self.viewModel.getProfessores { (professores, status, error) in
            if let err = error {
                self.state = .error
                print(err.localizedDescription)
            } else {
                if let professoresList = professores {
                    self.state = .ready(professoresList)
                } else {
                    self.state = .error
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
        tb.isUserInteractionEnabled = true
        tb.register(AddProfessorCell.self, forCellReuseIdentifier: "cell")
        return tb
    }()
    
    let loading = LoadingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.addCustomBackButton(title: "Voltar")
        self.navigationController?.navigationBar.tintColor = UIColor.Colors.blueTitle
        self.navigationItem.title = "PROFESSORES"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.Colors.blueTitle]
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.initialSetup()
        self.layout()
    }
    
    private func initialSetup() {
        self.loadProfessoresList()
        self.hideKeyboardWhenTappedAround()
    }
    private func addDialog(professor: String) {
        let storyboard = UIStoryboard(name: "Dialog", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DialogViewController") as! DialogViewController
        vc.setupDialog(msg: "Deseja adicionar \(professor) em sua lista de professores",
                       iconType: .warning) {
            vc.dismiss(animated: true, completion: nil)
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)

    }
}

extension AddProfessorViewController {
  enum State {
    case loading
    case ready([Professor])
    case error
    case success
    case deleteProfessor
    case addProfessor
    case empty
  }
}

extension AddProfessorViewController {
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
    
    private func showDialog() -> DialogViewController {
        let storyboard = UIStoryboard(name: "Dialog", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DialogViewController") as! DialogViewController
        return vc
    }
}

extension AddProfessorViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let userProfessores = self.professores {
            return userProfessores.count
        } else {
            return 0
        }
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let professoresList = professores {
            var isAdded = false
            let now = professoresList[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AddProfessorCell
            cell.delegate = self
            if let alunos = now.alunos {
                for (key, _) in alunos {
                    var tempAdd = key == UserDefaults.standard.string(forKey: "id")!
                    if tempAdd {
                        isAdded = true
                    }
                }
            }
            cell.bind(name: now.username,
                      email: now.email,
                      pos: indexPath.row,
                      isAdded: isAdded,
                      id: now.id)
            
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

extension AddProfessorViewController : AddProfessorCellDelegate {
    func addProfessor(pos: Int) {
        guard let professor = professores?[pos] else { return }
        
        let vc = showDialog()
        vc.setupDialog(msg: "Deseja adicionar \(professor.username) na sua lista de professores?",
                       iconType: .warning, hideCancel: false) {
            vc.dismiss(animated: true, completion: nil)
            self.state = .loading
            self.viewModel.addProfessor(professor: professor) { (success, error) in
                if let err = error {
                    self.state = .error
                } else {
                    self.state = .addProfessor
                }
            }
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)

    }
    
    func removeProfessor(id: String) {
        let vc = showDialog()
        vc.setupDialog(msg: "Deseja realmente excluir o professor da sua lista?",
                       iconType: .warning, hideCancel: false) {
            vc.dismiss(animated: true, completion: nil)
            self.state = .loading
            self.viewModel.delProfessor(id: id) { (success, error) in
                if let err = error {
                    self.state = .error
                } else {
                    self.state = .deleteProfessor
                }
            }
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
}
