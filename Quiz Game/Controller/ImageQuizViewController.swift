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
    
    private let questionView = UIImageView()
    private var questionViewConstraints: [NSLayoutConstraint]!
    
    private var imageGridViews = [UIView]()
    
    private let answerView = UIView()
    private var answerViewConstraints: [NSLayoutConstraint]!
    
    private let countDownView = UIView()
    private var countDownViewConstraints: [NSLayoutConstraint]!
    
    private var answerButtons = [RoundedButton]()
    private var answerButtonsConstraints: [NSLayoutConstraint]!
    
    private let progressView = UIProgressView()
    private var progressViewConstraints: [NSLayoutConstraint]!
    
    private let backgroundColour = UIColor(red: 51/255, green: 110/255, blue: 123/255, alpha: 1.0)
    private let foregroundColour = UIColor(red: 197/255, green: 239/255, blue: 247/255, alpha: 1.0)
    
    private let quizLoader = QuizLoader()
    
    private var questionArray = [MultipleChoiceQuestion]()
    private var questionIndex = 0
    private var currentQuestion: MultipleChoiceQuestion!
    
    private var timer = Timer()
    private var revealTimer = Timer()
    private var revealIndex = 0
    private var score = 0
    private var highScore = UserDefaults.standard.integer(forKey: imageQuizHighScoreIdentifier)
    
    
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
        for _ in 0...8 {
            let view = UIView()
            imageGridViews.append(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            questionView.addSubview(view)
            view.backgroundColor = foregroundColour
        }
        
        
        answerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(answerView)
        for _ in 0...3 {
            let button = RoundedButton()
            answerButtons.append(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            answerView.addSubview(button)
            button.addTarget(self, action: #selector(answerButtonHandler(_:)), for: .touchUpInside)
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
        
        answerViewConstraints = [
            answerView.topAnchor.constraint(equalTo: questionView.bottomAnchor, constant: paddings.twenty),
            answerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: paddings.twenty),
            answerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: paddings.minusTwenty),
            answerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: paddings.fourTenth)
        ]
        
        answerButtonsConstraints = [
            answerButtons[0].leadingAnchor.constraint(equalTo: answerView.leadingAnchor),
            answerButtons[0].trailingAnchor.constraint(equalTo: answerButtons[1].leadingAnchor, constant: paddings.minusEight),
            answerButtons[0].topAnchor.constraint(equalTo: answerView.topAnchor),
            answerButtons[0].bottomAnchor.constraint(equalTo: answerButtons[2].topAnchor, constant: -8.0),
            answerButtons[1].trailingAnchor.constraint(equalTo: answerView.trailingAnchor),
            answerButtons[1].topAnchor.constraint(equalTo: answerView.topAnchor),
            answerButtons[1].bottomAnchor.constraint(equalTo: answerButtons[3].topAnchor, constant: paddings.minusEight),
            answerButtons[2].leadingAnchor.constraint(equalTo: answerView.leadingAnchor),
            answerButtons[2].trailingAnchor.constraint(equalTo: answerButtons[3].leadingAnchor, constant: paddings.minusEight),
            answerButtons[2].bottomAnchor.constraint(equalTo: answerView.bottomAnchor),
            answerButtons[3].trailingAnchor.constraint(equalTo: answerView.trailingAnchor),
            answerButtons[3].bottomAnchor.constraint(equalTo: answerView.bottomAnchor)
        ]
        
        for index in 1..<answerButtons.count {
            answerButtonsConstraints.append(answerButtons[index].heightAnchor.constraint(equalTo: answerButtons[index-1].heightAnchor))
            answerButtonsConstraints.append(answerButtons[index].widthAnchor.constraint(equalTo: answerButtons[index-1].widthAnchor))
        }
        
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
        NSLayoutConstraint.activate(answerButtonsConstraints)
        NSLayoutConstraint.activate(countDownViewConstraints)
        NSLayoutConstraint.activate(progressViewConstraints)
        
        for index in 0..<imageGridViews.count {
            if [0, 1, 2].contains(index) {
                imageGridViews[index].topAnchor.constraint(equalTo: questionView.topAnchor).isActive = true
            }
            if [3, 4, 5].contains(index) {
                imageGridViews[index].topAnchor.constraint(equalTo: imageGridViews[0].bottomAnchor).isActive = true
            }
            if [6, 7, 8].contains(index) {
                imageGridViews[index].topAnchor.constraint(equalTo: imageGridViews[3].bottomAnchor).isActive = true
                imageGridViews[index].bottomAnchor.constraint(equalTo: questionView.bottomAnchor).isActive = true
            }
            if [0, 3, 6].contains(index) {
                imageGridViews[index].leadingAnchor.constraint(equalTo: questionView.leadingAnchor).isActive = true
            }
            if [1, 4, 7].contains(index) {
                imageGridViews[index].leadingAnchor.constraint(equalTo: imageGridViews[0].trailingAnchor).isActive = true
            }
            if [2, 5, 8].contains(index) {
                imageGridViews[index].leadingAnchor.constraint(equalTo: imageGridViews[1].trailingAnchor).isActive = true
                imageGridViews[index].trailingAnchor.constraint(equalTo: questionView.trailingAnchor).isActive = true
            }
            if index > 0 {
                imageGridViews[index].heightAnchor.constraint(equalTo: imageGridViews[index-1].heightAnchor).isActive = true
                imageGridViews[index].widthAnchor.constraint(equalTo: imageGridViews[index-1].widthAnchor).isActive = true
            }
        }
        
        loadQuestions()
    }
    
    func loadQuestions() {
        do {
            questionArray = try quizLoader.loadMultipleChoiceQuiz(forQuiz: "ImageQuiz")
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
    
    @objc func loadNextQuestion() {
        if quizAlertView != nil {
            quizAlertView.removeFromSuperview()
        }
        currentQuestion = questionArray[questionIndex]
        setTitleForButtons()
    }
    
    func setTitleForButtons() {
        for (index, button) in answerButtons.enumerated() {
            button.titleLabel?.lineBreakMode = .byWordWrapping
            button.setTitle(currentQuestion.answers[index], for: .normal)
            button.isEnabled = true
            button.backgroundColor = foregroundColour
            button.setTitleColor(UIColor.darkGray, for: .normal)
        }
        for view in imageGridViews {
            view.alpha = 1.0
        }
        questionView.image = UIImage(named: currentQuestion.question)
        revealIndex = 0
        revealTile()
        startTimer()
    }
    
    func startTimer() {
        progressView.progressTintColor = flatGreen
        progressView.trackTintColor = .clear
        progressView.progress = 1.0
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateProgressView), userInfo: nil, repeats: true)
        revealTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(revealTile), userInfo: nil, repeats: true)
    }
    
    @objc func revealTile() {
        if revealIndex < imageGridViews.count {
            UIView.animate(withDuration: 0.25, animations: {
                self.imageGridViews[self.revealIndex].alpha = 0.0
            })
            revealIndex += 1
        }
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
        revealTimer.invalidate()
        timer.invalidate()
        showAlert(forReason: 0)
        for button in answerButtons {
            button.isEnabled = false
        }
    }
    
    @objc func answerButtonHandler(_ sender: RoundedButton) {
        for view in imageGridViews {
            view.alpha = 0.0
        }
        revealTimer.invalidate()
        timer.invalidate()
        if sender.titleLabel?.text == currentQuestion.correctAnswer {
            score += 1 + (imageGridViews.count - revealIndex)
            questionIndex += 1
            questionIndex < questionArray.count ? showAlert(forReason: 3) : showAlert(forReason: 2)
        } else {
            sender.backgroundColor = flatRed
            showAlert(forReason: 1)
        }
        for button in answerButtons {
            button.isEnabled = false
            
            if button.titleLabel?.text == currentQuestion.correctAnswer {
                button.backgroundColor = flatGreen
            }
        }
    }
    
    func showAlert(forReason reason: Int) {
        
        switch reason {
        case 0:
            quizAlertView = QuizAlertView(withTitle: "You lost.", andMessage: "You ran out of time.", colours: [backgroundColour, foregroundColour])
            quizAlertView.closeButton.addTarget(self, action: #selector(closeAlert), for: .touchUpInside)
        case 1:
            quizAlertView = QuizAlertView(withTitle: "You lost.", andMessage: "You picked the wrong answer.", colours: [backgroundColour, foregroundColour])
            quizAlertView.closeButton.addTarget(self, action: #selector(closeAlert), for: .touchUpInside)
        case 2:
            quizAlertView = QuizAlertView(withTitle: "You won.", andMessage: "You answered all the questions.", colours: [backgroundColour, foregroundColour])
            quizAlertView.closeButton.addTarget(self, action: #selector(closeAlert), for: .touchUpInside)
        case 3:
            quizAlertView = QuizAlertView(withTitle: "Correct!", andMessage: "Tap continue to get the next question", colours: [backgroundColour, foregroundColour])
            quizAlertView.closeButton.addTarget(self, action: #selector(loadNextQuestion), for: .touchUpInside)
        default:
            break
        }
        
        if let quizAlertView = quizAlertView {
            quizAlertView.closeButton.setTitleColor(.darkGray, for: .normal)
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
            UserDefaults.standard.set(highScore, forKey: imageQuizHighScoreIdentifier)
        }
        UserDefaults.standard.set(score, forKey: imageQuizRecentScoreIdentifier)
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil {
            revealTimer.invalidate()
            timer.invalidate()
        }
    }
}
