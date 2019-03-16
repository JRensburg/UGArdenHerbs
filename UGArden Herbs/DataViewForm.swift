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

class DataViewForm: FormViewController, FormUtils {

    var sendUrl : String
    var authentication = AirtableURls.authentication
    var postUrl: String
    var id: String?
    
    var APIformatter : DateFormatter
    let section:Int // tells me which model to use (seeding/drying/tea)
    let model: dataModel
    
    init(style: UITableView.Style, model: dataModel, section: Int) {
        sendUrl = "non-nil value"
        postUrl = "non-nil value"
        APIformatter = DateFormatter()
        self.section = section
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
        switch section {
        case 0:
            sendUrl = AirtableURls.seedingBase
            self.navigationItem.title = "Edit - Seeding Form"
            dict = (model.fields.value as! SeedingData).dictionary2
            configureSeedForm()
        case 1:
            sendUrl = AirtableURls.dryingBase
            self.navigationItem.title = "Edit - Drying Form"
            dict = (model.fields.value as! DryingData).dictionary2
            configureHerbForm()
        case 2:
            sendUrl = AirtableURls.teaBase
            self.navigationItem.title = "Edit - Tea Form"
            dict = (model.fields.value as! TeaData).dictionary2
            configureTeaForm()
        default:
            print("This shouldn't have happened")
        }
        
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
    
    /*
    //
    //      All the various configurations
    //
    */
    func configureSeedForm() {
        form +++ Section("Seeding Form")
            <<< TextRow("Plant Name"){
                $0.title = "Plant"
                $0.placeholder = "Plant Name"
                }.cellUpdate{ cell, row in
                    cell.height = {return 70}
            }
            <<< DateRow("Date Started"){
                $0.title = "Date Started (Seed or Cutting)"
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
    func configureHerbForm() {
        form +++ Section("Drying Form")
            <<< SuggestionAccessoryRow<String>("Crop"){
                //$0.placeholder = "Enter Crop Name"
                $0.title = "Crop Name"
                $0.filterFunction = { text in
                    options.filter({$0.hasPrefix(text)})
                }
                }.cellUpdate{ cell, row in
                    cell.height = {return 70}
            }
            <<< DateRow("Harvest Date"){ row in
                row.title = "Harvest Date"
                }.cellUpdate{ cell, row in
                    cell.height = {return 70}
            }
            <<< TextRow("Plot and Row"){
                $0.title = "Plot and Row"
                }.cellUpdate{cell, row in
                    cell.height = {return 70}
        }
            <<< IntRow("Feet Harvested"){
                $0.title = "Number of Feet harvested"
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
            <<< ActionSheetRow<String>("Drying Condition") {
                $0.title = "Drying Condtition"
                $0.selectorTitle = "Pick which drier was used"
                $0.options = ["Industrial Drier","Outsdie drier","Air Dry","Dry Room"]
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
    }
    
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
            <<< TextRow("Lot Number"){
                $0.title = "Lot Number"
                }.cellUpdate{cell, row in
                    cell.height = {return 70}
            }
//        form +++ MultivaluedSection(multivaluedOptions: [.Insert,.Reorder,.Delete], header: "Lot Numbers",footer: ""){
//            $0.tag = "Lot Number"
//            $0.addButtonProvider = { section in
//                return ButtonRow(){
//                    $0.title = "Add New Lot Number"
//                }
//            }
//            $0.multivaluedRowToInsertAt = { index in
//                return TextRow(){//"Lot_\(index+1)") {
//                    $0.placeholder = "Lot Number"
//                }
//            }
//        }
//            <<< TextRow("Lot Number"){
//                $0.title = "Lot Number"
//                }.cellUpdate{ cell, row in
//                    cell.height = {return 70}
//        }
    }
    func configureForm() {
        //TODO Implement
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
