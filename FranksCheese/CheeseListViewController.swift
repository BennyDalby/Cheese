//
//  CheeseListViewController.swift
//  FranksCheese
//
//  Created by Test on 5/29/20.
//  Copyright © 2020 BennyTest. All rights reserved.
//

import UIKit

class CheeseListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
   
    
    var text = String()
    var tableList = [CheeseModel]()
    let cellID = "cheeseCell"
    var cellStatus = [Bool]()
    var searchListbyName = [CheeseModel]()
    var searchListByCountry = [CheeseModel]()
    var finalList = [CheeseModel]()

    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var manualLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchSegment: UISegmentedControl!
    @IBOutlet weak var cheeseTableView: UITableView!
    @IBAction func backButtonPressed(_ sender: Any) {
        
        tableList.removeAll()
        searchListbyName.removeAll()
        searchListByCountry.removeAll()
        
        self.dismiss(animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

     //   print(text)
        // Do any additional setup after loading the view.
        cheeseTableView.register(CheeseCell.self, forCellReuseIdentifier: cellID)
        
        cheeseTableView.delegate = self
        cheeseTableView.dataSource = self
        
        cellStatus = Array(repeating: false, count: tableList.count)
        searchListByCountry = tableList
        searchListbyName = tableList
        
        searchTextField.delegate = self
        

        searchSegment.addTarget(self, action: #selector(mapTypeChanged(_:)), for: .valueChanged)
        
        searchTextField.isHidden = true
        manualLabel.isHidden = false
        
        layerOutAddtoCartButton()
        loadImages()
        
        addToCartButton.titleLabel?.font = UIFont(name: "CeraPro-Black", size: 14.0)

    }
    
    func loadImages() {
        
        for i in 0...tableList.count - 1 {
            
            if i % 5 == 0 {
                
                tableList[i].imageString = "FFC_logo_1"
            }
            
            else if i % 3 == 0 {
                
                 tableList[i].imageString = "cheddar"
            }
            
            else if i % 2 == 0 {
                
                tableList[i].imageString = "mozzarella"
            }
            
            else {
                
                tableList[i].imageString = "FFC_logo_1"
            }
        }
    }
    
    func layerOutAddtoCartButton() {
        
        addToCartButton.layer.cornerRadius = 10.0
        addToCartButton.layer.masksToBounds = false
    }
    
   @objc func mapTypeChanged(_ segControl: UISegmentedControl){

    searchListByCountry = tableList
    searchListbyName = tableList
    searchTextField.text = ""
    searchTextField.resignFirstResponder()
    cheeseTableView.reloadData()
    cheeseTableView.setNeedsLayout()
    
    if segControl.selectedSegmentIndex == 0 {
        
        searchTextField.isHidden = true
        manualLabel.isHidden = false
       
    }
    else{
        
        searchTextField.isHidden  = false
        manualLabel.isHidden = true
        
        if segControl.selectedSegmentIndex == 1 {
            
            searchTextField.placeholder = "Search by NAME..."
            
        }
        else {
            
             searchTextField.placeholder = "Search by COUNTRY..."
        }
        
    }
    
}
  
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let concurentQueue =  DispatchQueue(label: "com.queue.Concurrent", attributes: .concurrent)
               
        let value = textField.text!+string
        let count = textField.text?.count
               concurentQueue.async {
                if string == "" && count == 1 {
                    
                    self.searchListbyName = self.tableList
                    self.searchListByCountry = self.tableList
                    
                }
                else {
                    
                    if self.searchSegment.selectedSegmentIndex == 1 {
                        
                          self.searchListbyName = self.findSearchListByName(value)
                    }
                    else if self.searchSegment.selectedSegmentIndex == 2 {
                     
                           self.searchListByCountry = self.findSearchListByCountry(value)
                    }
              
                }
                   
                   DispatchQueue.main.async {
                       
                       self.cheeseTableView.reloadData()
                       self.cheeseTableView.setNeedsLayout()
                   }
                   
               }
        
        return true
    }
    
    
    
    
    func findSearchListByName(_ textValue: String?)-> [CheeseModel] {
        
        var searchList = [CheeseModel]()
        
        for item in tableList {
            
            let name = item.CheeseName
            
            if let range3 = name.range(of:String(textValue!) , options: .caseInsensitive) {
             
                 searchList.append(item)
            }
            
          
        }
        
        return searchList
        
    }
    
    
    func findSearchListByCountry(_ textValue: String?)-> [CheeseModel] {
        
        var searchList = [CheeseModel]()
        
        for item in tableList {
            
            if let name = item.Country {
                
                if let range3 = name.range(of:String(textValue!) , options: .caseInsensitive) {
                           
                               searchList.append(item)
                          }
            }
            
          
            
          
        }
        
        return searchList
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           
        if searchSegment.selectedSegmentIndex == 0 {
            
            return tableList.count
        }
        else if searchSegment.selectedSegmentIndex == 1 {
            
            return searchListbyName.count
        }
        else{
            
            return searchListByCountry.count
        }
        
        
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        if searchSegment.selectedSegmentIndex == 0 {
            
            cell.textLabel?.text = tableList[indexPath.row].CheeseName
            // var value = "\(tableList[indexPath.row].Price)"
            cell.imageView?.image = UIImage(named:tableList[indexPath.row].imageString ) // TODO:
             let countryValue = tableList[indexPath.row].Country ?? ""
             cell.detailTextLabel?.text = "Price = " + String(format: "%.2f",tableList[indexPath.row].Price ) + ", " + "Discount = " + String(format: "%.0f",tableList[indexPath.row].Discount ?? 0.00 ) + "%" + ", " + countryValue
            
            
             
             cell.detailTextLabel?.numberOfLines = 2
            
        }
        
        else if searchSegment.selectedSegmentIndex == 1 {
            
            
            cell.textLabel?.text = searchListbyName[indexPath.row].CheeseName
            // var value = "\(tableList[indexPath.row].Price)"
            cell.imageView?.image = UIImage(named: searchListbyName[indexPath.row].imageString) // TODO:
             let countryValue = searchListbyName[indexPath.row].Country ?? ""
             cell.detailTextLabel?.text = "Price = " + String(format: "%.2f",searchListbyName[indexPath.row].Price ) + ", " + "Discount = " + String(format: "%.0f",searchListbyName[indexPath.row].Discount ?? 0.00 ) + "%" + ", " + countryValue
             
             cell.detailTextLabel?.numberOfLines = 2
            
            
        }
        else {
            
            
            cell.textLabel?.text = searchListByCountry[indexPath.row].CheeseName
                       // var value = "\(tableList[indexPath.row].Price)"
                        cell.imageView?.image = UIImage(named: searchListByCountry[indexPath.row].imageString) // TODO:
                        let countryValue = searchListByCountry[indexPath.row].Country ?? ""
                        cell.detailTextLabel?.text = "Price = " + String(format: "%.2f",searchListByCountry[indexPath.row].Price ) + ", " + "Discount = " + String(format: "%.0f",searchListByCountry[indexPath.row].Discount ?? 0.00 ) + "%" + ", " + countryValue
                        
                        cell.detailTextLabel?.numberOfLines = 2
            
            
        }
        
        
        
        return cell

       }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100.0
    }
       
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var cheeseItem = CheeseModel()
        
        if searchSegment.selectedSegmentIndex == 0 {
            
             cheeseItem = tableList[indexPath.row]

            
        }
        
        else if searchSegment.selectedSegmentIndex == 1 {
            
             cheeseItem = searchListbyName[indexPath.row]
            
        }
        else {
            
            cheeseItem = searchListByCountry[indexPath.row]
        }
        
        
        if cheeseItem.Selected {
            
            if let cell = tableView.cellForRow(at: indexPath) {
                              cell.contentView.backgroundColor = UIColor.white
                          }
        }
        
        else {
            
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.contentView.backgroundColor = UIColor(red: 238/255.0, green: 140/255.0, blue: 29.0/255.0, alpha: 1.0)
            }
            
        }
        
        cheeseItem.Selected = cheeseItem.Selected == true ? false : true
        
        if searchSegment.selectedSegmentIndex == 0 {
            
            tableList[indexPath.row] = cheeseItem
            
            searchListbyName = updateList(searchListbyName, cheeseItem)
            
//            for i in 0...searchListbyName.count - 1 {
//
//                if searchListbyName[i].CheeseID == cheeseItem.CheeseID {
//
//                    searchListbyName[i] = cheeseItem
//                }
//            }
            
             searchListByCountry = updateList(searchListByCountry, cheeseItem)
            
//            for i in 0...searchListByCountry.count - 1 {
//
//                if searchListByCountry[i].CheeseID == cheeseItem.CheeseID {
//
//                    searchListByCountry[i] = cheeseItem
//                }
//            }
        }
        
        else if searchSegment.selectedSegmentIndex == 1 {
            
            searchListbyName[indexPath.row] = cheeseItem
            
             tableList = updateList(tableList, cheeseItem)
            
//            for i in 0...tableList.count - 1 {
//
//                if tableList[i].CheeseID == cheeseItem.CheeseID {
//
//                    tableList[i] = cheeseItem
//                }
//            }
            
              searchListByCountry = updateList(searchListByCountry, cheeseItem)
            
//            for i in 0...searchListByCountry.count - 1 {
//
//                if searchListByCountry[i].CheeseID == cheeseItem.CheeseID {
//
//                    searchListByCountry[i] = cheeseItem
//                }
//            }
            
            
        }
        
        else {
            
            searchListByCountry[indexPath.row] = cheeseItem
            
             searchListbyName = updateList(searchListbyName, cheeseItem)
//            for i in 0...searchListbyName.count - 1 {
//
//                if searchListbyName[i].CheeseID == cheeseItem.CheeseID {
//
//                    searchListbyName[i] = cheeseItem
//                }
//            }
            
            tableList = updateList(tableList, cheeseItem)
            
//            for i in 0...tableList.count - 1 {
//
//                if tableList[i].CheeseID == cheeseItem.CheeseID {
//
//                    tableList[i] = cheeseItem
//                }
//            }
//
            
        }
        
        
        
        let status = determineButtonStatus(tableList)
        
        if status {
            
            addToCartButton.backgroundColor = UIColor(red: 238/255.0, green: 140/255.0, blue: 39.0/255.0, alpha: 1.0)
        }
        
        else {
            
            addToCartButton.backgroundColor = UIColor.gray
        }
        
    }
    
    func determineButtonStatus(_ tableList: [CheeseModel])->Bool {
        
        for item in tableList {
            
            if item.Selected {
                
                return true
            }
        }
        
        return false
    }
    
    
    func updateList(_ data:[CheeseModel],_ item:CheeseModel)->[CheeseModel] {
        
        var list = data
        
        for i in 0...list.count - 1 {
            
            if list[i].CheeseID == item.CheeseID {
                
                list[i] = item
            }
        }
     
        return list
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if searchSegment.selectedSegmentIndex == 0 {
            
            if tableList[indexPath.row].Selected {
                
                cell.contentView.backgroundColor = UIColor(red: 238/255.0, green: 140/255.0, blue: 29.0/255.0, alpha: 1.0)
                             
            }
                
            else {
                
                cell.contentView.backgroundColor = UIColor.white
                
            }
            
        }
        
        else if searchSegment.selectedSegmentIndex == 1 {
            
            if searchListbyName[indexPath.row].Selected {
                
                cell.contentView.backgroundColor = UIColor(red: 238/255.0, green: 140/255.0, blue: 29.0/255.0, alpha: 1.0)
                             
            }
                
            else {
                
                cell.contentView.backgroundColor = UIColor.white
                
            }
            
        }
        
        else {
            
            if searchListByCountry[indexPath.row].Selected {
                
                cell.contentView.backgroundColor = UIColor(red: 238/255.0, green: 140/255.0, blue: 29.0/255.0, alpha: 1.0)
                             
            }
                
            else {
                
                cell.contentView.backgroundColor = UIColor.white
                
            }
            
            
        }
        
        
    }
    
    
    
    @IBAction func addToCartPressed(_ sender: Any) {
        
        finalList.removeAll()
        
        for item in tableList {
            
            if item.Selected {
                
                finalList.append(item)
            }
        }
        
        if finalList.count > 0 {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
               let nextViewController = storyBoard.instantiateViewController(withIdentifier: "addToCart") as! AddtoCartViewController
        nextViewController.finalList = finalList
               self.present(nextViewController, animated:true, completion:nil)
            
        }
        
        else {
            
            
            
        }
        
        
    }
    
}




class CheeseCell :  UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Customize imageView like you need
        self.imageView?.frame = CGRect(x: 20, y: 10, width: 60, height: 60)
        self.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        // Costomize other elements
        
//        self.textLabel?.font = UIFont(name: "CeraPro-Bold", size: 18)
//        
//        self.detailTextLabel?.font = UIFont(name: "CeraProRegular", size: 14)
        
      
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
