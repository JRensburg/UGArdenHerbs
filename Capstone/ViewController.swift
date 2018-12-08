//
//  ViewController.swift
//  Capstone
//
//  Created by Jaco Van Rensburg on 9/4/18.
//  Copyright © 2018 NMI. All rights reserved.
//

import UIKit
import Eureka
import SnapKit
import Alamofire
import RxAlamofire
import QRCode
import AVFoundation
import SuggestionRow

/*
 For reference: label may need to be around 2.4 inches to whatever length 
*/
class HerbFormController: FormViewController, FormUtils, AVCaptureMetadataOutputObjectsDelegate, PrintUtils{

    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    var formatter : DateFormatter?
    var postUrl = "https://api.airtable.com/v0/apptgk0JBqpaqbtT4/Drying%20Data?api_key=keyhr7xMO6nFfKreF&Content-Type=application/json"
    var qrData = ""
    let submit = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Drying Form"
        //self.view.backgroundColor =
        configureForm()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func configureForm(){
        form +++ Section("Pre-Production")
//            <<< TextRow("Crop"){ row in
//                row.title = "Crop"
//                row.placeholder = "Enter text here"
//                }.cellUpdate{ cell, row in
//                    cell.height = {return 70}
//            }
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
                row.value = Date()
                formatter = row.dateFormatter
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
//            <<< TextRow("Plant Part"){
//                $0.title = "Plant Part"
//                }.cellUpdate{ cell, row in
//                    cell.height = {return 70}
//            }
            <<< DecimalRow("Harvest Weight"){
                $0.title = "Harvest Weight"
                }.cellUpdate{ cell, row in
                    cell.height = {return 70}
        }
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
        form +++ Section("Submit")
            <<< ButtonRow("Submit"){
                $0.title = "Post!"
                $0.onCellSelection(self.buttonTapped)
                }.cellUpdate{ cell, row in
                    cell.height = {return 70}
            }
            <<< ButtonRow("Clear"){ row in
                row.onCellSelection(self.buttonTapped)
                }.cellUpdate{cell, row in
                    cell.textLabel?.attributedText = NSMutableAttributedString(string: "Clear Form", attributes: [.foregroundColor: UIColor.red])
                    cell.height = {return 70}
        }
        navigationOptions = RowNavigationOptions.Enabled.union(.StopDisabledRow)
        animateScroll = true
        rowKeyboardSpacing = 20
    }
    
    func showScanner(cell: ButtonCellOf<String>, row: ButtonRow) -> Void {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ScannerViewController") as! ScannerViewController
        vc.callback = {
            self.qrData = $0
            self.populateForm(json: $0)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func makeOtherLabel(cell: ButtonCellOf<String>, row: ButtonRow) -> Void {
        var literalDict : [String:Any] = [:]
        for item in form.rows{// for item in form.sectionBy(tag: "pre")! {
            if let value = item.baseValue {
                if(value is Date){
                    let val = formatter!.string(from: value as! Date)
                    literalDict[item.tag!] = val
                } else {
                    literalDict[item.tag!] = value
                }
            }
        }

        let jsonData = try? JSONSerialization.data(withJSONObject: literalDict, options: [])
        
        let otherCode = QRCode(String(data: jsonData!, encoding: .utf8)!)
        
        let labelView = createView(image: otherCode!.image!, info: literalDict.filter{$0.key == "Crop" || $0.key == "Harvest Date" || $0.key == "Plant Part"})

        printLabel(image: labelView)
    }
    
    func printLabel(image: UIImage){
        let printInfo = UIPrintInfo(dictionary:nil)
        printInfo.outputType = UIPrintInfoOutputType.general
        printInfo.jobName = "Label"
        
        let printController = UIPrintInteractionController.shared
        printController.printInfo = printInfo
        
        printController.printingItem = image
        
        // Do it
        printController.present(from: self.view.frame, in: self.view, animated: true, completionHandler: nil)
        
    }
    
    func populateForm(json: String) {
        let dict : [String: Any] = try! JSONSerialization.jsonObject(with: json.data(using: .utf8)!, options: []) as! [String : Any]
        print(dict)
        for item in dict {
            if(item.key == "Harvest Date"){
                let row =  (form.rowBy(tag: "Harvest Date") as! DateRow)
                row.baseValue = formatter!.date(from: item.value as! String)
                row.cell.datePicker.setDate(row.value!, animated: true)
            }
            else{
            form.rowBy(tag: item.key)?.baseValue = item.value
            }
            form.rowBy(tag: item.key)?.reload(with: .bottom)//.updateCell()
        }
        self.tableView.reloadData()
    }

}
