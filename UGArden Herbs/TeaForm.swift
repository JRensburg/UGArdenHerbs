//
//  TeaForm.swift
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

class TeaForm: FormViewController, FormUtils {
    var postUrl = AirtableURls.teaURl
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView?.backgroundColor = UIColor(red: 60/255, green: 80/255, blue: 11/255, alpha: 1)
        let imageView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        imageView.contentMode = .scaleToFill
        self.navigationItem.title = "Tea Form"
        configureForm()
    }
    
    func configureForm(){
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
        form +++ Section("Submit")
            <<< ButtonRow("Submit"){
                $0.title = "Submit!"
                $0.onCellSelection(self.buttonTapped)
                }.cellUpdate{ cell, row in
                    cell.height = {return 70}
            }
            <<< ButtonRow("Clear"){ row in
                row.onCellSelection(self.buttonTapped)
                }.cellUpdate{cell, row in
                    cell.height = {return 70}
                    cell.textLabel?.attributedText = NSMutableAttributedString(string: "Clear Form", attributes: [.foregroundColor: UIColor.red])
        }
    }
    
}
