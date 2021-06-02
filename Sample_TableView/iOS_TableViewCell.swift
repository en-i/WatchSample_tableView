//
//  iOS_TableViewCell.swift
//  Sample_TableView
//
//  Created by terada enishi on 2021/06/03.
//

import UIKit

//tableViewのcellに継承させる
class iOS_TableViewCell: UITableViewCell {
    //太字のラベルと接続
    @IBOutlet weak var animalLabel: UILabel!
    //薄い灰色のラベルと接続
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
