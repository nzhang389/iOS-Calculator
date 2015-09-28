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
    
    
    @IBOutlet weak var descriptionUILabel: UILabel!
    
    var start = true
    var decimal = false
    var firstNum = true
    var brain = calculatorBrain()
    
      //WORKING ON MAKE THIS DISPLAY RN
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if(start) {
            decimal = false
            display.text = "0"
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
                display.text = digit
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
        descriptionUILabel.text = "0"
    }
    
    @IBAction func operate(sender: UIButton) {
        if(!start){
            enter()
        }
        let operation = sender.currentTitle!
        displayNum = brain.performOperation(operation)
        descriptionUILabel.text = brain.discription
    }
    

    @IBAction func enter() {
        start = true
        displayNum = brain.pushOperand(displayNum!)
        descriptionUILabel.text = brain.discription
    }
    
    var displayNum: Double? {
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            if let valid = newValue{
                display.text = "\(newValue!)"
            }else{
                clear()//automatically resets calculator if an error is seen
                display.text = "ERROR"
            }
            start = true
        }
    }
    
}
