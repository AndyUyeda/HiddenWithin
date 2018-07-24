//
//  DataViewController.swift
//  Hidden Within
//
//  Created by Andy Uyeda on 6/26/15.
//  Copyright (c) 2015 Andy Uyeda. All rights reserved.
//

import UIKit
import QuartzCore

class DataViewController: UIViewController {
    //25, 20,15, 10, 1
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var tutorialView: UIView!
    @IBOutlet weak var devoButton: UIButton!
    
    var dataObject: AnyObject?
    var d : Int!
    var pd : Int!
    var references = NSMutableArray()
    var scriptures = NSMutableArray()
    var labels = NSMutableArray()
    var steps = NSMutableArray()
    var repetitions = NSMutableArray()
    var devotion : String!
    var stepperKey : String!
    var contentY : CGFloat!
    var repView : UIImageView!
    var repCountView : UIImageView!
    var devView : UIImageView!
    var swipeView : UIImageView!
    var overview : UITextView!
    var verseView : UIImageView!
    var counterView : UIImageView!
    var tutorialInSession : Bool!
    var tutorialStep = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        stepperKey = "Day" + d.description + "Steppers"
        
        let bounds = UIScreen.mainScreen().bounds
        let width = bounds.size.width
        let height = bounds.size.height
        //print(bounds.width)
        
        var scaleY = height / 600
        let scaleX = width / 600
        
        
        //print("app")
        //print(scaleX)
        //print(scaleY)
        
        scrollView.scrollEnabled = true
        
        
        if let obj: AnyObject = dataObject {
            self.dataLabel!.text = obj.description
        } else {
            self.dataLabel!.text = ""
        }
        blueView.layer.cornerRadius = 10;
        blueView.layer.masksToBounds = true;
        
        var tempButton = UILabel()
        var tempButton2 = UILabel()
        var tempButton3 = UIButton()
        var tempButton4 = UIStepper()
        
        for var i = references.count - 1; i >= 0; --i{
            
            let button = UIButton();
            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            button.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
            let font = UIFont(name: "Futura-CondensedMedium", size: (30 * scaleX))
            button.titleLabel?.font = font
            let text = references.objectAtIndex(i) as! String
            button.setTitle(text, forState: .Normal)
            
            button.tag = i
            button.addTarget(self, action: "takeAPeek:", forControlEvents: UIControlEvents.TouchUpInside)
            let t = text as NSString
            let size: CGSize = t.sizeWithAttributes([NSFontAttributeName: font!])
            let revChanger = references.count - 1 - i
            let fl = (CGFloat)(20 + (50 * revChanger))
            button.frame = CGRectMake(20 ,fl,size.width,size.height)
            if(i == references.count - 1 ){
                tempButton3 = button
            }
            
            let stepper = UIStepper()
            stepper.minimumValue = 0
            stepper.backgroundColor = UIColor.blackColor()
            stepper.layer.cornerRadius = 5
            stepper.layer.masksToBounds = true
            stepper.center = CGPointMake(((self.scrollView.bounds.width * scaleX) * 0.95) - (stepper.bounds.width / 2) , button.center.y)
            stepper.addTarget(self, action: "stepperValueChanged:", forControlEvents: .ValueChanged)
            stepper.tag = revChanger;
            steps.addObject(stepper)
            if(i == references.count - 1 ){
                tempButton4 = stepper
            }
            
            let label = UILabel(frame: CGRectMake(stepper.center.x,stepper.center.y, stepper.bounds.width * 0.4 * scaleX, stepper.bounds.height * 1.1))
            label.backgroundColor = UIColor.whiteColor()
            label.center = CGPointMake(stepper.center.x - stepper.bounds.width,stepper.center.y)
            label.layer.cornerRadius = 10
            label.layer.masksToBounds = true
            label.font = UIFont(name: "Futura-CondensedMedium", size: (20 * scaleX))
            label.textAlignment = .Center;
            let val = Int(stepper.value)
            label.text = val.description
            labels.addObject(label);
            if(i == 0){
                contentY = stepper.center.y + 30
            }
            if(i == references.count - 1 ){
                tempButton2 = label
            }
            
            var reps = 1
            if(revChanger == 0){
                //print(d%4)
                switch d%4 {
                case 0:
                    reps = 10
                    break
                case 1:
                    reps = 25
                    break
                case 2:
                    reps = 20
                    break
                case 3:
                    reps = 15
                    break
                default:
                    reps = 1
                    break
                
                }
            }
            //print(reps)
            repetitions.addObject(reps)
            let label2 = UILabel(frame: CGRectMake(stepper.center.x,stepper.center.y, 50, stepper.bounds.height * 1.1))
            label2.center = CGPointMake(55 + button.bounds.width,stepper.center.y)
            label2.font = UIFont(name: "Futura-CondensedMedium", size: (15 * scaleX))
            label2.text = "x " + reps.description
            label2.textColor = UIColor.blackColor()
            //labels.addObject(label);
            if(i == references.count - 1 ){
                tempButton = label2
            }
            print(button.titleLabel!.text, terminator: "")
            self.scrollView.addSubview(stepper)
            self.scrollView.addSubview(button)
            self.scrollView.addSubview(label)
            self.scrollView.addSubview(label2)
            
            
        }
        
