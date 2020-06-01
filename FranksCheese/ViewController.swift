//
//  ViewController.swift
//  FranksCheese
//
//  Created by Test on 5/29/20.
//  Copyright © 2020 BennyTest. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

  //  typealias CompletionHandler = (_ success:Bool) -> Void
    @IBOutlet weak var goButton: UIButton!
    var cheeseListVM = CheeseListViewModel()
    @IBOutlet weak var zipCodeField: UITextField!
    @IBOutlet weak var cheeseImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        zipCodeField.delegate = self
        setupCheeseImage()
        
        
        
    }
    
    @IBAction func goPressed(_ sender: Any) {
        
        zipCodeField.resignFirstResponder()
        
        guard let zipValue = zipCodeField.text
            else{
                return
        }
        
        if validationcheck(zipCodeField.text) == false {
            
             self.AddAlert(title: "Invalid", message:"please enter a valid zip code to continue")
            
            return
        }
        
        cheeseListVM.fetchListfromDBforZip(Int(zipValue)!, completionHandler1: { success,cheeseList,errordata in
            
            if !success {
                
                DispatchQueue.main.async {
                    
                    self.AddAlert(title: "Invalid", message:(errordata?.errorString)!)
                }
            }
            
            else {
                
                
                DispatchQueue.main.async {
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                           let nextViewController = storyBoard.instantiateViewController(withIdentifier: "listView") as! CheeseListViewController
                    nextViewController.text = self.zipCodeField.text ?? ""
                    nextViewController.tableList = cheeseList!
                           self.present(nextViewController, animated:true, completion:nil)
                }
                
            }
            
            
        })
        
       
        
    }
    
    
    
    func setupCheeseImage() {
        
        cheeseImage.layer.cornerRadius = 15.0
        cheeseImage.layer.masksToBounds = false
        cheeseImage.clipsToBounds = true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         
         textField.resignFirstResponder()
         return true
     }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let count = textField.text?.count
        if string == "" && count == 1 {
            
            goButton.setImage(UIImage(named: "FFC_arrow_inactive_right"), for: .normal)
            goButton.isEnabled = false
        }
        
        else {
            goButton.setImage(UIImage(named: "FFC_arrow_active_right"), for: .normal)
            goButton.isEnabled = true
        }
        
        
        
        
        return true
    }


}

   


func validationcheck(_ data: String?)-> Bool{
    
    if data == nil {
        
        return false
    }
    
    if data == "" {
        
        return false
    }
    
    if Int(data!) != nil {
        
        return true
    }
    
    else{
        
        return false
    }
}




class CheeseListViewModel {
    
     
    
    
    func fetchListfromDBforZip(_ zip:Int , completionHandler1: @escaping (Bool,[CheeseModel]?,Error?)->Void) {
        
        let env = Bundle.main.infoDictionary!
        let value = env["MY_API_BASE_URL_ENDPOINT"] as! String
        
        let session = URLSession.shared
        let urlString = value + "api/cheeselist.php?zip=" + String(zip)
        let url = URL(string: urlString)
        let task = session.dataTask(with: url!, completionHandler: { data, response, error in

            if let err = error {
                
                //perform error operation here
                
                 print(err.localizedDescription)
            }
            else{
                
                guard let
                dataResponse = data
                else {
            
                return
                    
                }
                
                do{
                     //here dataResponse received from a network request
                     let jsonResponse = try JSONSerialization.jsonObject(with:
                                            dataResponse, options: [])
                  //   print(jsonResponse) //Response result
                  
                guard let jsonDict = jsonResponse as? [String: Any] else {
                    
                      return
                }
              //  print(jsonDict)
                    guard let cheeseData = jsonDict["data"] as? [[String:Any]] else{
                        
                        //handle error condition here
                        
                        guard let errorParse = jsonDict["data"] as? String else{
                            
                            
                            return
                        }
                        
                        
                        let errormodel = Error(err: errorParse)
                        
                        completionHandler1(false,nil,errormodel)
                        
                        return
                    }
                    
                  //  print(cheeseData)
                    
                    var cheeseList = [CheeseModel]()
                    
                    for item in cheeseData{
                        
                        var cheesemodel = CheeseModel()
                        
                        cheesemodel.CheeseID = Int((item["CheeseID"] as! NSString).floatValue)
                        cheesemodel.OutOfStock = item["OutOfStock"] as! String
                        cheesemodel.CheeseName = item["CheeseName"] as! String
                        cheesemodel.Country = item["Country"] as? String
                        cheesemodel.Price = CGFloat((item["Price"] as! NSString).floatValue)
                         cheesemodel.Discount = CGFloat((item["Discount"] as! NSString).floatValue)
                        
                        
                        cheeseList.append(cheesemodel)
                    }
                
                completionHandler1(true,cheeseList,nil)
                
                
                } catch let parsingError {
                     print("Error", parsingError)
                }
            }
            
        })
        task.resume()
        
        
    }
    
    
}

struct CheeseModel: Decodable {
    
    enum Category: String, Decodable {
        case swift, combine, debugging, xcode
    }
    
    var CheeseID = Int()
    var CheeseName = String()
    var Country : String?
    var Price = CGFloat()
    var Discount : CGFloat?
    var OutOfStock = String()
    var Selected = false
    var imageString = String()
    
}

struct Error: Decodable {
    
    var errorString : String?
    
    init(err: String) {
        
        self.errorString = err
    }
    
}

