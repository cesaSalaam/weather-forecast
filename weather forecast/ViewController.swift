//
//  ViewController.swift
//  weather forecast
//
//  Created by Lifoma Salaam on 1/31/16.
//  Copyright © 2016 Lifoma Salaam. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var cityTextField: UITextField!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet var resultLabel: UILabel!
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        cityTextField.resignFirstResponder()
        return true
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func findWeatherButton(sender: AnyObject) {
        let attemptedUrl = NSURL(string: "http://www.weather-forecast.com/locations/" + cityTextField.text!.stringByReplacingOccurrencesOfString(" ", withString: "-") + "/forecasts/latest")
        var wasSuccessful = false
        if let url = attemptedUrl{
            
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            
            if let urlContent = data{
                
                let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                
                let websiteArray = webContent?.componentsSeparatedByString("3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")
                
                if websiteArray!.count > 1{
                    wasSuccessful = true
                    let weatherArray = websiteArray![1].componentsSeparatedByString("</span>")
                    if weatherArray.count > 1{
                        
                        let weatherSummary = weatherArray[0].stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.resultLabel.text = weatherSummary
                        })
                    }
                }
            }
            print(wasSuccessful)
            if wasSuccessful == false{
                print("in first if")
                self.resultLabel.text = "Error - Couldnt find the weather for that city. Please try again"
            }
            
        }
            
        task.resume()
            
        }else{
            
            self.resultLabel.text = "Error - Couldnt find the weather for that city. Please try again"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cityTextField.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}