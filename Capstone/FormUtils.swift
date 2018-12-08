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


//new key  - keyhr7xMO6nFfKreF

protocol FormUtils {
    //var sendUrl : String {get set}
    var postUrl : String {get set}
    
    
    func collectValues(values: [String:Any?]) -> [String:Any]
    func sendPost(dict : [String:Any])
  //  func sendRequest(key : String)
    func buttonTapped(cell: ButtonCellOf<String>, row: ButtonRow) -> Void
    func configureForm()
    
}

extension FormUtils where Self: FormViewController{

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
                } else {
                    literalDict[item.key] = value
                }
            }
        }
        return literalDict
    }

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
    
//    func sendRequest(key: String){
//        let whyDontThisWork : HTTPHeaders = [
//            "api_key" : key
//        ]
//        Alamofire.request(sendUrl, headers : whyDontThisWork).responseJSON { response in
//            let textField = UITextField()
//            textField.text = String(data: response.data!, encoding: String.Encoding.utf8)
//            self.view.addSubview(textField)
//        }
//    }
    
    func buttonTapped(cell: ButtonCellOf<String>, row: ButtonRow) -> Void {
        print("tapped!")
        if row.tag == "Submit"{
            sendPost(dict: collectValues(values: (cell.formViewController()?.form.values())!))
        }
        else {
            cell.formViewController()?.form.removeAll()
            configureForm()
        }
    }

}

