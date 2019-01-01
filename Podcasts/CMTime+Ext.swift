//
//  CMTime+Ext.swift
//  Podcasts
//
//  Created by Owen Henley on 12/31/18.
//  Copyright © 2018 Owen Henley. All rights reserved.
//

import AVKit

extension CMTime {
    /// Converts the CMTime to a prettified string to be shown on screen
    func asDisplayableString() -> String {
        if CMTimeGetSeconds(self).isNaN { return "--:--:--" }
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = (totalSeconds / 60) % 60
        let hours = totalSeconds / 60 / 60
        let timeFormatString = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        return timeFormatString
    }
}
