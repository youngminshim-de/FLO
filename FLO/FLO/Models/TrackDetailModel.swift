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
    let album: Album
    let representationArtist: RepresentationArtist
    let trackArtistList: [TrackArtist]
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
