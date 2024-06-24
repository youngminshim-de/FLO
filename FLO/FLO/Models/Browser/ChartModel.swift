//
//  ChartModel.swift
//  FLO
//
//  Created by 심영민 on 6/22/24.
//

import Foundation

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
