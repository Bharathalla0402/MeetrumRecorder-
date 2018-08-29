//
//  ListOfFileVC.swift
//  Meetrum Recorder
//
//  Created by think360 on 20/08/18.
//  Copyright © 2018 bharath. All rights reserved.
//

import UIKit
import AVFoundation


class ListOfFileVC: UIViewController ,UITableViewDelegate,UITableViewDataSource , UISearchBarDelegate, AVAudioPlayerDelegate, AVAudioRecorderDelegate {

    @IBOutlet var height_AudioPlayView: NSLayoutConstraint!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var btn_Menu: UIButton!
    @IBOutlet var btn_Play: UIButton!
    @IBOutlet var img_User: UIImageView!
    @IBOutlet var lbl_playFile: UILabel!
    @IBOutlet var lbl_Purpose: UILabel!
    @IBOutlet var Listtabl: UITableView!
    @IBOutlet var AudioPlayView: UIView!
    @IBOutlet var ProgressView: UIProgressView!
    
    var fileURLArray = Array<Any>()
    var audioPlayer : AVAudioPlayer!
    var audioRecorder:AVAudioRecorder!
    
    var strAutocheck = String()
    var arrData = [ListOfFiles]()
    var AudioPlayIndex = Int()
    var AudioPlayCheck = String()
    var timer1 = Timer()
    var time : Float = 0.0
    var Durationfile : Float = 0.0
    var fileStringUrl:URL?
    
    var x:Int = 1
    var y:Int = 1
    var increase:Float = 0.0
    
    let kConstantObj = kConstant()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         Listtabl.tableFooterView = UIView()
        
        AudioPlayCheck = "1"
        
        self.btn_Menu.tintColor = UIColor(red: 96.0, green: 110.0, blue: 211.0, alpha: 1.0)
        self.addDoneButtonOnKeyboard()
        height_AudioPlayView.constant = 0.0
        AudioPlayView.isHidden = true
        
        if let data = UserDefaults.standard.data(forKey: "ListOfFiles"),
            let info = NSKeyedUnarchiver.unarchiveObject(with: data) as? [ListOfFiles]
        {
            arrData = info
            print(arrData.count)
            print(arrData[0].filetype ?? "")
            print(arrData[0].fileformat ?? "")
        }
        
       
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            print(fileURLs)
            fileURLArray = fileURLs
            // process files
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
        // Do any additional setup after loading the view.
        
        if strAutocheck == "1"
        {
            perform(#selector(self.PlayAudio), with: nil, afterDelay: 0.1)
            AudioPlayIndex = arrData.count-1
        }
        else
        {
            AudioPlayIndex = arrData.count
        }
        
            
        
    }
    
