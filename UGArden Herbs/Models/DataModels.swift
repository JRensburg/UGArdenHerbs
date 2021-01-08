//
//  DataModels.swift
//  Capstone
//
//  Created by Jaco Van Rensburg on 11/13/18.
//  Copyright © 2018 NMI. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxAlamofire
import RxCocoa
import SnapKit
import SuggestionRow

//This is sort of a blanket Decodable struct. By using this pattern I can sort of throw it at any of the requests for data
//that I make and it should decode appropriately provided there is enough information
struct AnyFormModel: Decodable {
    var value: DataType
    init(index: Int){
        value = BlankItem(index: index)
    }
    init(from decoder: Decoder) throws {
        if let data = try? SeedingData(from: decoder){
            value = data
            return
        }
        if let data = try? TeaData(from: decoder){
            value = data
            return
        }
        if let data = try? DryingData(from: decoder){
            value = data
            return
        }
        value = BlankItem()
    }
}

/*
//The root structure. The JSON response when pulling a base is in the form
 // "records":[{ id : someValue,
 createdTime : "time",
 fields : {The various fields in the table}
*/
struct Root: Decodable {
    var records : [dataModel]
}
struct dataModel: Decodable{
    let id: String
    let createdTime: String
    let fields: AnyFormModel
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdTime
        case fields
    }
}
/*
//For Data from the drying form. Really l3ong, but this way I can have default values.
//(It was more convenient at the time for me to assign default values to the struct itself - the Rx binding to tableview was unhappy with nil or empty values and I hadn't thought of defining a protocol to lay out the cells)
 */
struct DryingData : Codable {
    
    var cropName: String
    var dateHarvested: String
    var plotNrow: String
    var feetHarvested: Int
    var plantPart: String
    var harvestWeight: Double
    var dryingCondition: String
    var temp: Int
    var humidity: Int
    var dateDried: String
    var dryWeight: Double
    var processedWeight: Double
    var lotNumber: String
    
    private enum CodingKeys: String, CodingKey {
        case cropName = "Crop"
        case dateHarvested = "Harvest Date"
        case plotNrow = "Plot and Row"
        case feetHarvested = "Feet Harvested"
        case plantPart = "Plant Part"
        case harvestWeight = "Harvest Weight"
        case dryingCondition = "Drying Condition"
        case temp = "Temperature"
        case humidity = "Relative Humidity"
        case dateDried = "Date Dried"
        case dryWeight = "Dry Weight"
        case processedWeight = "Processed Weight"
        case lotNumber = "Lot Number"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cropName = try container.decodeWrapper(key: .cropName, defaultValue: "No value")
        self.dateHarvested = try container.decodeWrapper(key: .dateHarvested, defaultValue: "No value")
        self.plotNrow = try container.decodeWrapper(key: .plotNrow, defaultValue: "No value")
        self.feetHarvested = try container.decodeWrapper(key: .feetHarvested, defaultValue: -1)
        self.plantPart = try container.decodeWrapper(key: .plantPart, defaultValue: "No value")
        self.harvestWeight = try container.decodeWrapper(key: .harvestWeight, defaultValue: -1)
        self.dryingCondition = try container.decodeWrapper(key: .dryingCondition
, defaultValue: "No value")
        self.temp = try container.decodeWrapper(key: .temp, defaultValue: -1)
        self.humidity = try container.decodeWrapper(key: .humidity, defaultValue: -1)
        self.dateDried = try container.decodeWrapper(key: .dateDried, defaultValue: "No value")
        self.dryWeight = try container.decodeWrapper(key: .dryWeight, defaultValue: -1)
        self.processedWeight = try container.decodeWrapper(key: .processedWeight, defaultValue: -1)
        self.lotNumber = try container.decodeWrapper(key: .lotNumber, defaultValue: "No value")
    
    }
}
//This is for data from the seeding form
struct SeedingData : Codable {
    var numberGerminated : Int
    var dateStarted : String
    var dateGerminated : String
    var totalSeeds : Int
    var percentageGerminated : Double?
    var plantName : String
    var datePlanted : String
    
