//
//  SettingsModel.swift
//  Meetrum Recorder
//
//  Created by think360 on 20/08/18.
//  Copyright © 2018 bharath. All rights reserved.
//

import UIKit

class SettingsModel: NSObject ,NSCoding
    {
        //MARK: Properties
        var audioFormat: String?
        var audioQuality: String?
        var videoFormat: String?
        var videoQuality: String?
        var autoplay: Bool = true
        var upload: Bool = false
    
        //MARK: Initialization
    init(audioFormat: String, audioQuality: String, videoFormat: String, videoQuality: String ,autoplay:Bool ,upload:Bool)
        {
            // Initialize stored properties
            self.audioFormat = audioFormat
            self.audioQuality = audioQuality
            self.videoFormat = videoFormat
            self.videoQuality = videoQuality
            self.autoplay = autoplay
            self.upload = upload
        }
        
        func encode(with aCoder: NSCoder)
        {
            aCoder.encode(audioFormat, forKey: "audioFormat")
            aCoder.encode(audioQuality, forKey: "audioQuality")
            aCoder.encode(videoFormat, forKey: "videoFormat")
            aCoder.encode(videoQuality, forKey: "videoQuality")
            aCoder.encode(autoplay, forKey: "autoplay")
            aCoder.encode(upload, forKey: "upload")
        }
        
        required init(coder decoder: NSCoder)
        {
            self.audioFormat = decoder.decodeObject(forKey: "audioFormat") as? String ?? ""
            self.audioQuality = decoder.decodeObject(forKey: "audioQuality") as? String ?? ""
            self.videoFormat = decoder.decodeObject(forKey: "videoFormat") as? String ?? ""
            self.videoQuality = decoder.decodeObject(forKey: "videoQuality") as? String ?? ""
            self.autoplay = decoder.decodeObject(forKey: "autoplay") as? Bool ?? true
            self.upload = decoder.decodeObject(forKey: "upload") as? Bool ?? false
        }
    
//    // Save Data
//    let newcoordinates = Place(name: self.LocationName.text!, Address: "", Currentlat: self.currentLatitude, CurrentLong: self.currentLongitude)
//    var newPlace = [Place]()
//    newPlace.append(newcoordinates)
//    let encodedData = NSKeyedArchiver.archivedData(withRootObject: newPlace)
//    UserDefaults.standard.set(encodedData, forKey: "NewPlace")
//
//    //Retrive Data
//    if let data = UserDefaults.standard.data(forKey: "NewPlace"),
//
//    let info = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Place]
//
//    {
//        LocationName.text = info.last?.name
//        currentLatitude = (info.last?.Currentlat)!
//        currentLongitude = (info.last?.CurrentLong)!
//    }

}
