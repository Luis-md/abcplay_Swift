//
//  HomeViewController.swift
//  abcplay
//
//  Created by Luis Domingues on 18/10/20.
//  Copyright © 2020 Luis Domingues. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let homeViewModel = HomeViewModel()
    
    private var state: State = .loading {
      didSet {
        switch state {
        case .ready(let assuntos):
            loading.stopLoading(vc: self)
            let vc = SeriesViewController()
            vc.assuntos = assuntos
            self.navigationController?.pushViewController(vc, animated: true)
        case .success(let userLog):
            loading.stopLoading(vc: self)
            if userLog.type.lowercased() == "estudante" {
                self.labelTitle.text = "Bem vindo ao ABC PLAY, \(userLog.username)"
                stack.isHidden = false
            } else {
                state = .professor
            }
        case .loading:
            loading.startLoading(vc: self)
            stack.isHidden = false
        case .professor:
            let storyboard = UIStoryboard(name: "Dialog", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DialogViewController") as! DialogViewController
            vc.setupDialog(msg: "Olá, professor! Você deve utilizar o desktop para acompanhar desempenho dos seus alunos!", iconType: .warning) {
                vc.dismiss(animated: true, completion: nil)
                let domain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.synchronize()
                self.navigationController?.popToRootViewController(animated: true)
            }
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)

        case .error:
            loading.stopLoading(vc: self)
        }
      }
    }
    
    let stack: UIStackView = {
        let st = UIStackView(frame: .zero)
        st.distribution = .fill
        st.alignment = .center
        st.axis = .vertical
        st.translatesAutoresizingMaskIntoConstraints = false
        st.spacing = 5
        return st
    }()
    
    let img: UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "ABC _ PLAY")
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        img.heightAnchor.constraint(equalToConstant: 16).isActive = true
        return img
    }()
    
    let labelTitle: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.Colors.blueTitle
        label.font = UIFont(name: "Helvetica neue", size: 20)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    let btnQuiz: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Escolher quiz", for: .normal)
        btn.backgroundColor = UIColor.Colors.lightBlueButton
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 5
        btn.setTitleColor(.white, for: .normal)
        btn.widthAnchor.constraint(equalToConstant: 250).isActive = true
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        return btn
    }()
    
    let btnMeusProfessores: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Meus professores", for: .normal)
        btn.backgroundColor = UIColor.Colors.lightBlueButton
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 5
        btn.setTitleColor(.white, for: .normal)
        btn.widthAnchor.constraint(equalToConstant: 250).isActive = true
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        return btn
    }()
    
    let btnDesempenho: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Desempenho", for: .normal)
        btn.backgroundColor = UIColor.Colors.lightBlueButton
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 5
        btn.setTitleColor(.white, for: .normal)
        btn.widthAnchor.constraint(equalToConstant: 250).isActive = true
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        return btn
    }()
    
    let loading = LoadingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sair", style: .plain, target: self, action: #selector(logoutTapped))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.Colors.abcRed
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.titleView = self.img
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.Colors.blueTitle]
        self.initialSetup()
        self.layout()
        self.loadUser()
    }
    
    private func initialSetup() {
        self.hideKeyboardWhenTappedAround()
        self.btnQuiz.addTarget(self, action: #selector(loadAssuntos), for: .touchDown)
        self.btnDesempenho.addTarget(self, action: #selector(goToDesempenho), for: .touchDown)
        self.btnMeusProfessores.addTarget(self, action: #selector(goToProfessores), for: .touchDown)
    }
    
    private func loadUser() {
        state = .loading
        self.homeViewModel.getUser { (user, status, error) in
            if let err = error {
                self.state = .error
                print(err.localizedDescription)
            } else {
                if let userLog = user {
                    if userLog.type.lowercased() == "estudante" {
                        self.state = .success(userLog)
                    } else {
                        self.state = .professor
                    }
                }
            }
        }
    }
    
    @objc private func loadAssuntos() {
        state = .loading
        self.homeViewModel.getAssuntos { (assunto, status, error) in
            if let err = error {
                self.state = .error
                print(err.localizedDescription)
            } else {
                if let assuntos = assunto {
                    self.state = .ready(assuntos)
                } else {
                    self.state = .error
                }
            }
        }
    }
    @objc private func goToDesempenho() {
        let vc = DesempenhoViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func goToProfessores() {
        let vc = ProfessoresViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func logoutTapped() {
        let storyboard = UIStoryboard(name: "Dialog", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DialogViewController") as! DialogViewController
        vc.setupDialog(msg: "Deseja encerrar sua sessão no ABC Play?", iconType: .warning, hideCancel: false) {
            vc.dismiss(animated: true, completion: nil)
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
            self.navigationController?.popToRootViewController(animated: true)
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
}

extension HomeViewController {
  enum State {
    case loading
    case ready([Assunto])
    case error
    case success(User)
    case professor
  }
}

extension HomeViewController {
    func layout() {
        self.view.backgroundColor = .white
        self.view.addSubview(stack)
        self.view.addSubview(labelTitle)
        
        stack.addArrangedSubview(btnQuiz)
        stack.addArrangedSubview(btnMeusProfessores)
        stack.addArrangedSubview(btnDesempenho)
        
        NSLayoutConstraint.activate([
            self.stack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.stack.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.stack.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 66),
            self.stack.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -66),
            
            self.btnDesempenho.leftAnchor.constraint(equalTo: self.stack.leftAnchor),
            self.btnDesempenho.rightAnchor.constraint(equalTo: self.stack.rightAnchor),

            self.btnQuiz.leftAnchor.constraint(equalTo: self.stack.leftAnchor),
            self.btnQuiz.rightAnchor.constraint(equalTo: self.stack.rightAnchor),
            
            self.btnMeusProfessores.leftAnchor.constraint(equalTo: self.stack.leftAnchor),
            self.btnMeusProfessores.rightAnchor.constraint(equalTo: self.stack.rightAnchor),
            
            self.labelTitle.bottomAnchor.constraint(equalTo: self.stack.topAnchor, constant: -16),
            self.labelTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.labelTitle.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 66),
            self.labelTitle.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -66),
        ])
    }
}
