//
//  ArticleTableViewCell.swift
//  CoPilotAssignmentSwiftStroyboard
//
//  Created by Prakasha on 07/03/25.
//

import UIKit
import Kingfisher

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var aricleImageView: UIImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(model: ArticleItemModel?) {
        if let imageUrl = model?.hero {
            self.aricleImageView?.kf.setImage(with: URL(string: imageUrl)!)
            self.aricleImageView?.contentMode = .scaleAspectFill
            self.aricleImageView?.clipsToBounds = true
            aricleImageView?.layer.cornerRadius = 10
            aricleImageView?.layer.borderWidth = 0.7
            aricleImageView?.layer.borderColor = UIColor.darkGray.cgColor
        }
        if let title = model?.title {
            self.articleTitleLabel.text = title
        }
        if let description = model?.Subtitle {
            self.articleDescriptionLabel.text = description
        }
    }
}
