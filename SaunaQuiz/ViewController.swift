//
//  ViewController.swift
//  SaunaQuiz
//
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.layer.borderWidth = 2
        startButton.layer.borderColor = UIColor.black.cgColor
    }


}

