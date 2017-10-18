//
//  WasteMaterialsTableViewCell.swift
//  BlueMountain-Swift
//
//  Created by Ashim Dhakal on 10/11/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import UIKit
import SDWebImage

class WasteMaterialsTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var thumnailImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func draw(_ rect: CGRect) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
      
    }
    
    
    func configureView(withPage page : Pages){
        
        self.thumnailImageView.sd_setImage(with: NSURL(string: page.pageImage!)! as URL, placeholderImage: nil, options: .scaleDownLargeImages, completed: nil)
    
        self.titleLabel.text = page.pageTitle 
    }
 
    
    
    
    
}
