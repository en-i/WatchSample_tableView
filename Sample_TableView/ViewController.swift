//
//  ViewController.swift
//  Sample_TableView
//
//  Created by terada enishi on 2021/06/03.
//

import UIKit
//Watchとの接続の役割
import WatchConnectivity

//WCSessionDelegate,UITableViewDelegate,UITableViewDataSourceを追加
class ViewController: UIViewController, WCSessionDelegate,UITableViewDelegate,UITableViewDataSource{
//tableViewを使用するときは、Main.StoryboardでtableViewのdelegateとdatasourceを、VIewControllerに接続しておく
    //tableViewのcellの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //receiveTimeListでも可
        return receiveAnimalList.count
    }
    
    //tableViewのcellの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //iOS_TableVIewCellを継承、cellのidentifierはMain.Storyboardで設定
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! iOS_TableViewCell
        //継承したanimalLabelに絵文字を代入
        cell.animalLabel.text = receiveAnimalList[indexPath.row]
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
    
    //Apple Watchから送られてきた、絵文字の情報を記録する配列
    var receiveAnimalList: [String]!
    
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
        
        //配列の初期化
        receiveAnimalList = []
        receiveTimeList = []
    }
    //Apple Watchのデータを受け取る関数(applicationContextに、送られてきたデータが入っている)
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async { () -> Void in
            //keyであるsendで検証
            if let message = applicationContext["send"] as? Dictionary<String, String> {
                //送られてきた絵文字を代入
                self.receiveAnimalList.append(message["animal"]! as String)
                //送られてきた時刻を代入
                self.receiveTimeList.append(message["date"]!)
                //tableVIewを更新
                self.tableView.reloadData()
            }
        }
    }
}

