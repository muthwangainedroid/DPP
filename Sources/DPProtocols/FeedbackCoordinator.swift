//
//  StartupState.swift
//  TemplateApp
//
//  Created by Steve Galbraith on 1/28/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation
import RxSwift
import RxFeedback

/// Ultimately, this should be moved to DPProtocols
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
    /// Start method will initialize RXFeedback loop
    func start() {
        Observable.system(initialState: initialState,
                      reduce: reduce,
                      scheduler: MainScheduler.instance,
                      feedback: feedback)
        .subscribe()
        .disposed(by: disposeBag)
    }
}
