//
//  PlayerVC.swift
//  Meetrum Recorder
//
//  Created by think360 on 20/08/18.
//  Copyright © 2018 bharath. All rights reserved.
//

import UIKit
import MSCircularSlider
import AVFoundation
import MobileCoreServices
import AVKit
import MediaPlayer

class PlayerVC: UIViewController ,MSCircularSliderDelegate{

    @IBOutlet var BackButt: UIButton!
    @IBOutlet var view_Slider: UIView!
    @IBOutlet var img_PlayerView: UIImageView!
    @IBOutlet var slider: MSCircularSlider!
    var animationTimer: Timer?
    var animationReversed = false
    var urlFile : URL?
    
    var player = AVPlayer()
    var videourl = NSURL()
    var videourls = [NSURL]()
    var PlayCheck = String()
    
    @IBOutlet var PlayerView: UIView!
    var strAutocheck = String()
    
    @IBOutlet var TimeDecreaseLab: UILabel!
    @IBOutlet var TimeIncreaseLab: UILabel!
    @IBOutlet var txtRecordDate: UILabel!
    @IBOutlet var txtRecordType: UILabel!
    
   
    @IBOutlet var PreviousButt: UIButton!
    @IBOutlet var NextButt: UIButton!
    @IBOutlet var PauseButt: UIButton!
    @IBOutlet var VolumeDecrease: UIButton!
    @IBOutlet var VolumeIncrease: UIButton!
    @IBOutlet var progressbar: UIProgressView!
    var strPlayCheck = String()
    
    var ChVolume = Float()
    var strRecordDate = String()
    var strRecordType = String()
    
    var y = Int()
    var x = Int()
    var z = Int()
    var timer1 = Timer()
    var timer2 = Timer()
    
     let kConstantObj = kConstant()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.implementSlider()
        
