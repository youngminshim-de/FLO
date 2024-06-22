//
//  BrowserViewController + UICollectionViewCompositionalLayout.swift
//  FLO
//
//  Created by 심영민 on 6/22/24.
//

import UIKit

private let INTER_ITEM_SPACING: NSCollectionLayoutSpacing = .fixed(8)
private let SECTION_INSET: NSDirectionalEdgeInsets = .init(top: 16,
                                                   leading: 0,
                                                   bottom: 16,
                                                   trailing: 0)
private let ITEM_INSET: NSDirectionalEdgeInsets = .init(top: 4,
                                               leading: 0,
                                               bottom: 4,
                                               trailing: 0)

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
