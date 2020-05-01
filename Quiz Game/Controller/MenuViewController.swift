//
//  ViewController.swift
//  Quiz Game
//
//  Created by Esmaeil MIRZAEE on 2020-04-27.
//  Copyright © 2020 TheBeaver. All rights reserved.
//

import UIKit
import SnapKit

class MenuViewController: UIViewController {
    
    private let paddings = Paddings()
    
    private let contentView = UIView()
    private let logoView = UIImageView()
    private let buttonView = UIView()
    private var gameButtons = [RoundedButton]()
    private let scoreView = UIView()
    private let titleLabel = UILabel()
    private let recentScoreLabel = UILabel()
    private let highScoreLabel = UILabel()

    private let titles = [
        "Multiple Choice",
        "Image Quiz",
        "Right or Wrong",
        "Emoji Riddle"
    ]
    
    private var recentScores = [Int]()
    private var highScores = [Int]()
    private var scoreIndex = 0
    private var timer = Timer()
    
    private var midXConstraints: [NSLayoutConstraint]!
    private var leftConstraints: [NSLayoutConstraint]!
    private var rightConstraints: [NSLayoutConstraint]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .white
        view.backgroundColor = UIColor(red: 41/255, green: 128/255, blue: 185/255, alpha: 1.0)
        layoutView()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        updateScores()
    }
    
    func updateScores() {
        recentScores = [
            UserDefaults.standard.integer(forKey: multipleChoiceRecentScoreIdentifier),
            UserDefaults.standard.integer(forKey: imageQuizRecentScoreIdentifier),
            UserDefaults.standard.integer(forKey: rightWrongRecentScoreIdentifier),
            UserDefaults.standard.integer(forKey: emojiRiddleRecentScoreIdentifier)
        ]
        
        highScores = [
            UserDefaults.standard.integer(forKey: multipleChoiceHighScoreIdentifier),
            UserDefaults.standard.integer(forKey: imageQuizHighScoreIdentifier),
            UserDefaults.standard.integer(forKey: rightWrongHighScoreIdentifier),
            UserDefaults.standard.integer(forKey: emojiRiddleHighScoreIdentifier)
        ]
    }
    
    func layoutView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        
        logoView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(logoView)
        logoView.image = UIImage(named: "logo")
        
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(buttonView)
        
        for (index, title) in titles.enumerated() {
            let button = RoundedButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            buttonView.addSubview(button)
            button.backgroundColor = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            button.setTitle(title, for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(buttonHandler), for: .touchUpInside)
            gameButtons.append(button)
        }
        
        scoreView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(scoreView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        recentScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        highScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreView.addSubview(titleLabel)
        scoreView.addSubview(recentScoreLabel)
        scoreView.addSubview(highScoreLabel)
        
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        titleLabel.textColor = .white
        recentScoreLabel.font = UIFont.boldSystemFont(ofSize: 20)
        recentScoreLabel.textColor = .white
        highScoreLabel.font = UIFont.boldSystemFont(ofSize: 20)
        highScoreLabel.textColor = .white
        
        titleLabel.text = titles[scoreIndex]
        recentScoreLabel.text = "Recent: \(String(UserDefaults.standard.integer(forKey: multipleChoiceRecentScoreIdentifier)))"
        highScoreLabel.text = "High Score: \(String(UserDefaults.standard.integer(forKey: multipleChoiceHighScoreIdentifier)))"
        
        let constraints = [
            contentView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8),
            contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            logoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: paddings.twenty),
            logoView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: paddings.sixTenth),
            logoView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: paddings.twoTenth),
            buttonView.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: paddings.twenty),
            buttonView.bottomAnchor.constraint(equalTo: scoreView.topAnchor, constant: paddings.minusTwenty),
            buttonView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: paddings.sixTenth),
            buttonView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            gameButtons[0].topAnchor.constraint(equalTo: buttonView.topAnchor, constant: paddings.eight),
            gameButtons[0].bottomAnchor.constraint(equalTo: gameButtons[1].topAnchor, constant: paddings.minusEight),
            gameButtons[0].leadingAnchor.constraint(equalTo: buttonView.leadingAnchor),
            gameButtons[0].trailingAnchor.constraint(equalTo: buttonView.trailingAnchor),
            gameButtons[1].bottomAnchor.constraint(equalTo: gameButtons[2].topAnchor, constant: paddings.minusEight),
            gameButtons[1].leadingAnchor.constraint(equalTo: buttonView.leadingAnchor),
            gameButtons[1].trailingAnchor.constraint(equalTo: buttonView.trailingAnchor),
            gameButtons[2].bottomAnchor.constraint(equalTo: gameButtons[3].topAnchor, constant: paddings.minusEight),
            gameButtons[2].leadingAnchor.constraint(equalTo: buttonView.leadingAnchor),
            gameButtons[2].trailingAnchor.constraint(equalTo: buttonView.trailingAnchor),
            gameButtons[3].bottomAnchor.constraint(equalTo: buttonView.bottomAnchor, constant: paddings.minusEight),
            gameButtons[3].leadingAnchor.constraint(equalTo: buttonView.leadingAnchor),
            gameButtons[3].trailingAnchor.constraint(equalTo: buttonView.trailingAnchor),
            gameButtons[0].heightAnchor.constraint(equalTo: gameButtons[1].heightAnchor),
            gameButtons[1].heightAnchor.constraint(equalTo: gameButtons[2].heightAnchor),
            gameButtons[2].heightAnchor.constraint(equalTo: gameButtons[3].heightAnchor),
            scoreView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: paddings.minusForty),
            scoreView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: paddings.sixTenth),
            scoreView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: paddings.threeTenth),
            titleLabel.topAnchor.constraint(equalTo: scoreView.topAnchor, constant: paddings.eight),
            titleLabel.leadingAnchor.constraint(equalTo: scoreView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: scoreView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: recentScoreLabel.topAnchor, constant: paddings.minusEight),
            recentScoreLabel.leadingAnchor.constraint(equalTo: scoreView.leadingAnchor),
            recentScoreLabel.trailingAnchor.constraint(equalTo: scoreView.trailingAnchor),
            recentScoreLabel.bottomAnchor.constraint(equalTo: highScoreLabel.topAnchor, constant: paddings.minusEight),
            highScoreLabel.leadingAnchor.constraint(equalTo: scoreView.leadingAnchor),
            highScoreLabel.trailingAnchor.constraint(equalTo: scoreView.trailingAnchor),
            highScoreLabel.bottomAnchor.constraint(equalTo: scoreView.bottomAnchor, constant: paddings.minusEight),
            titleLabel.heightAnchor.constraint(equalTo: recentScoreLabel.heightAnchor),
            recentScoreLabel.heightAnchor.constraint(equalTo: highScoreLabel.heightAnchor)
        ]
        
        midXConstraints = [scoreView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)]
        leftConstraints = [scoreView.trailingAnchor.constraint(equalTo: contentView.leadingAnchor)]
        rightConstraints = [scoreView.leadingAnchor.constraint(equalTo: contentView.trailingAnchor)]
        
        NSLayoutConstraint.activate(constraints)
        NSLayoutConstraint.activate(midXConstraints)
        
        timer = Timer.scheduledTimer(timeInterval: 3.9, target: self, selector: #selector(nextScores), userInfo: nil, repeats: true)
    }
    
    @objc func buttonHandler(sender: RoundedButton) {
        var vc: UIViewController?
        switch sender.tag {
        case 0:
            print("Multiple")
            vc = MultipleChoiceViewController()
        case 1:
            vc = ImageQuizViewController()
        case 2:
            print("Right Wrong")
        case 3:
            vc = EmojiQuizViewController()
        default:
            break
        }
        
        if let newVC = vc {
            navigationController?.pushViewController(newVC, animated: true)
        }
    }
    
    @objc func nextScores() {
        scoreIndex = scoreIndex < (recentScores.count - 1) ? scoreIndex + 1 : 0
        UIView.animate(withDuration: 2.0, animations: {
            NSLayoutConstraint.deactivate(self.midXConstraints)
            NSLayoutConstraint.activate(self.leftConstraints)
            self.view.layoutIfNeeded()
        }) { (compilation: Bool) in
            self.titleLabel.text = self.titles[self.scoreIndex]
            self.recentScoreLabel.text = "Recent: \(String(self.recentScores[self.scoreIndex]))"
            self.highScoreLabel.text = "Highscore: \(String(self.highScores[self.scoreIndex]))"
            NSLayoutConstraint.deactivate(self.leftConstraints)
            NSLayoutConstraint.activate(self.rightConstraints)
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 1.0) {
                NSLayoutConstraint.deactivate(self.rightConstraints)
                NSLayoutConstraint.activate(self.midXConstraints)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    

}

