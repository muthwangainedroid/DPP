//
//  ViewModel.swift
//  DPProtocols
//
//  Created by travis.r.fischer on 4/2/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation

/// Protocol for consistently defined ViewModel interface
public protocol ViewModel {
    associatedtype Input
    associatedtype Output

    /// Inputs to a ViewModel (typically a struct of Observers)
    var input: Input { get }
    
    /// Outputs from a ViewModel (typically a struct of Observables)
    var output: Output { get }
}
