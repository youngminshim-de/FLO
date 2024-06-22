//
//  VideoCell.swift
//  FLO
//
//  Created by 심영민 on 6/21/24.
//

import UIKit

class VideoCell: UICollectionViewCell {
    static let reuseIdentifier = "VideoCell"
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let playTimeView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.5
        view.layer.cornerRadius = 4
        return view
    }()
    
    private let playTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let descriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 2
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let singerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        self.backgroundColor = .clear
        
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.descriptionStackView)
        
        self.imageView.addSubview(playTimeView)
        self.playTimeView.addSubview(self.playTimeLabel)
        self.descriptionStackView.addArrangedSubview(self.titleLabel)
        self.descriptionStackView.addArrangedSubview(self.singerLabel)
        
        self.imageView.snp.makeConstraints {
            $0.top.left.trailing.equalToSuperview()
        }
        
        self.playTimeView.snp.makeConstraints {
            $0.right.equalTo(self.imageView.snp.right).offset(-10)
            $0.bottom.equalTo(self.imageView.snp.bottom).offset(-10)
        }
        
        self.playTimeLabel.snp.makeConstraints {
            $0.edges.equalTo(self.playTimeView).inset(4)
//            $0.center.equalTo(self.playTimeView)
        }
        
        self.descriptionStackView.snp.makeConstraints {
            $0.top.equalTo(self.imageView.snp.bottom).offset(8)
            $0.bottom.equalToSuperview()
        }
    }
    
    func configure(video: Video?) {
        guard let video = video else {
            return
        }
        
            if let url = video.thumbnailImageList.first?.url,
           let imageUrl = URL(string: url) {
            self.imageView.kf.setImage(with: imageUrl)
        }
        
        self.playTimeLabel.text = video.playTm
        
        self.titleLabel.text = video.videoNm
        self.singerLabel.text = video.representationArtist?.name
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.configure(video: nil)
    }
}
