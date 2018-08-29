//
//  SettingsViewController.swift
//  Meetrum Recorder
//
//  Created by think360 on 14/08/18.
//  Copyright © 2018 bharath. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet var BackButt: UIButton!
    @IBOutlet var LogoImg: UIImageView!
    
    @IBOutlet var AudioFormatLab: UILabel!
    @IBOutlet var AudioQuantityLab: UILabel!
    @IBOutlet var VideoFormatLab: UILabel!
    @IBOutlet var VideoQuantityLab: UILabel!
    @IBOutlet var RecordSwitch: UISwitch!
    @IBOutlet var UploadSwitch: UISwitch!
    
    @IBOutlet var UserNameView: UIView!
    @IBOutlet var UserNameLab: UILabel!
    @IBOutlet var DeleteAccountButt: UIButton!
    
    var RecSwitch:Bool = true
    var UpdSwitch:Bool = true
    
    let kConstantObj = kConstant()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserNameView.layer.cornerRadius = 4.0
        UserNameView.layer.borderWidth = 1.3
        UserNameView.layer.borderColor = #colorLiteral(red: 0.2470588235, green: 0.2431372549, blue: 0.2666666667, alpha: 1)
        
        DeleteAccountButt.layer.cornerRadius = 4.0
        DeleteAccountButt.layer.borderWidth = 1.3
        DeleteAccountButt.layer.borderColor = #colorLiteral(red: 0.2470588235, green: 0.2431372549, blue: 0.2666666667, alpha: 1)
        
        RecSwitch = true
        UpdSwitch = true

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if let data = UserDefaults.standard.data(forKey: "Settings"),
            let info = NSKeyedUnarchiver.unarchiveObject(with: data) as? [SettingsModel]
        {
            self.AudioFormatLab.text = info.last?.audioFormat
            self.AudioQuantityLab.text = info.last?.audioQuality
            self.VideoFormatLab.text = info.last?.videoFormat
            self.VideoQuantityLab.text = info.last?.videoQuality
            
            let checkAutoPlay:Bool = (info.last?.autoplay)!
            
            if checkAutoPlay == true
            {
                self.RecordSwitch.setOn(true, animated: false)
            }
            else
            {
                self.RecordSwitch.setOn(true, animated: false)
            }
            
            
            let UploadMeetrum:Bool = (info.last?.upload)!
            
            if UploadMeetrum == true
            {
                self.UploadSwitch.setOn(true, animated: false)
            }
            else
            {
                self.UploadSwitch.setOn(true, animated: false)
            }
        }
        else
        {
           
        }
    }

     //MARK: Back Butt Clicked
    @IBAction func BackButtClicked(_ sender: UIButton)
    {
        let mainVcIntial = self.kConstantObj.SetIntialMainViewController("ViewController")
        self.navigationController?.pushViewController(mainVcIntial, animated: true)
        
       // self.navigationController?.popViewController(animated: true)
    }
    
    //Video Ogv, mp4, mkv
    // Audio aac, MP3, opus, ogg, wav
    
     //MARK: AudioFormat Butt Clicked
    @IBAction func AudioFormatButtClicked(_ sender: UIButton)
    {
        AlertClassVC.sharedInstance.callAlertPopup(view: self, title1: "aac", title2: "MP3", title3: "opus", title4: "ogg", title5: "wav", completionHandler: { (success) -> Void in
            if success == 101 {
                self.AudioFormatLab.text = ".aac" 
            }
            if success == 102 {
                self.AudioFormatLab.text = ".MP3"
            }
            if success == 103 {
                self.AudioFormatLab.text = ".opus"
            }
            if success == 104 {
                 self.AudioFormatLab.text = ".ogg"
            }
            if success == 105 {
                self.AudioFormatLab.text = ".wav"
            }else {
            }
        })
    }
    
    //MARK: AudioQuality Butt Clicked
    @IBAction func AudioQualityButtClicked(_ sender: UIButton)
    {
        AlertClassVC.sharedInstance.callAlertPopup(view: self, title1: "120 Kb/s", title2: "240 Kb/s", title3: "320 Kb/s", title4: "", title5: "", completionHandler: { (success) -> Void in
            if success == 101 {
                self.AudioQuantityLab.text = "120 Kb/s"
            }
            if success == 102 {
                self.AudioQuantityLab.text = "240 Kb/s"
            }
            if success == 103 {
                self.AudioQuantityLab.text = "320 Kb/s"
            }else {
            }
        })
    }
    
    //MARK: VideoFormat Butt Clicked
    @IBAction func VideoFormatButtClicked(_ sender: UIButton)
    {
        AlertClassVC.sharedInstance.callAlertPopup(view: self, title1: "Ogv", title2: "mp4", title3: "mkv", title4: "", title5: "", completionHandler: { (success) -> Void in
            if success == 101 {
               self.VideoFormatLab.text = ".Ogv"
            }
            if success == 102 {
               self.VideoFormatLab.text = ".mp4"
            }
            if success == 103 {
               self.VideoFormatLab.text = ".mkv"
            }else {
            }
        })
    }
    
    //MARK: VideoQuality Butt Clicked
    @IBAction func VideoQualityButtClicked(_ sender: UIButton)
    {
        AlertClassVC.sharedInstance.callAlertPopup(view: self, title1: "Normal", title2: "HD", title3: "Full HD", title4: "", title5: "", completionHandler: { (success) -> Void in
            if success == 101 {
                self.VideoQuantityLab.text = "Normal"
            }
            if success == 102 {
                self.VideoQuantityLab.text = "HD"
            }
            if success == 103 {
                self.VideoQuantityLab.text = "Full HD"
            }else {
            }
        })
    }
    
    //MARK: RecordSwitch Butt Clicked
    @IBAction func RecordSwitchChanged(_ sender: UISwitch)
    {
        if RecordSwitch.isOn
        {
            RecSwitch = true
            self.RecordSwitch.setOn(true, animated: true)
        }
        else
        {
            RecSwitch = false
            self.RecordSwitch.setOn(false, animated: true)
        }
    }
    
     //MARK: UploadMeetrum Butt Clicked
    @IBAction func UploadMeetrumSwitchChanged(_ sender: UISwitch)
    {
        if UploadSwitch.isOn
        {
            UpdSwitch = true
            self.UploadSwitch.setOn(true, animated: true)
        }
        else
        {
            UpdSwitch = false
             self.UploadSwitch.setOn(false, animated: true)
        }
    }
    
     //MARK: Delete Butt Clicked
    @IBAction func DeleteButtClicked(_ sender: UIButton)
    {
        let alert = UIAlertController(title: "Meetrum Recorder", message: "Are You Sure Want to Delete Account?", preferredStyle: UIAlertControllerStyle.alert)
        
        let alertOKAction=UIAlertAction(title:"Delete", style: UIAlertActionStyle.default,handler: { action in
           
        })
        
        let alertCancelAction=UIAlertAction(title:"Cancel", style: UIAlertActionStyle.default,handler: { action in
            
        })
        
        alert.addAction(alertOKAction)
        alert.addAction(alertCancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Save Butt Clicked
    @IBAction func SaveButtClicked(_ sender: UIButton)
    {
        let newSettingsData = SettingsModel(audioFormat: self.AudioFormatLab.text!, audioQuality: self.AudioQuantityLab.text!, videoFormat: self.VideoFormatLab.text!, videoQuality: self.VideoQuantityLab.text!, autoplay: RecSwitch, upload: UpdSwitch)
        var newSettings = [SettingsModel]()
        newSettings.append(newSettingsData)
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: newSettings)
        UserDefaults.standard.set(encodedData, forKey: "Settings")
        
        
        let alert = UIAlertController(title: "Meetrum Recorder", message: "Settings has been saved successfully", preferredStyle: UIAlertControllerStyle.alert)
        
        let alertOKAction=UIAlertAction(title:"Ok", style: UIAlertActionStyle.default,handler: { action in
            // self.navigationController?.popViewController(animated: true)
            
            let mainVcIntial = self.kConstantObj.SetIntialMainViewController("ViewController")
            self.navigationController?.pushViewController(mainVcIntial, animated: true)
        })
        alert.addAction(alertOKAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
