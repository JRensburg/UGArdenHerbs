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
import AVFoundation
import SuggestionRow

/*
 For reference: label may need to be around 2.4 inches to whatever length 
*/
class HerbFormController: FormViewController, FormUtils, AVCaptureMetadataOutputObjectsDelegate, PrintUtils,Dryable{

    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var dateFormatter : DateFormatter?
    var postUrl = AirtableURLs.dryingURl
    let submit = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter = DateFormatter()
        dateFormatter?.timeStyle = .none
        dateFormatter?.dateStyle = .medium
        dateFormatter?.locale = Locale.current
        self.navigationItem.title = "Drying Form"
        configureForm()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func configureForm(){
        configureFirstHalf()
        addScanToForm()
        configureSecondHalf()
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
    /**
     Populates the drying form with a given json string
     I tried using a dictionary, but encoding the json string as opposed
     to a dictionary or data object made the qr code scan much more quickly.
     */
    func populateForm(json: String) {
        let dict : [String: Any] = try! JSONSerialization.jsonObject(with: json.data(using: .utf8)!, options: []) as! [String : Any]
        print(dict)
        for item in dict {
            if(item.key == "Harvest Date"){
                let row =  (form.rowBy(tag: "Harvest Date") as! DateRow)
                row.baseValue = dateFormatter!.date(from: item.value as! String)
                row.cell.datePicker.setDate(row.value!, animated: true)
            }
            else{
            form.rowBy(tag: item.key)?.baseValue = item.value
            }
            form.rowBy(tag: item.key)?.reload(with: .bottom)
        }
        self.tableView.reloadData()
    }

}
