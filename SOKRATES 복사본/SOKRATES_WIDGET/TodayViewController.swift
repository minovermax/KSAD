//
//  TodayViewController.swift
//  SOKRATES_WIDGET
//
//  Created by 이성민 on 10/18/19.
//  Copyright © 2019 KSAD. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    // DO NOT TOUCH
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    } // NEVER TOUCH
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        widgetQuoteLabel.preferredMaxLayoutWidth = widgetQuoteLabel.frame.size.width
        self.view.layoutIfNeeded()
    }
    
    
    // connecting labels
    @IBOutlet weak var widgetQuoteLabel: UILabel!
    @IBOutlet weak var widgetAuthorLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        
        // adding animations
        self.widgetQuoteLabel.fadeTransition(0.2)
        self.widgetAuthorLabel.fadeTransition(0.2)
        
        if let quote = UserDefaults(suiteName: "group.com.ksad.sokrates")?.value(forKey: "quote") {
            widgetQuoteLabel.text = quote as? String
        }
        
        if let author = UserDefaults(suiteName: "group.com.ksad.sokrates")?.value(forKey: "author") {
            widgetAuthorLabel.text = author as? String
        }
        
    }
    
}

// DO NOT TOUCH - extension for animations when text is changing
extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}  // NEVER TOUCH
