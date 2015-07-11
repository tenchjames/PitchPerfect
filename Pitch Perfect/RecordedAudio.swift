//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by James Tench on 6/27/15.
//  Copyright (c) 2015 James Tench. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}