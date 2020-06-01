//
//  AddtoCartViewController.swift
//  FranksCheese
//
//  Created by Test on 5/31/20.
//  Copyright © 2020 BennyTest. All rights reserved.
//

import UIKit

class AddtoCartViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    @IBOutlet weak var addToCartList: UITableView!
    
    var finalList = [CheeseModel]()
    var cellID = "addToCart"
    

    override func viewDidLoad() {
        super.viewDidLoad()

         addToCartList.register(CartCell.self, forCellReuseIdentifier: cellID)
        
        addToCartList.delegate = self
        addToCartList.dataSource = self
        
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        finalList.removeAll()
        
        self.dismiss(animated: true, completion: nil)
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        finalList.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
         let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        cell.textLabel?.text = finalList[indexPath.row].CheeseName
        
        let cost = finalList[indexPath.row].Price - finalList[indexPath.row].Price*finalList[indexPath.row].Discount!/100
        
        cell.detailTextLabel?.text = "Price = $" + String(format: "%.2f",cost)
        cell.detailTextLabel?.numberOfLines = 2
        
        cell.imageView?.image = UIImage(named: finalList[indexPath.row].imageString)
      
        
        
        
        
        
        
        cell.selectionStyle = .none
        
        return cell
        
       }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}


class CartCell :  UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    override func layoutSubviews() {
           super.layoutSubviews()
           // Customize imageView like you need
           self.imageView?.frame = CGRect(x: 20, y: 10, width: 60, height: 60)
           self.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
           // Costomize other elements
        
//         self.textLabel?.font = UIFont(name: "CeraPro-Bold", size: 18)
//        
//        self.textLabel?.frame = CGRect(x: self.textLabel!.frame.origin.x, y: self.textLabel!.frame.origin.y, width: 90, height:self.textLabel!.frame.size.height )
      //  self.textLabel?.contentMode = UIView.ContentMode.scaleAspectFit
       
       }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
