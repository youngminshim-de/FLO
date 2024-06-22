//
//  StandardHeaderView.swift
//  FLO
//
//  Created by 심영민 on 6/21/24.
//

import UIKit
import SnapKit

class StandardHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "StandardHeaderView"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
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
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview()
        }
    }
    
    func configure(title: String) {
        self.titleLabel.text = title
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(title: "")
    }
}
