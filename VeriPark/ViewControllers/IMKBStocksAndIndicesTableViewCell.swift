//
//  IMKBStocksAndIndicesTableViewCell.swift
//  VeriPark
//
//  Created by ENES AKSOY on 10.10.2019.
//  Copyright © 2019 ENES AKSOY. All rights reserved.
//

import UIKit

class IMKBStocksAndIndicesTableViewCell: UITableViewCell {

    @IBOutlet weak var symbolValueLabel: UILabel!
    @IBOutlet weak var priceValueLabel: UILabel!
    @IBOutlet weak var differenceValueLabel: UILabel!
    @IBOutlet weak var volumeValueLabel: UILabel!
    @IBOutlet weak var buyingValueLabel: UILabel!
    @IBOutlet weak var salesValueLabel: UILabel!
    @IBOutlet weak var changeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
