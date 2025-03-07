//
//  DropDownCollectionViewCell.swift
//  CoPilotAssignmentSwiftStroyboard
//
//  Created by Prakasha on 06/03/25.
//

import UIKit

class DropDownCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        holderView.layer.cornerRadius = 10
        holderView.layer.borderWidth = 0.7
        holderView.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    func configureCell(list: [FilterItemModel]?) {
        guard let list = list else { return }
        nameLabel.text = getSelectedItem(list: list).name
    }
    
    fileprivate func getSelectedItem(list: [FilterItemModel]) -> FilterItemModel {
        return list.first(where: { $0.selected == "true" }) ?? list[0]
    }
}
