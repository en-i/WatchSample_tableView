//
//  InterfaceController.swift
//  Sample_TableView WatchKit Extension
//
//  Created by terada enishi on 2021/06/03.
//

import WatchKit
import Foundation
//iOSとの接続の役割
import WatchConnectivity

//WCSessionDelegateを追加
class InterfaceController: WKInterfaceController,WCSessionDelegate {
    //WatchConnectivityを使うときは必ず記入
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    //tableに表示するデータ
    var emojis: [String]!
    
    //tableと接続
    @IBOutlet weak var sendTable: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        //WatchConnectivityのSession開始
        if (WCSession.isSupported()) {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
        //データの読み込み
        if UserDefaults.standard.object(forKey: "emojis") != nil{
            emojis = UserDefaults.standard.object(forKey: "emojis") as? [String]
        }else{
            //配列の初期化
            emojis = ["🐱 ネコ", "🐶 イヌ", "🐹 ハムスター", "🐲 ドラゴン", "🦄 ユニコーン"]
        }
        
        //Table生成の関数(↓を参照)
        createTable()

    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    //tableがタップされた時の処理
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        
        //押された日付を取得、yyyy/MM/dd HH:mm:ssの形に整型
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeStyle = .medium
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let date = dateFormatter.string(from: Date())
        
        //animal、dateをkeyとしてiOSに送信
        let message = ["animal": emojis[rowIndex],"date": date]
        WCSession.default.sendMessage(message, replyHandler:  { reply in print(reply) }, errorHandler: { error in print(error.localizedDescription)})
    }
    
    //iOSからデータを受け取った時の処理
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        DispatchQueue.main.async {() -> Void in
            
            //送られてきた絵文字を追加
            self.emojis.append(message["send"] as! String)
            
            //データを保存
            UserDefaults.standard.set(self.emojis, forKey: "emojis")
            
            //Tableを再定義
            self.createTable()
            replyHandler(["watch": "OK"])
        }
        
    }
    
    //Tableを生成する関数
    func createTable(){
        
        //配列animalsのデータの数だけtableを生成、withRowTypeはRowControllerのidentifierで設定
        sendTable.setNumberOfRows(emojis.count, withRowType: "row")
        
        //enumerated関数を使うことで、配列animalsのデータがitemに、取得されたデータのindex番号がindexに返される
        for (index, item) in emojis.enumerated() {
            
            //Watch_TableRowを継承
            let row = sendTable.rowController(at: index) as! Watch_TableRow
            
            //継承したanimalLabelに時刻を代入
            row.animalLabel.setText(item)
        }
    }
}
