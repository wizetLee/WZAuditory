//
//  WZMusicRecycleCell.swift
//  WZAuditory
//
//  Created by 李炜钊 on 2017/12/10.
//  Copyright © 2017年 wizet. All rights reserved.
//

import UIKit

class WZMusicRecycleCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
