//
//  FLOAPI.swift
//  FLO
//
//  Created by 심영민 on 6/20/24.
//

import Foundation
import RxSwift
import Moya

enum FLOAPI: TargetType {
    private static let provider: MoyaProvider<Self> = .create()
    
    /// APIList
    case browser
    case trackDetail(trackId: String)
    
    var baseURL: URL {
        return URL(string: "https://raw.githubusercontent.com/dreamus-ios/challenge/main")!
    }
    
    var path: String {
        switch self {
        case .browser                 : return "/browser"
        case let .trackDetail(trackId): return "/track/\(trackId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .browser    : return .get
        case .trackDetail: return .get
        }
    }
    
    var task: Moya.Task {
        
        switch self {
        case .browser    : return .requestPlain
        case .trackDetail: return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return [:]
    }
}

extension FLOAPI {
    static func browser() -> Observable<APIResponse<BrowserModel>> {
        return provider.request(.browser)
    }
    
    static func trackDetail(trackId: String) -> Observable<TrackDetailResponse> {
        return provider.request(.trackDetail(trackId: trackId))
    }
}
