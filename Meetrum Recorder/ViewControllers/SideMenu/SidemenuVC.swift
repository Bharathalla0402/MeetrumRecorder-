//
//  SidemenuVC.swift
//  RadioApp
//
//  Created by think360 on 28/05/18.
//  Copyright © 2018 Chandra. All rights reserved.
//

import UIKit

class SidemenuVC: UIViewController {

    @IBOutlet var imageviewObj: UIImageView!
    @IBOutlet var UserNameLab: UILabel!
    @IBOutlet var UserNameLab2: UILabel!
    @IBOutlet var SongPlayButt: UIButton!
    
    let kConstantObj = kConstant()
    
    override func viewDidLoad() {
        
//       NotificationCenter.default.addObserver(self, selector: #selector(self.Notificationmethod), name: NSNotification.Name(rawValue: "Notification"), object: nil)
        
        
        super.viewDidLoad()
        imageviewObj.layer.cornerRadius = 35
        imageviewObj.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func RadioAction(_ sender: UIButton) {
    }
    
    @IBAction func SettingsAction(_ sender: UIButton) {
      //  let myVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController
      //  self.navigationController?.pushViewController(myVC!, animated: true)
        
        let mainVcIntial = self.kConstantObj.SetIntialMainViewController("SettingsViewController")
        self.navigationController?.pushViewController(mainVcIntial, animated: true)
        
    //self.revealViewController().revealToggle(animated: true)
        
    }
    
    
    @IBAction func SideMenuButtClicked(_ sender: UIButton)
    {
        let mainVcIntial = self.kConstantObj.SetIntialMainViewController("ViewController")
        self.navigationController?.pushViewController(mainVcIntial, animated: true)
        
        //self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func AudiorecorderButtClicked(_ sender: UIButton)
    {
        let mainVcIntial = self.kConstantObj.SetIntialMainViewController("ViewController")
        self.navigationController?.pushViewController(mainVcIntial, animated: true)
    }
    
    @IBAction func videorecorderButtClicked(_ sender: UIButton)
    {
        UserDefaults.standard.set("yes", forKey: "Route")
        let mainVcIntial = self.kConstantObj.SetIntialMainViewController("VideoRecordingViewController")
        self.navigationController?.pushViewController(mainVcIntial, animated: true)
    }
    
    @IBAction func helpAction(_ sender: UIButton)
    {
        
    }
    
    @IBAction func RadioPlayerClicked(_ sender: UIButton)
    {
        let mainVcIntial = self.kConstantObj.SetIntialMainViewController("ListOfFileVC")
        self.navigationController?.pushViewController(mainVcIntial, animated: true)
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
