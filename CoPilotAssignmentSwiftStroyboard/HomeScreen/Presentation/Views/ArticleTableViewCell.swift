//
//  ArticleTableViewCell.swift
//  CoPilotAssignmentSwiftStroyboard
//
//  Created by Prakasha on 07/03/25.
//

import UIKit

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
//            self.imageView?.loadImage(from: imageUrl)
        }
        if let title = model?.title {
            self.articleTitleLabel.text = title
        }
        if let description = model?.Subtitle {
            self.articleDescriptionLabel.text = description
        }
    }
}

extension UIImageView {
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to load image: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Invalid image data")
                return
            }
            
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
