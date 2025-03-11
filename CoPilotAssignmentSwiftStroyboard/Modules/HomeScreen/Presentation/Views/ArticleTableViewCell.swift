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
            // Download image from URL
//            self.imageView?.kf.setImage(with: URL(string: "https://res.cloudinary.com/your_cloudinary_name/image/upload/w_100,h_100/your_image_file.jpg")!)
//            self.imageView?.contentMode = .scaleAspectFill
//            self.imageView?.clipsToBounds = true
//            
//            imageView?.layer.masksToBounds = true
//            imageView?.layer.cornerRadius = 10
//
//            imageView?.layer.borderWidth = 1
//            imageView?.layer.borderColor = UIColor.yellow.cgColor
//            imageView?.clipsToBounds = true
            
            
//            let url = URL(string: imageUrl)
//            let processor = DownsamplingImageProcessor(size: (imageView?.bounds.size)!)
//                         |> RoundCornerImageProcessor(cornerRadius: 20)
//            imageView?.kf.indicatorType = .activity
//            imageView?.kf.setImage(
//                with: url,
//                placeholder: UIImage(named: "placeholderImage"),
//                options: [
//                    .processor(processor),
//                    .scaleFactor(UIScreen.main.scale),
//                    .transition(.fade(1)),
//                    .cacheOriginalImage
//                ])
//            {
//                result in
//                switch result {
//                case .success(let value):
//                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
//                case .failure(let error):
//                    print("Job failed: \(error.localizedDescription)")
//                }
//            }
        }
        if let title = model?.title {
            self.articleTitleLabel.text = title
        }
        if let description = model?.Subtitle {
            self.articleDescriptionLabel.text = description
        }
    }
}