    @objc func PlayAudio()
    {
        if let fileString = arrData.last?.fileUrl{

//            do {
//                audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath:  Bundle.main.path(forResource: "beep", ofType: "wav")!))
//                audioPlayer.prepareToPlay()
//
//            } catch{
//                print(error)
//            }
            
            print(fileString)
            fileStringUrl = fileString as URL
             lbl_playFile.text = arrData.last?.fileRecordedDate
             AudioPlayView.isHidden = false
             height_AudioPlayView.constant = 50.0
            self.audioPlayer = try! AVAudioPlayer(contentsOf: fileString as URL)
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.delegate = self
            y = (arrData.last?.fileDuration)!
           // increase = Float(1 / (arrData.last?.fileDuration)!)
          //  x = increase
          //  timer1 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.autoScroll), userInfo: nil, repeats: true)
            print(increase)
            let duration = (arrData.last?.fileDuration)! % 60
            Durationfile = Float((arrData.last?.fileDuration)! % 60)
            UIView.animate(withDuration: TimeInterval(Float(duration)), animations: { () -> Void in
                self.ProgressView.setProgress(1.0, animated: true)
               // self.btn_Play.setImage(UIImage(named: "ListPlay"), for: .normal)
               // self.AudioPlayCheck = "3"
            })
            self.audioPlayer.play()
            
             timer1 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.autoScroll), userInfo: nil, repeats: true)
        }
    }
    
    @objc func autoScroll()
    {
        print(x)
         print(y)
        if x == y
        {
            timer1.invalidate()
            AudioPlayCheck = "3"
            
             Listtabl.reloadData()
            self.ProgressView.setProgress(0.0, animated: false)
            btn_Play.setImage(UIImage(named: "ListPlay"), for: .normal)
        }
        else
        {
            self.x += 1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:  TableView Delegate and Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListOfItemCell", for: indexPath) as? ListOfItemCell
        //if let fileString = fileURLArray[indexPath.row] as? URL{
        let urlString = String(describing: arrData[indexPath.row].fileUrl)
        let value = urlString.components(separatedBy: "/")
        print(value)
        print(value[value.count-1])
        cell?.lbl_FileName.text = value[value.count-1]
        
        cell?.lbl_FileName.text = arrData[indexPath.row].fileRecordedDate
        cell?.lbl_Quality.text = arrData[indexPath.row].fileQuantity
        
        var fileName = String()
        fileName = arrData[indexPath.row].filetype!
       
        
        if fileName == "Audio"
        {
            cell?.img_User.image = UIImage(named: "Audio")
            
            if AudioPlayIndex == indexPath.row
            {
                if AudioPlayCheck == "1"
                {
                    cell?.btn_Play.setTitle(nil, for: .normal)
                    cell?.btn_Play.setImage(UIImage(named: "ListPause"), for: .normal)
                }
                else
                {
                    cell?.btn_Play.setTitle(String(describing:indexPath.row+1), for: .normal)
                    cell?.btn_Play.setImage(nil, for: .normal)
                }
            }
            else
            {
                cell?.btn_Play.setTitle(String(describing:indexPath.row+1), for: .normal)
                cell?.btn_Play.setImage(nil, for: .normal)
            }
        }
        else
        {
            cell?.img_User.image = UIImage(named: "Video")
            
            cell?.btn_Play.setTitle(String(describing:indexPath.row+1), for: .normal)
            cell?.btn_Play.setImage(nil, for: .normal)
        }

       
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var fileName = String()
        fileName = arrData[indexPath.row].filetype!
        print(arrData[indexPath.row].fileUrl! as URL)
        
        if fileName == "Audio"
        {
            
            if  AudioPlayIndex == indexPath.row
            {
                
            }else
            {
                x=1
                AudioPlayIndex = indexPath.row
                lbl_playFile.text = arrData[indexPath.row].fileRecordedDate
                AudioPlayView.isHidden = false
                fileStringUrl = arrData[indexPath.row].fileUrl! as URL
               height_AudioPlayView.constant = 50.0
                self.ProgressView.setProgress(0.0, animated: false)
//            self.audioPlayer = try! AVAudioPlayer(contentsOf: arrData[indexPath.row].fileUrl! as URL)
//            self.audioPlayer.prepareToPlay()
//            self.audioPlayer.delegate = self
//            self.audioPlayer.play()
            do {
                self.audioPlayer = try AVAudioPlayer(contentsOf: arrData[indexPath.row].fileUrl! as URL)
                audioPlayer.prepareToPlay()
                self.audioPlayer.delegate = self
                y = (arrData.last?.fileDuration)!
              //  increase = Float(1 % (arrData.last?.fileDuration)!)
              //  x = increase
                let duration = arrData[indexPath.row].fileDuration! % 60
                Durationfile = Float(arrData[indexPath.row].fileDuration! % 60)
                UIView.animate(withDuration: TimeInterval(Float(duration)), animations: { () -> Void in
                    DispatchQueue.main.async {
                    self.ProgressView.setProgress(1.0, animated: true)
                      //  self.btn_Play.setImage(UIImage(named: "ListPlay"), for: .normal)
                     //   self.AudioPlayCheck = "3"
                    }
                })
                self.audioPlayer.play()
                AudioPlayCheck = "1"
                btn_Play.setImage(UIImage(named: "ListPause"), for: .normal)
                timer1 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.autoScroll), userInfo: nil, repeats: true)
                
                
                
            } catch{
                print(error)
            }
                
                 Listtabl.reloadData()
            }
        }
        else
        {
             AudioPlayIndex = arrData.count
             AudioPlayView.isHidden = true
            height_AudioPlayView.constant = 00.0
            let playerVCObj = self.storyboard?.instantiateViewController(withIdentifier: "PlayerVC") as? PlayerVC
            playerVCObj?.videourl = arrData[indexPath.row].fileUrl! as URL as NSURL
            playerVCObj?.strRecordDate = arrData[indexPath.row].fileRecordedDate!
            playerVCObj?.y = arrData[indexPath.row].fileDuration!
            self.navigationController?.pushViewController(playerVCObj!, animated: true)
            
            Listtabl.reloadData()
        }
        
        
        
        
        
