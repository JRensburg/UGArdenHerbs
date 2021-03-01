//
//  Dryable.swift
//  UGArden Herbs
//
//  Created by Jacobus Janse van Rensburg on 10/27/20.
//  Copyright © 2020 NMI. All rights reserved.
//

import UIKit
import Eureka
import SuggestionRow

protocol Dryable {
    var dateFormatter : DateFormatter? {get set}
    func populateForm(json: String)
}
extension Dryable where Self: FormViewController & PrintUtils {
    
    func showScanner(cell: ButtonCellOf<String>, row: ButtonRow) -> Void {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ScannerViewController") as! ScannerViewController
        vc.callback = {
            //self.qrData = $0 also probs not needed
            self.populateForm(json: $0)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func makeOtherLabel(cell: ButtonCellOf<String>, row: ButtonRow) -> Void {
        var literalDict : [String:Any] = [:]
        for item in form.rows{
            if let value = item.baseValue {
                if(value is Date){
                    let val = dateFormatter!.string(from: value as! Date)
                    literalDict[item.tag!] = val
                } else {
                    literalDict[item.tag!] = value
                }
            }
        }

        let jsonData = try? JSONSerialization.data(withJSONObject: literalDict, options: [])
        
        let otherCode = QRCode(String(data: jsonData!, encoding: .utf8)!)
        
        let labelView = createView(image: otherCode!.image!, info: literalDict.filter{$0.key == "Crop" || $0.key == "Harvest Date" || $0.key == "Lot Number"})

        printLabel(image: labelView)
    }
    
    func printLabel(image: UIImage){
        let printInfo = UIPrintInfo(dictionary:nil)
        printInfo.outputType = UIPrintInfoOutputType.general
        printInfo.jobName = "Label"
        let printController = UIPrintInteractionController.shared
        printController.printInfo = printInfo
        printController.printingItem = image
        printController.present(from: self.view.frame, in: self.view, animated: true, completionHandler: nil)
    }
    
    func configureFirstHalf(){
        form +++ Section("Pre-Production")
            <<< SuggestionAccessoryRow<String>("Crop"){
                $0.title = "Crop Name"
                $0.filterFunction = { text in
                    PlantNames.shared.names.filter({$0.hasPrefix(text)})
                }
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }.cellUpdate{ cell, row in
                    cell.height = {return 70}
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            <<< TextRow("Lot Number"){
                $0.title = "Lot Number"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }.cellUpdate{ cell, row in
                    cell.height = {return 70}
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
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
            <<< DecimalRow("Dry Weight"){
                $0.title = "Dry Weight"
                }.cellUpdate{ cell, row in
                    cell.height = {return 70}
            }
            <<< DecimalRow("Processed Weight"){
                $0.title = "Processed Weight"
                }.cellUpdate{ cell, row in
                    cell.height = {return 70}
            }
        form +++ Section("Miscellaneous")
            <<< TextAreaRow("Notes")
    }
    
    func addScanToForm() {
        form +++ Section("QR Code")
            <<< ButtonRow(){
                $0.title = "Generate Label"
                $0.onCellSelection(self.makeOtherLabel)
                }.cellUpdate{ cell, row in
                    cell.height = {return 70}
            }
            <<< ButtonRow(){
                $0.title = "Scan Label"
                $0.onCellSelection(self.showScanner)
                }.cellUpdate{ cell, row in
                    cell.height = {return 70}
        }
    }
}
