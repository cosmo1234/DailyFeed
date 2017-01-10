//
//  DailyFeedItemCell.swift
//  DailyFeed
//
//  Created by TrianzDev on 28/12/16.
//  Copyright © 2016 trianz. All rights reserved.
//

import UIKit

class DailyFeedItemCell: UICollectionViewCell {

    @IBOutlet weak var newsItemImageView: TSImageView!
    @IBOutlet weak var newsItemTitleLabel: UILabel!
    @IBOutlet weak var newsItemSourceLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addGradient()
    }
    
    func addGradient() {
        guard newsItemImageView.layer.sublayers?.count == nil else { return }
    
        newsItemImageView.addGradient([UIColor(white: 0, alpha: 0.6).cgColor, UIColor.clear.cgColor], locations: [0.0, 0.98])
    }
    
    func offset(_ offset: CGPoint) {
        newsItemImageView.frame = self.newsItemImageView.bounds.offsetBy(dx: offset.x, dy: offset.y)
    }

}
