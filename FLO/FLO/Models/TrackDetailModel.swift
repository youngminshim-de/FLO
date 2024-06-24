//
//  TrackDetailModel.swift
//  FLO
//
//  Created by 심영민 on 6/21/24.
//

import Foundation

struct TrackDetailModel: Decodable {
    let id: Int
    let name: String
    let lyrics: String
    let playTime: String
    let album: Album?
    let representationArtist: RepresentationArtist?
    let trackArtistList: [TrackArtist]
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case lyrics
        case playTime
        case album
        case representationArtist
        case trackArtistList
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = (try? container.decode(Int.self, forKey: .id)) ?? 0
        self.name = (try? container.decode(String.self, forKey: .name)) ?? ""
        self.lyrics = (try? container.decode(String.self, forKey: .lyrics)) ?? "가사 정보 없음"
        self.playTime = (try? container.decode(String.self, forKey: .playTime)) ?? ""
        self.album = try? container.decode(Album.self, forKey: .album)
        self.representationArtist = try? container.decode(RepresentationArtist.self, forKey: .representationArtist)
        self.trackArtistList = (try? container.decode([TrackArtist].self, forKey: .trackArtistList)) ?? []
    }
}

struct TrackArtist: Decodable {
    let name: String
    let roleName: String
    
    enum CodingKeys: CodingKey {
        case name
        case roleName
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = (try? container.decode(String.self, forKey: .name)) ?? ""
        self.roleName = (try? container.decode(String.self, forKey: .roleName)) ?? ""
    }
}
