//
//  ViewController.swift
//  Meetrum Recorder
//
//  Created by think360 on 14/08/18.
//  Copyright © 2018 bharath. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var SettingsButt: UIButton!
    @IBOutlet var logoImg: UIImageView!
    @IBOutlet var TypeRecordLab: UILabel!
    @IBOutlet var AVSwitch: UISwitch!
    @IBOutlet var CenterLogo: UIImageView!
    @IBOutlet var RecordButt: UIButton!
    @IBOutlet var QualityLab: UILabel!
    @IBOutlet var SavedFilesButt: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SavedFilesButt.isHidden = true
        
        RecordButt.layer.cornerRadius = RecordButt.bounds.size.width/2
        RecordButt.clipsToBounds = true
        
        SavedFilesButt.layer.cornerRadius = SavedFilesButt.bounds.size.width/2
        SavedFilesButt.clipsToBounds = true
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if let data = UserDefaults.standard.data(forKey: "Settings"),
            let info = NSKeyedUnarchiver.unarchiveObject(with: data) as? [SettingsModel]
        {
            let strquality: String = (info.last?.audioQuality)!
            let strformat: String = (info.last?.audioFormat)!
            
            var strqualityType = String()
            if strquality == "120 Kb/s"
            {
                strqualityType = "Low"
            }
            else if strquality == "240 Kb/s"
            {
                strqualityType = "Medium"
            }
            else
            {
                strqualityType = "High"
            }
            
            let str1 = "Quality: "
            let str2 = " ("
            let str3 = "/"
            let str4 = ")"
            
            let txtStrQuality: String = str1+strqualityType+str2+strformat+str3+strquality+str4
            
            QualityLab.text = txtStrQuality
        }
        else
        {
            
            let newSettingsData = SettingsModel(audioFormat: ".MP3", audioQuality: "320 Kb/s", videoFormat: ".mp4", videoQuality: "Full HD", autoplay: true, upload: true)
            var newSettings = [SettingsModel]()
            newSettings.append(newSettingsData)
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: newSettings)
            UserDefaults.standard.set(encodedData, forKey: "Settings")         
            
            QualityLab.text = "Quality: High(.MP3/320 Kb/s)"
        }
    }
    
     //MARK: Setting Butt Clicked
    @IBAction func SettingsButtClicked(_ sender: UIButton)
    {
         sideMenuVC.toggleMenu()
        
//        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController
//        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    
    @IBAction func goToSavedFiles_Action(_ sender: Any)
    {
        if let data = UserDefaults.standard.data(forKey: "ListOfFiles"),
            let info = NSKeyedUnarchiver.unarchiveObject(with: data) as? [ListOfFiles]
        {
           if info.count == 0
           {
                let alert = UIAlertController(title: "Meetrum Recorder", message: "There is no files saved in your account", preferredStyle: UIAlertControllerStyle.alert)
            
                let alertOKAction=UIAlertAction(title:"Ok", style: UIAlertActionStyle.default,handler: { action in
                
                })
                alert.addAction(alertOKAction)
                self.present(alert, animated: true, completion: nil)
            }
            else
           {
                let listOfFileVCObj = self.storyboard?.instantiateViewController(withIdentifier: "ListOfFileVC") as? ListOfFileVC
                self.navigationController?.pushViewController(listOfFileVCObj!, animated: true)
            }
        }
        else
        {
            let alert = UIAlertController(title: "Meetrum Recorder", message: "There is no files saved in your account", preferredStyle: UIAlertControllerStyle.alert)
            
            let alertOKAction=UIAlertAction(title:"Ok", style: UIAlertActionStyle.default,handler: { action in
                
            })
            alert.addAction(alertOKAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    //MARK: AVSwitch Changed
    @IBAction func AVSwitchChanged(_ sender: UISwitch)
    {
        self.AVSwitch.setOn(false, animated: false)
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "VideoRecordingViewController") as? VideoRecordingViewController
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    
    @IBAction func SwitchButtClicked(_ sender: UIButton)
    {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "VideoRecordingViewController") as? VideoRecordingViewController
        self.navigationController?.pushViewController(myVC!, animated: false)
    }
    
    //MARK: Record Butt Clicked
    @IBAction func RecordButtClicked(_ sender: UIButton)
    {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "RecordingViewController") as? RecordingViewController
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    
    //MARK: Saved Files Butt Clicked
    @IBAction func SavedFilesButtClicked(_ sender: UIButton)
    {
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

