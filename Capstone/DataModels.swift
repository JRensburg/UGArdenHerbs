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

protocol APIRequest {
    var method: HTTPMethod {get}
    var path: String { get }
    //var parameters: [String : String] { get }
}

extension APIRequest {
    func request() -> URLRequest {
        
        var request = URLRequest(url: URL(string: path)!)
        request.httpMethod = method.rawValue
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}

class DryingRequest : APIRequest {
    var method = HTTPMethod.get
    var path = "https://api.airtable.com/v0/app2gxA4kdnENWzXO/Production?api_key=keyGahK21OkwKGoI8"
    
}

struct Root: Codable {
    let records : [dryingModel]
}
struct dryingModel: Codable{
    let id: String
    let createdTime: String
    let fields: dryingData
}

struct dryingData : Codable {
    
    var cropName: String
    var dateHarvested: String
    var plotNrow: String
    var feetHarvested: Int
    var plantPart: String
    var harvestWeight: Int
    var dryingCondition: String
    var temp: Int
    var humidity: Int
    var dateDried: String
    var dryWeight: Int
    var processedWeight: Int
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


public class APIClient<T:Codable> {
    
    func pull(url: String) -> Observable<([dryingModel])> {
        return request(.get, url).responseData()
            .map({ (Element) in
                do{
                    let  root = try JSONDecoder().decode(Root.self, from: Element.1)
                    return root.records
                }
                catch {
                    fatalError()
//                    return [dryingModel.init(id: "Error", createdTime: "Error", fields: dryingData.init(cropName: "No value", dateHarvested: "No value", plotNrow: "No value", feetHarvested: -1, plantPart: "No value", harvestWeight: -1, dryingCondition: "No value", temp: -1, humidity: -1, dateDried: "No value", dryWeight: -1, processedWeight: -1, lotNumber: "No value"))]
                }
            })
    }
    
}

public final class CustomCell : UITableViewCell {
    
    var model: dryingModel?
    
    var title = UILabel()
    var date = UILabel()
    var date2 = UILabel()
    var color = UIColor.clear
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(title)
        title.snp.makeConstraints{
            $0.height.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(4)
            $0.left.equalToSuperview().offset(50)
        }
        contentView.addSubview(date)
        date.snp.makeConstraints{
            $0.height.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(4)
            $0.left.equalTo(title.snp.right)
        }
        contentView.addSubview(date2)
        date2.snp.makeConstraints{
            $0.height.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(4)
            $0.left.equalTo(date.snp.right).offset(20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override public func prepareForReuse() {
        super.prepareForReuse()
    }
    
    
}
final class DisplayFieldCell : UITableViewCell, UITextFieldDelegate {
    
    let dispose = DisposeBag()
    var key = UILabel()
    var value : UITextField
    var color = UIColor.clear
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        value = UITextField()
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(key)
        key.textAlignment = .left
        key.snp.makeConstraints{
            $0.height.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(3)
            $0.right.equalTo(contentView.snp.centerX)
        }
        contentView.addSubview(value)
        value.textAlignment = .left
        value.snp.makeConstraints{
            $0.height.equalToSuperview()
            $0.right.equalToSuperview()
            $0.left.equalTo(contentView.snp.centerX).offset(15)
        }
      //  value.delegate = self
        value.clearButtonMode = .whileEditing
        backgroundView = nil
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override public func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "No value" {textField.text = ""}
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            textField.text = "No value"
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return false
    }
    
}

public let options = ["Hops","Luffa","Passionflower","Blue vervain","Echinacea"," Elecampane","Garden Sage","Goldenrod","Gotu Kola","Lavender (english)","Lemon Balm","Lemon verbena","Mint Licorice","Motherwort","Mugwort","Oregano","Peppermint","Rosemary","Skullcap (official)"," Stevia","Stinging Nettle","Thyme (English)","Violet","Yarrow","Ashwagandha, Vedic","Burdock, gobo", "Calendula, orange","Callifornia Poppy","Chamomile, german", "Cilantro","Dandelion, wild","Hibiscus","Lemongrass","Parsley","Plantain","Red Clover","Temperate Tulsi","Turmeric","Ginger","Blueberry leaves","Comfrey, Russian","Elderberries","Hawthorne","Licorice","Red raspberry","Rose","Ted Rose","Sumac","Yaupon Holly"]
public let parts = ["Herb","Flowering Tops","Leaf","Flower","Root","Calyx"]

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
