//
//  TableViewCells.swift
//  Capstone
//
//  Created by Jaco Van Rensburg on 12/3/18.
//  Copyright © 2018 NMI. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

public final class CustomCell: UITableViewCell {
    
    var model: dataModel?
    
    var title = UILabel()
    var middleColumn = UILabel()
    var rightColumn = UILabel()
    var color = UIColor.clear
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(title)
        title.snp.makeConstraints{
            $0.height.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(4)
            $0.left.equalToSuperview().inset(60)
        }
        contentView.addSubview(middleColumn)
        middleColumn.textAlignment = .center
        middleColumn.snp.makeConstraints{
            $0.height.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(4)
            $0.centerX.equalToSuperview()
        }
        contentView.addSubview(rightColumn)
        rightColumn.snp.makeConstraints{
            $0.height.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(4)
            $0.right.equalToSuperview().offset(20)
        }
    }
    
    func layoutCell(model: dataModel){
        self.model = model
        populateFromModel(model: model.fields.value)
        model.fields.isComplete() ? backgroundColor = UIColor(red: 212/255, green: 4/255, blue: 36/255, alpha: 0.4) : (backgroundColor = .clear)
        if (model.fields.value is BlankItem){
            backgroundColor = UIColor(red: 138/255, green: 158/255, blue: 87/255, alpha: 1)
            isUserInteractionEnabled = false
        }
    }

    func populateFromModel(model: DataType){
        let cellModel = model.asCellItem()
        title.text = cellModel.titleColumn
        middleColumn.text = cellModel.middleColumn
        rightColumn.text = cellModel.rightColumn
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override public func prepareForReuse() {
        super.prepareForReuse()
        model = nil
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
