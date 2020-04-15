//
//  FeedbackCoordinator.swift
//  DPProtocols
//
//  Created by Travis Fischer on 4/1/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift
import RxFeedback

/// Adds support for RxFeedback to Coordinator patterns
public protocol FeedbackCoordinator : Coordinator {
    associatedtype Event
    associatedtype State
    
    var disposeBag: DisposeBag { get }
    var reduce: (State, Event) -> State { get }
    var feedback: ((ObservableSchedulerContext<State>) -> Observable<Event>)! { get }
    var initialState: State { get }
}

public extension FeedbackCoordinator {
    /// Start method will initialize RxFeedback loop
    func start() {
        Observable.system(initialState: initialState,
                      reduce: reduce,
                      scheduler: MainScheduler.instance,
                      feedback: feedback)
        .subscribe()
        .disposed(by: disposeBag)
    }
}
