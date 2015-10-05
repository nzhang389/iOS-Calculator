//
//  ViewController.swift
//  calculatorStanford
//
//  Created by Nathan Zhang on 8/16/15.
//  Copyright (c) 2015 Nathan Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    
    
    var start = true
    var decimal = false
    var firstNum = true
    var brain = calculatorBrain()
    
      //WORKING ON MAKE THIS DISPLAY RN
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if(start) {
            decimal = false
            display.text = brain.discription + "0"
        }
        if(digit == "."){
            if(decimal){}
            else{
                display.text = display.text! + digit
                decimal = true
                start = false
            }
        }
        else{
            if(start){
                display.text = brain.discription + digit
                start = false
            }
            else{
                display.text = display.text! + digit
            }
        }
    }

    
    @IBAction func appendSymbol(sender: UIButton) {
        let symbol = sender.currentTitle!
        switch symbol{
            case "pi":
                displayNum = M_PI
        default: break
        }
        start = false
    }
  
    @IBAction func clear() {
        brain.clear()
        start = true
        displayNum = 0
        firstNum = true
    }
    
    @IBAction func operate(sender: UIButton) {
        if(!start){
            enter()
        }
        let operation = sender.currentTitle!
        displayNum = brain.performOperation(operation)
    }
    

    @IBAction func enter() {
        start = true
        displayNum = brain.pushOperand(displayNum!)
    }
    
    var displayNum: Double? {
        get{
            let currentD = display.text!
            let myStringArr = currentD.componentsSeparatedByString("=")
            let inputNum = myStringArr[1]
            return NSNumberFormatter().numberFromString(inputNum)!.doubleValue
        }
        set{
            if let valid = newValue{
                display.text = brain.discription + "\(newValue!)"
            }else{
                clear()//automatically resets calculator if an error is seen
                display.text = "ERROR"
            }
            start = true
        }
    }
    
}
