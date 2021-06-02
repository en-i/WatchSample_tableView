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
    let animals = ["🐱 ネコ", "🐶 イヌ", "🐹 ハムスター", "🐲 ドラゴン", "🦄 ユニコーン"]
    
    //tableと接続
    @IBOutlet weak var sendTable: WKInterfaceTable!
    override func awake(withContext context: Any?) {
        //WatchConnectivityのSession開始
        if (WCSession.isSupported()) {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
        //配列animalsのデータの数だけ、tableを形成、withRowTypeはRowControllerのidentifierで設定
        sendTable.setNumberOfRows(animals.count, withRowType: "row")
        
        //enumerated関数を使うことで、配列animalsのデータがitemに、取得されたデータのindex番号がindexに返される
        for (index, item) in animals.enumerated() {
            //Watch_TableRowを継承
            let row = sendTable.rowController(at: index) as! Watch_TableRow
            //継承したanimalLabelに時刻を代入
            row.animalLabel.setText(item)
        }
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
        
        //データをanimal,dateをkeyとしてiOSに送信
        let item: Dictionary<String, String> = ["animal": animals[rowIndex],"date": dateFormatter.string(from: Date())]
        //メッセージ全体のkeyをsendに設定して送信
        let message = ["send" :item]
        do{
            try WCSession.default.updateApplicationContext(message)
        }catch{
            //失敗した時
        }
    }
}
