//
//  DevotionalController.swift
//  Hidden Within
//
//  Created by Andy Uyeda on 6/29/15.
//  Copyright (c) 2015 Andy Uyeda. All rights reserved.
//

import Foundation
import UIKit

class DevotionalController: UIViewController {

    @IBOutlet weak var devoTitle: UILabel!
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var textView: UITextView!
    var devotion : String!
    var day : Int!
    
    override func viewDidLoad() {
        var titles : [String] = ["Heart", "Gospel", "Holy Spirit", "Word", "Love", "Witness", "Compassion", "Church", "Future", "Hope [Glory]"]
        print(day, terminator: "")
        var num = (day % 4)
        if(num == 0){
            num = 4
        }
        let tt = titles[(day - 1)/4] + " (Day " + day.description + ")"
        devoTitle.text = tt
        whiteView.layer.cornerRadius = 5
        bottomView.layer.cornerRadius = 5
        //self.textView.scrollRangeToVisible(NSMakeRange(0, 1))
    }
    override func viewDidAppear(animated: Bool) {
        print("HEEY")
        
        textView.text = devotion
        self.textView.scrollRangeToVisible(NSMakeRange(0, 1))
    }
    
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}