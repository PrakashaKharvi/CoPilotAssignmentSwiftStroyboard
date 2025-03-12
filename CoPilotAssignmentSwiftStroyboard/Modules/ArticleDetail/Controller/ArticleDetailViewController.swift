//
//  ArticleDetailViewController.swift
//  CoPilotAssignmentSwiftStroyboard
//
//  Created by Prakasha on 11/03/25.
//

import UIKit
import WebKit
import Kingfisher
import AVKit

class ArticleDetailViewController: UIViewController {

    private let viewModel: ArticleDetailViewModel
    private let playerView: VideoPlayerView = VideoPlayerView() // Extracted Video Logic
    private var controlsTimer: Timer?

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
        articleTitleLabel.text = viewModel.articleTitle
        authorNameLabel.text = viewModel.authorName
        articleSubtitleLabel.text = viewModel.articleSubtitle

        if let imageURL = viewModel.articleImageURL {
            articleHeroImageView.kf.setImage(with: URL(string: imageURL))
            articleHeroImageView.contentMode = .scaleAspectFill
            articleHeroImageView.clipsToBounds = true
            articleHeroImageView.layer.cornerRadius = 10
            articleHeroImageView.layer.borderWidth = 0.7
            articleHeroImageView.layer.borderColor = UIColor.darkGray.cgColor
        }

        if viewModel.isArticleText {
            articleVideoHolderView.isHidden = true
            articleDescriptionWebView.loadHTMLString(viewModel.articleDescription, baseURL: nil)
        } else {
            articleDescriptionWebView.isHidden = true
            setupVideoPlayer()
        }
    }
    
    private func setupVideoPlayer() {
        playerView.frame = articleVideoHolderView.bounds
        articleVideoHolderView.addSubview(playerView)
        playerView.configure(with: viewModel.videoURL)
    }

    private func setupCollectionView() {
        articleTagsCollectionView.dataSource = self
        articleTagsCollectionView.delegate = self
        articleTagsCollectionView.register(UINib(nibName: "TagsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TagsCollectionViewCell")

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        articleTagsCollectionView.collectionViewLayout = layout
    }

    private func bindViewModel() {
        viewModel.onTagsUpdated = { [weak self] in
            self?.articleTagsCollectionView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        playerView.stopPlaying()
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
        self.viewModel.navigateToArticleTagScreen(at: indexPath.row)
    }
}
