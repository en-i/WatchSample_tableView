//
//  Watch_TableRow.swift
//  Sample_TableView WatchKit Extension
//
//  Created by terada enishi on 2021/06/03.
//

import WatchKit

//tableのディレクトリのControllerに継承させる
class Watch_TableRow: NSObject {
    //rowのラベルと接続
    @IBOutlet weak var animalLabel: WKInterfaceLabel!
}
