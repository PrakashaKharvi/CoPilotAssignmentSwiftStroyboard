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
    private var player: AVPlayer?
    private let playerLayer = AVPlayerLayer()
    private let playPauseButton = UIButton()
    private let seekSlider = UISlider()
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
        if let title = self.viewModel.article.title {
            self.articleTitleLabel.text = title
        }
        if let imageURL = self.viewModel.article.hero {
            self.articleHeroImageView.kf.setImage(with: URL(string: imageURL))
            self.articleHeroImageView.contentMode = .scaleAspectFill
            self.articleHeroImageView.clipsToBounds = true
            self.articleHeroImageView.layer.cornerRadius = 10
            self.articleHeroImageView.layer.borderWidth = 0.7
            self.articleHeroImageView.layer.borderColor = UIColor.darkGray.cgColor
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
                if let videoURLString = self.viewModel.article.description {
                    self.setupPlayer(url: videoURLString)
                    self.setupControls()
                    self.setupObservers()
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

extension ArticleDetailViewController {

    private func setupPlayer(url: String) {
        // 1. Video URL
        guard let url = URL(string: url) else { return }

        // 2. Create AVPlayer
        player = AVPlayer(url: url)
        
        // 3. Configure Player Layer
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill // Adjust video aspect ratio
        
        // 4. Attach PlayerLayer to View
        playerLayer.frame = view.bounds
        self.articleVideoHolderView.layer.addSublayer(playerLayer)
        
        // 5. Start Playing
        player?.play()
    }
    
    private func setupControls() {
        // Play/Pause Button
        playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        playPauseButton.tintColor = .white
        playPauseButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        playPauseButton.layer.cornerRadius = 12
        playPauseButton.addTarget(self, action: #selector(playPauseTapped), for: .touchUpInside)

        // Seek Bar (UISlider)
        seekSlider.minimumValue = 0
        seekSlider.maximumValue = 1
        seekSlider.addTarget(self, action: #selector(seekSliderChanged), for: .valueChanged)

        // Auto Layout
        let controlsStackView = UIStackView(arrangedSubviews: [playPauseButton, seekSlider])
        controlsStackView.axis = .horizontal
        controlsStackView.spacing = 10
        controlsStackView.alignment = .center
        controlsStackView.distribution = .fillProportionally
        controlsStackView.translatesAutoresizingMaskIntoConstraints = false

        self.articleVideoHolderView.addSubview(controlsStackView)

        NSLayoutConstraint.activate([
            controlsStackView.leadingAnchor.constraint(equalTo: articleVideoHolderView.leadingAnchor, constant: 7),
            controlsStackView.trailingAnchor.constraint(equalTo: articleVideoHolderView.trailingAnchor, constant: -7),
            controlsStackView.bottomAnchor.constraint(equalTo: articleVideoHolderView.bottomAnchor, constant: -7),
            playPauseButton.widthAnchor.constraint(equalToConstant: 39),
            playPauseButton.heightAnchor.constraint(equalToConstant: 39),
        ])

        // Tap Gesture to Show/Hide Controls
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleControls))
        self.articleVideoHolderView.addGestureRecognizer(tapGesture)
    }

    private func setupObservers() {
        guard let player = player else { return }
        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let duration = player.currentItem?.duration.seconds, duration > 0 else { return }
            self?.seekSlider.value = Float(time.seconds / duration)
        }
    }

    @objc private func playPauseTapped() {
        guard let player = player else { return }
        if player.timeControlStatus == .playing {
            player.pause()
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            player.play()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
        resetControlsTimer()
    }

    @objc private func seekSliderChanged() {
        guard let duration = player?.currentItem?.duration.seconds, duration > 0 else { return }
        let newTime = CMTime(seconds: Double(seekSlider.value) * duration, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player?.seek(to: newTime)
        resetControlsTimer()
    }

    @objc private func toggleControls() {
        let isHidden = playPauseButton.isHidden
        playPauseButton.isHidden = !isHidden
        seekSlider.isHidden = !isHidden
        if !isHidden {
            resetControlsTimer()
        }
    }

    private func resetControlsTimer() {
        controlsTimer?.invalidate()
        controlsTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self] _ in
            self?.playPauseButton.isHidden = true
            self?.seekSlider.isHidden = true
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = self.articleVideoHolderView.bounds  // Ensure player resizes with view
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.player?.pause()
        self.playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
    }
}
