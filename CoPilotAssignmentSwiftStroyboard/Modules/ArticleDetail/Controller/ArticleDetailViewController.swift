//
//  ArticleDetailViewController.swift
//  CoPilotAssignmentSwiftStroyboard
//
//  Created by Prakasha on 11/03/25.
//

import UIKit
import WebKit
import Kingfisher

class ArticleDetailViewController: UIViewController {

    private let viewModel: ArticleDetailViewModel

    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleHeroImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var articleSubtitleLabel: UILabel!
    @IBOutlet weak var articleDescriptionWebView: WKWebView!
    @IBOutlet weak var articleVideoHolderView: UIView!
    @IBOutlet weak var articleTagsCollectionView: UICollectionView!
    
    
    init(viewModel: ArticleDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ArticleDetailViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Article Detail" //self.viewModel.article.authorName

        // populate the objects
        self.setupUI()
        
        //setCollectionView
        self.setupCollectionView()
    }
    
    fileprivate func setupUI() {
        if let title = self.viewModel.article.title {
            self.articleTitleLabel.text = title
        }
        if let imageURL = self.viewModel.article.hero {
            self.articleHeroImageView.kf.setImage(with: URL(string: imageURL))
        }
        if let authorName = self.viewModel.article.authorName {
            self.authorNameLabel.text = authorName
        }
        if let subTitle = self.viewModel.article.Subtitle {
            self.articleSubtitleLabel.text = subTitle
        }
        if let articleType = self.viewModel.article.articleType {
            if articleType == 1 {
                self.articleVideoHolderView.isHidden = true
                
                if let descriptionHTML = self.viewModel.article.description {
                    self.articleDescriptionWebView.loadHTMLString(descriptionHTML, baseURL: nil)
                }
            } else {
                self.articleDescriptionWebView.isHidden = true
                if let videoURLString = self.viewModel.article.hero {
                }
            }
        }
    }

    fileprivate func setupCollectionView() {
        self.articleTagsCollectionView.dataSource = self
        self.articleTagsCollectionView.delegate = self
        
        self.articleTagsCollectionView.register(UINib(nibName: "TagsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TagsCollectionViewCell")
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        self.articleTagsCollectionView.collectionViewLayout = layout
    }

}

extension ArticleDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfTags()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagsCollectionViewCell", for: indexPath) as! TagsCollectionViewCell
        cell.tagLabel.text = self.viewModel.getTagText(at: indexPath.row)
        return cell
    }
}

extension ArticleDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tag = self.viewModel.getTagText(at: indexPath.row)
        print("Selected tag:", tag)
        self.viewModel.navigateToArticleTagScreen(at: indexPath.row)
    }
}
