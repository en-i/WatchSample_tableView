//
//  ViewController.swift
//  Sample_TableView
//
//  Created by terada enishi on 2021/06/03.
//

import UIKit
//Watchとの接続の役割
import WatchConnectivity

//WCSessionDelegate,UITableViewDelegate,UITableViewDataSource,UINavigationBarDelegateを追加
class ViewController: UIViewController, WCSessionDelegate,UITableViewDelegate,UITableViewDataSource,UINavigationBarDelegate{
//tableViewを使用するときは、Main.StoryboardでtableViewのdelegateとdatasourceを、VIewControllerに接続しておく
    //tableViewのcellの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //receiveTimeListでも可
        return receiveEmojiList.count
    }
    
    //tableViewのcellの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //iOS_TableVIewCellを継承、cellのidentifierはMain.Storyboardで設定
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! iOS_TableViewCell
        //継承したanimalLabelに絵文字を代入
        cell.animalLabel.text = receiveEmojiList[indexPath.row]
        //継承したtimeLabelに時刻を代入
        cell.timeLabel.text = receiveTimeList[indexPath.row]
        return cell
    }
    
    //tableViewのcellの高さを調整
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    //tableViewと接続
    @IBOutlet weak var tableView: UITableView!
    
    //ナビゲーションバーと接続
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    //追加ボタンと接続
    @IBAction func addButton(_ sender: Any) {
        //追加用TextField
        var alertTextField: UITextField?
        
        //ダイアログを定義
        let alert = UIAlertController(
            title: "追加データ",
            message: "",
            preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(
            configurationHandler: {(textField: UITextField!) in
                alertTextField = textField
        })
        
        //Cancelを押した時
        alert.addAction(
            UIAlertAction(
                title: "取り消し",
                style: UIAlertAction.Style.cancel,
                handler: nil))
        
        //OKを押した時
        alert.addAction(
            UIAlertAction(
                title: "送信",
                style: UIAlertAction.Style.default) {_ in
                
                //入力データをWatchに送信
                let addEmoji: String = alertTextField!.text!
                let message = ["send" :addEmoji]
                //Watchにデータを送る処理
                WCSession.default.sendMessage(message, replyHandler:  { reply in print(reply) }, errorHandler: { error in print(error.localizedDescription)})
            }
        )
        self.present(alert, animated: true, completion: nil)
    }
    
    //Apple Watchから送られてきた、絵文字の情報を記録する配列
    var receiveEmojiList: [String]!
    
    //Apple Watchから送られてきた、時刻の情報を記録する配列
    var receiveTimeList:[String]!
    
    //WatchConnectivityを使うときは必ず記入
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    func sessionDidDeactivate(_ session: WCSession) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //WatchConnectivityのSession開始
        if (WCSession.isSupported()) {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
        //ナビゲーションバーの初期設定
        navigationBar.delegate = self
        
        //データの読み込み
        if UserDefaults.standard.object(forKey: "receiveEmojiList") != nil && UserDefaults.standard.object(forKey: "receiveTimeList") != nil{
            receiveEmojiList = UserDefaults.standard.object(forKey: "receiveEmojiList") as? [String]
            receiveTimeList = UserDefaults.standard.object(forKey: "receiveTimeList") as? [String]
        }else{
            //配列の初期化
            receiveEmojiList = []
            receiveTimeList = []
        }
        
        self.tableView.reloadData()
        
    }
    
    //Apple Watchのデータを受け取る関数(applicationContextに、送られてきたデータが入っている)
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async { () -> Void in
            //keyであるsendで検証
            if let message = applicationContext["send"] as? Dictionary<String, String> {
                //送られてきた絵文字を代入
                self.receiveEmojiList.append(message["animal"]! as String)
                //送られてきた時刻を代入
                self.receiveTimeList.append(message["date"]!)
                
                //データを保存
                UserDefaults.standard.set(self.receiveEmojiList, forKey: "receiveEmojiList")
                UserDefaults.standard.set(self.receiveTimeList, forKey: "receiveTimeList")
                
                //tableVIewを更新
                self.tableView.reloadData()
            }
        }
    }
    
    //ナビゲーションバーの位置を調整
    func position(for bar: UIBarPositioning) -> UIBarPosition {
            return .topAttached
    }
}

