//
//  VideoModel.swift
//  FLO
//
//  Created by 심영민 on 6/22/24.
//

import Foundation

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
    
    var representVideo: Video? {
        return self.videoList.first
    }
    
    var videoListExceptFirst: [Video] {
        return Array(self.videoList.dropFirst())
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


