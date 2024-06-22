//
//  PageIndicatorFooterView.swift
//  FLO
//
//  Created by 심영민 on 6/22/24.
//

import UIKit
import RxSwift

class PageIndicatorFooterView: UICollectionReusableView {
    static let reuseIdentifier = "PageIndicatorFooterView"
    
    private var disposeBag = DisposeBag()
    
    private let pageControll: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .blue
        pageControl.pageIndicatorTintColor = .gray
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func bind(input: Observable<(Int, Int)>, pageNumber: Int, selectedSection: Int) {
        pageControll.numberOfPages = pageNumber
        input.filter { (sectionIndex, _) in
            sectionIndex == selectedSection
        }.subscribe(onNext: { [weak self] (_, currentPage) in
            self?.pageControll.currentPage = currentPage
        })
        .disposed(by: disposeBag)
    }
    
    func setupViews() {
        self.backgroundColor = .clear
        self.addSubview(self.pageControll)
        self.pageControll.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-8)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
