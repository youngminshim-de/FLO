//
//  ProgramCategoryModel.swift
//  FLO
//
//  Created by 심영민 on 6/22/24.
//

import Foundation

struct ProgramCategoryList: Decodable {
    let name: String
    let type: ProgramCategoryType
    let list: [ProgramCategory]

    enum CodingKeys: String, CodingKey {
        case name
        case type
        case list
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = (try? container.decode(String.self, forKey: .name)) ?? ""
        type = (try? container.decode(ProgramCategoryType.self, forKey: .type)) ?? .general
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
