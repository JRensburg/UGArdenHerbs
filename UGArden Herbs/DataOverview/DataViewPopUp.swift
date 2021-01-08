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
    let model: dataModel
    var navdelgate: navDelegate? = nil
    var modelDict = [String:Any]()
    lazy var values = modelDict.sorted(by: {$0.0 < $1.0})
    let update = UIButton()
    let delete = UIButton()
    let remove = UIButton()
    
    init(model: dataModel){
        let screen = UIScreen.main.bounds
        self.model = model
        super.init(frame: CGRect(x: 0, y: 0, width: screen.width / 1.25, height: screen.height / 1.5))
        configureButtons()
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.darkGray.cgColor
        
        tableView.rx.setDelegate(self).disposed(by: dispose)
        backgroundColor = UIColor(red: 138/255, green: 158/255, blue: 87/255, alpha: 1)
        tableView.allowsSelection = false
        configureCells()
        layer.borderWidth = 1
        layer.borderColor = UIColor.darkGray.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    /**
     This function adds the edit and delete buttons to the view and also adds their handlers
     It also creates the constraints for both
    */
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
    
    /**
     This function adds the tableView to the superview and also binds the dictionary of data to the tableView
     */
    func configureCells(){
        tableView.register(DisplayFieldCell.self, forCellReuseIdentifier: "dryCell")
        addSubview(tableView)
        tableView.snp.makeConstraints{
            $0.width.equalToSuperview()//.inset(15)
            $0.top.equalTo(remove.snp.bottom)
            $0.height.equalToSuperview().multipliedBy(0.85) //was .78
            $0.centerX.equalToSuperview()
        }
        
        tableView.layer.borderWidth = 1
        
        modelDict = model.fields.value.dictionary
        
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

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    @objc func editTapped() -> Void {
        let formView = DataViewForm(style: .grouped, model: model)
        navdelgate?.navigate(viewController: formView)
    }
    
    @objc func deleteTapped() -> Void {
        var delUrls : String?
        if (model.fields.value is SeedingData) {
            delUrls = AirtableURLs.seedingBase+model.id
        }
        else if (model.fields.value is DryingData) {
            delUrls = AirtableURLs.dryingBase+model.id
        }
        else if (model.fields.value is TeaData) {
            delUrls = AirtableURLs.teaBase+model.id
        }
        delUrls?.append("?" + AirtableURLs.authentication)
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this entry?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {action in
            self.sendDelete(url: delUrls!)
            self.removeFromSuperview()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        navdelgate?.presentAlert(alert: alert)
    }
    
    func sendDelete(url: String){
        AF.request(url, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON{response in
            print(response)
            self.navdelgate?.refresh()
        }
    }
}
/**
 The class above is a UIView and thus has no access to the navigation controller. To get around this and push the edit form onto the screen, the class that presents this view also conforms to this protocol. This way, the UIView can still present ViewControllers with the information it contains. 
 */
protocol navDelegate {
    func navigate(viewController: DataViewForm)
    func presentAlert(alert: UIAlertController)
    func refresh()
}

