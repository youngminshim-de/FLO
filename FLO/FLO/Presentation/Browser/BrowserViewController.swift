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

enum StickyHeaderType: Int, CustomStringConvertible, CaseIterable {
    case music = 0
    case genre = 1
    case audio = 2
    case video = 3
    
    var description: String {
        switch self {
        case .music: return "차트"      // Music
        case .genre: return "장르/테마"  // genre
        case .audio: return "오디오"    // audio
        case .video: return "영상"     // video
        }
    }
    
    var section: Int {
        switch self {
        case .music: return 0
        case .genre: return 2
        case .audio: return 5
        case .video: return 6
        }
    }
}

class BrowserViewController: UIViewController, View {
    var disposeBag = DisposeBag()
    
    var currentBannerPage = PublishSubject<(Int, Int)>()
    var selectedAnchor = PublishSubject<StickyHeaderType>()
    
    /// stickyHeaderView
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 8
        return stackView
    }()
    
    /// stickyHeaderView anchors
    private let anchors: [UIButton] = {
        let configurationUpdateHandler: UIButton.ConfigurationUpdateHandler = { button in
            switch button.state {
            case .selected:
                button.configuration?.baseBackgroundColor = .blue
            case .normal:
                button.configuration?.baseBackgroundColor = .gray
            default:
                button.configuration?.baseBackgroundColor = .gray
            }
        }
        return StickyHeaderType.allCases.map { section in
            var config = UIButton.Configuration.filled()
            var titleContainer = AttributeContainer()
            titleContainer.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            config.attributedTitle = AttributedString(section.description, attributes: titleContainer)
            config.baseBackgroundColor = .gray
            config.buttonSize = .small
            
            let button = UIButton(configuration: config)
            button.configurationUpdateHandler = configurationUpdateHandler
            
            return button
        }
    }()

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
        view.delegate = self
        return view
    }()
    
    var dataSource: [BrowserSection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
    }
    
    func setupViews() {
        self.view.addSubview(self.horizontalStackView)
        self.view.addSubview(self.collectionView)
        
        self.anchors.forEach {
            self.horizontalStackView.addArrangedSubview($0)
        }
        
        self.horizontalStackView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(16)
        }
        
        self.collectionView.snp.makeConstraints {
            $0.top.equalTo(self.horizontalStackView.snp.bottom).offset(16)
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
    
    func bind(reactor: BrowserReactor) {
        /// action
        reactor.action.onNext(.viewDidLoad)
        
        for index in 0..<anchors.count {
            anchors[index].rx.tap
                .do(onNext: { [weak self] in
                    let section = StickyHeaderType(rawValue: index) ?? .music
                    self?.scrollToSection(section.section)
                })
                .map { Reactor.Action.onTapAnchor(section: StickyHeaderType(rawValue: index) ?? .music) }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
        }

        /// state
        reactor.state.map { $0.dataSource }
            .subscribe(onNext:  { [weak self] in
                self?.dataSource = $0
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.selectedAnchor }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] in
                _ = self?.anchors.map { $0.isSelected = false }
                self?.anchors[$0.rawValue].isSelected = true
            })
            .disposed(by: disposeBag)
        
        /// view
        collectionView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                switch self.dataSource[indexPath.section] {
                case let .music(chart):
                    let trackId = chart.trackList[indexPath.row].id
                    let viewController = TrackDetailViewController()
                    viewController.view.backgroundColor = .white
                    viewController.reactor = TrackDetailReactor(initialState: .init(trackId: trackId))
                    self.present(viewController, animated: true)
                default: return
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func scrollToSection(_ section: Int)  {
        guard !dataSource.isEmpty else { return }
        let indexPath = IndexPath(item: 0, section: section)
        
        if let attributes = collectionView.layoutAttributesForSupplementaryElement(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath) {
            let topOfHeader = CGPoint(x: 0, y: attributes.frame.origin.y - collectionView.contentInset.top)
            collectionView.setContentOffset(topOfHeader, animated: true)
        }
    }
}

extension UIViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO: music cell 눌렀을 때 상세화면 이동
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 500 {
            
        }
    }
}


