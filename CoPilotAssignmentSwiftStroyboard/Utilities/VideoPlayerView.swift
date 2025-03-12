//
//  VideoPlayerView.swift
//  CoPilotAssignmentSwiftStroyboard
//
//  Created by Prakasha on 12/03/25.
//

import AVKit

class VideoPlayerView: UIView {

    private var player: AVPlayer?
    private let playerLayer = AVPlayerLayer()
    private let playPauseButton = UIButton()
    private let seekSlider = UISlider()

    func configure(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        player = AVPlayer(url: url)

        // Configure Player Layer
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)

        setupControls()
        player?.play()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }

    private func setupControls() {
        playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        playPauseButton.tintColor = .white
        playPauseButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        playPauseButton.layer.cornerRadius = 12
        playPauseButton.addTarget(self, action: #selector(playPauseTapped), for: .touchUpInside)

        seekSlider.minimumValue = 0
        seekSlider.maximumValue = 1
        seekSlider.addTarget(self, action: #selector(seekSliderChanged), for: .valueChanged)

        let controlsStackView = UIStackView(arrangedSubviews: [playPauseButton, seekSlider])
        controlsStackView.axis = .horizontal
        controlsStackView.spacing = 10
        controlsStackView.alignment = .center
        controlsStackView.distribution = .fillProportionally
        controlsStackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(controlsStackView)
        NSLayoutConstraint.activate([
            controlsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 7),
            controlsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -7),
            controlsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7),
            playPauseButton.widthAnchor.constraint(equalToConstant: 39),
            playPauseButton.heightAnchor.constraint(equalToConstant: 39),
        ])
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
    }

    @objc private func seekSliderChanged() {
        guard let duration = player?.currentItem?.duration.seconds, duration > 0 else { return }
        let newTime = CMTime(seconds: Double(seekSlider.value) * duration, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player?.seek(to: newTime)
    }
}
