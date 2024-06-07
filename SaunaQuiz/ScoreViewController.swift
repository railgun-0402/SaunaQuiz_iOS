//
//  ScoreViewController.swift
//  SaunaQuiz
//
//

import UIKit

class ScoreViewController: UIViewController {
    @IBOutlet var returnTopButton: UIButton!
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var scoreLabel: UILabel!
    
    var correct = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLabel.text = "\(correct)問正解!"
        
        shareButton.layer.borderWidth = 2
        shareButton.layer.borderColor = UIColor.black.cgColor
        returnTopButton.layer.borderWidth = 2
        returnTopButton.layer.borderColor = UIColor.black.cgColor
    }
    
    /* 結果をシェアするボタン */
    @IBAction func shareButtonAction(_ sender: Any) {
        let activityItems = ["\(correct)問正解しました。", "#クイズアプリ"]
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        self.present(activityVC, animated: true)
    }
    /* トップへ戻るボタン */
    @IBAction func toTopButtonAction(_ sender: Any) {
        // 2つ前の画面に戻る
        self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true)
    }        
}
