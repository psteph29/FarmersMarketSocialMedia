//
//  NavigationBarAppearanceManager.swift
//  FarmersMarketSocialMedia
//
//  Created by kole ervine on 10/15/23.
//

import Foundation
import UIKit

struct NavigationBarAppearanceManager {
    static func customizeNavigationBarAppearance() {
        // Create a navigation bar appearance instance
        let navigationBarAppearance = UINavigationBarAppearance()
        
        // Customize the back button color in navigation bar
        navigationBarAppearance.buttonAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: red400406]
        
        // Customize the back button color in bar button item
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: red400406], for: .normal)
        
        UINavigationBar.appearance().tintColor = red400406
        
        navigationBarAppearance.backgroundColor = .clear
    }
}
