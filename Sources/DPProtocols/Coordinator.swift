//
//  Coordinator.swift
//  TemplateApp
//
//  Created by Steve Galbraith on 9/16/19.
//  Copyright © 2019 Digital Products. All rights reserved.
//

import UIKit

/// Assists in the implemetation of the coordinator pattern, enabling simple navigation within and across modules
public protocol Coordinator {
    var childCoordinator: Coordinator? { get set }
    var navigationController: UINavigationController { get set }

    /// Displays the initial view for the coordinator, effectively passing control to the coordinator
    func start()
}
