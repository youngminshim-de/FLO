//
//  SectionModel.swift
//  FLO
//
//  Created by 심영민 on 6/22/24.
//

import Foundation

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
