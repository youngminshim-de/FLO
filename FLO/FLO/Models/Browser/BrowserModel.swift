//
//  BrowserModel.swift
//  FLO
//
//  Created by 심영민 on 6/20/24.
//

import Foundation

struct BrowserModel: Decodable {
    let chartList: [Chart] // FLO 차트, 해외 소셜차트
    let sectionList: [Section] // 장르 (장르, 상황, 분위기)
    let programCategoryList: ProgramCategoryList // 오디오
    let videoPlayList: VideoPlayList // 영상
}
