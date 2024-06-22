//
//  ChartHeaderView.swift
//  FLO
//
//  Created by 심영민 on 6/22/24.
//

import UIKit

class ChartHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "ChartHeaderView"
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .leading
        return stackView
    }()
    
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .center
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let basedOnUpdateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14, weight: .bold)
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
        self.addSubview(self.verticalStackView)
        self.verticalStackView.addArrangedSubview(self.horizontalStackView)
        self.verticalStackView.addArrangedSubview(self.descriptionLabel)
        
        self.horizontalStackView.addArrangedSubview(self.titleLabel)
        self.horizontalStackView.addArrangedSubview(self.basedOnUpdateLabel)
        
        self.verticalStackView.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(8)
            $0.right.equalToSuperview().offset(-8)
            $0.bottom.equalToSuperview()
        }
    }
    
    func configure(title: String?, basedOnUpdate: String?, description: String?) {
        self.titleLabel.text = title
        self.basedOnUpdateLabel.text = basedOnUpdate
        self.descriptionLabel.text = description
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(title: nil,
                  basedOnUpdate: nil,
                  description: nil)
    }
}
