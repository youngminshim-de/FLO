//
//  BrowserReactor.swift
//  FLO
//
//  Created by 심영민 on 6/22/24.
//

import Foundation
import ReactorKit
import RxSwift

enum BrowserSection {
    case music(Chart)
    case genre(Section)
    case audio(ProgramCategoryList)
    case representVideo(VideoPlayList)
    case videoCarousel([Video])
}

final class BrowserReactor: Reactor {
    enum Action {
        case viewDidLoad
        case onTapAchor
    }
    
    enum Mutation {
        case setDatasource(data: BrowserModel?)
        case setAnchor
    }
    
    struct State {
        var dataSource: [BrowserSection] = []
        var currentPage: Int = 0
    }
    
    let initialState = State()
    var disposeBag = DisposeBag()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return fetchData()
                .map { Mutation.setDatasource(data: $0) }
        case .onTapAchor:
            return Observable.just(Mutation.setAnchor)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setDatasource(data):
            guard let data = data else { return state }
            
            var newState = state
            var dataSource: [BrowserSection] = []
            dataSource.append(contentsOf: data.chartList.map { .music($0) })
            dataSource.append(contentsOf: data.sectionList.map { .genre($0) })
            dataSource.append(.audio(data.programCategoryList))
            dataSource.append(.representVideo(data.videoPlayList))
            dataSource.append(.videoCarousel(data.videoPlayList.videoListExceptFirst))
            newState.dataSource = dataSource
            return newState

        case .setAnchor:
            //TODO: Anchor click 시 scroll 처리 필요
            var newState  = state
            return newState
        }
    }
    
    private func fetchData() -> Observable<BrowserModel?> {
        FLOAPI.browser()
            .observe(on: MainScheduler.instance)
            .map { response -> BrowserModel? in
                return response.data
            }
            .do(onError: { error in
                // TODO: AlertView
                print(error)
            })
            .catchAndReturn(nil)
    }
}
