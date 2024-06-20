//
//  MoyaProvider.swift
//  FLO
//
//  Created by 심영민 on 6/20/24.
//

import Foundation
import RxSwift
import RxMoya
import Moya

extension MoyaProvider {
    static func create<T: TargetType>() -> MoyaProvider<T> {
        return MoyaProvider<T>(plugins: [NetworkLoggerPlugin()])
    }
    
    /// 사전에 정의되어 있는 특정 error code가 없는경우 그대로 반환
//    func request2<DataType: Decodable>(_ target: Target) -> Observable<APIResponse<DataType>> {
//        self.rx.request(target)
//            .filterSuccessfulStatusCodes()
//            .map(APIResponse<DataType>.self)
//            .asObservable()
//    }
    
    /// 사전에 정의되어 있는 특정 error code가 있는 경우 error를 발생시킨다.
    func request<DataType: Decodable>(_ target: Target) -> Observable<APIResponse<DataType>> {
        let request = self.rx.request(target).asObservable()
            .filterSuccessfulStatusCodes()
            .map(APIResponse<DataType>.self)
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .do { response in
//                if response.code == 300 {
//                    throw FLOError.customError
//                }
            }
            .catch { .error(self.mapToCustomError(with: $0)) }
        
        return Observable.just(())
            .flatMap { _ in request }
    }
    
    /// 사전에 정의된 에러를 커스텀 에러로 변환
    private func mapToCustomError(with error: Error) -> FLOError {
        if let moyaError = error as? MoyaError {
            return .moyaError(moyaError)
        } else {
            return .customError
        }
    }
}

private extension MoyaProvider {
    static var defaultAlamofireSession: Session {
        let session = URLSessionConfiguration.default
        session.headers = .default
        session.timeoutIntervalForRequest = 30
        session.requestCachePolicy = .reloadIgnoringCacheData
        session.urlCache = nil

        return Session(configuration: session, startRequestsImmediately: false)
    }
}

struct APIResponse<DataType: Decodable>: Decodable {
    let data: DataType?
    let code: String?
    
    enum CodingKeys: CodingKey {
        case data
        case code
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decodeIfPresent(DataType.self, forKey: .data)
        self.code = try container.decodeIfPresent(String.self, forKey: .code)
    }
}
