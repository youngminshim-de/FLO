//
//  MusicCell.swift
//  FLO
//
//  Created by 심영민 on 6/20/24.
//

import UIKit
import SnapKit
import Kingfisher

class MusicCell: UICollectionViewCell {
    static let reuseIdentifier = "MusicCell"
    private let imageView = UIImageView()
    
    private let rankLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
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
        
        self.contentView.addSubview(self.horizontalStackView)
        self.horizontalStackView.addArrangedSubview(self.imageView)
        self.horizontalStackView.addArrangedSubview(self.rankLabel)
        self.horizontalStackView.addArrangedSubview(self.descriptionStackView)
        
        self.descriptionStackView.addArrangedSubview(self.titleLabel)
        self.descriptionStackView.addArrangedSubview(self.singerLabel)
        
        self.horizontalStackView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        self.imageView.snp.makeConstraints {
            $0.width.equalTo(self.imageView.snp.height)
        }

        self.rankLabel.snp.makeConstraints {
            $0.left.equalTo(self.imageView.snp.right).offset(8)
            $0.right.equalTo(self.descriptionStackView.snp.left).offset(-8)
            $0.centerY.equalTo(self.imageView.snp.centerY)
        }
    }
    
    func configure(track: Track?, index: Int?) {
        guard let track = track,
              let index = index else {
            return
        }
        
        if let url = track.album?.imgList.first?.url,
           let imageUrl = URL(string: url) {
            self.imageView.kf.setImage(with: imageUrl)
        }
        
        self.rankLabel.text = String(index)
        self.titleLabel.text = track.name
        self.singerLabel.text = track.representationArtist?.name
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.configure(track: nil, index: nil)
    }
}
