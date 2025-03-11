//
//  TagsCollectionViewCell.swift
//  CoPilotAssignmentSwiftStroyboard
//
//  Created by Prakasha on 11/03/25.
//

import UIKit

class TagsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var labelHolderView: UIView!
    @IBOutlet weak var tagLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.labelHolderView.backgroundColor = .lightGray
        self.labelHolderView.layer.cornerRadius = 12.0
        self.labelHolderView.clipsToBounds = true
        self.labelHolderView.layer.borderWidth = 1.0
        self.labelHolderView.layer.borderColor = UIColor.darkGray.cgColor
    }

}
