//
//  TableViewCells.swift
//  Capstone
//
//  Created by Jaco Van Rensburg on 12/3/18.
//  Copyright © 2018 NMI. All rights reserved.
//

import Foundation
import SnapKit
import RxSwift

public final class CustomCell: UITableViewCell {
    
    var model: dataModel?
    
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
            $0.left.equalToSuperview().inset(60)
        }
        contentView.addSubview(date)
        date.textAlignment = .center
        date.snp.makeConstraints{
            $0.height.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(4)
            $0.centerX.equalToSuperview()
        }
        contentView.addSubview(date2)
        date2.snp.makeConstraints{
            $0.height.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(4)
            $0.right.equalToSuperview().offset(20)
        }
    }
    
    func layoutCell(model: dataModel, segmentIndex : Int){
        self.model = model
        if model.fields.value as? Int == 1 {
            backgroundColor = UIColor(red: 138/255, green: 158/255, blue: 87/255, alpha: 1)
            switch segmentIndex {
            case 0:
                title.text = "Plant Name"
                date.text = "Started"
                date2.text = "Date Dried"
            case 1:
                title.text = "Crop Name"
                date.text = "Harvested"
                date2.text = "Date Dried"
            case 2:
                title.text = "Tea Blend"
                date.text = "Date"
                date2.text = "Batch"
            default:
                print("oof")
            }
            return
        }
        switch segmentIndex {
        case 0:
            let seedModel = (model.fields.value as? SeedingData)
            title.text = seedModel?.plantName
            date.text = seedModel?.dateGerminated
            date.text = ((seedModel?.dateStarted != "No value") ? (seedModel?.dateStarted)! : "")
            date2.text = ((seedModel?.datePlanted != "No value") ?  (seedModel?.datePlanted)! : "")
        case 1:
            let dryModel = (model.fields.value as? DryingData)
            title.text = dryModel?.cropName
            date.text = ((dryModel?.dateHarvested != "No value") ? (dryModel?.dateHarvested)! : "")
            date2.text = ((dryModel?.dateDried != "No value") ?  (dryModel?.dateDried)! : "")
         
        case 2:
            let teaModel = (model.fields.value as? TeaData)
            title.text = teaModel?.teaBlend
            date.text = teaModel?.date
            date2.text = teaModel?.batchNumber
        default:
            print("oh darn")
        }
           model.fields.isComplete() ? backgroundColor = UIColor(red: 212/255, green: 4/255, blue: 36/255, alpha: 0.4) : (backgroundColor = .clear)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override public func prepareForReuse() {
        super.prepareForReuse()
    }
    
    
}

final class DisplayFieldCell : UITableViewCell {
    
    let dispose = DisposeBag()
    var key = UILabel()
    var value = UILabel()
    var color = UIColor.clear
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(key)
        key.textAlignment = .left
        key.snp.makeConstraints{
            $0.height.equalToSuperview()
            $0.right.equalTo(contentView.snp.centerX)
            $0.left.equalToSuperview().inset(15)
        }
        contentView.addSubview(value)
        value.textAlignment = .left
        value.snp.makeConstraints{
            $0.height.equalToSuperview()
            $0.right.equalToSuperview().inset(15)
            $0.left.equalTo(contentView.snp.centerX)
        }
        backgroundView = nil
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override public func prepareForReuse() {
        super.prepareForReuse()
    }
    
}