        let image : UIImage = UIImage(named:"devo.png")!
        devView = UIImageView(image: image)
        devView.frame = CGRectMake(devoButton.center.x + 17, 0, 257, 67)
        self.tutorialView.addSubview(devView)
        
        let image2 : UIImage = UIImage(named:"reps.png")!
        repView = UIImageView(image: image2)
        repView.frame = CGRectMake(tempButton.center.x - 130, tempButton.center.y + 60, 150, 150)
        self.tutorialView.addSubview(repView)
        
        let image3 : UIImage = UIImage(named:"Untitled.png")!
        repCountView = UIImageView(image: image3)
        repCountView.frame = CGRectMake(tempButton2.center.x + 50, tempButton2.center.y + 60, 150, 150)
        self.tutorialView.addSubview(repCountView)
        
        let image4 : UIImage = UIImage(named:"verse.png")!
        verseView = UIImageView(image: image4)
        verseView.frame = CGRectMake(tempButton3.center.x + 60, tempButton2.center.y + 50, 150, 300)
        self.tutorialView.addSubview(verseView)
        
        let image5 : UIImage = UIImage(named:"counter.png")!
        counterView = UIImageView(image: image5)
        counterView.frame = CGRectMake(tempButton4.center.x - 30, tempButton2.center.y + 60, 150, 300)
        self.tutorialView.addSubview(counterView)
        
        let image6 : UIImage = UIImage(named:"swipe.png")!
        swipeView = UIImageView(image: image6)
        swipeView.frame = CGRectMake(tempButton.center.x - 80, tempButton2.center.y + 90, 300, 150)
        self.tutorialView.addSubview(swipeView)
        
        
        overview = UITextView(frame: CGRectMake(15, 30, width - 30, tutorialView.frame.height))
        overview.text = "Overview:  Each day read the devotional and repeat the memory verse for as many times as indicated (eventually you will do it without looking).  A new verse will appear every 5th day while you retain the older verses."
        overview.textAlignment = .Center
        overview.font = UIFont(name: "Futura", size: 24)
        overview.textColor = UIColor.whiteColor()
        overview.editable = false
        overview.selectable = false
        overview.userInteractionEnabled = false
        overview.backgroundColor = UIColor.clearColor()
        self.tutorialView.addSubview(overview)
        
        overview.hidden = true
        devView.hidden = true
        repView.hidden = true
        repCountView.hidden = true
        verseView.hidden = true
        counterView.hidden = true
        swipeView.hidden = true
    
        scrollView.contentSize = CGSizeMake(100, contentY)
        
        
        
