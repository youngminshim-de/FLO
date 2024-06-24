//
//  TrackDetailViewController.swift
//  FLO
//
//  Created by 심영민 on 6/23/24.
//

import UIKit
import ReactorKit
import RxSwift
import SnapKit

class TrackDetailViewController: UIViewController, View {
    var disposeBag = DisposeBag()
    
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let verticalStackView: UIStackView = {
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
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        return button
        
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let lyricsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        self.view.addSubview(self.horizontalStackView)
        self.view.addSubview(self.verticalStackView)
        self.view.addSubview(self.scrollView)
        
        self.horizontalStackView.addArrangedSubview(self.verticalStackView)
        self.horizontalStackView.addArrangedSubview(self.dismissButton)
        
        self.verticalStackView.addArrangedSubview(self.titleLabel)
        self.verticalStackView.addArrangedSubview(self.singerLabel)
        self.scrollView.addSubview(self.lyricsLabel)
        
        self.horizontalStackView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(self.scrollView.snp.top).offset(-16)
        }
        
        self.scrollView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview()
        }
        
        self.lyricsLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.centerX.equalTo(self.scrollView.snp.centerX)
            $0.verticalEdges.equalTo(self.scrollView.snp.verticalEdges)
        }
    }
    
    func bind(reactor: TrackDetailReactor) {
        /// action
        reactor.action.onNext(.viewDidLoad)
        
        self.dismissButton.rx.tap
            .map { Reactor.Action.onTapDismissButton(self)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        /// state
        reactor.state.map { $0.trackDetail }
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] in
                self?.titleLabel.text = $0.name
                self?.singerLabel.text = $0.representationArtist?.name
                self?.lyricsLabel.text = $0.lyrics
            })
            .disposed(by: disposeBag)
    }
}
