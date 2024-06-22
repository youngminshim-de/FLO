//
//  ViewController.swift
//  FLO
//
//  Created by 심영민 on 6/18/24.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

enum HeaderSection: CustomStringConvertible {
    case chart
    case genre
    case audio
    case video
    
    var description: String {
        switch self {
        case .chart: return "차트"
        case .genre: return "장르/테마"
        case .audio: return "오디오"
        case .video: return "영상"
        }
    }
}

class BrowserViewController: UIViewController, View {
    var disposeBag = DisposeBag()
    let reactor = BrowserReactor()
    
    var currentBannerPage = PublishSubject<(Int, Int)>()

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: getLayout())
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(MusicCell.self, forCellWithReuseIdentifier: MusicCell.reuseIdentifier)
        view.register(GenreCell.self, forCellWithReuseIdentifier: GenreCell.reuseIdentifier)
        view.register(VideoCell.self, forCellWithReuseIdentifier: VideoCell.reuseIdentifier)
        view.register(ChartHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ChartHeaderView.reuseIdentifier)
        view.register(StandardHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: StandardHeaderView.reuseIdentifier)
        view.register(PageIndicatorFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: PageIndicatorFooterView.reuseIdentifier)
        view.dataSource = self
        return view
    }()
    
    var dataSource: [BrowserSection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(reactor: reactor)
        reactor.action.onNext(.viewDidLoad)
        self.setupViews()
    }
    
    func setupViews() {
        self.view.addSubview(self.collectionView)
        
        self.collectionView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
        }
    }
    
    func bind(reactor: BrowserReactor) {
        reactor.state.map { $0.dataSource }
            .subscribe(onNext:  { [weak self] in
                self?.dataSource = $0
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

