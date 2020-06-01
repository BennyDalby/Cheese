//
//  Extentions.swift
//  FranksCheese
//
//  Created by Test on 6/1/20.
//  Copyright © 2020 BennyTest. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    
    func AddAlert(title: String, message:String){
        
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

        self.present(alert, animated: true)
        
        
        
    }
    
}
