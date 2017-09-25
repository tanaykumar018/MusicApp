//
//  ProgressUpdateDelegate.swift
//  MusicApp
//
//  Created by Tanay Kumar on 9/24/17.
//  Copyright © 2017 Tanay Kumar. All rights reserved.
//

import Foundation

protocol ProgressUpdateDelegate {
    func updateDisplay(progress: Float, totalSize : String);
}

