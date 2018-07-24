//
//  ModelController.swift
//  Hidden Within
//
//  Created by Andy Uyeda on 6/26/15.
//  Copyright (c) 2015 Andy Uyeda. All rights reserved.
//

import UIKit

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */


class ModelController: NSObject, UIPageViewControllerDataSource {

    var pageData = NSMutableArray()
    var numberDays = NSMutableArray()
    var referenceArray = NSMutableArray()
    var scriptureArray = NSMutableArray()
    var devotionalArray = NSMutableArray()

    override init() {
        super.init()
        // Create the data model.
        let dateFormatter = NSDateFormatter()
        for i in 1...80{
            numberDays.addObject(i)
            pageData.addObject("Day " + String(i))
        }
        
        let rtf = NSBundle.mainBundle().URLForResource("Ref", withExtension: "rtf", subdirectory: nil, localization: nil)
        
        let attributedString = try? NSAttributedString(fileURL: rtf!, options: [NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType], documentAttributes: nil)
        var done = false
        let searcher = MEStringSearcher(fromString: attributedString!.string)
        while(!done){
            var r = searcher.getStringWithLeftBounds("*", rght: "*\n")
            //print(r)
            if(r?.length < 1){
                done = true
            }
            else{
                referenceArray.addObject(r!)
            }
        }
        
        
        
        let rtf2 = NSBundle.mainBundle().URLForResource("Scrip", withExtension: "rtf", subdirectory: nil, localization: nil)
        
        let attributedString2 = try? NSAttributedString(fileURL: rtf2!, options: [NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType], documentAttributes: nil)
        var done2 = false
        let searcher2 = MEStringSearcher(fromString: attributedString2!.string)
        while(!done2){
            var r = searcher2.getStringWithLeftBounds("*", rght: "*\n")
            //print(r)
            if(r?.length < 1){
                done2 = true
            }
            else{
                scriptureArray.addObject(r!)
            }
        }

        
        let rtf3 = NSBundle.mainBundle().URLForResource("Devo", withExtension: "rtf", subdirectory: nil, localization: nil)
        
        let attributedString3 = try? NSAttributedString(fileURL: rtf3!, options: [NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType], documentAttributes: nil)
        var done3 = false
        let searcher3 = MEStringSearcher(fromString: attributedString3!.string)
        while(!done3){
            var r = searcher3.getStringWithLeftBounds("**", rght: "*\n")
            //print(r)
            if(r?.length < 1){
                done3 = true
            }
            else{
                devotionalArray.addObject(r!)
            }
        }

        //print(devotionalArray)
        
    
    }

    func viewControllerAtIndex(index: Int, storyboard: UIStoryboard) -> DataViewController? {
        // Return the data view controller for the given index.
        if (self.pageData.count == 0) || (index >= self.pageData.count) {
            return nil
        }

        // Create a new view controller and pass suitable data.
        let dataViewController = storyboard.instantiateViewControllerWithIdentifier("DataViewController") as! DataViewController
        dataViewController.dataObject = self.pageData[index]
        let nt = numberDays.objectAtIndex(index) as! Int
        dataViewController.setDay(nt)
        //print(nt / 5)
        let partRef = NSMutableArray()
        let partScr = NSMutableArray()
        for var i = 0; i <= ((nt - 1) / 4); ++i{
            partRef.addObject(referenceArray.objectAtIndex(i))
            partScr.addObject(scriptureArray.objectAtIndex(i))
        }
        //print(nt)
        //print(devotionalArray.count)
        if(devotionalArray.count >= nt){
            
            dataViewController.setDevo(devotionalArray.objectAtIndex(nt - 1) as! String)
        }
        dataViewController.setRefs(partRef, ss: partScr)
        return dataViewController
    }

    func indexOfViewController(viewController: DataViewController) -> Int {
        // Return the index of the given data view controller.
        // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
        if let dataObject: AnyObject = viewController.dataObject {
            return self.pageData.indexOfObject(dataObject)
        } else {
            return NSNotFound
        }
    }

    // MARK: - Page View Controller Data Source

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        for recognizer in pageViewController.gestureRecognizers{
            if recognizer.isKindOfClass(UITapGestureRecognizer){
                let rr = recognizer 
                rr.enabled = false
                //print("DOOOOO")
            }
        }

        
        var index = self.indexOfViewController(viewController as! DataViewController)
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index--
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        for recognizer in pageViewController.gestureRecognizers{
            if recognizer.isKindOfClass(UITapGestureRecognizer){
                let rr = recognizer 
                rr.enabled = false
                //print("DOOOOO")
            }
        }

        
        var index = self.indexOfViewController(viewController as! DataViewController)
        if index == NSNotFound {
            return nil
        }
        
        index++
        if index == self.pageData.count {
            return nil
        }
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }

}

