//
//  GenreCell.swift
//  FLO
//
//  Created by 심영민 on 6/20/24.
//

import UIKit
import SnapKit

class GenreCell: UICollectionViewCell {
    static let reuseIdentifier = "GenreCell"
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
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
        self.imageView.addSubview(self.titleLabel)
        
        self.imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.imageView.snp.top).offset(10)
            $0.left.equalTo(self.imageView.snp.left).offset(10)
        }
    }
    
    func configure(title: String?, image: String?) {
        guard let title = title,
              let image = image,
              let imageUrl = URL(string: image) else { return }
        
        self.titleLabel.text = title
        self.imageView.kf.setImage(with: imageUrl)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(title: nil, image: nil)
    }
}
