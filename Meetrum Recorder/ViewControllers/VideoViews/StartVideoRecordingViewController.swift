//
//  StartVideoRecordingViewController.swift
//  Meetrum Recorder
//
//  Created by think360 on 16/08/18.
//  Copyright © 2018 bharath. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import AVKit

class StartVideoRecordingViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate, AVCaptureFileOutputRecordingDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate{

  
  
    @IBOutlet var SaveButt: UIButton!
    @IBOutlet var logoImg: UIImageView!
    @IBOutlet var TypeRecordLab: UILabel!
   
    @IBOutlet var RecordButt: UIButton!
    @IBOutlet var QualityLab: UILabel!
    @IBOutlet var myView: UIView!
    @IBOutlet var durationTxt: UILabel!
    @IBOutlet var CameraButt: UIButton!
    
    var videourls = [NSURL]()
    
    let captureSession = AVCaptureSession()
    let movieOutput = AVCaptureMovieFileOutput()
    var previewLayer: AVCaptureVideoPreviewLayer!
    var activeInput: AVCaptureDeviceInput!
    
    var outputURL: URL!
    let avPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!
    var url = NSURL()
    var seconds: Int!
    var durationTimer: Timer?
    
    var player = AVPlayer()
    var Selecturl = NSURL()
    
    var timer1 = Timer()
    var y:Int = 0
    var strcheck = String()
    
    var strCheckPosition = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CameraButt.isHidden = true
        SaveButt.isHidden = true
        
       // durationTxt.isHidden = true
        
        if let data = UserDefaults.standard.data(forKey: "Settings"),
            let info = NSKeyedUnarchiver.unarchiveObject(with: data) as? [SettingsModel]
        {
            let strquality: String = (info.last?.videoQuality)!
            let strformat: String = (info.last?.videoFormat)!
            
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
            QualityLab.text = "Quality: High(.mp4/320 Kb/s)"
        }
        
        strcheck = "1"
        
        RecordButt.layer.cornerRadius = RecordButt.bounds.size.width/2
        RecordButt.clipsToBounds = true
        
      
         perform(#selector(self.showPlayerView), with: nil, afterDelay: 1.0)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func showPlayerView() {
        if setupSession() {
            setupPreview()
            startSession()
        }
        
        if strCheckPosition == "1"
        {
            let currentCameraInput: AVCaptureInput = captureSession.inputs[0] as! AVCaptureInput
            captureSession.removeInput(currentCameraInput)
            var newCamera: AVCaptureDevice
            if (currentCameraInput as! AVCaptureDeviceInput).device.position == .back {
                newCamera = self.cameraWithPosition(position: .front)!
            } else {
                newCamera = self.cameraWithPosition(position: .back)!
            }
            do{
                let newVideoInput = try AVCaptureDeviceInput(device: newCamera)//AVCaptureDeviceInput(device: newCamera, error: nil)
                captureSession.removeInput(activeInput)
                captureSession.addInput(newVideoInput)
                activeInput = newVideoInput
            }
            catch {
                print(error)
            }
        }
        
    }
    
    func setupPreview() {
        // Configure previewLayer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        myView.layer.addSublayer(previewLayer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    //MARK:- Setup Camera
    
    func setupSession() -> Bool {
        
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        //captureSession.startse
        // Setup Camera
        // let camera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        let camera = AVCaptureDevice.default(for: .video)
        
        do {
            let input = try AVCaptureDeviceInput(device: camera!)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
                activeInput = input
            }
        } catch {
            print("Error setting device video input: \(error)")
            return false
        }
        
        // Setup Microphone
        // let microphone = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)
        let microphone = AVCaptureDevice.default(for: .audio)
        
        do {
            let micInput = try AVCaptureDeviceInput(device: microphone!)
            if captureSession.canAddInput(micInput) {
                captureSession.addInput(micInput)//addInput(micInput)
            }
        } catch {
            print("Error setting device audio input: \(error)")
            return false
        }
       
        // Movie output
        if captureSession.canAddOutput(movieOutput) {
            captureSession.addOutput(movieOutput)
        }
        
        return true
    }
    
    func setupCaptureMode(_ mode: Int) {
        // Video Mode
        
    }
    
    //MARK:- Camera Session
    func startSession() {
        if !captureSession.isRunning {
            videoQueue().async {
                self.captureSession.startRunning()
                self.startRecording()
            }
        }
    }
    
