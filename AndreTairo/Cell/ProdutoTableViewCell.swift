//
//  ProdutoTableViewCell.swift
//  AndreTairo
//
//  Created by Vinicius Torres on 01/10/17.
//  Copyright © 2017 Vinicius Torres. All rights reserved.
//

import UIKit

class ProdutoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imagemIV: UIImageView!
    @IBOutlet weak var nomeLbl: UILabel!
    @IBOutlet weak var valorLbl: UILabel!
    @IBOutlet weak var estadoLbl: UILabel!
    @IBOutlet weak var cartaoLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
