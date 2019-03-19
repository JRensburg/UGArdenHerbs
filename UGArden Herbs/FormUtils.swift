//
//  FormUtils.swift
//  Capstone
//
//  Created by Jaco Van Rensburg on 9/25/18.
//  Copyright © 2018 NMI. All rights reserved.
//

import Foundation
import Alamofire
import Eureka

protocol FormUtils {
    //var sendUrl : String {get set}
    var postUrl : String {get set}
    
    
    func collectValues(values: [String:Any?]) -> [String:Any]
    func sendPost(dict : [String:Any])
    func buttonTapped(cell: ButtonCellOf<String>, row: ButtonRow) -> Void
    func configureForm()
}

extension FormUtils where Self: FormViewController{

    /**
     This function collects and formats certain values like dates into a dictionary.
     The forms must have their tag values set to match what the api expects.
     It is called on form.values, which returns all the values in the Eureka form as a dictionary [tag:value]. This can return optionals, while collectValues formats the date row and does not return a dictionary with optionals.
     */
    func collectValues(values: [String:Any?]) -> [String:Any] {
        var literalDict : [String:Any] = [:]
        let dateFormatta = DateFormatter()
        dateFormatta.dateStyle = DateFormatter.Style.long
        dateFormatta.timeStyle = .none
        for item in values {
            if let value = item.value {
                if(value is Date){
                    let val = dateFormatta.string(from: value as! Date)
                    literalDict[item.key] = val
                }
                else if (value is [String?]){
                    literalDict[item.key] = (value as! [String]).joined(separator: ",")
                }
                else {
                    literalDict[item.key] = value
                }
            }
        }
        return literalDict
    }
    
    
    /**
     Posts the data to the Airtable backened
     - parameters:
     - dict : this dict is the body that gets posted. The dict is created such that the keys match what the API expects and Alamofire, using the jsonencoding parameter, converts this to the json needed.
     */
    func sendPost(dict : [String:Any]){
        
        let postParam : Parameters = [
            "fields" : dict
        ]
        print(postParam)
        
        let almoRequest = Alamofire.request(postUrl, method: .post, parameters: postParam, encoding: JSONEncoding.default).responseJSON { response in
            print(response)
            let message = String(data: response.data!, encoding: .utf8)
            var alert: UIAlertController

            if message?.contains("fields") ?? false{
            alert = UIAlertController(title: "Success", message: "Data added successfully.", preferredStyle: UIAlertControllerStyle.alert)
            }
            else {
            alert = UIAlertController(title: "Error", message: "It looks like something went wrong. Please try again later.", preferredStyle: UIAlertControllerStyle.alert)
            }
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                }}))
            self.present(alert, animated: true, completion: nil)
            
        }
        print(almoRequest)
    }
    
    func buttonTapped(cell: ButtonCellOf<String>, row: ButtonRow) -> Void {
        print("tapped!")
        if row.tag == "Submit"{
            if let values = (cell.formViewController()?.form.sectionBy(tag: "Lot Numbers") as? MultivaluedSection)?.values() {
                print(values)
            }
            sendPost(dict: collectValues(values: (cell.formViewController()?.form.values())!))
        }
        else {
            cell.formViewController()?.form.removeAll()
            configureForm()
        }
    }

}