//        var urlArray = Array<Any>()
//        if let fileString = arrData[indexPath.row].fileUrl as URL?{
//            let urlString = String(describing: fileString)
//            urlArray = urlString.components(separatedBy: "/")
//            print(urlArray)
//           let fileNameArray = urlString.components(separatedBy: ".")
//            fileName = fileNameArray[1]
//            print(urlArray[urlArray.count-1])
//
//        }
//       if fileName == "aac" || fileName == "MP3" || fileName == "opus" || fileName == "ogg" || fileName == "wav"{
//       // if fileName ==  arrData[indexPath.row].filetype! {
//         height_AudioPlayView.constant = 50.0
//         lbl_playFile.text = urlArray[urlArray.count-1] as? String
//            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as! NSString
//            print(documentsPath)
//        if let fileString = arrData[indexPath.row].fileUrl as URL?{
//            self.audioPlayer = try! AVAudioPlayer(contentsOf: arrData[indexPath.row].fileUrl! as URL)
//        self.audioPlayer.prepareToPlay()
//        self.audioPlayer.delegate = self
//        self.audioPlayer.play()
//          }
//        }
//        else{
//
//        }
    
    }
    
    @objc func showPlayerView()
    {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
   @objc func setProgress(index:Int) {
       // time += 0.1
    let hours = arrData[index].fileDuration! / 3600
    time = Float(hours)
        ProgressView.progress = time / 3
        if time >= 3 {
           // timer1.invalidate()
        }
    }

    //MARK:  UISearchBar delegate
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    
    
    @IBAction func SettingsButtClicked(_ sender: Any)
    {
       // let myVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController
       // self.navigationController?.popToViewController(myVC!, animated: false)
        
        let mainVcIntial = self.kConstantObj.SetIntialMainViewController("ViewController")
        self.navigationController?.pushViewController(mainVcIntial, animated: true)
        
       // self.navigationController?.popToRootViewController(animated: true)
    }
    
     //MARK:  AudioPlay
    @IBAction func Action_Play(_ sender: Any)
    {
        if AudioPlayCheck == "1"
        {
           //  self.audioRecorder.pause()
            AudioPlayCheck = "2"
            btn_Play.setImage(UIImage(named: "ListPlay"), for: .normal)
            Listtabl.reloadData()
            
            timer1.invalidate()
        }
        else if AudioPlayCheck == "2"
        {
           // self.audioPlayer.play()
            x = 1
            
            AudioPlayCheck = "1"
            btn_Play.setImage(UIImage(named: "ListPause"), for: .normal)
             Listtabl.reloadData()
            
            self.ProgressView.setProgress(0.0, animated: true)
            self.audioPlayer = try! AVAudioPlayer(contentsOf: fileStringUrl!)
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.delegate = self
            UIView.animate(withDuration: TimeInterval(Durationfile), animations: { () -> Void in
                self.ProgressView.setProgress(1.0, animated: true)
            })
            self.audioPlayer.play()
            
            timer1 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.autoScroll), userInfo: nil, repeats: true)
        }
        else
        {
            x = 1
            AudioPlayCheck = "1"
            
            self.audioPlayer = try! AVAudioPlayer(contentsOf: fileStringUrl!)
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.delegate = self
            UIView.animate(withDuration: TimeInterval(Durationfile), animations: { () -> Void in
                self.ProgressView.setProgress(1.0, animated: true)
            })
            self.audioPlayer.play()
           
            Listtabl.reloadData()
           
            btn_Play.setImage(UIImage(named: "ListPause"), for: .normal)
            timer1 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.autoScroll), userInfo: nil, repeats: true)
            
            
           // perform(#selector(self.showPlayerView), with: nil, afterDelay: 0.1)
        }
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
        self.searchBar.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.searchBar.resignFirstResponder()
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

}

class ListOfItemCell: UITableViewCell {
    @IBOutlet var lbl_FileName: UILabel!
    @IBOutlet var lbl_Purpose: UILabel!
    @IBOutlet var lbl_Quality: UILabel!
    @IBOutlet var img_Download: UIImageView!
    @IBOutlet var img_User: UIImageView!
    @IBOutlet var btn_Play: UIButton!  
}
