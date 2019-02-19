//
//  Notification+Ext.swift
//  Podcasts
//
//  Created by Owen Henley on 2/19/19.
//  Copyright © 2019 Owen Henley. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let downloadProgress = NSNotification.Name("downloadProgress")
    static let downloadComplete = NSNotification.Name("downloadComplete")
}
