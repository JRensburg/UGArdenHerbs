//
//  DataViewPopUp.swift
//  Capstone
//
//  Created by Jaco Van Rensburg on 11/8/18.
//  Copyright © 2018 NMI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

class DataViewPopUp : UIView, UITableViewDelegate {

    private let tableView = UITableView()
    let dispose = DisposeBag()
    let switchInt: Int
    let model: dataModel
    var navdelgate: navDelegate? = nil
    var modelDict = [String:Any]()
    lazy var values = modelDict.sorted(by: {$0.0 < $1.0})
    let update = UIButton()
    let delete = UIButton()
    let remove = UIButton()
    let urls = [AirtableURls.seedingBase,AirtableURls.dryingBase,AirtableURls.teaBase]
    
    init(section: Int, model: dataModel){
        let screen = UIScreen.main.bounds
        self.model = model
        switchInt = section
        super.init(frame: CGRect(x: 0, y: 0, width: screen.width / 1.25, height: screen.height / 1.5))
        configureButtons()
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.darkGray.cgColor//black.cgColor
        
        tableView.rx.setDelegate(self).disposed(by: dispose)
        backgroundColor = UIColor(red: 138/255, green: 158/255, blue: 87/255, alpha: 1)
        tableView.allowsSelection = false
        configureCells(section: section)
        layer.borderWidth = 1
        layer.borderColor = UIColor.darkGray.cgColor//black.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    func configureButtons(){
        
        addSubview(remove)
  
        remove.setTitle("Dismiss", for: .normal)
        remove.snp.makeConstraints{
            $0.top.left.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(12)
            $0.width.equalToSuperview().dividedBy(4)
        }
        remove.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        addSubview(update)
        addSubview(delete)
        delete.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        //delete.setTitle("Delete Record", for: .normal)
        delete.setImage(UIImage(named: "bettererTrash.png"), for: .normal)
        delete.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(12)
            $0.width.equalToSuperview().dividedBy(11)
            $0.right.equalToSuperview()
        }
    update.setImage(UIImage(named: "evenBetterEdit.png"), for: .normal)
    update.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
    update.snp.makeConstraints{
        $0.top.equalToSuperview()
        $0.height.equalToSuperview().dividedBy(12)
        $0.width.equalToSuperview().dividedBy(11)
        $0.right.equalTo(delete.snp.left)
    }
        update.imageEdgeInsets = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)

        tableView.backgroundView = nil
    }
    
    func configureCells(section: Int){
        tableView.register(DisplayFieldCell.self, forCellReuseIdentifier: "dryCell")
        addSubview(tableView)
        tableView.snp.makeConstraints{
            $0.width.equalToSuperview()//.inset(15)
            $0.top.equalTo(remove.snp.bottom)
            $0.height.equalToSuperview().multipliedBy(0.85) //was .78
            $0.centerX.equalToSuperview()
        }
        //tableView.rowHeight = 30.0
        tableView.layer.borderWidth = 1
        switch section {
        case 0:
            let data = model.fields.value as! SeedingData
            modelDict = data.dictionary
        case 1:
            // Case 1 means that segmented control was "Drying"
            let data = model.fields.value as! DryingData
            modelDict = data.dictionary
        case 2:
            let data = model.fields.value as! TeaData
            modelDict = data.dictionary
        default:
            //self.model = nil
            backgroundColor = .orange
        }
        
        Observable.from(optional: values).bind(to: tableView.rx.items(cellIdentifier: "dryCell", cellType: DisplayFieldCell.self)){index, element, cell in
            cell.key.text = element.key
            var val = element.value
            if val as? Int == -1 {
                val = "No Number"
            }
            cell.value.text = "\(val)"
            }.disposed(by: dispose)
    }
    
    @objc func buttonTapped() -> Void {
        self.removeFromSuperview()
    }
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//       let action = UITableViewRowAction(style: .normal, title: "Submit This Row", handler: {_,_ in })
//        action.backgroundColor = UIColor(red: 208/255, green: 194/255, blue: 212/255, alpha: 1.0)
//        return [action]
//    }
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
//        return UITableViewCellEditingStyle.delete
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    @objc func editTapped() -> Void {
        let formView = DataViewForm(style: .grouped, model: self.model, section: self.switchInt)
        navdelgate?.navigate(viewController: formView)
    }
    
    @objc func deleteTapped() -> Void {
        var delUrls : String?
        if ((model.fields.value as? SeedingData) != nil) {
            delUrls = urls[0]+model.id
        }
        else if ((model.fields.value as? DryingData) != nil) {
            delUrls = urls[1]+model.id
        }
        else if ((model.fields.value as? TeaData) != nil) {
            delUrls = urls[2]+model.id
        }
        delUrls?.append("?" + AirtableURls.authentication)
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this entry?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {action in
            self.sendDelete(url: delUrls!)
            self.removeFromSuperview()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        navdelgate?.presentAlert(alert: alert)
    }
    
    func sendDelete(url: String){
        Alamofire.request(url, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON{response in
            print(response)
            self.navdelgate?.refresh()
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch: UITouch? = touches.first
//        if touch?.view == self {
//            backgroundColor = .red
//        }
//
//    }
}

protocol navDelegate {
    func navigate(viewController: DataViewForm)
    func presentAlert(alert: UIAlertController)
    func refresh()
}

