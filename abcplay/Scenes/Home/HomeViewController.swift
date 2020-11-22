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
            self.labelTitle.text = "Bem vindo ao ABC PLAY, \(userLog.username)"
            stack.isHidden = false
        case .loading:
            loading.startLoading(vc: self)
            stack.isHidden = false
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
        st.spacing = 8
        return st
    }()
    
    let labelTitle: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    let btnQuiz: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Escolher assunto", for: .normal)
        btn.backgroundColor = UIColor(red: 67/255.0, green: 159/255.0, blue: 104/255.0, alpha: 1.0)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 5
        btn.setTitleColor(.white, for: .normal)
        btn.widthAnchor.constraint(equalToConstant: 170).isActive = true
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        return btn
    }()
    
    let btnMenu: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Menu", for: .normal)
        btn.backgroundColor = UIColor(red: 67/255.0, green: 159/255.0, blue: 104/255.0, alpha: 1.0)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 5
        btn.setTitleColor(.white, for: .normal)
        btn.widthAnchor.constraint(equalToConstant: 170).isActive = true
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        return btn
    }()
    
    let loading = LoadingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.title = "HOME"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.initialSetup()
        self.layout()
        self.loadUser()
    }
    
    private func initialSetup() {
        self.hideKeyboardWhenTappedAround()
        self.btnQuiz.addTarget(self, action: #selector(loadAssuntos), for: .touchDown)
        self.btnMenu.addTarget(self, action: #selector(menuAction), for: .touchDown)
    }
    
    private func loadUser() {
        state = .loading
        self.homeViewModel.getUser { (user, status, error) in
            if let err = error {
                self.state = .error
                print(err.localizedDescription)
            } else {
                if let userLog = user {
                    self.state = .success(userLog)
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
    @objc private func menuAction() {
        let storyboard = UIStoryboard(name: "Menu", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController {
  enum State {
    case loading
    case ready([Assunto])
    case error
    case success(User)
  }
}

extension HomeViewController {
    func layout() {
        self.view.backgroundColor = UIColor(red: 130/255.0, green: 155/255.0, blue: 225/255.0, alpha: 1.0)
        self.view.addSubview(stack)

        stack.addArrangedSubview(labelTitle)
        stack.addArrangedSubview(btnQuiz)
        stack.addArrangedSubview(btnMenu)
        
        NSLayoutConstraint.activate([
            self.stack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.stack.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.stack.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24),
            self.stack.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24)
        ])
    }
}
