//
//  BrowserViewController + DataSource.swift
//  FLO
//
//  Created by 심영민 on 6/22/24.
//

import UIKit

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
