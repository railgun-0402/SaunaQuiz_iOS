//
//  QuizViewController.swift
//  SaunaQuiz
//
//

import UIKit
import GoogleMobileAds

class QuizViewController: UIViewController {
    @IBOutlet weak var quizNumberLabel: UILabel!
    @IBOutlet var quizTextView: UITextView!
    
    @IBOutlet var answerButton1: UIButton!
    
    @IBOutlet var answerButton2: UIButton!
    @IBOutlet var answerButton3: UIButton!
    
    @IBOutlet var answerButton4: UIButton!
    @IBOutlet var judgeImageView: UIImageView!
    
    var bannerView: GADBannerView!
    var csvArray: [String] = []
    var quizArray: [String] = []
    var quizCount = 0
    var correctCount = 0
    var selectLevel = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        addBannerViewToView(bannerView)
        
        print("選択したのはレベル\(selectLevel)")
        
        csvArray = loadCSV(fileName: "quiz\(selectLevel)")
        
        csvArray.shuffle() // 問題をシャッフルする
        quizArray = csvArray[quizCount].components(separatedBy: ",")
        
        quizNumberLabel.text = "第\(quizCount + 1)問"
        quizTextView.text = quizArray[0]
        answerButton1.setTitle(quizArray[2], for: .normal)
        answerButton2.setTitle(quizArray[3], for: .normal)
        answerButton3.setTitle(quizArray[4], for: .normal)
        answerButton4.setTitle(quizArray[5], for: .normal)
        
        answerButton1.layer.borderWidth = 2
        answerButton1.layer.borderColor = UIColor.black.cgColor
        answerButton2.layer.borderWidth = 2
        answerButton2.layer.borderColor = UIColor.black.cgColor
        answerButton3.layer.borderWidth = 2
        answerButton3.layer.borderColor = UIColor.black.cgColor
        answerButton4.layer.borderWidth = 2
        answerButton4.layer.borderColor = UIColor.black.cgColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let scoreVC = segue.destination as! ScoreViewController
        scoreVC.correct = correctCount
    }
    
    // 要素の状態を変更する
    func changeElement(status: Bool) {
        self.judgeImageView.isHidden = status
        self.answerButton1.isEnabled = status
        self.answerButton2.isEnabled = status
        self.answerButton3.isEnabled = status
        self.answerButton4.isEnabled = status
    }
    
    //ボタンを押したときに呼ばれる
    @IBAction func btnAction(sender: UIButton) {
        if sender.tag == Int(quizArray[1]) {
            correctCount += 1
            print("正解")
            judgeImageView.image = UIImage(named: "correct")
        } else {
            print("不正解")
            judgeImageView.image = UIImage(named: "incorrect")
        }
        // ボタンと画像を非活性にする
        changeElement(status: false)
        // 丸と罰の画像を0.5s後に削除する
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // ボタンと画像を活性にする
            self.changeElement(status: true)
            self.nextQuiz()
        }
    }
    
    func nextQuiz() {
        quizCount += 1
        if quizCount < csvArray.count {
            quizArray = csvArray[quizCount].components(separatedBy: ",")
            quizNumberLabel.text = "第\(quizCount + 1)問"
            quizTextView.text = quizArray[0]
            answerButton1.setTitle(quizArray[2], for: .normal)
            answerButton2.setTitle(quizArray[3], for: .normal)
            answerButton3.setTitle(quizArray[4], for: .normal)
            answerButton4.setTitle(quizArray[5], for: .normal)
        } else {
            performSegue(withIdentifier: "toScoreVC", sender: nil)
        }
    }
    
    func loadCSV(fileName: String) -> [String] {
        // 指定されたファイル名のCSVファイルのパスを取得
        let csvBundle = Bundle.main.path(forResource: fileName, ofType: "csv")!
        do {
            // CSVファイルの内容を文字列として読み込む
            let csvData = try String(contentsOfFile: csvBundle, encoding: String.Encoding.utf8)
            // 改行コードが "\r" となっている部分を "\n" に置き換える
            let lineChange = csvData.replacingOccurrences(of: "\r", with: "\n")
            // 改行コード "\n" を基準に文字列を分割し、配列として取得
            csvArray = lineChange.components(separatedBy: "\n")
            // 最後の空要素を削除
            csvArray.removeLast()
        } catch {
            print("エラー")
        }
        // CSVの内容を行ごとに格納した配列を返す
        return csvArray
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false // 手動制約
        view.addSubview(bannerView)
        view.addConstraints(
        [NSLayoutConstraint(item: bannerView,
                    attribute: .bottom,
                    relatedBy: .equal,
                    toItem: view.safeAreaLayoutGuide,
                    attribute: .bottom,
                    multiplier: 1,
                    constant: 0),
         NSLayoutConstraint(item: bannerView,
                    attribute: .centerX,
                    relatedBy: .equal,
                    toItem: view,
                    attribute: .centerX,
                    multiplier: 1,
                    constant: 0)
        ])
    }
}
