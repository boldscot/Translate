//
//  ViewController.swift
//  Translate
//
//  Created by Robert O'Connor on 16/10/2015.
//  Edited by Stephen Collins on 3/11/2016
//  Copyright © 2015 WIT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var textToTranslate: UITextView!
    @IBOutlet weak var translatedText: UITextView!
    @IBOutlet weak var languagePicker: UIPickerView!
    
    let languagePickerData = ["English", "French", "Turkish", "Gaelic"]
    var languages: String = ""
    var source: String = "en"
    var dest: String = "en"
    
    //var data = NSMutableData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set view controller as delegate
        textToTranslate.delegate = self
        languagePicker.delegate = self
        languagePicker.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // This function resigns the first responder when the return key is pressed on the software keyboard
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textToTranslate.resignFirstResponder()
            return false
        }
        return true
    }
    
    // clear text when typing
    func textViewDidBeginEditing(_ textView: UITextView) {
        textToTranslate.text = ""
        translatedText.text = ""
    }
    
    // Number of columns
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languagePickerData.count
    }
    
    // Get data for specific row and column
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languagePickerData[row]
    }
    
    // This function decides what happens when something in the picker view is selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let languageCodes = ["en", "fr", "tr", "ga"]        // array of language codes
        if (component == 0) {
            source = languageCodes[row]
        } else if (component == 1) {
           dest = languageCodes[row]
        }
        languages = source + "|" + dest
    }
    
    
    @IBAction func translate(_ sender: AnyObject) {
        
        let str = textToTranslate.text
        let escapedStr = str?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let langStr = (languages).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        let urlStr:String = ("https://api.mymemory.translated.net/get?q="+escapedStr!+"&langpair="+langStr!)
        let url = URL(string: urlStr)
        let request = URLRequest(url: url!)     // Creating Http Request
        
        
        //var data = NSMutableData()var data = NSMutableData()
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.startAnimating()
        
        var result = "<Translation Error>"
        
       /* NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) { response, data, error in
            
            indicator.stopAnimating()
            
            if let httpResponse = response as? HTTPURLResponse {
                if(httpResponse.statusCode == 200){
                    
                    let jsonDict: NSDictionary!=(try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                    
                    if(jsonDict.value(forKey: "responseStatus") as! NSNumber == 200){
                        let responseData: NSDictionary = jsonDict.object(forKey: "responseData") as! NSDictionary
                        
                        result = responseData.object(forKey: "translatedText") as! String
                    }
                }
                
                self.translatedText.text = result
            }
        } */
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            indicator.stopAnimating()
            
            if let httpResponse = response as? HTTPURLResponse {
                if(httpResponse.statusCode == 200){
                    
                    let jsonDict: NSDictionary!=(try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                    
                    if(jsonDict.value(forKey: "responseStatus") as! NSNumber == 200){
                        let responseData: NSDictionary = jsonDict.object(forKey: "responseData") as! NSDictionary
                        
                        result = responseData.object(forKey: "translatedText") as! String
                    }
                }
                
                self.translatedText.text = result
            }
        }
        task.resume()
        
    }
}






/*
 
For c++
 
 2 functions
    distancefrompoint(vector, boolean)
        length of ceiling/ground
        data ground/ceiling
        int k =1
        loop through data to length
            if ship is between k-1 - k break;
        
        use k points in slope formula
        use slope result with formula
            return result
 
    check collision(vector, boolean)
        distance = distancefrompoint(vector, boolean)
        if distance <= 0 && ground/ceiling check
 
 */
