//
//  IGDragAndDropImageView.swift
//  IPAIconGenerator
//
//  Created by Orest Savchak on 6/17/15.
//  Copyright (c) 2015 Orest&Vadym. All rights reserved.
//

import Foundation
import AppKit

@objc protocol IGDragAndDropImageViewDelegate {
    func imageDroppedWithPath(path: NSString!)
    func didClickChoose()
}

class IGDragAndDropImageView: NSImageView, NSDraggingDestination {
    
    @IBOutlet weak var dropDelegate: IGDragAndDropImageViewDelegate!
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
    }
    
    let fileTypes = IGImageModel.extentions()
    var fileTypeIsOk = false
    var droppedFilePath: String?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        registerForDraggedTypes([NSFilenamesPboardType, NSURLPboardType, NSPasteboardTypeTIFF])
    }
    
    override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation {
        if checkExtension(sender) == true {
            self.fileTypeIsOk = true
            return .Copy
        } else {
            self.fileTypeIsOk = false
            return .None
        }
    }
    
    override func draggingUpdated(sender: NSDraggingInfo) -> NSDragOperation {
        if self.fileTypeIsOk {
            return .Copy
        } else {
            return .None
        }
    }
    
    override func performDragOperation(sender: NSDraggingInfo) -> Bool {
        if let board = sender.draggingPasteboard().propertyListForType("NSFilenamesPboardType") as? NSArray {
            if let imagePath = board[0] as? String {
                self.droppedFilePath = imagePath
                self.dropDelegate.imageDroppedWithPath(self.droppedFilePath)
                return true
            }
        }
        return false
    }
    
    func checkExtension(drag: NSDraggingInfo) -> Bool {
        if let board = drag.draggingPasteboard().propertyListForType("NSFilenamesPboardType") as? NSArray {
            if let url = NSURL(fileURLWithPath: (board[0] as! String)) {
                let suffix = url.pathExtension!
                for ext in self.fileTypes {
                    if ext.lowercaseString == suffix {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    override func mouseDown(theEvent: NSEvent) {
        if (theEvent.clickCount == 1) {
            self.dropDelegate.didClickChoose()
        }
    }
    
}