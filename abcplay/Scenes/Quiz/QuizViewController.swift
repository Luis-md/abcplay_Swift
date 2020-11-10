//
//  QuizViewController.swift
//  abcplay
//
//  Created by Luis Domingues on 08/11/20.
//  Copyright © 2020 Luis Domingues. All rights reserved.
//

import UIKit
import FontAwesome_swift
import AVFoundation
class QuizViewController: UIViewController {
    private let quizViewModel = QuizViewModel()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var wrongAnswer = AVAudioPlayer()
    var rightAnswer = AVAudioPlayer()
    var changeAnswer = AVAudioPlayer()
    var bg = AVAudioPlayer()
    var questoes: [Assunto.Quiz]?
    var num: Int = 0
    var quizTitle: String = ""
    var acertos: Int = 0
    var erros: Int = 0
    var timer: Int = 10
    var myAnswer: Int = 4
    private var state: State = .ready {
      didSet {
        switch state {
        case .finishedQuiz:
            self.nextBtn.addTarget(self, action: #selector(sendResult), for: .touchDown)
        case .ready:
            loading.stopLoading(vc: self)
        case .success:
            loading.stopLoading(vc: self)
            let storyboard = UIStoryboard(name: "Result", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
            vc.acertos = acertos
            vc.erros = erros
            vc.assunto = quizTitle
            vc.aproveitamento = Double((Double(acertos) / Double(questoes!.count)) * 100)
            self.navigationController?.pushViewController(vc, animated: true)
        case .loading:
            loading.startLoading(vc: self)
        case .error:
            loading.stopLoading(vc: self)
        case .nextQuestion:
            self.num += 1
            self.nextBtn.isHidden = false
            self.nextBtn.setTitle("Próxima pergunta", for: .normal)
            self.timer = 10
            self.nextBtn.addTarget(self, action: #selector(self.startQuiz), for: .touchDown)
        }
      }
    }
    
    let stack: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.alignment = .leading
        stack.axis = .vertical
        stack.spacing = 7
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
        
    let labelQuestion: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let firstAnswer: UIButton = {
        let btn = UIButton(frame: .zero)
        btn.backgroundColor = UIColor(red: 130/255.0, green: 155/255.0, blue: 225/255.0, alpha: 1.0)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 42).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 250).isActive = true
        btn.layer.cornerRadius = 5
        btn.tag = 0
        btn.addTarget(self, action: #selector(selectAnswer(_:)), for: .touchDown)
        return btn
    }()
    let secondAnswer: UIButton = {
        let btn = UIButton(frame: .zero)
        btn.backgroundColor = UIColor(red: 67/255.0, green: 159/255.0, blue: 104/255.0, alpha: 1.0)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 42).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 250).isActive = true
        btn.layer.cornerRadius = 5
        btn.tag = 1
        btn.addTarget(self, action: #selector(selectAnswer(_:)), for: .touchDown)
        return btn
    }()
    let thirdAnswer: UIButton = {
        let btn = UIButton(frame: .zero)
        btn.backgroundColor = UIColor(red: 240/255.0, green: 212/255.0, blue: 2/255.0, alpha: 1.0)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 42).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 250).isActive = true
        btn.layer.cornerRadius = 5
        btn.tag = 2
        btn.addTarget(self, action: #selector(selectAnswer(_:)), for: .touchDown)
        return btn
    }()
    let fourthAnswer: UIButton = {
        let btn = UIButton(frame: .zero)
        btn.backgroundColor = UIColor(red: 232/255.0, green: 19/255.0, blue: 19/255.0, alpha: 1.0)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 42).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 250).isActive = true
        btn.layer.cornerRadius = 5
        btn.tag = 3
        btn.addTarget(self, action: #selector(selectAnswer(_:)), for: .touchDown)
        return btn
    }()
    let counterLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let iconLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.fontAwesome(ofSize: 16, style: .solid)
        lbl.text = String.fontAwesomeIcon(name: .stopwatch)
        lbl.textColor = UIColor.gray
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    let nextBtn: UIButton = {
        let btn = UIButton(frame: .zero)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(UIColor(red: 171/255.0, green: 171/255.0, blue: 171/255.0, alpha: 1.0), for: .normal)
        return btn
    }()
        
    let loading = LoadingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.music.stop()
        self.loadAudio()
        self.bg.play()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.view.largeContentTitle = "ABC PLAY"
        self.startQuiz()
        self.layout()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.bg.stop()
    }
    @objc private func startQuiz() {
        self.allowInteraction()
        self.nextBtn.isHidden = true
        self.myAnswer = 4
        self.labelQuestion.text = questoes?[num].pergunta
        self.iconLabel.text = String.fontAwesomeIcon(name: .clock)
        self.iconLabel.textColor = .gray
        self.firstAnswer.setTitle(questoes?[num].alt[0] ?? "", for: .normal)
        self.secondAnswer.setTitle(questoes?[num].alt[1] ?? "", for: .normal)
        self.thirdAnswer.setTitle(questoes?[num].alt[2] ?? "", for: .normal)
        self.fourthAnswer.setTitle(questoes?[num].alt[3] ?? "", for: .normal)
        self.counterLabel.text = "\(timer) segundos..."
        self.counterLabel.textColor = .black
        self.firstAnswer.layer.borderWidth = 0
        self.secondAnswer.layer.borderWidth = 0
        self.thirdAnswer.layer.borderWidth = 0
        self.fourthAnswer.layer.borderWidth = 0
        self.startTime()
    }
    private func startTime() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.timer -= 1
            self.counterLabel.text = "\(self.timer) segundos..."
            if self.timer == 0 {
                self.retrieveInteraction()
                self.checkAnswer()
                if self.num + 1 < self.questoes!.count {
                    self.state = .nextQuestion
                } else {
                    self.nextBtn.isHidden = false
                    self.nextBtn.setTitle("Gerar resultado!", for: .normal)
                    self.state = .finishedQuiz
                }
                timer.invalidate()
            }
        }
    }
    @objc private func selectAnswer(_ sender: UIButton) {
        self.changeAnswer.play()
        self.firstAnswer.layer.borderWidth = 0
        self.secondAnswer.layer.borderWidth = 0
        self.thirdAnswer.layer.borderWidth = 0
        self.fourthAnswer.layer.borderWidth = 0
        self.myAnswer = sender.tag
        sender.layer.borderWidth = 2
        sender.layer.borderColor = UIColor.blue.cgColor
    }
    private func retrieveInteraction() {
        self.firstAnswer.isUserInteractionEnabled = false
        self.secondAnswer.isUserInteractionEnabled = false
        self.thirdAnswer.isUserInteractionEnabled = false
        self.fourthAnswer.isUserInteractionEnabled = false
    }
    private func allowInteraction() {
        self.firstAnswer.isUserInteractionEnabled = true
        self.secondAnswer.isUserInteractionEnabled = true
        self.thirdAnswer.isUserInteractionEnabled = true
        self.fourthAnswer.isUserInteractionEnabled = true
    }
    private func checkAnswer() {
        if self.myAnswer == self.questoes?[self.num].resp {
            rightAnswer.play()
            self.counterLabel.text = "Resposta certa!"
            self.counterLabel.textColor = UIColor(red: 67/255.0, green: 159/255.0, blue: 104/255.0, alpha: 1.0)
            self.iconLabel.text = String.fontAwesomeIcon(name: .star)
            self.iconLabel.textColor = UIColor(red: 67/255.0, green: 159/255.0, blue: 104/255.0, alpha: 1.0)
            //self.clockImg.image = #imageLiteral(resourceName: "correct")
            self.acertos += 1
        } else {
            wrongAnswer.play()
            self.counterLabel.text = "Resposta errada!"
            self.counterLabel.textColor = UIColor(red: 232/255.0, green: 19/255.0, blue: 19/255.0, alpha: 1.0)
            self.iconLabel.text = String.fontAwesomeIcon(name: .timesCircle)
            self.iconLabel.textColor = UIColor(red: 232/255.0, green: 19/255.0, blue: 19/255.0, alpha: 1.0)
            self.erros += 1
        }
    }
    @objc private func sendResult() {
        self.state = .loading
        self.quizViewModel.sendResult(title: self.quizTitle, acertos: self.acertos, erros: self.erros) { (success, apiError) in
            if let error = apiError {
                self.state = .error
                print(error.localizedDescription)
            } else {
                if !success {
                    self.state = .error
                } else {
                    self.state = .success
                }
            }
        }
    }
}