        timer1 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.autoScroll), userInfo: nil, repeats: true)
        timer2 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timercount), userInfo: nil, repeats: true)
        
        txtRecordDate.text = strRecordDate
        
        x = 1
        z = y
        
        PlayerView.layer.cornerRadius = PlayerView.bounds.size.width/2
        perform(#selector(self.showPlayerView), with: nil, afterDelay: 1.0)
        PlayerView.layer.borderWidth = 5
        PlayerView.layer.borderColor = #colorLiteral(red: 0.3764705882, green: 0.431372549, blue: 0.8274509804, alpha: 1)
        // Do any additional setup after loading the view.
        
        strPlayCheck = "1"
        
        progressbar?.progress = 0.4
        ChVolume = 0.4
        
        (MPVolumeView().subviews.filter{NSStringFromClass($0.classForCoder) == "MPVolumeSlider"}.first as? UISlider)?.setValue(self.ChVolume, animated: false)
        
        print(videourl)
    } 
    
    @objc func showPlayerView() {
        let playerItem = AVPlayerItem(url: videourl as URL)
        self.player = AVPlayer(playerItem: playerItem)
        let playerLayer = AVPlayerLayer(player: self.player)
        playerLayer.frame=CGRect(x: 0, y: 0, width: self.PlayerView.bounds.size.width, height: self.PlayerView.bounds.size.height)
        self.PlayerView.layer.addSublayer(playerLayer)
        self.player.play()
    }
    
    @objc func timercount()
    {
       if x == z
       {
         let minutes = self.x / 60 % 60
         let seconds = self.x % 60
        
         TimeIncreaseLab.text =  String(format:"%02i:%02i", minutes, seconds)
        
         timer1.invalidate()
         timer2.invalidate()
        
         PauseButt.setImage(UIImage(named: "ListPlay"), for: .normal)
        
        strPlayCheck = "3"
       }
        else
       {
        let minutes = self.x / 60 % 60
        let seconds = self.x % 60
        
        TimeIncreaseLab.text =  String(format:"%02i:%02i", minutes, seconds)
        self.x = self.x + 1
        }
    }
    
    
    @objc func autoScroll()
    {
        if y == 0
        {
            let minutes = self.y / 60 % 60
            let seconds = self.y % 60
            
            TimeDecreaseLab.text =  String(format:"%02i:%02i", minutes, seconds)
            
            timer1.invalidate()
            timer2.invalidate()
            
            PauseButt.setImage(UIImage(named: "ListPlay"), for: .normal)
            
            strPlayCheck = "3"
        }
        else
        {
            self.y = self.y - 1
            let minutes = self.y / 60 % 60
            let seconds = self.y % 60
            
            TimeDecreaseLab.text =  String(format:"%02i:%02i", minutes, seconds)
        }
    }
    
    
    //MARK: Record Butt Clicked
    @IBAction func playStopAction(_ sender: Any)
    {
        if  PlayCheck == "1"
        {
            self.player.pause()
          //  RecordButt.setImage(UIImage(named: "PlayAgain"), for: .normal)
            PlayCheck = "2"
        }
        else
        {
            self.player.play()
          //  RecordButt.setImage(UIImage(named: "Pause"), for: .normal)
            PlayCheck = "1"
        }
    }
    
    @IBAction func PlayAgain(_ sender: UIButton)
    {
        let playerItem = AVPlayerItem(url: videourl as URL)
        self.player = AVPlayer(playerItem: playerItem)
        let playerLayer = AVPlayerLayer(player: self.player)
        playerLayer.frame=CGRect(x: 0, y: 0, width: self.PlayerView.bounds.size.width, height: self.PlayerView.bounds.size.height)
        self.PlayerView.layer.addSublayer(playerLayer)
        self.player.play()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Implement Slider
    
    func implementSlider(){
        view_Slider.layer.cornerRadius = view_Slider.frame.size.height/2 + 20
        view_Slider.clipsToBounds = true
        img_PlayerView.layer.cornerRadius = img_PlayerView.frame.size.height/2 + 20
        img_PlayerView.clipsToBounds = true
        self.slider.handleRotatable = true
//        self.slider.maximumValue = 1.0
//        self.slider.minimumValue = 0.0
        animateSlider()
    }

    // Delegate Methods
    func circularSlider(_ slider: MSCircularSlider, valueChangedTo value: Double, fromUser: Bool) {
     //   self.slider.currentValue = 1.0
       // valueLbl.text = String(format: "%.1f", value)
    }
    
    func circularSlider(_ slider: MSCircularSlider, startedTrackingWith value: Double) {
        // optional delegate method
    }
    
    func circularSlider(_ slider: MSCircularSlider, endedTrackingWith value: Double) {
        // optional delegate method
    }
    
    
    
    func animateSlider() {
        animationTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateSliderValue), userInfo: nil, repeats: true)
    }
    @objc func updateSliderValue() {
        slider.currentValue += animationReversed ? -1.0 : 1.0
        
        if slider.currentValue >= slider.maximumValue {
            animationTimer?.invalidate()
            // Reverse animation
            animationReversed = true
            animationTimer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(updateSliderValue), userInfo: nil, repeats: true)
        }
        else if slider.currentValue <= slider.minimumValue && animationReversed {
            // Animation ended
            animationTimer?.invalidate()
        }
    }
    
    @IBAction func SettingsButtClicked(_ sender: Any) {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    
     //MARK:- BackButt Clicked
    @IBAction func BackButtClicked(_ sender: UIButton)
    {
        if strAutocheck == "1"
        {
            let mainVcIntial = self.kConstantObj.SetIntialMainViewController("ViewController")
            self.navigationController?.pushViewController(mainVcIntial, animated: true)
            
           // self.navigationController?.popToRootViewController(animated: true)
        }
        else
        {
           self.navigationController?.popViewController(animated: true)
        }
    }
    
     //MARK:- Previous Butt Clicked
    @IBAction func PreviousButtClicked(_ sender: UIButton)
    {
        
    }
    
      //MARK:- Forward Butt Clicked
    @IBAction func ForwardButtClicked(_ sender: UIButton)
    {
       
    }
    
    //MARK:- PlayPause Butt Clicked
    @IBAction func PlayPauseButtClicked(_ sender: UIButton)
    {
        if strPlayCheck == "1"
        {
            strPlayCheck = "2"
            self.player.pause()
            
            timer1.invalidate()
            timer2.invalidate()
            
            PauseButt.setImage(UIImage(named: "ListPlay"), for: .normal)
        }
        else if strPlayCheck == "2"
        {
            strPlayCheck = "1"
            self.player.play()
            
            timer1 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.autoScroll), userInfo: nil, repeats: true)
            timer2 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timercount), userInfo: nil, repeats: true)
            
            PauseButt.setImage(UIImage(named: "ListPause"), for: .normal)
        }
        else
        {
             strPlayCheck = "1"
             y = z
             x = 1
            
            timer1 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.autoScroll), userInfo: nil, repeats: true)
            timer2 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timercount), userInfo: nil, repeats: true)
            
            PauseButt.setImage(UIImage(named: "ListPause"), for: .normal)
            
            perform(#selector(self.showPlayerView), with: nil, afterDelay: 0.1)
        }
    }
    
    //MARK:- VolumeDecrease Butt Clicked
    @IBAction func VolumeDecreaseButtClicked(_ sender: UIButton)
    {
        if progressbar?.progress == 0.0
        {
            (MPVolumeView().subviews.filter{NSStringFromClass($0.classForCoder) == "MPVolumeSlider"}.first as? UISlider)?.setValue(0, animated: false)
        }
        else
        {
            progressbar?.progress -= 0.1
            if progressbar?.progress == 0.0 {
              
                
                (MPVolumeView().subviews.filter{NSStringFromClass($0.classForCoder) == "MPVolumeSlider"}.first as? UISlider)?.setValue(0, animated: false)
                
            }
            else
            {
                
                ChVolume = ChVolume - 0.1
                //player.volume = ChVolume
                (MPVolumeView().subviews.filter{NSStringFromClass($0.classForCoder) == "MPVolumeSlider"}.first as? UISlider)?.setValue(ChVolume, animated: false)
            }
        }
    }
    
    //MARK:- VolumeIncrease Butt Clicked
    @IBAction func VolumeIncreaseButtClicked(_ sender: UIButton)
    {
        if progressbar?.progress == Float(1.0)
        {
            (MPVolumeView().subviews.filter{NSStringFromClass($0.classForCoder) == "MPVolumeSlider"}.first as? UISlider)?.setValue(1, animated: false)
        }
        else
        {
            progressbar?.progress += 0.1
            if progressbar?.progress == 0.1 {
                //reducebtn_outlet.setImage(UIImage(named: "path"), for: UIControlState.normal)
                
                ChVolume = ChVolume + 0.1
                (MPVolumeView().subviews.filter{NSStringFromClass($0.classForCoder) == "MPVolumeSlider"}.first as? UISlider)?.setValue(ChVolume, animated: false)
                
            }
            else if progressbar?.progress == 1.0
            {
                (MPVolumeView().subviews.filter{NSStringFromClass($0.classForCoder) == "MPVolumeSlider"}.first as? UISlider)?.setValue(1, animated: false)
            }
            else
            {
                ChVolume = ChVolume + 0.1
                (MPVolumeView().subviews.filter{NSStringFromClass($0.classForCoder) == "MPVolumeSlider"}.first as? UISlider)?.setValue(ChVolume, animated: false)
            }
        }
    }
    
    
    
    
    
    
    
    
    
}
