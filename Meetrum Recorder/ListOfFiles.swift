//
//  ListOfFiles.swift
//  Meetrum Recorder
//
//  Created by think360 on 22/08/18.
//  Copyright © 2018 bharath. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import AVKit

class ListOfFiles: NSObject,NSCoding
{
    //MARK: Properties
    var filetype: String?
    var fileDuration: Int?
    var fileformat: String?
    var fileQuantity: String?
    var fileUrl: NSURL?
    var fileRecordedDate: String?
  //  var audioRecorder = AVAudioRecorder()
    
    
    //MARK: Initialization
    //init(filetype: String, fileDuration: Int, fileformat: String ,fileQuantity: String, fileUrl: NSURL, fileRecordedDate: String, audioRecorder: AVAudioRecorder )
    init(filetype: String, fileDuration: Int, fileformat: String ,fileQuantity: String, fileUrl: NSURL, fileRecordedDate: String )
    {
        // Initialize stored properties
        self.filetype = filetype
        self.fileDuration = fileDuration
        self.fileformat = fileformat
        self.fileQuantity = fileQuantity
        self.fileUrl = fileUrl
        self.fileRecordedDate = fileRecordedDate
       // self.audioRecorder = audioRecorder
    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(filetype, forKey: "filetype")
        aCoder.encode(fileDuration, forKey: "fileDuration")
        aCoder.encode(fileformat, forKey: "fileformat")
        aCoder.encode(fileQuantity, forKey: "fileQuantity")
        aCoder.encode(fileUrl, forKey: "fileUrl")
        aCoder.encode(fileRecordedDate, forKey: "fileRecordedDate")
       //  aCoder.encode(audioRecorder, forKey: "audioRecorder")
    }
    
    required init(coder decoder: NSCoder)
    {
        self.filetype = decoder.decodeObject(forKey: "filetype") as? String ?? ""
        self.fileDuration = decoder.decodeObject(forKey: "fileDuration") as? Int ?? 0
        self.fileformat = decoder.decodeObject(forKey: "fileformat") as? String ?? ""
        self.fileQuantity = decoder.decodeObject(forKey: "fileQuantity") as? String ?? ""
        self.fileUrl = decoder.decodeObject(forKey: "fileUrl") as? NSURL
        self.fileRecordedDate = decoder.decodeObject(forKey: "fileRecordedDate") as? String ?? ""
      //  self.audioRecorder = decoder.decodeObject(forKey: "audioRecorder") as! AVAudioRecorder 
    }
}
