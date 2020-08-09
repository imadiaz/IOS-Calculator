//
//  UIButtonExtension.swift
//  IOS-Calculator
//
//  Created by Immanuel Díaz on 05/08/20.
//  Copyright © 2020 Immanuel Díaz. All rights reserved.
//

import UIKit
private let oragne = UIColor(red: 254/255, green: 148/255, blue: 0/255, alpha: 1)
extension UIButton {
    // Borde redondo
    func round() {
        layer.cornerRadius = bounds.height / 2
        clipsToBounds = true
    }
    
    // Brilla
       func shine() {
           UIView.animate(withDuration: 0.1, animations: {
               self.alpha = 0.5
           }) { (completion) in
               UIView.animate(withDuration: 0.1, animations: {
                   self.alpha = 1
               })
           }
       }
    
    //Apariencia del boton de operacion
    func selectOperation(_ selected:Bool){
        backgroundColor = selected ? .white : oragne
        setTitleColor(selected ? oragne : .white, for: .normal)
    }
}
