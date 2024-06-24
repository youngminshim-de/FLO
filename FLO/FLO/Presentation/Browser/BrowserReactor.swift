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
        case onTapAnchor(section: StickyHeaderType)
        case changedAnchor(section: StickyHeaderType)
    }
    
    enum Mutation {
        case setDatasource(BrowserModel?)
        case setAnchor(StickyHeaderType)
        case setErrorMessage(FLOError?)
    }
    
    struct State {
        var dataSource: [BrowserSection] = []
        var currentPage: Int = 0
        var selectedAnchor: StickyHeaderType = .music
        @Pulse var errorMessage: String = ""
    }
    
    let initialState = State()
    var disposeBag = DisposeBag()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let mutation = fetchData()
                .map {
                    return Mutation.setDatasource($0)
                }
                .catch {
                    guard let error = $0 as? FLOError else {
                        return Observable.just(Mutation.setErrorMessage(.unknown))
                    }
                    return Observable.just(Mutation.setErrorMessage(error))
                }
            return mutation
        case let .onTapAnchor(section):
            return Observable.just(Mutation.setAnchor(section))
        case let .changedAnchor(section):
            return Observable.just(Mutation.setAnchor(section))
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

        case let .setAnchor(section):
            var newState  = state
            newState.selectedAnchor = section
            return newState
        case let .setErrorMessage(error):
            guard let error = error else { return state }
            var newState = state
            newState.errorMessage = error.displayErrorMessage
            return newState
        }
    }
    
    private func fetchData() -> Observable<BrowserModel?> {
        FLOAPI.browser()
            .observe(on: MainScheduler.instance)
            .map { response -> BrowserModel? in
                return response.data
            }
    }
}