    private enum CodingKeys: String, CodingKey {
        case numberGerminated = "Total Number Germinated"
        case dateStarted = "Date Started"
        case dateGerminated = "Date of Germination"
        case totalSeeds = "Total # of Seeds"
        case percentageGerminated = "Percentage Germinated"
        case plantName = "Plant Name"
        case datePlanted = "Date Planted"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.numberGerminated = try container.decodeWrapper(key: .numberGerminated, defaultValue: -1)
        self.dateStarted = try container.decodeWrapper(key: .dateStarted, defaultValue: "No value")
        self.dateGerminated = try container.decodeWrapper(key: .dateGerminated, defaultValue: "No value")
        self.totalSeeds = try container.decodeWrapper(key: .totalSeeds, defaultValue: -1)
        self.percentageGerminated = (try container.decodeWrapper(key: .percentageGerminated, defaultValue: -1.0) * 100).rounded() / 100
        self.plantName = try container.decode(String.self, forKey: .plantName)
        self.datePlanted = try container.decodeWrapper(key: .datePlanted, defaultValue: "No value")
    }
}

//And finally the tea data model
struct TeaData : Codable {
    var batchNumber: String
    var date: String
    var lotNumber: String
    var teaBlend : String
    
    private enum CodingKeys: String, CodingKey {
        case batchNumber = "Batch Number"
        case date = "Date"
        case lotNumber = "Lot Number"
        case teaBlend = "Tea Blend"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.batchNumber  = try container.decodeWrapper(key: .batchNumber, defaultValue: "No value")
        self.date = try container.decodeWrapper(key: .date, defaultValue: "No value")
        self.lotNumber  = try container.decodeWrapper(key: .lotNumber, defaultValue: "No value")
        self.teaBlend = try container.decode(String.self, forKey: .teaBlend)
    }
}

struct BlankItem : DataType {
    func asEditItem() -> EditItem {
        return EditItem(baseURL: "",title:"",dict: ["":""])
    }
    
    var index : Int
    func asCellItem() -> CellItem {
        switch index {
        case 0:
            return CellItem(data:self,titleColumn: "Plant Name",middleColumn: "Started",rightColumn: "Date Dried")
        case 1:
            return CellItem(data:self,titleColumn: "Crop Name",middleColumn: "Harvested",rightColumn:"Date Dried")
        case 2:
            return CellItem(data:self,titleColumn: "Tea Blend",middleColumn: "Date",rightColumn:"Batch")
        default:
            return CellItem(data: self, titleColumn: "", middleColumn: "",rightColumn: "")
        }
    }
    init(index: Int? = 1){
        self.index = index!
    }
}

//Pulls data with the given data and decodes it into my custom data types.
public class APIClient {
    static func pull(url: String) -> Observable<[dataModel]> {
        //request(.get, url).responseJSON().subscribe{print($0)}//.disposed(by: DisposeBag())
        return request(.get, url).responseData()
            .map({(Element) in
                let decoder = JSONDecoder()
                let response = try decoder.decode(Root.self, from: Element.1)
                return response.records
            })
    }
}


//Not Really Data Models, but used for the suggestion rows
public let options = ["Ashwagandha","Basil","Blue vervain","Blueberry leaves","Calendula","Chamomile","Comfre","Dandelion","Echinacea","Elderberry","Ginger","Goldenrod","Hawthorne","Hibiscus","Holy basil, Kapoor","Holy basil, Krishna","Holy basil, Vana","Lemon balm","Lemon verbena","Lemongrass","Licorice Mint","Luffa","Marjoram","Motherwort","Oats","Oregano","Parsley","Passionflower","Peppermint","Plantain","Red clover","Red Rose","Rose Hip","Rosemary","Skullcap","Stevia","Stinging nettle","Thyme","Yarrow","Yaupon holly"]
public let parts = ["Herb","Flowering Tops","Leaf","Flower","Root","Calyx"]

//Convenience Methods that convert my data structs to dictionaries. Used primarily by DataViewPopUp to fill out the forms
extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    var dictionary2: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
    
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
    }
}
extension KeyedDecodingContainer {
    func decodeWrapper<T>(key: K, defaultValue: T) throws -> T
        where T : Decodable {
            return try decodeIfPresent(T.self, forKey: key) ?? defaultValue
    }
}

//Lets me check whether the cells should be red. Returns false if any of the fields have one of the default values (-1 or "No Value")
extension AnyFormModel{
    func isComplete() -> Bool {
        return (value.dictionary.filter{return ($0.value as? String == "No value" || $0.value as? Int == -1)}.count > 0)
    }
}
