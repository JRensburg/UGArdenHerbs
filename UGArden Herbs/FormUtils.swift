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
import SuggestionRow

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
protocol Seedable {
    
}
extension Seedable where Self:FormViewController {
    func configureSeedForm() {
        form +++ Section("Seeding Form")
            <<< SuggestionAccessoryRow<String>("Plant Name"){
                $0.title = "Crop Name"
                $0.filterFunction = { text in
                    options.filter({$0.hasPrefix(text)})
                }
                }.cellUpdate{ cell, row in
                    cell.height = {return 70}
            }
            <<< DateRow("Date Started"){
                $0.title = "Date Started (Seed or Cutting)"
                $0.value = Date()
                }.cellUpdate{ cell,row in
                    cell.height = {return 70}
            }
            <<< IntRow("Total # of Seeds"){
                $0.title = "Number of seeds planted/cuttings"
                }.cellUpdate{ cell,row in
                    cell.height = {return 70}
            }
            <<< DateRow("Date of Germination"){
                $0.title = "Date of First Germination"
                }.cellUpdate{ cell,row in
                    cell.height = {return 70}
            }
            <<< IntRow("Total Number Germinated"){
                $0.title = "Total Number Germinated"
                }.cellUpdate{ cell,row in
                    cell.height = {return 70}
            }
            <<< TextAreaRow("Notes"){
                $0.title = "Notes"
                $0.placeholder = "Notes for any seed treatment"
                }.cellUpdate{ cell,row in
                    cell.height = {return 70}
            }
            <<< DateRow("Date Planted"){
                $0.title = "Date Planted"
                }.cellUpdate{cell, row in
                    cell.height = {return 70}
        }
    }
}
protocol Dryable {
    
}
extension Dryable where Self:FormViewController {
    func configureFirstHalf(){
        form +++ Section("Pre-Production")
            <<< SuggestionAccessoryRow<String>("Crop"){
                $0.title = "Crop Name"
                $0.filterFunction = { text in
                    options.filter({$0.hasPrefix(text)})
                }
                }.cellUpdate{ cell, row in
                    cell.height = {return 70}
            }
            <<< DateRow("Harvest Date"){ row in
                row.title = "Harvest Date"
                row.value = Date()
                }.cellUpdate{ cell, row in
                    cell.height = {return 70}
            }
            <<< TextRow("Plot and Row"){
                $0.title = "Plot and Row"
                }.cellUpdate{cell, row in
                    cell.height = {return 70}
            }
            <<< IntRow("Feet Harvested"){
                $0.title = "Feet harvested"
                }.cellUpdate{ cell, row in
                    cell.height = {return 70}
            }
            <<< SuggestionAccessoryRow<String>("Plant Part"){
                $0.title = "Plant Part"
                $0.filterFunction = { text in
                    parts.filter({$0.hasPrefix(text)})
                }
                }.cellUpdate{ cell, row in
                    cell.height = {return 70}
            }
            <<< DecimalRow("Harvest Weight"){
                $0.title = "Harvest Weight"
                }.cellUpdate{ cell, row in
                    cell.height = {return 70}
        }
    }
    func configureSecondHalf(){
        form +++ Section("Post-Production")
            <<< ActionSheetRow<String>("Drying Condition") {
                $0.title = "Drying Condtition"
                $0.selectorTitle = "Pick which drier was used"
                $0.options = ["Industrial Drier","Outside Drier","Air Dry","Dry Room"]
                $0.value = "Dry Room"   // initially selected
                }.cellUpdate{ cell, row in
                    cell.height = {return 70}
            }
            <<< IntRow("Temperature"){
                $0.title = "Drying Temperature"
                }.cellUpdate{ cell, row in
                    cell.height = {return 70}
            }
            <<< IntRow("Relative Humidity"){
                $0.title = "Relative Humidity"
                }.cellUpdate{ cell, row in
                    cell.height = {return 70}
            }
            <<< DateRow("Date Dried"){
                $0.title = "Date Dried"
                }.cellUpdate{ cell, row in
                    cell.height = {return 70}
            }
            <<< IntRow("Dry Weight"){
                $0.title = "Dry Weight"
                }.cellUpdate{ cell, row in
                    cell.height = {return 70}
            }
            <<< IntRow("Processed Weight"){
                $0.title = "Processed Weight"
                }.cellUpdate{ cell, row in
                    cell.height = {return 70}
            }
            <<< TextRow("Lot Number"){
                $0.title = "Lot Number"
                }.cellUpdate{ cell, row in
                    cell.height = {return 70}
        }
        form +++ Section("Miscellaneous")
            <<< TextAreaRow("Notes")
    }
}
protocol TeaAble {
}
extension TeaAble where Self:FormViewController {
    func configureTeaForm(){
        form +++ Section("Tea Production")
            <<< DateRow("Date"){
                $0.title = "Date"
                $0.value = Date()
                }.cellUpdate{ cell, row in
                    cell.height = {return 70}
            }
            <<< TextRow("Tea Blend"){
                $0.title = "Tea Blend"
                }.cellUpdate{ cell, row in
                    cell.height = {return 70}
            }
            <<< TextRow("Batch Number"){
                $0.title = "Batch Number"
                }.cellUpdate{ cell, row in
                    cell.height = {return 70}
        }
        form +++ MultivaluedSection(multivaluedOptions: [.Insert,.Reorder,.Delete], header: "Lot Numbers",footer: ""){
            $0.tag = "Lot Number"
            $0.addButtonProvider = { section in
                return ButtonRow(){
                    $0.title = "Add New Lot Number"
                }
            }
            $0.multivaluedRowToInsertAt = { index in
                return TextRow(){
                    $0.placeholder = "Lot Number"
                }
            }
            $0 <<< TextRow(){
                $0.placeholder = "Lot Number"
            }
        }
    }
}

