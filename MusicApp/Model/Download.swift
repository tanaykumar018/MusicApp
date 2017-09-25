//
//  Download.swift
//  MusicApp
//
//  Created by Tanay Kumar on 9/24/17.
//  Copyright © 2017 Tanay Kumar. All rights reserved.
//

import Foundation

class Download: NSObject {
    var url: URL
    var isDownloading = false
    var progress: Float = 0
    
    var task: URLSessionDownloadTask?
    var resumeData: Data?
    
    init(url: URL) {
        self.url = url
    }
}

