//
//  ViewController.swift
//  IPAIconGenerator
//
//  Created by Orest Savchak on 2/27/15.
//  Copyright (c) 2015 Orest&Vadym. All rights reserved.
//

import Cocoa
import ImageIO

class ViewController: NSViewController {
    
    @IBOutlet weak var IPhoneCB: NSButton!
    @IBOutlet weak var IPadCB: NSButton!
    @IBOutlet weak var CarPlayCB: NSButton!
    @IBOutlet weak var macOsCB: NSButton!
    
    @IBOutlet weak var appWatchCB: NSButton!
    @IBOutlet weak var generateButton: NSButton!
    @IBOutlet weak var preview: NSImageView!
    
    @IBOutlet weak var progress: NSProgressIndicator!
    var url: NSURL?
    var arrayUrls: Array<NSURL>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func openFileWithTypesArray(fileTypesArray:Array<String>,allowsMultipleSelection:Bool) -> Array<AnyObject>? {
        let openDlg : NSOpenPanel       = NSOpenPanel()
        openDlg.canChooseFiles          = true
        openDlg.allowedFileTypes        = fileTypesArray
        openDlg.allowsMultipleSelection = allowsMultipleSelection
        if openDlg.runModal() == NSModalResponseOK {
            return openDlg.URLs
        }
        else {
            return nil
        }
    }

    @IBAction func didCickChooseImage(sender: NSButton) {
        if let urlArr : Array  = openFileWithTypesArray(IGImageModel.extentions(),allowsMultipleSelection: false) {
            self.url = urlArr[0] as? NSURL
            self.preview.image = NSImage(contentsOfURL: self.url!)
            let height = self.preview.image?.size.height
            let width = self.preview.image?.size.width
            if (height != width) {
                let alert = NSAlert()
                alert.messageText = "Selected image should be square!"
                alert.runModal()
            } else {
                self.generateButton.enabled = true
            }
        }
    }

    @IBAction func didClickGenerate(sender: NSButton) {
        var scope: Array<IGImageModel> = []
        var count = 0
        if (IPhoneCB.state == NSOnState) {
            count += iPhoneCount
            scope.extend(IGIPhoneScope)
        }
        if (IPadCB.state == NSOnState) {
            count += iPadCount
            scope.extend(IGIPadScope)
        }
        if (CarPlayCB.state == NSOnState) {
            count += carPlayCount
            scope.extend(IGCarPlayScope)
        }
        if (macOsCB.state == NSOnState) {
            count += macOSCount
            scope.extend(IGMacOSScope)
        }
        if (appWatchCB.state == NSOnState) {
            count += appWatchCount
            scope.extend(IGAppWathScope)
        }
        if (count == 0) {
            return
        }
        self.progress.maxValue = Double(count)
        self.progress.hidden = false
        self.arrayUrls = Array<NSURL>()
        self.arrayUrls?.append(self.url!)
        for model: IGImageModel in scope {
            
            let scales:Array<IGScale> = model.scales
            let size: IGSize = model.size
            
            for scale: IGScale in scales {
                self.makeImageAndSave(model.imageName(size, scale: scale), imageSize: model.imageSize(size, scale: scale))
            }
        }
        self.progress.hidden = true
        NSWorkspace.sharedWorkspace().activateFileViewerSelectingURLs(self.arrayUrls!)
    }
    
    func makeImageAndSave(imageName:String, imageSize:CGSize) {
        if let imageSource = CGImageSourceCreateWithURL(self.url!, nil) {
            let options = [kCGImageSourceThumbnailMaxPixelSize as String: max(imageSize.width, imageSize.height), kCGImageSourceCreateThumbnailFromImageIfAbsent as String: true]
            if let cgimg = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options) {
                let newRep = NSBitmapImageRep(CGImage: cgimg);
                newRep.size = imageSize;
                if let pngData: NSData? = newRep.representationUsingType(NSBitmapImageFileType.NSPNGFileType, properties: [NSObject : AnyObject]()) {
                    let url: NSURL = self.url!.URLByDeletingLastPathComponent!.URLByAppendingPathComponent(imageName)
                    pngData?.writeToURL(url, atomically: false)
                    
                    self.arrayUrls?.append(url)
                }
            }
            
            self.progress.doubleValue++;
            self.progress.displayIfNeeded()
        }
    }
}

