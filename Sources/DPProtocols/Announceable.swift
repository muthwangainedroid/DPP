//
//  Announceable.swift
//  TemplateApp
//
//  Created by Steve Galbraith on 9/24/19.
//  Copyright © 2019 Digital Products. All rights reserved.
//

import UIKit

/// Allows a conforming view cotroller or view to alert the user know of changes via Voice Over for accessibility
public protocol Announceable {
    func announce(withDelay delay: Double, message: String)
}

public extension Announceable {

    /// Announce the passed in message audibly in Voice Over after the specified time delay
    /// - Parameter delay: Number of seconds to delay announcement
    /// - Parameter message: Message to be announced
    func announce(withDelay delay: Double = 0.0, message: String) {
        guard UIAccessibility.isVoiceOverRunning else { return }

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            UIAccessibility.post(notification: .announcement, argument: message)
        }
    }
}

