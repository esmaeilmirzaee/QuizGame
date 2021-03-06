//
//  Constants+Extensions.swift
//  Quiz Game
//
//  Created by Esmaeil MIRZAEE on 2020-04-27.
//  Copyright © 2020 TheBeaver. All rights reserved.
//

import Foundation
import UIKit

extension Array {
    
    mutating func shuffle() {
        if count < 2 { return }
        for i in 0..<(count-1) {
            var j = 0
            while j == i {
                j = Int(arc4random_uniform(UInt32(count - i))) + i
            }
            self.swapAt(i, j)
        }
    }
}

let multipleChoiceHighScoreIdentifier = "MultipleChoiceHighScoreIdentifier"
let multipleChoiceRecentScoreIdentifier = "MultipleChoiceRecentScoreIdentifier"

let imageQuizHighScoreIdentifier = "ImageQuizHighScoreIdentifier"
let imageQuizRecentScoreIdentifier = "ImageQuizRecentScoreIdentifier"

let rightWrongHighScoreIdentifier = "RightWrongHighScoreIdentifier"
let rightWrongRecentScoreIdentifier = "RightWrongRecentScoreIdentifier"

let emojiRiddleHighScoreIdentifier = "EmojiRiddleHighScoreIdentifier"
let emojiRiddleRecentScoreIdentifier = "EmojiRiddleRecentScoreIdentifier"


let flatGreen = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)
let flatOrange = UIColor(red: 203/255, green: 126/255, blue: 34/255, alpha: 1.0)
let flatRed = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
