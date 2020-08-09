//
//  HomeViewController.swift
//  IOS-Calculator
//
//  Created by Immanuel Díaz on 03/08/20.
//  Copyright © 2020 Immanuel Díaz. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController {
    //MARK: Oulets
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var numberZero: UIButton!
    @IBOutlet weak var numberOne: UIButton!
    @IBOutlet weak var numberTwo: UIButton!
    @IBOutlet weak var numberThree: UIButton!
    @IBOutlet weak var numberFour: UIButton!
    @IBOutlet weak var numberFive: UIButton!
    @IBOutlet weak var numberSix: UIButton!
    @IBOutlet weak var numberSeven: UIButton!
    @IBOutlet weak var numberEight: UIButton!
    @IBOutlet weak var numberNine: UIButton!
    
    
    //MARK: Operators
    
    @IBOutlet weak var operatorAC: UIButton!
    @IBOutlet weak var operatorPlusLess: UIButton!
    @IBOutlet weak var operatorPorcent: UIButton!
    @IBOutlet weak var operatorResult: UIButton!
    @IBOutlet weak var operatorPlus: UIButton!
    @IBOutlet weak var operatorMinus: UIButton!
    @IBOutlet weak var operatorDivision: UIButton!
    @IBOutlet weak var operatorMultiplication: UIButton!
    @IBOutlet weak var numberDecimal: UIButton!
    
    //MARK: Variables
    
    private var total:Double = 0 //total
    private var temp:Double=0 //Valor por pantalla
    private var operating:Bool=false //Indicar si ha seleccionado operador
    private var decimal:Bool=false //Indicar si el valor es decimal
    private var operation:OperationType =  .NONE
    
    
    //MARK: Constantes
    private let kDecimalSeparator = Locale.current.decimalSeparator
    private let kMaxLength = 9
    private let kTotal = "total"
 
    
    private enum OperationType {
        case NONE,ADDICION,SUBSTRACTION,DIVISION,PORCENT,MULTIPLICATION
    }
    
    
    //Formateo de valores auxiliares
    private let auxFormatter : NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 100
        return formatter
    }()
    
    //Formateo de valores auxiliares
    private let auxTotalFormatter : NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = ""
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 100
        return formatter
    }()
    
    //Formateo de valores por pantalla por defecto
    private let printFormatter : NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = locale.groupingSeparator
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 9
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 8
        return formatter
    }()
    
    //Formateo de valores por pantalla en formato cientifico
    private let printScientificFormatter : NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.numberStyle = .scientific
        formatter.minimumFractionDigits = 3
        formatter.exponentSymbol = "e"
        return formatter
    }()
    
    //MARK: Init
    //    Declaration of the constructor app
    init() {
        super.init(nibName:nil,bundle:nil)
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:  Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        

        numberDecimal.setTitle(kDecimalSeparator, for: .normal)
        total = UserDefaults.standard.double(forKey: kTotal)
        result()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //UI
        numberZero.round()
        numberOne.round()
        numberTwo.round()
        numberThree.round()
        numberFour.round()
        numberFive.round()
        numberSix.round()
        numberSeven.round()
        numberEight.round()
        numberNine.round()
        numberDecimal.round()
        operatorAC.round()
        operatorPlusLess.round()
        operatorPorcent.round()
        operatorResult.round()
        operatorPlus.round()
        operatorMinus.round()
        operatorDivision.round()
        operatorMultiplication.round()
    }

    
    
    //MARK: Buttons actions
    
    @IBAction func operatorACAction(_ sender: UIButton) {
        clear()
        
        sender.shine()
    }
    
    
    @IBAction func operatorPlusLessAction(_ sender: UIButton) {
        temp = temp * (-1)
        resultLabel.text = printFormatter.string(from: NSNumber(value:temp))
        sender.shine()
    }
    
    
    @IBAction func operatorPorcentAction(_ sender: UIButton) {
        if(operation != .PORCENT){
            result()
        }
        operating = true
        operation = .PORCENT
        result()
        sender.shine()
    }
    
    @IBAction func operatorDivisionAction(_ sender: UIButton) {
        if(operation != .NONE){
            result()
        }
              operating = true
              operation = .DIVISION
         sender.selectOperation(true)
        sender.shine()
    }
    
    @IBAction func operatorMultiplicationAction(_ sender: UIButton) {
        if(operation != .NONE){
            result()
        }
              operating = true
              operation = .MULTIPLICATION
         sender.selectOperation(true)
        sender.shine()
    }
    
    @IBAction func operatorMinusAction(_ sender: UIButton) {
        if(operation != .NONE){
            result()
        }
                
              operating = true
              operation = .SUBSTRACTION
         sender.selectOperation(true)
                sender.shine()
    }
    
    @IBAction func operatorPlusAction(_ sender: UIButton) {
       if(operation != .NONE){
            result()
        }
        operating = true
        operation = .ADDICION
        sender.selectOperation(true)
        sender.shine()
    }
    
    @IBAction func operatorResultAction(_ sender: UIButton) {
        result()
        sender.shine()
    }
    
    
    
    @IBAction func numberDecimalAction(_ sender: UIButton) {
        let currentTemp = auxTotalFormatter.string(from: NSNumber(value:temp))!
        
        if(operating && currentTemp.count>=kMaxLength){
            return
        }
        resultLabel.text = resultLabel.text! + kDecimalSeparator!
        decimal = true
        
        
        selectVisualOperation()
        sender.shine()
    }
    
    //sender indicaa el elemento que manda la accion
    @IBAction func numberAction(_ sender: UIButton) {
        operatorAC.setTitle("C", for: .normal)
        var currentTemp = auxTotalFormatter.string(from: NSNumber(value:temp))!
        if(!operating && currentTemp.count>=kMaxLength){
            return
        }
        currentTemp = auxFormatter.string(from: NSNumber(value:temp))!
        
        //Se selecciono una operacion
        
        if(operating){
            total = total == 0 ? temp : total
            resultLabel.text = ""
            currentTemp = ""
            operating = false
        }
        
        //Se selecciono un decimal
        if (decimal){
            currentTemp = "\(currentTemp)\(kDecimalSeparator!)"
            decimal=false
        }
        
        let number = sender.tag
        temp = Double(currentTemp + String(number))!
        resultLabel.text = printFormatter.string(from: NSNumber(value:temp))
        selectVisualOperation()
        sender.shine()
        
    }
    
    
    //Limpiar los valores
    private func clear(){
        operation = .NONE
        operatorAC.setTitle("AC", for: .normal)
        if (temp != 0 ){
            temp=0
            resultLabel.text="0"
            
        }else{
            total=0
            result()
        }
    }
    
    //Obtiene el resultado total
    private func result(){
        switch operation {
        case .NONE:
            //Ninguna operacion
              break
        case .ADDICION:
            total = total + temp
            break
        case .SUBSTRACTION:
            total = total - temp
            break
        case .MULTIPLICATION:
            total = total * temp
            break
        case .DIVISION:
            total = total / temp
            break
        case .PORCENT:
            temp = temp / 100
            total = temp
            break
        }
        
        if let currentTotal = auxTotalFormatter.string(from: NSNumber(value:total)),currentTotal.count > kMaxLength {
            resultLabel.text = printScientificFormatter.string(from: NSNumber(value:total))
        }else{
             resultLabel.text = printFormatter.string(from: NSNumber(value:total))
        }
        
        operation = .NONE
        selectVisualOperation()
        UserDefaults.standard.set(total,forKey: kTotal)
        
    
}
    //Muestra de manera visual la operacion seleccionada
    private func selectVisualOperation(){
        if(!operating){
            //No se  esta operando
            operatorPlus.selectOperation(false)
            operatorMinus.selectOperation(false)
            operatorMultiplication.selectOperation(false)
            operatorDivision.selectOperation(false)
        }else{
            switch operation {
                
            case .NONE,.PORCENT:
                operatorPlus.selectOperation(false)
                operatorMinus.selectOperation(false)
                operatorMultiplication.selectOperation(false)
                operatorDivision.selectOperation(false)
                break
            case .ADDICION:
                operatorPlus.selectOperation(true)
                operatorMinus.selectOperation(false)
                operatorMultiplication.selectOperation(false)
                operatorDivision.selectOperation(false)
                break
            case .SUBSTRACTION:
                operatorPlus.selectOperation(false)
                operatorMinus.selectOperation(true)
                operatorMultiplication.selectOperation(false)
                operatorDivision.selectOperation(false)
                break
            case .DIVISION:
                operatorPlus.selectOperation(false)
                operatorMinus.selectOperation(false)
                operatorMultiplication.selectOperation(false)
                operatorDivision.selectOperation(true)
                break
            case .MULTIPLICATION:
                operatorPlus.selectOperation(false)
                operatorMinus.selectOperation(false)
                operatorMultiplication.selectOperation(true)
                operatorDivision.selectOperation(false)
                break
            }
    }
}
}


