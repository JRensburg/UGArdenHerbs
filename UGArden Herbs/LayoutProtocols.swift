//
//  LayoutProtocols.swift
//  UGArden Herbs
//
//  Created by Jaco Van Rensburg on 3/19/19.
//  Copyright © 2019 NMI. All rights reserved.
//

import Foundation
import Eureka

struct CellItem {
    var data : DataType
    var titleColumn: String
    var middleColumn: String
    var rightColumn: String
}

struct EditItem {
    var baseURL : String
    var title : String
    var dict : [String:Any]?
}

protocol DataType :Codable {
    func asCellItem() -> CellItem
    func asEditItem() -> EditItem
}

extension SeedingData : DataType {
    func asCellItem() -> CellItem {
        return CellItem(data: self, titleColumn:  plantName, middleColumn: dateStarted.checkNoValue(), rightColumn: datePlanted.checkNoValue())
    }
    func asEditItem() -> EditItem {
        return EditItem(baseURL: AirtableURls.seedingBase, title: "Edit - Seeding Form", dict: self.dictionary2)
    }
}
extension DryingData : DataType {
    func asCellItem() -> CellItem {
        return CellItem(data: self,titleColumn: cropName,middleColumn: dateHarvested.checkNoValue(),rightColumn:dateDried.checkNoValue())
    }
    func asEditItem() -> EditItem {
        return EditItem(baseURL: AirtableURls.dryingBase, title: "Edit Drying Form", dict: self.dictionary2)
    }
}
extension TeaData : DataType {
    func asCellItem() -> CellItem {
        return CellItem(data: self, titleColumn: teaBlend, middleColumn: date.checkNoValue(), rightColumn: batchNumber.checkNoValue())
    }
    func asEditItem() -> EditItem {
        return EditItem(baseURL: AirtableURls.teaBase
            ,title: "Edit - Tea Form", dict: self.dictionary2)
    }
}

extension String {
    func checkNoValue() -> String {
        return self != "No value" ? self : ""
    }
}

