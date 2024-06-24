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
        case setErrorMessage(FLOError?)
    }
    
    struct State {
        var trackId: Int?
        var trackDetail: TrackDetailModel?
        @Pulse var errorMessage: String = ""
        
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
            let mutation = fetchData()
                .map { return Mutation.setTrackDetil($0)}
                .catch {
                    guard let error = $0 as? FLOError else {
                        return Observable.just(Mutation.setErrorMessage(.unknown))
                    }
                    return Observable.just(Mutation.setErrorMessage(error))
                }
            return mutation
        case let .onTapDismissButton(viewController):
            return Observable.just(Mutation.dismiss(viewController))
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
        case let .setErrorMessage(error):
            guard let error = error else { return state }
            var newState = state
            newState.errorMessage = error.displayErrorMessage
            return newState
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
    }
}
