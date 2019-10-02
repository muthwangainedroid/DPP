//
//  Bindable.swift
//  TemplateApp
//
//  Created by Steve Galbraith on 9/16/19.
//  Copyright © 2019 Digital Products. All rights reserved.
//

import UIKit

/// Bindable protocol, is added to an object to provide a standard interface to all it's internal elelments to be bound to a view model
public protocol Bindable {
    associatedtype ViewModel

    var viewModel: ViewModel! { get set }
    func bindViewModel()
}

public extension Bindable where Self: UIViewController {

    /// Apply the ViewModel for this UIViewController
    /// - Parameter model: An object conforming to the ViewModel type, that will be contain the necessary logic for bound items
    mutating func setViewModel(to model: Self.ViewModel) {
        viewModel = model
        loadViewIfNeeded()
        bindViewModel()
    }
}

public extension Bindable where Self: UIView {

    /// Apply the ViewModel for this UIView
    /// - Parameter model: An object conforming to the ViewModel type, that will be contain the necessary logic for bound items
    mutating func setViewModel(to model: Self.ViewModel) {
        viewModel = model
        layoutIfNeeded()
        bindViewModel()
    }
}
