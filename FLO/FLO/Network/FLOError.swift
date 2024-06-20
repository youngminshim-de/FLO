//
//  FLOError.swift
//  FLO
//
//  Created by 심영민 on 6/20/24.
//

import Foundation
import Moya

/// 일반적인 error는 MoyaError를 따른다.
/// 특정한 에러 정립 시, Error 추가
enum FLOError: Error {
    case moyaError(MoyaError)
    case customError
    
    var localizedDescription: String {
        switch self {
        case let .moyaError(error):
            return error.localizedDescription
        case .customError:
            return "특정한 에러입니다."
        }
    }
    
    /// 에러의 내용은 이용자에게 보여줄 필요가 없을 것 같아 모든에러를 같은 메세지로 처리한다.
    var displayErrorMessage: String {
        return "오류가 발생하였습니다. 잠시 후 다시 시도해주세요"
    }
}
