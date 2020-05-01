//
//  RightWrongQuizViewController.swift
//  Quiz Game
//
//  Created by Esmaeil MIRZAEE on 2020-04-27.
//  Copyright © 2020 TheBeaver. All rights reserved.
//

import UIKit

class RightWrongQuizViewController: UIViewController {

    private let paddings = Paddings()
    
    private let contentView =  UIView()
    private var contentViewConstraints: [NSLayoutConstraint]!
    
    private let questionView = UIView()
    private var questionViewConstraints: [NSLayoutConstraint]!
    
    private let answerView = UIView()
    private var answerViewConstraints: [NSLayoutConstraint]!
    
    private let countDownView = UIView()
    private var countDownViewConstraints: [NSLayoutConstraint]!
    
    private let questionLabel = RoundedLabel()
    private var questionLabelConstraints: [NSLayoutConstraint]!
    private let questionButton = RoundedButton()
    private var questionButtonConstraints: [NSLayoutConstraint]!
    
    private var answerButtons = [RoundedButton]()
    private var answerButtonsConstraints: [NSLayoutConstraint]!
    
    private let progressView = UIProgressView()
    private var progressViewConstraints: [NSLayoutConstraint]!
    
    private let backgroundColour = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1.0)
    private let foregroundColour = UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1.0)
    
    private let quizLoader = QuizLoader()
    
    private var questionArray = [SimpleQuestion]()
    private var questionIndex = 0
    private var currentQuestion: SimpleQuestion!
    
    private var timer = Timer()
    private var score = 0
    private var highScore = UserDefaults.standard.integer(forKey: rightWrongHighScoreIdentifier)
    
    
    private var quizAlertView: QuizAlertView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColour
        layoutView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    func layoutView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        
        questionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(questionView)
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionView.addSubview(questionLabel)
        questionLabel.backgroundColor = foregroundColour
        questionLabel.textColor = .darkGray
        questionLabel.font = UIFont.boldSystemFont(ofSize: 30)
        questionLabel.textAlignment = .center
        questionLabel.numberOfLines = 4
        questionLabel.adjustsFontSizeToFitWidth = true
        questionButton.translatesAutoresizingMaskIntoConstraints = false
        questionView.addSubview(questionButton)
        questionButton.addTarget(self, action: #selector(questionButtonHandler), for: .touchUpInside)
        questionButton.isEnabled = false
        
        answerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(answerView)
        for index in 0...1 {
            let button = RoundedButton()
            answerButtons.append(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            answerView.addSubview(button)
            index == 0 ? button.setTitle("Correct", for: .normal) : button.setTitle("Wrong", for: .normal)
            button.addTarget(self, action: #selector(answerButtonHandler), for: .touchUpInside)
        }
        
        countDownView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(countDownView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        countDownView.addSubview(progressView)
        
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 5)
        
        contentViewConstraints = [
            contentView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        questionViewConstraints = [
            questionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: paddings.twenty),
            questionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: paddings.twenty),
            questionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: paddings.minusTwenty),
            questionView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: paddings.fourTenth)
        ]
        
        questionLabelConstraints = [
            questionLabel.topAnchor.constraint(equalTo: questionView.topAnchor),
            questionLabel.leadingAnchor.constraint(equalTo: questionView.leadingAnchor),
            questionLabel.trailingAnchor.constraint(equalTo: questionView.trailingAnchor),
            questionLabel.bottomAnchor.constraint(equalTo: questionView.bottomAnchor)
        ]
        
        questionButtonConstraints = [
            questionButton.topAnchor.constraint(equalTo: questionView.topAnchor),
            questionButton.leadingAnchor.constraint(equalTo: questionView.leadingAnchor),
            questionButton.trailingAnchor.constraint(equalTo: questionView.trailingAnchor),
            questionButton.bottomAnchor.constraint(equalTo: questionView.bottomAnchor)
        ]
        
        answerViewConstraints = [
            answerView.topAnchor.constraint(equalTo: questionView.bottomAnchor, constant: paddings.twenty),
            answerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: paddings.twenty),
            answerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: paddings.minusTwenty),
            answerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: paddings.fourTenth)
        ]
        
        answerButtonsConstraints = [
            answerButtons[0].leadingAnchor.constraint(equalTo: answerView.leadingAnchor),
            answerButtons[0].trailingAnchor.constraint(equalTo: answerView.trailingAnchor),
            answerButtons[0].topAnchor.constraint(equalTo: answerView.topAnchor),
            answerButtons[0].bottomAnchor.constraint(equalTo: answerButtons[1].topAnchor, constant: -8.0),
            answerButtons[1].leadingAnchor.constraint(equalTo: answerView.leadingAnchor),
            answerButtons[1].trailingAnchor.constraint(equalTo: answerView.trailingAnchor),
            answerButtons[1].bottomAnchor.constraint(equalTo: answerView.bottomAnchor),
            answerButtons[0].heightAnchor.constraint(equalTo: answerButtons[1].heightAnchor),
            answerButtons[0].widthAnchor.constraint(equalTo: answerButtons[1].widthAnchor)
        ]
        
        countDownViewConstraints = [
            countDownView.topAnchor.constraint(equalTo: answerView.bottomAnchor, constant: paddings.twenty),
            countDownView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: paddings.twenty),
            countDownView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: paddings.minusTwenty),
            countDownView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: paddings.minusTwenty)
        ]
        
        progressViewConstraints = [
            progressView.leadingAnchor.constraint(equalTo: countDownView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: countDownView.trailingAnchor),
            progressView.centerYAnchor.constraint(equalTo: countDownView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(contentViewConstraints)
        NSLayoutConstraint.activate(questionViewConstraints)
        NSLayoutConstraint.activate(questionLabelConstraints)
        NSLayoutConstraint.activate(questionButtonConstraints)
        NSLayoutConstraint.activate(answerViewConstraints)
        NSLayoutConstraint.activate(answerButtonsConstraints)
        NSLayoutConstraint.activate(countDownViewConstraints)
        NSLayoutConstraint.activate(progressViewConstraints)
        
        loadQuestions()
    }
    
    func loadQuestions() {
        do {
            questionArray = try quizLoader.loadSimpleQuiz(forQuiz: "RightWrongQuiz")
            loadNextQuestion()
        } catch {
            switch error {
            case LoaderError.dictionaryFailed:
                print("Could not load dictionary")
            case LoaderError.pathFailed:
                print("Could not find valid file at path")
            default:
                print("Unknown Error")
            }
        }
    }
    
    func loadNextQuestion() {
        currentQuestion = questionArray[questionIndex]
        setTitleForButtons()
    }
    
    func setTitleForButtons() {
        for button in answerButtons {
            button.isEnabled = true
            button.backgroundColor = foregroundColour
            button.setTitleColor(.darkGray, for: .normal)
        }
        questionLabel.text = currentQuestion.question
        startTimer()
    }
    
    func startTimer() {
        progressView.progressTintColor = flatGreen
        progressView.trackTintColor = .clear
        progressView.progress = 1.0
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateProgressView), userInfo: nil, repeats: true)
    }
    
    @objc func updateProgressView() {
        progressView.progress -= 0.01/30
        if progressView.progress == 0 {
            outOfTime()
            print("Game Over")
        } else if progressView.progress <= 0.2 {
            progressView.progressTintColor = flatRed
        } else if progressView.progress <= 0.5 {
            progressView.progressTintColor = flatOrange
        }
    }
    
    func outOfTime() {
        timer.invalidate()
        showAlert(forReason: 0)
    }
    
    @objc func questionButtonHandler() {
        questionButton.isEnabled = false
        questionIndex += 1
        questionIndex < questionArray.count ? loadNextQuestion() : showAlert(forReason: 2)
    }
    
    @objc func answerButtonHandler(_ sender: RoundedButton) {
        timer.invalidate()
        if sender.titleLabel?.text == currentQuestion.correctAnswer {
            score += 1
            questionLabel.text = "Tap to continue"
            questionButton.isEnabled = true
        } else {
            sender.backgroundColor = flatRed
            sender.setTitleColor(.white, for: .normal)
            showAlert(forReason: 1)
        }
        for button in answerButtons {
            button.isEnabled = false
            if button.titleLabel?.text == currentQuestion.correctAnswer {
                button.backgroundColor = flatGreen
                button.setTitleColor(.white, for: .normal)
            }
        }
    }
    
    func showAlert(forReason reason: Int) {
        
        switch reason {
        case 0:
            quizAlertView = QuizAlertView(withTitle: "You lost.", andMessage: "You ran out of time.", colours: [backgroundColour, foregroundColour])
        case 1:
            quizAlertView = QuizAlertView(withTitle: "You lost.", andMessage: "You picked the wrong answer.", colours: [backgroundColour, foregroundColour])
        case 2:
                quizAlertView = QuizAlertView(withTitle: "You won.", andMessage: "You answered all the questions.", colours: [backgroundColour, foregroundColour])
        default:
            break
        }
        
        if let quizAlertView = quizAlertView {
            quizAlertView.closeButton.addTarget(self, action: #selector(closeAlert), for: .touchUpInside)
            createQuizAlertView(withAlert: quizAlertView)
        }
    }
    
    func createQuizAlertView(withAlert alert: QuizAlertView) {
        alert.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(alert)
        alert.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        alert.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        alert.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        alert.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    @objc func closeAlert() {
        if score > highScore {
            highScore = score
            UserDefaults.standard.set(highScore, forKey: rightWrongHighScoreIdentifier)
        }
        UserDefaults.standard.set(score, forKey: rightWrongRecentScoreIdentifier)
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil {
            timer.invalidate()
        }
    }
}
