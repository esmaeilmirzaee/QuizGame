//
//  QuizLoader.swift
//  Quiz Game
//
//  Created by Esmaeil MIRZAEE on 2020-04-28.
//  Copyright © 2020 TheBeaver. All rights reserved.
//

import Foundation

struct MultipleChoiceQuestion {
    let question: String
    let correctAnswer: String
    let answer: [String]
}

enum LoaderError: Error {
    case dictionaryFailed, pathFailed
}


class QuizLoader {
    public func loadMultipleChoiceQuiz(forQuiz quizName: String) throws -> [MultipleChoiceQuestion] {
        var questions = [MultipleChoiceQuestion]()
        
        if let path = Bundle.main.path(forResource: quizName, ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path) {
                let tempArray: Array = dict["Questions"]! as! [Dictionary<String,AnyObject>]
                for dictionary in tempArray {
                    let questionToAdd = MultipleChoiceQuestion(question: dictionary["Question"] as! String, correctAnswer: dictionary["CorrectAnswer"] as! String, answer: dictionary["Answers"] as! [String])
                    questions.append(questionToAdd)
                }
                return questions
            } else {
                throw LoaderError.dictionaryFailed
            }
        } else {
            throw LoaderError.pathFailed
        }
    }
}
