//
//  AudioUploadViewController.swift
//  Meetrum Recorder
//
//  Created by think360 on 14/08/18.
//  Copyright © 2018 bharath. All rights reserved.
//

import UIKit
import AVFoundation

class AudioUploadViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate,UITextViewDelegate {

    @IBOutlet var RecordTypeLab: UILabel!
    @IBOutlet var logoImg: UIImageView!
    
    var audioPlayer : AVAudioPlayer!
    var Selecturl = NSURL()
    
    var audioRecorder:AVAudioRecorder!
    
    @IBOutlet var txtView_Description: UITextView!
    @IBOutlet var AudioFormatLab: UILabel!
    @IBOutlet var AudioQuantityLab: UILabel!
    @IBOutlet var UploadSwitch: UISwitch!
    @IBOutlet var SaveButt: UIButton!
    @IBOutlet var RecordDatelab: UILabel!
    
    var y = Int()
    var dateString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let str1 = " Recording"
        RecordDatelab.text = dateString+str1

        // Do any additional setup after loading the view.
        
        if let data = UserDefaults.standard.data(forKey: "Settings"),
            let info = NSKeyedUnarchiver.unarchiveObject(with: data) as? [SettingsModel]
        {
            AudioQuantityLab.text = (info.last?.audioQuality)!
            AudioFormatLab.text = (info.last?.audioFormat)!
        }
        else
        {
           
        }
        
        Selecturl =  audioRecorder.url as NSURL
        print(Selecturl)     
//        self.audioPlayer = try! AVAudioPlayer(contentsOf: Selecturl as URL )
//        self.audioPlayer.prepareToPlay()
//        self.audioPlayer.delegate = self
//        self.audioPlayer.play()
        
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
    
    // MARK:  Save Butt Clicked
    @IBAction func SaveButtClicked(_ sender: UIButton)
    {
       // let dateFormatterGet = DateFormatter()
       //  dateFormatterGet.dateFormat = "yyyy-MM-dd-HH:mm:ss"
       //  let date = Date()
       // let dateString = dateFormatterGet.string(from: date)
        
        if let data = UserDefaults.standard.data(forKey: "ListOfFiles"),
            var info = NSKeyedUnarchiver.unarchiveObject(with: data) as? [ListOfFiles]
        {
           // let Newfile = ListOfFiles(filetype: "Audio", fileDuration: y, fileformat: AudioFormatLab.text!, fileQuantity: AudioQuantityLab.text!, fileUrl: Selecturl, fileRecordedDate: dateString, audioRecorder: audioRecorder)
            let Newfile = ListOfFiles(filetype: "Audio", fileDuration: y, fileformat: AudioFormatLab.text!, fileQuantity: AudioQuantityLab.text!, fileUrl: Selecturl, fileRecordedDate: dateString)
            info.append(Newfile)
            
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: info)
            UserDefaults.standard.set(encodedData, forKey: "ListOfFiles")
        }
        else
        {
          //  let Newfile = ListOfFiles(filetype: "Audio", fileDuration: y, fileformat: AudioFormatLab.text!, fileQuantity: AudioQuantityLab.text!, fileUrl: Selecturl, fileRecordedDate: dateString, audioRecorder: audioRecorder)
            let Newfile = ListOfFiles(filetype: "Audio", fileDuration: y, fileformat: AudioFormatLab.text!, fileQuantity: AudioQuantityLab.text!, fileUrl: Selecturl, fileRecordedDate: dateString)
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
                let listOfFileVCObj = self.storyboard?.instantiateViewController(withIdentifier: "ListOfFileVC") as? ListOfFileVC
                listOfFileVCObj?.strAutocheck = "1"
                self.navigationController?.pushViewController(listOfFileVCObj!, animated: true)
            }else
            {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        else{
//            let listOfFileVCObj = self.storyboard?.instantiateViewController(withIdentifier: "ListOfFileVC") as? ListOfFileVC
//            listOfFileVCObj?.strAutocheck = "2"
//            self.navigationController?.pushViewController(listOfFileVCObj!, animated: true)
            
             self.navigationController?.popToRootViewController(animated: true)
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
    @IBAction func AudioformatButtClicked(_ sender: UIButton)
    {
        
    }
    
    // MARK:  Audio Quality Clicked
    @IBAction func AudioQualityButtClicked(_ sender: UIButton)
    {
        
    }
    
    // MARK:  Audio Switch Clicked
    @IBAction func AudioSwitchChanged(_ sender: UISwitch)
    {
    
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print(flag)
    }
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?){
        print(error.debugDescription)
    }
    internal func audioPlayerBeginInterruption(_ player: AVAudioPlayer){
        print(player.debugDescription)
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
