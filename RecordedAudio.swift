//
//  RecordedAudio.swift
//  PitchPerfect
//
//  Created by yunchu on 5/13/15.
//  Copyright (c) 2015 AmerPe Studio. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var title:String!
    var filePathUrl: NSURL!
    init(title: String, filePathUrl: NSURL) {
        self.title = title
        self.filePathUrl = filePathUrl
    }
}