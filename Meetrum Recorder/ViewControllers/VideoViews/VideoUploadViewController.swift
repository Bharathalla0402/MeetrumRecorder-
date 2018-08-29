//
//  VideoUploadViewController.swift
//  Meetrum Recorder
//
//  Created by think360 on 16/08/18.
//  Copyright © 2018 bharath. All rights reserved.
//

import UIKit

class VideoUploadViewController: UIViewController,UITextViewDelegate {

    @IBOutlet var RecordTypeLab: UILabel!
    @IBOutlet var logoImg: UIImageView!
    @IBOutlet var UploadImg: UIImageView!
    
     var videourl = NSURL()
    @IBOutlet var VideoFormatLab: UILabel!
    @IBOutlet var VideoQuantityLab: UILabel!
    @IBOutlet var UploadSwitch: UISwitch!
    @IBOutlet var SaveButt: UIButton!
    @IBOutlet var txtView_Description: UITextView!
    var dateString = String()
    @IBOutlet var RecordDateLab: UILabel!
    
    var y = Int()
    var strformat = String()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let str1 = " Recording"
        RecordDateLab.text = dateString+str1
        
        if let data = UserDefaults.standard.data(forKey: "Settings"),
            let info = NSKeyedUnarchiver.unarchiveObject(with: data) as? [SettingsModel]
        {
            VideoQuantityLab.text = (info.last?.videoQuality)!
            VideoFormatLab.text = (info.last?.videoFormat)!
            self.strformat = (info.last?.videoFormat)!
        }
        else
        {
          self.strformat = ".mp4"
        }
        
        UploadImg.layer.cornerRadius = UploadImg.bounds.size.width/2
        UploadImg.clipsToBounds = true

        self.addDoneButtonOnKeyboard()
        // Do any additional setup after loading the view.
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x:0, y:0, width:320, height:50))
        doneToolbar.barStyle = UIBarStyle.black
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneButtonAction))
        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        self.txtView_Description.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
       self.view.endEditing(true)
    }
    
    // MARK:  Back Butt Clicked
    @IBAction func BackButtClicked(_ sender: UIButton)
    {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func directoryURL() -> NSURL? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as NSURL
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd-HH:mm:ss"
        let date = Date()
        let dateString = dateFormatterGet.string(from: date)
        let videoDataPath = dateString+self.strformat
        //let filepath = directoryPath.appending(filename)
        let soundURL = documentDirectory.appendingPathComponent(videoDataPath)
        print(soundURL ?? "")
        return soundURL as NSURL?
    }
    
    // MARK:  Save Butt Clicked
    @IBAction func SaveButtClicked(_ sender: UIButton)
    {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd-HH:mm:ss"
        let date = Date()
        let dateString = dateFormatterGet.string(from: date)
        
        if let data = UserDefaults.standard.data(forKey: "ListOfFiles"),
            var info = NSKeyedUnarchiver.unarchiveObject(with: data) as? [ListOfFiles]
        {
            // let Newfile = ListOfFiles(filetype: "Audio", fileDuration: y, fileformat: AudioFormatLab.text!, fileQuantity: AudioQuantityLab.text!, fileUrl: Selecturl, fileRecordedDate: dateString, audioRecorder: audioRecorder)
            let Newfile = ListOfFiles(filetype: "Video", fileDuration: y, fileformat: VideoFormatLab.text!, fileQuantity: VideoQuantityLab.text!, fileUrl: videourl, fileRecordedDate: dateString)
            info.append(Newfile)
            
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: info)
            UserDefaults.standard.set(encodedData, forKey: "ListOfFiles")
        }
        else
        {
            //  let Newfile = ListOfFiles(filetype: "Audio", fileDuration: y, fileformat: AudioFormatLab.text!, fileQuantity: AudioQuantityLab.text!, fileUrl: Selecturl, fileRecordedDate: dateString, audioRecorder: audioRecorder)
            let Newfile = ListOfFiles(filetype: "Video", fileDuration: y, fileformat: VideoFormatLab.text!, fileQuantity: VideoQuantityLab.text!, fileUrl: videourl, fileRecordedDate: dateString)
            var NewlistofFiles = [ListOfFiles]()
            NewlistofFiles.append(Newfile)
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: NewlistofFiles)
            UserDefaults.standard.set(encodedData, forKey: "ListOfFiles")
        }
        
        
        if let data = UserDefaults.standard.data(forKey: "Settings"),
            let info = NSKeyedUnarchiver.unarchiveObject(with: data) as? [SettingsModel]
        {
            let CheckAutoPlay: Bool = (info.last?.autoplay)!
            
            if CheckAutoPlay == true
            {
                let listOfFileVCObj = self.storyboard?.instantiateViewController(withIdentifier: "PlayerVC") as? PlayerVC
                listOfFileVCObj?.videourl = videourl
                listOfFileVCObj?.strAutocheck = "1"
                listOfFileVCObj?.strRecordDate = dateString
                listOfFileVCObj?.y = y
                self.navigationController?.pushViewController(listOfFileVCObj!, animated: true)
            }else
            {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        else{
            let listOfFileVCObj = self.storyboard?.instantiateViewController(withIdentifier: "PlayerVC") as? PlayerVC
            listOfFileVCObj?.videourl = videourl
            listOfFileVCObj?.strAutocheck = "1"
            listOfFileVCObj?.strRecordDate = dateString
            listOfFileVCObj?.y = y
            self.navigationController?.pushViewController(listOfFileVCObj!, animated: true)
           // self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    //MARK:- textview delegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Description" {
            textView.text = nil
            textView.textColor = UIColor.white
        }
        else{
          }
    }
    
    
    // MARK:  ContentType Butt Clicked
    @IBAction func ContentTypeButtClicked(_ sender: UIButton)
    {
        
    }
    
    // MARK:  Tag Butt Clicked
    @IBAction func TagsButtClicked(_ sender: UIButton)
    {
        
    }
    
    // MARK:  Audio Format Clicked
    @IBAction func VideoformatButtClicked(_ sender: UIButton)
    {
        
    }
    
    // MARK:  Audio Quality Clicked
    @IBAction func VideoQualityButtClicked(_ sender: UIButton)
    {
        
    }
    
    // MARK:  Audio Switch Clicked
    @IBAction func VideoSwitchChanged(_ sender: UISwitch)
    {
      
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
