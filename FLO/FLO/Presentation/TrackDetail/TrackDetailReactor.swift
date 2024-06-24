//
//  TrackDetailReactor.swift
//  FLO
//
//  Created by 심영민 on 6/24/24.
//

import UIKit
import ReactorKit

final class TrackDetailReactor: Reactor {
    enum Action {
        case viewDidLoad
        case onTapDismissButton(UIViewController)
    }
    
    enum Mutation {
        case setTrackDetil(TrackDetailModel?)
        case dismiss(UIViewController)
//        case setAlertMessage(String)
    }
    
    struct State {
        var trackId: Int?
        var trackDetail: TrackDetailModel?
//        @Pulse var alertMessage: String?
        
        init(trackId: Int?) {
            self.trackId = trackId
        }
    }
    
    init(initialState: State) {
        self.initialState = initialState
    }
    
    let initialState: State
    var disposeBag = DisposeBag()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return fetchData()
                .map { Mutation.setTrackDetil($0) }
        case let .onTapDismissButton(viewController):
            return Observable.just(Mutation.dismiss(viewController))
//        case let .setAlertMessage(message):
//            return Observable.just(Mutation.setAlertMessage(message))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setTrackDetil(data):
            guard let data = data else { return state }
            var newState = state
            newState.trackDetail = data
            return newState
        case let .dismiss(viewController):
            viewController.dismiss(animated: true)
            return state
        }
    }
    
    private func fetchData() -> Observable<TrackDetailModel?> {
        guard let trackId = initialState.trackId else {
            return .just(nil)
        }
        return FLOAPI.trackDetail(trackId: trackId)
            .observe(on: MainScheduler.instance)
            .map { response -> TrackDetailModel? in
                return response.data
            }
            .do(onError: { error in
                // TODO: AlertView
                print(error)
            })
            .catchAndReturn(nil)
    }
}
