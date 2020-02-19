//
//  ViewController.swift
//  BRKWordCloud
//
//  Created by arsinio on 02/18/2020.
//  Copyright (c) 2020 arsinio. All rights reserved.
//
import UIKit


import BRKWordCloud


class ViewController: UIViewController {

    
    @IBOutlet weak var wordCloudView : BRKWordCloudView?
    
    
    //MARK: View Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // generate random words
        self.wordCloudView?.colors = UIColor.lal_colors(forPreferredColor: .blueGreen) as! [UIColor]
        self.wordCloudView?.words = self.generateRandomWords()
    }

    //MARK: Private Functions
    private func generateRandomWords() -> [String:NSNumber] {
        var retVal : [String:NSNumber] = [:]
        
        if let wordsFilePath = Bundle.main.path(forResource: "web2", ofType: nil) {
            do{
                let wordsString = try String(contentsOfFile: wordsFilePath)
                let wordLines = wordsString.components(separatedBy: .newlines)
                
                for _ in 0...100 {
                    let randomLine = wordLines[numericCast(arc4random_uniform(numericCast(wordLines.count)))]
                    retVal[randomLine] = NSNumber(integerLiteral: Int.random(in: 0 ..< 1000))
                }
            }catch { }
        }
        
        return retVal
    }
}
