//
//  UITableView+Ext.swift
//  Podcasts
//
//  Created by Owen Henley on 12/31/18.
//  Copyright © 2018 Owen Henley. All rights reserved.
//

import UIKit

extension UITableView {
    
    /// Reloads the UITableView on DispatchQueue.main.async
    func reloadOnMainThread() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}
