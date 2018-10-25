
//
//  SeedingForm.swift
//  Capstone
//
//  Created by Jaco Van Rensburg on 9/20/18.
//  Copyright © 2018 NMI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Eureka
import Alamofire

class SeedingForm: FormViewController, FormUtils {
    var sendUrl: String = ""
    
    var postUrl: String = ""
    
    
    let APIkey = "keyGahK21OkwKGoI8"
    let whyDontThisWork : HTTPHeaders = [
        "api_key" : "keyGahK21OkwKGoI8"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Seeding Form"
        configureForm()
    }
    
    func configureForm(){
        form +++ Section("Seeding Form")
            <<< TextRow("Plant:"){
                $0.title = "Plant"
                $0.placeholder = "Plant Name"
            }
            <<< DateRow("Date Started"){
                $0.title = "Date Started (Seed or Cutting)"
                $0.value = Date()
            }
            <<< IntRow("Number Seedlings"){
                $0.title = "Total # of seeds planted/cuttings"
            }
            <<< DateRow("Date Germination"){
                $0.title = "Date of First Germination"
            }
            <<< IntRow("Number germintated"){
                $0.title = "Total Number Germinated"
            }
            <<< DecimalRow("Percentage"){
                $0.title = "Percentage Germinated"
            }
            <<< TextAreaRow("Notes"){
                $0.title = "Notes"
                $0.placeholder = "Notes for any seed treatment"
        }
        form +++ Section("Submit")
            <<< ButtonRow("Submit"){
                $0.title = "Submit"
                $0.onCellSelection(self.buttonTapped)
                }
            <<< ButtonRow("Clear"){ row in
                //row.title = "Clear Form"
                row.onCellSelection(self.buttonTapped)
                }.cellUpdate{cell, row in
                    cell.textLabel?.attributedText = NSMutableAttributedString(string: "Clear Form", attributes: [.foregroundColor: UIColor.red])
                }
    }
}