        let firstLaunch = NSUserDefaults.standardUserDefaults().boolForKey("FirstLaunch")
        if firstLaunch  {
            print("Not first launch.", terminator: "")
            tutorialInSession = false
        }
        else {
            print("First launch, setting NSUserDefault.", terminator: "")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "FirstLaunch")
            
            scrollView.contentOffset = CGPoint(x: 0, y: 0)
            tutorialView.hidden = false
            tutorialInSession = true
            overview.hidden = false
            devView.hidden = true
            repView.hidden = true
            repCountView.hidden = true
            verseView.hidden = true
            counterView.hidden = true
            
            ++tutorialStep
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       
        if(d > 40){
            devoButton.hidden = true
        }
        if let ss = NSUserDefaults.standardUserDefaults().objectForKey(stepperKey) as? NSMutableArray{
            let tt = NSUserDefaults.standardUserDefaults().objectForKey(stepperKey) as! NSMutableArray
            for var i = 0; i < steps.count; ++i{
                let s = steps.objectAtIndex(i) as! UIStepper
                s.value = tt.objectAtIndex(i) as! Double
            }
            for var i = 0; i < labels.count; ++i{
                let l = labels.objectAtIndex(i) as! UILabel
                let j = Int(tt.objectAtIndex(i) as! Double)
                l.text = j.description
            
                
                let rr = repetitions.objectAtIndex(i) as! Int
                if(j >= rr){
                    l.textColor = UIColor.greenColor()
                }
            }
        
        }
        
        
        if let previousDay = NSUserDefaults.standardUserDefaults().objectForKey("Day") as? Int{
            let previousD = NSUserDefaults.standardUserDefaults().objectForKey("Day") as! Int
            pd = previousD
        }
        else{
            pd = 0
        }
        //print(pd)
        
    }
    func takeAPeek(sender:UIButton!){
        let r = references.objectAtIndex(sender.tag) as! String
        let s = scriptures.objectAtIndex(sender.tag) as! String
        //print(s)
        
        
        let alertView = UIAlertView()
        alertView.delegate = self
        alertView.addButtonWithTitle("Thanks")
        alertView.addButtonWithTitle("Said It")
        alertView.title = r
        alertView.message = s
        alertView.tag = sender.tag
        alertView.show()
        
    
    }
    
    func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
        
        switch buttonIndex{
            
        case 0:
            NSLog("Dismiss")
            break;
        case 1:
            let xx = steps.count - 1 - View.tag
            print(xx, terminator: "")
            let st = steps.objectAtIndex(xx) as! UIStepper
            ++st.value
            
            let l = labels.objectAtIndex(xx) as! UILabel
            let i = Int(st.value)
            l.text = i.description
            
            let rr = repetitions.objectAtIndex(xx) as! Int
            if(i >= rr){
                l.textColor = UIColor.greenColor()
            }
            
            let times = NSMutableArray()
            for var i = 0; i < steps.count; ++i{
                let s = steps.objectAtIndex(i) as! UIStepper
                times.addObject(s.value)
            }
            
            var check = true
            for var i = 0; i < steps.count; ++i{
                let s = steps.objectAtIndex(i) as! UIStepper
                let r = repetitions.objectAtIndex(i) as! Double
                if(s.value < r){
                    check = false
                }
            }
            if check{
                print("Complete", terminator: "")
                if(d > pd){
                    pd = d
                }
                
            }
            
            NSUserDefaults.standardUserDefaults().setObject(pd, forKey: "Day")
            NSUserDefaults.standardUserDefaults().setObject(times, forKey: stepperKey)
            NSUserDefaults.standardUserDefaults().synchronize()
            break;
        default:
            NSLog("Dismiss")
            break;
            //Some code here..
            
        }
    }
    
    func stepperValueChanged(sender:UIStepper!)
    {
        //print(sender.tag)
        let l = labels.objectAtIndex(sender.tag) as! UILabel
        let i = Int(sender.value)
        l.text = i.description
        //Change to Green
        let rr = repetitions.objectAtIndex(sender.tag) as! Int
        if(i >= rr){
            l.textColor = UIColor.greenColor()
        }
        else{
            l.textColor = UIColor.blackColor()
        }
        //Saving the Steppers
        let times = NSMutableArray()
        for var i = 0; i < steps.count; ++i{
            let s = steps.objectAtIndex(i) as! UIStepper
            times.addObject(s.value)
        }
        
        var check = true
        for var i = 0; i < steps.count; ++i{
            let s = steps.objectAtIndex(i) as! UIStepper
            let r = repetitions.objectAtIndex(i) as! Double
            if(s.value < r){
                check = false
            }
        }
        if check{
            print("Complete", terminator: "")
            if(d > pd){
                pd = d
            }
        }
        print(pd, terminator: "")
        
        NSUserDefaults.standardUserDefaults().setObject(pd, forKey: "Day")
        NSUserDefaults.standardUserDefaults().setObject(times, forKey: stepperKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func setDay(amount : Int){
        //print(amount)
        d = amount
    }
    func setDevo(de : String){
        devotion = de
    }
    func setRefs(rs : NSMutableArray, ss : NSMutableArray){
        references = rs
        scriptures = ss
        //print(references)
        //print(scriptures)
    }
    
    @IBAction func devotionSelected(sender: AnyObject) {
        
        self.performSegueWithIdentifier("devo", sender: self);
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if(segue.identifier == "devo"){
            let dvc = segue.destinationViewController as! DevotionalController
            dvc.devotion = self.devotion
            dvc.day = self.d
            
        }
    }
    
    @IBAction func help(sender: AnyObject) {
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        tutorialView.hidden = false
        tutorialInSession = true
        overview.hidden = false
        devView.hidden = true
        repView.hidden = true
        repCountView.hidden = true
        verseView.hidden = true
        counterView.hidden = true
        swipeView.hidden = true
        
        //self.view.userInteractionEnabled = false
        ++tutorialStep
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("HEEEEEEYYY", terminator: "")
        if(tutorialInSession!){
            if(tutorialStep == 2){
                overview.hidden = true
                devView.hidden = true
                repView.hidden = true
                repCountView.hidden = true
                devView.hidden = false
                counterView.hidden = true
                swipeView.hidden = true
                ++tutorialStep
            }
            else if(tutorialStep == 3){
                devView.hidden = true
                repView.hidden = true
                repCountView.hidden = true
                overview.hidden = true
                verseView.hidden = false
                counterView.hidden = true
                swipeView.hidden = true
                ++tutorialStep
            }
            else if(tutorialStep == 4){
                devView.hidden = true
                overview.hidden = true
                repView.hidden = false
                repCountView.hidden = true
                verseView.hidden = true
                counterView.hidden = true
                swipeView.hidden = true
                ++tutorialStep
            }
            else if(tutorialStep == 5){
                devView.hidden = true
                overview.hidden = true
                repView.hidden = true
                repCountView.hidden = false
                verseView.hidden = true
                counterView.hidden = true
                swipeView.hidden = true
                ++tutorialStep
            }
            else if(tutorialStep == 6){
                devView.hidden = true
                overview.hidden = true
                repView.hidden = true
                repCountView.hidden = true
                verseView.hidden = true
                counterView.hidden = false
                swipeView.hidden = true
                ++tutorialStep
            }
            else if(tutorialStep == 7){
                devView.hidden = true
                overview.hidden = true
                repView.hidden = true
                repCountView.hidden = true
                verseView.hidden = true
                counterView.hidden = true
                swipeView.hidden = false
                ++tutorialStep
            }
            else{
                tutorialInSession = false
                tutorialView.hidden = true
                overview.hidden = true
                tutorialStep = 1
                
                devView.hidden = true
                repView.hidden = true
                repCountView.hidden = true
                verseView.hidden = true
                counterView.hidden = true
            }
        
        }
    }
    
}

