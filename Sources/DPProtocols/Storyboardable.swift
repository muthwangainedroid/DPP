//
//  Storyboardable.swift
//  TemplateApp
//
//  Created by Steve Galbraith on 9/16/19.
//  Copyright © 2019 Digital Products. All rights reserved.
//

import UIKit

/// Provides a simple interface to initialize view controllers from a storyboard
public protocol Storyboardable {
    static func instantiate(fromStoryboardNamed storyboardName: String?, in storyboardBundle: Bundle?) -> Self
}

public extension Storyboardable where Self: UIViewController {

    /// Instantiates a view controller of the coorect type from a storyboard
    /// - Parameter storyboardName: The name of the storyboard
    /// - Parameter storyboardBundle: The bundle which contains the storyboard
    static func instantiate(fromStoryboardNamed storyboardName: String? = nil, in storyboardBundle: Bundle? = nil) -> Self {
        let identifier = String(describing: self)
        let name = storyboardName ?? "Main"
        let bundle = storyboardBundle ?? Bundle.main
        let storyboard = UIStoryboard.init(name: name, bundle: bundle)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! Self
    }
}
