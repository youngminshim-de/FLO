//
//  ChartSectionBackgroundView.swift
//  FLO
//
//  Created by 심영민 on 6/22/24.
//

import UIKit

class ChartSectionBackgroundView: UICollectionReusableView {
    static let elementKind = "ChartSectionBackgroundView"
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.alpha = 0.5
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
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
        self.addSubview(self.backgroundView)
        self.backgroundView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-8)
            $0.top.left.right.equalToSuperview()
        }
    }
}
