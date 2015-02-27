//
//  IGImageModel.swift
//  IPAIconGenerator
//
//  Created by Orest Savchak on 2/27/15.
//  Copyright (c) 2015 Orest&Vadym. All rights reserved.
//

import Foundation

enum IGSize : String {
    case PT29 = "29", PT40 = "40", PT57 = "57", PT60 = "60", PT50 = "50", PT72 = "72", PT76 = "76", PT120 = "120", PT16 = "16", PT32 = "32", PT128 = "128", PT256 = "256", PT512 = "512"
}

enum IGScale : String {
    case _1X = "", _2X = "@2x", _3X = "@3x"
}

class IGImageModel {
    
    let baseName = "logo"
    let extention: String = "png"
    
    let size : IGSize
    let scales : Array<IGScale>
    
    init(size:IGSize, scales:Array<IGScale>) {
        self.size = size
        self.scales = scales
    }
    
    func imageName(size:IGSize, scale:IGScale) -> NSString {
        return baseName + size.rawValue + scale.rawValue + "." + extention
    }
    
    func imageSize(size:IGSize, scale:IGScale) -> CGSize {
        let height = size.rawValue.toInt()!
        let multiplier = scale == ._1X ? 1 : scale == ._2X ? 2 : 3
        
        let result = height * multiplier
        
        return CGSize(width: result, height: result)
    }
    
    class func extentions() -> Array<String> {
        return ["png"]
    }
}