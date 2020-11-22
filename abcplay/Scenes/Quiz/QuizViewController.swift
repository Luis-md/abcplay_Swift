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
    var helpCount: Int = 0
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
            self.interactLabel.isHidden = true
            self.icon.isHidden = true
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
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var answers: [UIButton]!
    @IBOutlet weak var icon: UILabel!
    @IBOutlet weak var interactLabel: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var helpLabel: UILabel!
    
    let loading = LoadingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLayout()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.bg.stop()
    }
    private func initialLayout() {
        self.answers.forEach({ $0.layer.cornerRadius = 5 })
        self.helpLabel.font = UIFont.fontAwesome(ofSize: 40, style: .solid)
        self.helpLabel.text = String.fontAwesomeIcon(name: .lightbulb)
        self.setupHelpTap()
        self.loadAudio()
        self.bg.play()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.view.largeContentTitle = "ABC PLAY"
        self.startQuiz()
    }
    @objc private func startQuiz() {
        self.allowInteraction()
        self.answers.forEach({ $0.alpha = 1 })
        self.helpLabel.isHidden = self.helpCount != 0
        self.resetColors()
        self.nextBtn.isHidden = true
        self.myAnswer = 4
        self.questionLabel.text = questoes?[num].pergunta
        self.icon.font = UIFont.fontAwesome(ofSize: 22, style: .solid)
        self.icon.text = String.fontAwesomeIcon(name: .clock)
        self.icon.textColor = .gray
        self.answers[0].setTitle(questoes?[num].alt[0] ?? "", for: .normal)
        self.answers[1].setTitle(questoes?[num].alt[1] ?? "", for: .normal)
        self.answers[2].setTitle(questoes?[num].alt[2] ?? "", for: .normal)
        self.answers[3].setTitle(questoes?[num].alt[3] ?? "", for: .normal)
        self.interactLabel.text = "\(timer) segundos..."
        self.interactLabel.textColor = .black
        self.answers.forEach({ $0.layer.borderWidth = 0 })
        self.startTime()
    }
    private func startTime() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.timer -= 1
            self.interactLabel.text = "\(self.timer) segundos..."
            if self.timer == 0 {
                self.retrieveInteraction()
                self.checkAnswer()
                if self.num + 1 < self.questoes!.count {
                    self.state = .nextQuestion
                } else {
                    self.nextBtn.isHidden = false
                    self.nextBtn.setTitle("Gerar resultado!", for: .normal)
                    self.nextBtn.addTarget(self, action: #selector(self.sendResult), for: .touchDown)
                    self.state = .finishedQuiz
                }
                timer.invalidate()
            }
        }
    }
    private func setupHelpTap() {
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(useHelp))
        self.helpLabel.isUserInteractionEnabled = true
        self.helpLabel.addGestureRecognizer(labelTap)
    }
    @IBAction func btnOne(_ sender: UIButton) {
        self.selectAnswer(position: sender.tag)
    }
    @IBAction func btnTwo(_ sender: UIButton) {
        self.selectAnswer(position: sender.tag)
    }
    @IBAction func btnThree(_ sender: UIButton) {
        self.selectAnswer(position: sender.tag)
    }
    @IBAction func btnFour(_ sender: UIButton) {
        self.selectAnswer(position: sender.tag)
    }
    @objc private func useHelp() {
        self.helpCount += 1
        var result = Int.random(in: 0..<4)
        let resp = self.questoes?[self.num].resp ?? 4
        while result == resp {
            result = Int.random(in: 0..<4)
        }
        answers[result].alpha = 0.5
        answers[result].isUserInteractionEnabled = false
        self.helpLabel.isUserInteractionEnabled = false
        self.helpLabel.isHidden = true
    }
    @objc private func selectAnswer(position: Int) {
        self.changeAnswer.play()
        self.answers.forEach({ $0.layer.borderWidth = 0 })
        self.myAnswer = position
        self.answers[position].layer.borderWidth = 2
        self.answers[position].layer.borderColor = UIColor.blue.cgColor
    }
    private func retrieveInteraction() {
        self.answers.forEach({ $0.isUserInteractionEnabled = false })
    }
    private func allowInteraction() {
        self.answers.forEach({ $0.isUserInteractionEnabled = true })
    }
    private func checkAnswer() {
        self.helpLabel.isHidden = true
        self.turnButtonGray()
        self.answers.forEach({ $0.layer.borderWidth = 0 })
        if self.myAnswer == self.questoes?[self.num].resp {
            rightAnswer.play()
            self.answers[myAnswer].backgroundColor = UIColor(red: 67/255.0, green: 159/255.0, blue: 104/255.0, alpha: 1.0)
            self.interactLabel.text = "Resposta certa!"
            self.interactLabel.textColor = UIColor(red: 67/255.0, green: 159/255.0, blue: 104/255.0, alpha: 1.0)
            self.icon.font = UIFont.fontAwesome(ofSize: 22, style: .solid)
            self.icon.text = String.fontAwesomeIcon(name: .star)
            self.icon.textColor = UIColor(red: 67/255.0, green: 159/255.0, blue: 104/255.0, alpha: 1.0)
            self.acertos += 1
        } else {
            wrongAnswer.play()
            self.interactLabel.text = "Resposta errada!"
            if self.myAnswer != 4 {
                self.answers[myAnswer].backgroundColor = UIColor(red: 232/255.0, green: 19/255.0, blue: 19/255.0, alpha: 1.0)
            }
            self.interactLabel.textColor = UIColor(red: 232/255.0, green: 19/255.0, blue: 19/255.0, alpha: 1.0)
            self.icon.font = UIFont.fontAwesome(ofSize: 22, style: .solid)
            self.icon.text = String.fontAwesomeIcon(name: .timesCircle)
            self.icon.textColor = UIColor(red: 232/255.0, green: 19/255.0, blue: 19/255.0, alpha: 1.0)
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
    private func turnButtonGray() {
        self.answers.forEach({ $0.backgroundColor = .gray })
    }
    private func resetColors() {
        self.answers[0].backgroundColor = UIColor(red: 130/255.0, green: 155/255.0, blue: 225/255.0, alpha: 1.0)
        self.answers[1].backgroundColor = UIColor(red: 67/255.0, green: 159/255.0, blue: 104/255.0, alpha: 1.0)
        self.answers[2].backgroundColor = UIColor(red: 240/255.0, green: 212/255.0, blue: 2/255.0, alpha: 1.0)
        self.answers[3].backgroundColor = UIColor(red: 232/255.0, green: 19/255.0, blue: 19/255.0, alpha: 1.0)
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