extension QuizViewController {
  enum State {
    case loading
    case ready
    case error
    case nextQuestion
    case success
    case finishedQuiz
  }
}

extension QuizViewController {
    func layout() {
        self.view.backgroundColor = .white
        self.view.addSubview(stack)
        self.view.addSubview(labelQuestion)
        self.view.addSubview(iconLabel)
        self.view.addSubview(counterLabel)
        self.view.addSubview(nextBtn)
        stack.addArrangedSubview(firstAnswer)
        stack.addArrangedSubview(secondAnswer)
        stack.addArrangedSubview(thirdAnswer)
        stack.addArrangedSubview(fourthAnswer)
        
        if #available(iOS 11.0, *) {
            self.labelQuestion.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60).isActive = true
        } else {
            self.labelQuestion.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 60).isActive = true
        }
        NSLayoutConstraint.activate([
            self.labelQuestion.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            self.labelQuestion.rightAnchor.constraint(lessThanOrEqualTo: self.view.rightAnchor, constant: -16),
            self.stack.topAnchor.constraint(equalTo: self.labelQuestion.bottomAnchor, constant: 9),
            self.stack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.counterLabel.topAnchor.constraint(equalTo: self.stack.bottomAnchor, constant: 9),
            self.counterLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.view.bottomAnchor, constant: -16),
            self.counterLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.iconLabel.rightAnchor.constraint(equalTo: self.counterLabel.leftAnchor, constant: -7),
            self.iconLabel.centerYAnchor.constraint(equalTo: self.counterLabel.centerYAnchor),
            self.nextBtn.topAnchor.constraint(equalTo: self.counterLabel.bottomAnchor, constant: 9),
            self.nextBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    private func loadAudio() {
        let wrongSound = Bundle.main.path(forResource: "Wrong", ofType: "mp3")
        let change = Bundle.main.path(forResource: "Beep", ofType: "mp3")
        let correctSound = Bundle.main.path(forResource: "Correct", ofType: "mp3")
        let bgSound = Bundle.main.path(forResource: "Robots a Cometh - Dan Lebowitz", ofType: "mp3")
        do {
            self.wrongAnswer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: wrongSound!))
            self.changeAnswer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: change!))
            self.rightAnswer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: correctSound!))
            self.bg = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: bgSound!))
        } catch {
            print(error)
        }
    }
}

