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

private let INTER_ITEM_SPACING: NSCollectionLayoutSpacing = .fixed(8)
private let SECTION_INSET: NSDirectionalEdgeInsets = .init(top: 16,
                                                   leading: 0,
                                                   bottom: 16,
                                                   trailing: 0)
private let ITEM_INSET: NSDirectionalEdgeInsets = .init(top: 4,
                                               leading: 0,
                                               bottom: 4,
                                               trailing: 0)

class BrowserViewController: UIViewController, View {
    var disposeBag = DisposeBag()
    let reactor = BrowserReactor()
    
    private var currentBannerPage = PublishSubject<(Int, Int)>()

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
    
    private var dataSource: [BrowserSection] = []
    
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

//MARK: - UICollectionViewCompositionalLayout
extension BrowserViewController {
    func getLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) ->
            NSCollectionLayoutSection? in
            switch self.dataSource[sectionIndex] {
            case .music:
                // item
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0 / 4.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                // group
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalHeight(1.0 / 4.0))
                
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: groupSize,
                    repeatingSubitem: item,
                    count: 4)
                group.interItemSpacing = INTER_ITEM_SPACING
                group.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
                
                // section
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                
                // header
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(56))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
                
                // footer (UIPageControl)
                let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(40))
                let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
                // decoration
                let decoration = NSCollectionLayoutDecorationItem.background(elementKind: ChartSectionBackgroundView.elementKind)
                
                section.decorationItems = [decoration]
                section.boundarySupplementaryItems = [header, footer]
                
                section.contentInsets = SECTION_INSET
                section.visibleItemsInvalidationHandler = { [weak self] (items, offset, environment) in
                    let currentPage = Int(max(0, round(offset.x / environment.container.contentSize.width)))
                    self?.currentBannerPage.onNext((sectionIndex,currentPage))
                }
                return section
                
            case .genre:
                // item
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / 2.0),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = ITEM_INSET
                
                // group
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalWidth(1.0 / 4.0))
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    repeatingSubitem: item,
                    count: 2)
                
                group.interItemSpacing = INTER_ITEM_SPACING
                
                // section
                let section = NSCollectionLayoutSection(group: group)
                
                // header
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .estimated(44))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                         elementKind: UICollectionView.elementKindSectionHeader,
                                                                         alignment: .topLeading)
                
                section.boundarySupplementaryItems = [header]
                section.contentInsets = SECTION_INSET
                
                return section
                
            case .audio:
                // item
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / 2.0),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = ITEM_INSET
                
                // group
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalWidth(1.0 / 4.0))
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    repeatingSubitem: item,
                    count: 2)
                
                group.interItemSpacing = INTER_ITEM_SPACING
                
                // section
                let section = NSCollectionLayoutSection(group: group)
                
                // header
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .estimated(44))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                         elementKind: UICollectionView.elementKindSectionHeader,
                                                                         alignment: .topLeading)
                
                section.boundarySupplementaryItems = [header]
                section.contentInsets = SECTION_INSET
                
                return section
                
            case .representVideo:
                // item
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                item.contentInsets = .init(top: 0, leading: 4, bottom: 0, trailing: 4)
                
                // group
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalWidth(1.0 / 1.5))
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    repeatingSubitem: item,
                    count: 1)
                
                // section
                let section = NSCollectionLayoutSection(group: group)
                
                // header
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .estimated(44))
                
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                         elementKind: UICollectionView.elementKindSectionHeader,
                                                                         alignment: .topLeading)
                
                section.boundarySupplementaryItems = [header]
                section.contentInsets = SECTION_INSET
                return section
                
            case .videoCarousel:
                // item
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                item.contentInsets = .init(top: 0, leading: 4, bottom: 0, trailing: 4)
                // group
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7),
                                                       heightDimension: .fractionalWidth(1.0 / 2.0))
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    repeatingSubitem: item,
                    count: 1)
                
                group.interItemSpacing = INTER_ITEM_SPACING
                
                // section
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                
                return section
            }
        }
        
        layout.register(ChartSectionBackgroundView.self, forDecorationViewOfKind: ChartSectionBackgroundView.elementKind)
        return layout
    }
}

//MARK: - UICollectionViewDataSource
extension BrowserViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.dataSource[section] {
        case let .music(chart):
            return chart.trackList.count
        case let .genre(section):
            return section.shortcutList.count
        case let .audio(programList):
            return programList.list.count
        case .representVideo:
            return 1
        case let .videoCarousel(videoList):
            return videoList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch self.dataSource[indexPath.section] {
        case let .music(chart):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MusicCell.reuseIdentifier, for: indexPath) as? MusicCell else {
                return UICollectionViewCell()
            }
            let item = chart.trackList[indexPath.item]
            cell.configure(track: item, index: indexPath.item + 1)
            return cell
            
        case let .genre(section):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCell.reuseIdentifier, for: indexPath) as? GenreCell else {
                return UICollectionViewCell()
            }
            let item = section.shortcutList[indexPath.item]
            cell.configure(title: item.name, image: item.imgList.first?.url)
            return cell
        case let .audio(programList):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCell.reuseIdentifier, for: indexPath) as? GenreCell else {
                return UICollectionViewCell()
            }
            let item = programList.list[indexPath.item]
            cell.configure(title: item.displayTitle, image: item.imgUrl)
            return cell
        case let .representVideo(videoList):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCell.reuseIdentifier, for: indexPath) as? VideoCell else {
                return UICollectionViewCell()
            }
            let item = videoList.representVideo
            cell.configure(video: item)
            return cell
        case let .videoCarousel(videoList):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCell.reuseIdentifier, for: indexPath) as? VideoCell else {
                return UICollectionViewCell()
            }
            let item = videoList[indexPath.item]
            cell.configure(video: item)
            return cell

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            var headerView: UICollectionReusableView
            
            switch self.dataSource[indexPath.section] {
            case let .music(chart):
                guard let chartHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ChartHeaderView.reuseIdentifier, for: indexPath) as? ChartHeaderView else {
                    return UICollectionReusableView()
                }
                chartHeaderView.configure(title: chart.name,
                                     basedOnUpdate: chart.basedOnUpdate,
                                     description: chart.description)
                headerView = chartHeaderView

            case let .genre(section):
                guard let standardHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: StandardHeaderView.reuseIdentifier, for: indexPath) as? StandardHeaderView else {
                    return UICollectionReusableView()
                }
                standardHeaderView.configure(title: section.name)
                headerView = standardHeaderView
            case let .audio(programList):
                guard let standardHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: StandardHeaderView.reuseIdentifier, for: indexPath) as? StandardHeaderView else {
                    return UICollectionReusableView()
                }
                standardHeaderView.configure(title: programList.name)
                headerView = standardHeaderView
            case let .representVideo(videoList):
                guard let standardHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: StandardHeaderView.reuseIdentifier, for: indexPath) as? StandardHeaderView else {
                    return UICollectionReusableView()
                }
                standardHeaderView.configure(title: videoList.name)
                headerView = standardHeaderView
            default:
                return UICollectionReusableView()
            }

            return headerView
        case UICollectionView.elementKindSectionFooter:
            switch self.dataSource[indexPath.section] {
            case let .music(chart):
                guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PageIndicatorFooterView.reuseIdentifier, for: indexPath) as? PageIndicatorFooterView else {
                    return UICollectionReusableView()
                }
                
                footerView.bind(input: currentBannerPage,
                                pageNumber: Int(chart.trackList.count / 4),
                                selectedSection: indexPath.section)
                return footerView
            default: return UICollectionReusableView()
            }
        default: return UICollectionReusableView()
        }
    }
}
