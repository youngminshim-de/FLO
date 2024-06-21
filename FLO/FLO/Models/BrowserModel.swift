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
enum ChartType: String, Codable {
    case rankChart = "RANK_CHART"
    case chart     = "CHART"
}

struct Chart: Decodable {
    let type: String
    let id: Int
    let name: String
    let totalCount: Int
    let trackList: [Track]
    let basedOnUpdate: String
    let description: String

    enum CodingKeys: String, CodingKey {
        case type, id, name, totalCount, trackList, basedOnUpdate, description
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        type = (try? container.decode(String.self, forKey: .type)) ?? ""
        id = (try? container.decode(Int.self, forKey: .id)) ?? 0
        name = (try? container.decode(String.self, forKey: .name)) ?? ""
        totalCount = (try? container.decode(Int.self, forKey: .totalCount)) ?? 0
        trackList = (try? container.decode([Track].self, forKey: .trackList)) ?? []
        basedOnUpdate = (try? container.decode(String.self, forKey: .basedOnUpdate)) ?? ""
        description = (try? container.decode(String.self, forKey: .description)) ?? ""
    }
}

struct Track: Decodable {
    let id: Int
    let name: String
    let album: Album?
    let representationArtist: RepresentationArtist?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case album
        case representationArtist
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = (try? container.decode(Int.self, forKey: .id)) ?? -1
        name = (try? container.decode(String.self, forKey: .name)) ?? ""
        album = try container.decodeIfPresent(Album.self, forKey: .album)
        representationArtist = try container.decodeIfPresent(RepresentationArtist.self, forKey: .representationArtist)
    }
}

// MARK: - Album
struct Album: Decodable {
    let id: Int
    let title: String
    let imgList: [FLOImage]

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case imgList
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = (try? container.decode(Int.self, forKey: .id)) ?? -1
        title = (try? container.decode(String.self, forKey: .title)) ?? ""
        imgList = (try? container.decode([FLOImage].self, forKey: .imgList)) ?? []
    }
}

// MARK: - ImgList
struct FLOImage: Decodable {
    let size: Int
    let url: String

    enum CodingKeys: String, CodingKey {
        case size
        case url
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        size = (try? container.decode(Int.self, forKey: .size)) ?? 0
        url = (try? container.decode(String.self, forKey: .url)) ?? ""
    }
}

struct RepresentationArtist: Decodable {
    let id: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = (try? container.decode(Int.self, forKey: .id)) ?? -1
        name = (try? container.decode(String.self, forKey: .name)) ?? ""
    }
}

struct ProgramCategoryList: Decodable {
    let name: String
    let type: String
    let list: [ProgramCategory]

    enum CodingKeys: String, CodingKey {
        case name
        case type
        case list
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = (try? container.decode(String.self, forKey: .name)) ?? ""
        type = (try? container.decode(String.self, forKey: .type)) ?? ""
        list = (try? container.decode([ProgramCategory].self, forKey: .list)) ?? []
    }
}
enum ProgramCategoryType: String, Decodable {
    case general = "GENERAL"
    case operation = "OPERATION"
    
    init(from decoder: any Decoder) throws {
        self = try ProgramCategoryType(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .general
    }
}

struct ProgramCategory: Decodable {
    let programCategoryId: Int
    let programCategoryType: ProgramCategoryType
    let displayTitle: String
    let imgUrl: String

    enum CodingKeys: String, CodingKey {
        case programCategoryId
        case programCategoryType
        case displayTitle
        case imgUrl
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        programCategoryId = (try? container.decode(Int.self, forKey: .programCategoryId)) ?? 0
        programCategoryType = (try? container.decode(ProgramCategoryType.self, forKey: .programCategoryType)) ?? .general
        displayTitle = (try? container.decode(String.self, forKey: .displayTitle)) ?? ""
        imgUrl = (try? container.decode(String.self, forKey: .imgUrl)) ?? ""
    }
}

enum SectionType: String, Codable {
    case genre = "GENRE"
    case mood = "MOOD"
    case sittn = "SITTN"
    
    init(from decoder: any Decoder) throws {
        self = try SectionType(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .genre
    }
}
struct Section: Decodable {
    let name: String
    let type: SectionType
    let shortcutList: [Shortcut]

    enum CodingKeys: String, CodingKey {
        case name
        case type
        case shortcutList
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = (try? container.decode(String.self, forKey: .name)) ?? ""
        type = (try? container.decode(SectionType.self, forKey: .type)) ?? .genre
        shortcutList = (try? container.decode([Shortcut].self, forKey: .shortcutList)) ?? []
    }
}

struct Shortcut: Decodable {
    let type: SectionType
    let id: Int
    let name: String
    let imgList: [FLOImage]

    enum CodingKeys: String, CodingKey {
        case type
        case id
        case name
        case imgList
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        type = (try? container.decode(SectionType.self, forKey: .type)) ?? .genre
        id = (try? container.decode(Int.self, forKey: .id)) ?? -1
        name = (try? container.decode(String.self, forKey: .name)) ?? ""
        imgList = (try? container.decode([FLOImage].self, forKey: .imgList)) ?? []
    }
}

struct VideoPlayList: Decodable {
    let id: Int
    let name: String
    let type: String
    let videoList: [Video]
    let description: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case videoList
        case description
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = (try? container.decode(Int?.self, forKey: .id)) ?? -1
        name = (try? container.decode(String.self, forKey: .name)) ?? ""
        type = (try? container.decode(String.self, forKey: .type)) ?? ""
        videoList = (try? container.decode([Video].self, forKey: .videoList)) ?? []
        description = (try? container.decode(String.self, forKey: .description)) ?? ""
    }
}

struct Video: Decodable {
    let id: Int
    let videoNm: String
    let playTm: String
    let thumbnailImageList: [ThumbnailImageList]
    let representationArtist: RepresentationArtist?

    enum CodingKeys: String, CodingKey {
        case id
        case videoNm
        case playTm
        case thumbnailImageList
        case representationArtist
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = (try? container.decode(Int.self, forKey: .id)) ?? 0
        videoNm = (try? container.decode(String.self, forKey: .videoNm)) ?? ""
        playTm = (try? container.decode(String.self, forKey: .playTm)) ?? ""
        thumbnailImageList = (try? container.decode([ThumbnailImageList].self, forKey: .thumbnailImageList)) ?? []
        representationArtist = (try? container.decode(RepresentationArtist.self, forKey: .representationArtist))
    }
}

struct ThumbnailImageList: Decodable {
    let width: Int
    let height: Int
    let url: String

    enum CodingKeys: String, CodingKey {
        case width
        case height
        case url
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        width = (try? container.decode(Int.self, forKey: .width)) ?? 0
        height = (try? container.decode(Int.self, forKey: .height)) ?? 0
        url = (try? container.decode(String.self, forKey: .url)) ?? ""
    }
}


