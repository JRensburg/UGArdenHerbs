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

class DataViewPopUp : UIView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{

    
   
    private let tableView = UITableView()
    let dispose = DisposeBag()
    let switchInt: Int
    var modelDict = [String:Any]()
    lazy var values = modelDict.sorted(by: {$0.0 < $1.0})
    let update = UIButton()
    let delete = UIButton()
    let remove = UIButton()
    let editBarButton = UIButton()
    
    init(section: Int, model: Any){
        let screen = UIScreen.main.bounds
        //self.model = model
        switchInt = section

        super.init(frame: CGRect(x: 0, y: 0, width: screen.width / 1.5, height: screen.height / 1.5))
        configureButtons()
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        tableView.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        backgroundColor = UIColor(red: 138/255, green: 158/255, blue: 87/255, alpha: 1)
        switch section {
        case 1:
            tableView.register(DisplayFieldCell.self, forCellReuseIdentifier: "dryCell")
            //self.model = model as? dryingModel
            //let modelInfo = Variable(model as? dryingModel)
            let data = (model as? dryingModel)?.fields
            modelDict = data.dictionary
            tableView.dataSource = self
            addSubview(tableView)
            tableView.snp.makeConstraints{
                $0.width.equalToSuperview().inset(15)
                $0.top.equalTo(remove.snp.bottom)
                $0.height.equalToSuperview().multipliedBy(0.78)
                $0.centerX.equalToSuperview()
            }
            
        default:
            //self.model = nil
            backgroundColor = .orange
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    func configureButtons(){
        
        addSubview(remove)
        remove.setImage(UIImage(named: "Return.png"), for: .normal)
    
        remove.imageView?.contentMode = .scaleAspectFit
        
        remove.snp.makeConstraints{
            $0.top.left.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(10)
            $0.width.equalToSuperview().dividedBy(4)
        }
        remove.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        addSubview(update)
        update.backgroundColor = UIColor(red: 208/255, green: 194/255, blue: 212/255, alpha: 1.0
        )
        update.setTitle("Edit Record", for: .normal)
        update.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
        update.snp.makeConstraints{
            $0.left.bottom.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(2)
            $0.height.equalToSuperview().dividedBy(10)
        }
        
        addSubview(delete)
        delete.setTitle("Delete Record", for: .normal)
        delete.backgroundColor = UIColor(red: 212/255, green: 4/255, blue: 36/255, alpha: 0.8)
        delete.snp.makeConstraints{
            $0.right.bottom.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(2)
            $0.height.equalToSuperview().dividedBy(10)
        }
        update.layer.cornerRadius = 10
        delete.layer.cornerRadius = 10
        
        editBarButton.setTitle("Submit Update", for: .normal)
        editBarButton.addTarget(self, action: #selector(SubmitClicked), for: .touchUpInside)
        tableView.backgroundView = nil
    }

    @objc func buttonTapped() -> Void {
        self.removeFromSuperview()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
       let action = UITableViewRowAction(style: .normal, title: "Submit This Row", handler: {_,_ in })
        action.backgroundColor = UIColor(red: 208/255, green: 194/255, blue: 212/255, alpha: 1.0)
        return [action]
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dryCell") as! DisplayFieldCell
        let newVal = values[indexPath.row]
        var val = newVal.value
        if val as? Int == -1 {
            val = "No value"
        }
        //print("dequeue row at")
        cell.value.delegate = self
        cell.value.text = "\(val)"
        cell.key.text = newVal.key; cell.value.placeholder = "\(val)"
        return cell
    
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let indexOf = (modelDict as NSDictionary).allKeys(for: textField)
        
    }
    
    @objc func editTapped() -> Void {
        //tableView.setEditing(!tableView.isEditing, animated: true)
        
        if (!self.subviews.contains(editBarButton)){
            addSubview(editBarButton)
            tableView.backgroundColor = UIColor(red: 208/255, green: 194/255, blue: 212/255, alpha: 1.0)
            editBarButton.snp.makeConstraints{
                $0.top.equalToSuperview()
                $0.right.equalToSuperview().inset(15)
                $0.height.equalToSuperview().dividedBy(10)
                $0.width.equalToSuperview().dividedBy(4)
            }
            
            update.setTitle("Done Editing", for: .normal)
        }
        else{
            editBarButton.removeFromSuperview()
            tableView.backgroundColor = .white
            update.setTitle("Edit Record", for: .normal)
        }
    }
    
    
    @objc func SubmitClicked() -> Void {
        print("foo")
    }
    
    @objc func keyBoardWillShow( _ notification: Notification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc func keyboardWillHide( _ notification: Notification){
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
