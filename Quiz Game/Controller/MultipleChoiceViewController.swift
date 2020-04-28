//
//  MultipleChoiceViewController.swift
//  Quiz Game
//
//  Created by Esmaeil MIRZAEE on 2020-04-27.
//  Copyright © 2020 TheBeaver. All rights reserved.
//

import UIKit

class MultipleChoiceViewController: UIViewController {

    
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
    
    private let backgroundColour = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
    private let foregroundColour = UIColor(red: 52/255, green: 73/255, blue: 94/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .systemBlue
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
        questionLabel.textColor = .white
        questionLabel.font = UIFont.boldSystemFont(ofSize: 50)
        questionLabel.textAlignment = .center
        questionLabel.numberOfLines = 4
        questionLabel.adjustsFontSizeToFitWidth = true
        
        questionButton.translatesAutoresizingMaskIntoConstraints = false
        questionView.addSubview(questionButton)
        questionButton.isEnabled = false
        
        answerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(answerView)
        
        for _ in 0...3 {
            let button = RoundedButton()
            answerButtons.append(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            answerView.addSubview(button)
        }
        
        countDownView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(countDownView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        countDownView.addSubview(progressView)
    }
}
