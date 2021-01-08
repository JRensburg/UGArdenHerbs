//
//  TeaAble.swift
//  UGArden Herbs
//
//  Created by Jacobus Janse van Rensburg on 10/28/20.
//  Copyright © 2020 NMI. All rights reserved.
//

import Foundation
import Eureka
protocol TeaAble { }
extension TeaAble where Self: FormViewController {
    func configureTeaForm(){
        form +++ Section("Tea Production")
            <<< DateRow("Date"){
                $0.title = "Date"
                $0.value = Date()
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }.cellUpdate{ cell, row in
                    cell.height = {return 70}
            }
            <<< TextRow("Tea Blend"){
                $0.title = "Tea Blend"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }.cellUpdate{ cell, row in
                    cell.height = {return 70}
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
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

