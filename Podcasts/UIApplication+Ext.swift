//
//  UIApplication+Ext.swift
//  Podcasts
//
//  Created by Owen Henley on 1/12/19.
//  Copyright © 2019 Owen Henley. All rights reserved.
//

import UIKit

extension UIApplication {
    static func mainTabBarController() -> MainTabBarController? {
        return shared.keyWindow?.rootViewController as? MainTabBarController
    }
}
