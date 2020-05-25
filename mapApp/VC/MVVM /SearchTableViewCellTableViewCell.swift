//
//  SearchTableViewCellTableViewCell.swift
//  mapApp
//
//  Created by user on 5/22/20.
//  Copyright © 2020 Vinova.Train.mapApp. All rights reserved.
//

import UIKit

class SearchTableViewCellTableViewCell: UITableViewCell {

   // @IBOutlet weak var subText: UILabel?
    
    @IBOutlet weak var Title: UILabel!
    
    @IBOutlet weak var subTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//           super.init(style: style, reuseIdentifier: "searchCell")
//
//       }
//
//       required init?(coder aDecoder: NSCoder) {
//              fatalError("init(coder:) has not been implemented")
//          }
       

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
