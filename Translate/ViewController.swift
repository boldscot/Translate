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
    @IBOutlet weak var translateButton: UIButton!
    
    var languagePickerData = ["English", "French", "Turkish", "Gaelic"]
    var languages: String = ""
    var source: String = "en"
    var dest: String = "fr"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set view controller as delegate
        textToTranslate.delegate = self
        languagePicker.delegate = self
        languagePicker.dataSource = self
        
        
        // Improve the look of the button and ui text views
        translateButton.backgroundColor = UIColor.clear
        translateButton.layer.cornerRadius = 30
        translateButton.layer.borderWidth = 2
        translateButton.layer.borderColor = UIColor.yellow.cgColor
        
        textToTranslate.layer.borderWidth = 2
        textToTranslate.layer.borderColor = UIColor.yellow.cgColor
        
       
        translatedText.layer.borderWidth = 2
        translatedText.layer.borderColor = UIColor.yellow.cgColor
        
        languagePicker.layer.borderWidth = 2
        languagePicker.layer.borderColor = UIColor.yellow.cgColor
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
    
    // change color of picker view text, from stack overflow http://stackoverflow.com/questions/29243564/change-uipicker-color-swift
    func pickerView(_ languagepickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = languagePickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Helvetica Neue", size: 20.0)!,NSForegroundColorAttributeName:UIColor.yellow])
        return myTitle
    }
    
    // Get data for specific row and column
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languagePickerData[row]
    }
    
    // This function decides what happens when something in the picker view is selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var languageCodes = ["en", "fr", "tr", "ga"]        // array of language codes
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
        let session = URLSession.shared
        
        // Indicator brought in from third party, https://github.com/goktugyil/EZLoadingActivity
        EZLoadingActivity.show("Loading...", disableUI: true)
        
        var result = "<Translation Error>"
        
        session.dataTask(with: url!) {
            (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse {
                if(httpResponse.statusCode == 200){
                        
                    let jsonDict: NSDictionary = try! JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                        
                    if(jsonDict.value(forKey: "responseStatus") as! NSNumber == 200){
                        let responseData: NSDictionary = jsonDict.object(forKey: "responseData") as! NSDictionary
                        result = responseData.object(forKey: "translatedText") as! String
                    }
                }
            }
            DispatchQueue.main.async {
                EZLoadingActivity.hide(true, animated: true)
                self.translatedText.text = result
            }
        }.resume()
            
    }
}