    func stopSession() {
        if captureSession.isRunning {
            videoQueue().async {
                self.captureSession.stopRunning()
            }
        }
    }
    
    func videoQueue() -> DispatchQueue {
        return DispatchQueue.main
    }
    
    
    
    func currentVideoOrientation() -> AVCaptureVideoOrientation {
        var orientation: AVCaptureVideoOrientation
        
        switch UIDevice.current.orientation {
        case .portrait:
            orientation = AVCaptureVideoOrientation.portrait
        case .landscapeRight:
            orientation = AVCaptureVideoOrientation.landscapeLeft
        case .portraitUpsideDown:
            orientation = AVCaptureVideoOrientation.portraitUpsideDown
        default:
            orientation = AVCaptureVideoOrientation.landscapeRight
        }
        
        return orientation
    }
    
    func startCapture() {
        
        startRecording()
        
    }
    
    //EDIT 1: I FORGOT THIS AT FIRST
    
    func tempURL() -> URL? {
        let directory = NSTemporaryDirectory() as NSString
        
        if directory != "" {
            let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
            return URL(fileURLWithPath: path)
        }
        return nil
    }
    
    
    func startRecording()
    {
        if movieOutput.isRecording == false {
            //playBtn.setTitle("stop", for: .normal)
            strcheck = "1"
             self.captureSession.startRunning()
             RecordButt.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.431372549, blue: 0.8274509804, alpha: 1)
            RecordButt.setImage(UIImage(named: "Play"), for: .normal)
            let connection = movieOutput.connection(with: AVMediaType.video)
            if (connection?.isVideoOrientationSupported)! {
                connection?.videoOrientation = currentVideoOrientation()
            }
            
            if (connection?.isVideoStabilizationSupported)! {
                connection?.preferredVideoStabilizationMode = AVCaptureVideoStabilizationMode.auto
            }
            
            let device = activeInput.device
            if (device.isSmoothAutoFocusSupported) {
                do {
                    try device.lockForConfiguration()
                    device.isSmoothAutoFocusEnabled = false
                    device.unlockForConfiguration()
                } catch {
                    print("Error setting configuration: \(error)")
                }
                
            }
            
            //EDIT2: And I forgot this
            outputURL = tempURL()
            movieOutput.startRecording(to: outputURL, recordingDelegate: self)
            setTimer()
        }
        else {
            
            //            playBtn.setTitle("start", for: .normal)
             RecordButt.setImage(UIImage(named: "Camera"), for: .normal)
             RecordButt.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

            stopRecording()
           // self.setupPreview()
            timer1.invalidate()
        }
        
    }
    
    func setTimer()
    {
        timer1 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timercount), userInfo: nil, repeats: true)
    }
    
    @objc func timercount()
    {
        self.y = self.y + 1
        let hours = self.y / 3600
        let minutes = self.y / 60 % 60
        let seconds = self.y % 60
        
        durationTxt.text =  String(format:"%02i : %02i : %02i", hours, minutes, seconds)
    }
    
    func stopRecording() {
        
        if movieOutput.isRecording == true {
            movieOutput.stopRecording()
        }
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
        
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        if (error != nil) {
            print("Error recording movie: \(error!.localizedDescription)")
            print("\(outputURL)")
            
        } else {
            
            _ = outputURL as URL
            
        }
        outputURL = nil
        let pathString = outputFileURL.relativePath
        
        
        
        url = NSURL.fileURL(withPath: pathString) as NSURL
        print(url)
        
        videourls.append(url)
        
        print("\nAll Video URL's:\n \(videourls)")
        
        if strcheck == "1"
        {
            let playvc = self.storyboard?.instantiateViewController(withIdentifier: "VideoPlayViewController") as? VideoPlayViewController
            playvc?.videourl = self.url
             playvc?.y = self.y
            self.navigationController?.pushViewController(playvc!, animated: true)
        }
        else
        {
            strcheck = "1"
        }
        
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?)
    {
        if (error != nil) {
            print("Error recording movie: \(error!.localizedDescription)")
            print("\(outputURL)")
            
        } else {
            
            _ = outputURL as URL
            
        }
        outputURL = nil
        let pathString = outputFileURL.relativePath
        
        url = NSURL.fileURL(withPath: pathString) as NSURL
        
        videourls.append(url)
        
        if strcheck == "1"
        {
            let playvc = self.storyboard?.instantiateViewController(withIdentifier: "VideoPlayViewController") as? VideoPlayViewController
            playvc?.videourl = self.url
             playvc?.y = self.y
            self.navigationController?.pushViewController(playvc!, animated: true)
        }
        else
        {
            strcheck = "1"
        }
        
        print("\nAll Video URL's:\n \(videourls)")
    }
    
    //MARK: Record Butt Clicked
    @IBAction func playStopAction(_ sender: Any)
    {
        startRecording()
    }
    
    
    @IBAction func stopAction(_ sender: Any)
    {
        if movieOutput.isRecording == true
        {
            stopRecording()
        }
    }
    
  
    
    func changeCameraButtonClick(sender: AnyObject)
    {
        //        playBtn.setTitle("start", for: .normal)
       
        strcheck = "2"
        y = 0
        RecordButt.setImage(UIImage(named: "Camera"), for: .normal)
        RecordButt.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
        stopRecording()
        
        timer1.invalidate()
        
        let currentCameraInput: AVCaptureInput = captureSession.inputs[0] as! AVCaptureInput
        captureSession.removeInput(currentCameraInput)
        var newCamera: AVCaptureDevice
        if (currentCameraInput as! AVCaptureDeviceInput).device.position == .back {
            newCamera = self.cameraWithPosition(position: .front)!
        } else {
            newCamera = self.cameraWithPosition(position: .back)!
        }
        do{
            let newVideoInput = try AVCaptureDeviceInput(device: newCamera)//AVCaptureDeviceInput(device: newCamera, error: nil)
            captureSession.addInput(newVideoInput)
        }
        catch {
            print(error)
        }
    }
    
    
    
    func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice?
    {
        //let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        if #available(iOS 10.0, *) {
            
           // return AVCaptureDevice.default(for: .video)
            return AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position)
            
            //  return AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera,
            //                                       mediaType: AVMediaTypeVideo,
            //                                      position: position)
            
        } else {
            // Fallback on earlier versions
            let devices = AVCaptureDevice.devices(for: AVMediaType.video)
            for device in devices {
                if (device as AnyObject).position == position {
                    return device
                }
            }
        }
        
        return nil
    }
    
    
    @IBAction func cameraToogleAction(_ sender: Any) {
        //        playBtn.setTitle("start", for: .normal)
    
        strcheck = "2"
        y = 0
        RecordButt.setImage(UIImage(named: "Camera"), for: .normal)
        RecordButt.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        stopRecording()
        
        timer1.invalidate()
        
        let hours = self.y / 3600
        let minutes = self.y / 60 % 60
        let seconds = self.y % 60
        
        durationTxt.text =  String(format:"%02i : %02i : %02i", hours, minutes, seconds)
        
        let currentCameraInput: AVCaptureInput = captureSession.inputs[0] as! AVCaptureInput
        captureSession.removeInput(currentCameraInput)
        var newCamera: AVCaptureDevice
        if (currentCameraInput as! AVCaptureDeviceInput).device.position == .back {
            newCamera = self.cameraWithPosition(position: .front)!
        } else {
            newCamera = self.cameraWithPosition(position: .back)!
        }
        do{
            let newVideoInput = try AVCaptureDeviceInput(device: newCamera)//AVCaptureDeviceInput(device: newCamera, error: nil)
            captureSession.removeInput(activeInput)
            captureSession.addInput(newVideoInput)
            activeInput = newVideoInput
        }
        catch {
            print(error)
        }
        
        RecordButt.setImage(UIImage(named: "Camera"), for: .normal)
        RecordButt.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        stopRecording()
        timer1.invalidate()
    }
    
    
    @IBAction func BackButtClicked(_ sender: UIButton)
    {
        let alert = UIAlertController(title: "Meetrum Recorder", message: "Are You Sure Want to Discard the Recording Video.", preferredStyle: UIAlertControllerStyle.alert)
        
        let alertOKAction=UIAlertAction(title:"Discard", style: UIAlertActionStyle.default,handler: { action in
            
            self.navigationController?.popViewController(animated: true)
            
        })
        
        let alertCancelAction=UIAlertAction(title:"Continue", style: UIAlertActionStyle.destructive,handler: { action in
            
        })
        
        alert.addAction(alertOKAction)
        alert.addAction(alertCancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func SaveButtClicked(_ sender: UIButton)
    {
         stopRecording()
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
