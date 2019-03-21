//
//  DataViewForm.swift
//  Capstone
//
//  Created by Jaco Van Rensburg on 11/26/18.
//  Copyright © 2018 NMI. All rights reserved.
//

import Foundation
import Eureka
import Alamofire
import SuggestionRow

class DataViewForm: FormViewController, FormUtils,Seedable, Dryable, TeaAble {

    var sendUrl : String
    var authentication = AirtableURls.authentication
    var postUrl: String
    var id: String?
    var APIformatter : DateFormatter
    let model: dataModel
    
    init(style: UITableView.Style, model: dataModel) {
        sendUrl = "non-nil value"
        postUrl = "non-nil value"
        APIformatter = DateFormatter()
        self.model = model
        super.init(style: style)
        APIformatter.dateFormat = "yyyy-MM-dd"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var dict : [String: Any]?
        id = model.id
        let viewItem = model.fields.value.asEditItem()
        sendUrl = viewItem.baseURL
        dict = viewItem.dict
        self.navigationItem.title = viewItem.title
        configureForm()
        form +++ Section("Submit Changes")
            <<< ButtonRow("Submit"){
                $0.title = "Submit Changes"
                $0.onCellSelection(self.submitChanges)
                }.cellUpdate{cell, row in
                    cell.height = {return 70}
                    cell.textLabel?.textColor = UIColor.white
                    cell.backgroundColor = UIColor(red: 208/255, green: 194/255, blue: 212/255, alpha: 1.0
                    )
        }
        populateForm(dict: dict ?? ["":""])
    }
    
    func populateForm(dict: [String:Any]) {
        print(dict)
        for item in dict {
            if ((item.value as? String != "No value") && (item.value as? Int != -1)){
            if(item.key == "Harvest Date" || item.key == "Date Dried" || item.key == "Date Started" || item.key == "Date of Germination" || item.key == "Date Planted" || item.key == "Date"){
                
                let row = (form.rowBy(tag: item.key) as! DateRow)
                let thisBroke = APIformatter.date(from: item.value as! String)
                row.value = thisBroke
                row.cell.datePicker.setDate(row.value!, animated: true)
            }
            else{
                form.rowBy(tag: item.key)?.baseValue = item.value
            }
            form.rowBy(tag: item.key)?.reload(with: .bottom)//.updateCell()
            }
        }
    }
    
    func configureForm() {
        if (model.fields.value is SeedingData) {
            configureSeedForm()
        }
        else if (model.fields.value is DryingData) {
            configureFirstHalf()
            configureSecondHalf()
        }
        else if (model.fields.value is TeaData) {
            configureTeaForm()
        }
    }
    
    func submitChanges(cell: ButtonCellOf<String>, row: ButtonRow) -> Void {
        sendPatch(dict: collectValues(values: (form.values())))
    }
    
    func sendPatch(dict : [String:Any]){
        
        let postParam : Parameters = [
            "fields" : dict
        ]
        print(postParam)
        let finalurl = sendUrl + (id ?? "") + "?" + authentication
        let almoRequest = Alamofire.request(finalurl, method: .put, parameters: postParam, encoding: JSONEncoding.default).responseJSON { response in
            let message = String(data: response.data!, encoding: .utf8)
            var alert: UIAlertController
            
            if message?.contains("fields") ?? false{
                alert = UIAlertController(title: "Success", message: "Data changed successfully.", preferredStyle: UIAlertControllerStyle.alert)
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
}

