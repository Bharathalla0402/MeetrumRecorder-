//
//  AlertClassVC.swift
//  Meetrum Recorder
//
//  Created by think360 on 21/08/18.
//  Copyright © 2018 bharath. All rights reserved.
//

import UIKit

class AlertClassVC: NSObject {
    
    static let sharedInstance = AlertClassVC()
    typealias CompletionHandler = (_ success:Int) -> Void
    
    func callAlertPopup(view:UIViewController,title1:String ,title2:String,title3:String,title4:String,title5:String,completionHandler: @escaping CompletionHandler){
    
    let alert = UIAlertController(title: "Meetrum Recorder", message: "Please Select Format.", preferredStyle: UIAlertControllerStyle.alert)
    
    if title1 != ""{
    let action1 = UIAlertAction(title: title1, style: UIAlertActionStyle.default,handler: { action in
         completionHandler(101)
    })
      
       alert.addAction(action1)
    }
    if title2 != ""{
    let action2 = UIAlertAction(title: title2, style: UIAlertActionStyle.default,handler: { action in
     completionHandler(102)
    })
    
    alert.addAction(action2)
    }
    
    if title3 != ""{
    let action3 = UIAlertAction(title: title3, style: UIAlertActionStyle.default,handler: { action in
       completionHandler(103)
    })
    
    alert.addAction(action3)
    }
    
    if title4 != ""{
    let action4 = UIAlertAction(title: title4, style: UIAlertActionStyle.default,handler: { action in
         completionHandler(104)
    })
    alert.addAction(action4)
    }
        
    if title5 != ""{
    let action5 = UIAlertAction(title: title5, style: UIAlertActionStyle.default,handler: { action in
         completionHandler(105)
    })
    alert.addAction(action5)
    } 
    view.present(alert, animated: true, completion: nil)
    }

}
