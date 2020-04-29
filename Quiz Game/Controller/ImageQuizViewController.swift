//
//  MultipleChoiceViewController.swift
//  Quiz Game
//
//  Created by Esmaeil MIRZAEE on 2020-04-27.
//  Copyright © 2020 TheBeaver. All rights reserved.
//

import UIKit

class ImageQuizViewController: UIViewController {

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
    
    // Change Colours
    private let backgroundColour = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
    private let foregroundColour = UIColor(red: 52/255, green: 73/255, blue: 94/255, alpha: 1.0)
    
    private let quizLoader = QuizLoader()
    
    // Select according question type
    private var questionArray = [MultipleChoiceQuestion]()
    private var questionIndex = 0
    private var currentQuestion: MultipleChoiceQuestion!
    
    private var timer = Timer()
    private var score = 0
    // Change Identifier
    private var highScore = UserDefaults.standard.integer(forKey: multipleChoiceHighScoreIdentifier)
    
    
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
        
        
        answerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(answerView)
        
        
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
        
        answerViewConstraints = [
            answerView.topAnchor.constraint(equalTo: questionView.bottomAnchor, constant: paddings.twenty),
            answerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: paddings.twenty),
            answerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: paddings.minusTwenty),
            answerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: paddings.fourTenth)
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
        NSLayoutConstraint.activate(answerViewConstraints)
        NSLayoutConstraint.activate(countDownViewConstraints)
        NSLayoutConstraint.activate(progressViewConstraints)
        
        loadQuestions()
    }
    
    func loadQuestions() {
        do {
            // load the appropriate questions
            questionArray = try quizLoader.loadMultipleChoiceQuiz(forQuiz: "MultipleChoice")
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
    
    @objc func answerButtonHandler(_ sender: RoundedButton) {
        timer.invalidate()
        if sender.titleLabel?.text == currentQuestion.correctAnswer {
            score += 1
            questionLabel.text = "Tap to continue"
            questionButton.isEnabled = true
        } else {
            sender.backgroundColor = flatRed
            showAlert(forReason: 1)
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
            UserDefaults.standard.set(highScore, forKey: multipleChoiceHighScoreIdentifier)
        }
        UserDefaults.standard.set(score, forKey: multipleChoiceRecentScoreIdentifier)
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil {
            timer.invalidate()
        }
    }
}
