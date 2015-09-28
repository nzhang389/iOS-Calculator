//
//  calculatorBrain.swift
//  calculatorStanford
//
//  Created by Nathan Zhang on 9/6/15.
//  Copyright (c) 2015 Nathan Zhang. All rights reserved.
//

import Foundation

class calculatorBrain{
    
    private enum Op: Printable
    {
        case Operand(Double)
        case Variable(String)
        case BinaryOperation(String, (Double, Double) -> Double)
        case UnaryOperation(String, Double -> Double)
        var description: String{
            get{
                switch self{
                case .Operand(let operand):
                    return "\(operand)"
                case .BinaryOperation(let binOp, _):
                    return  binOp
                case .UnaryOperation(let unOp, _):
                    return unOp
                case .Variable(let symbol):
                    return symbol
                }
            }
        }
        
    }
    
    private var opStack = [Op]()
    var variableValues = [String:Double]()
    private var knownOps = [String: Op]()
    private var currentDiscription = [String]()
    
    init(){
        knownOps["+"] = Op.BinaryOperation("+", {$0+$1} )
        knownOps["-"] = Op.BinaryOperation("-", {$1-$0} )
        knownOps["*"] = Op.BinaryOperation("*",*)
        knownOps["/"] = Op.BinaryOperation("/", {$1 / $0} )
        knownOps["√"] = Op.UnaryOperation("√", {sqrt($0)})
        knownOps["sin"] = Op.UnaryOperation("sin", {sin($0)})
        knownOps["cos"] = Op.UnaryOperation("cos", {cos($0)})
    }

    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]){
        if !ops.isEmpty{
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op{
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result{
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_,let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result{
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result{
                        return (operation(operand1, operand2),op2Evaluation.remainingOps)
                    }
                }
            case .Variable(let variable):
                if let varNum = variableValues[variable]{
                    return(varNum, remainingOps)
                }
            }
        }
        return(nil, ops)
    }
    
    var discription: String{
        get{
            var dis = ""
            for(var index = 0; index < currentDiscription.count; index++){
                if(index != 0){
                    dis += currentDiscription[index]
                }
            }
            return dis
                //Int in currentDiscription{
                //dis += currentDiscription[index]
            
        }
            //plan: make another evaluate function add strings forward separated by a comma, an operation will replace the comma backwards
            //parenthesese????
        
    }

    private func updateDiscription(op: Op){
        switch op{
        case .Operand(let operand):
            currentDiscription.append(", ")
            currentDiscription.append("\(operand)")
        case .Variable(let operand):
            currentDiscription.append(", ")
            currentDiscription.append("\(operand)")
        case .UnaryOperation(let symbol, _):
            let index = findLastComma() + 1
            currentDiscription.insert(symbol, atIndex: index)
            currentDiscription.insert("(", atIndex: index+1)
            currentDiscription.append(")")
        case .BinaryOperation(let symbol, _):
            let index = findLastComma()
            if(symbol == "*" || symbol == "/"){
                let needsP = checkP(index)
            }else{
                currentDiscription.replaceRange(index...index, with: [" " + symbol + " "])
            }
        }
    }

    //ONLY USE COMMAS FOR PRINTING
    //USE EACH SPOT IN THE ARRAY AS A COMPLETED EXPRESSION
    
    
    //logic behind this method: if it enters a parentheses, the other stuff doesn't matter so we basically will ignore them. If it sees a +, it will need the parentheses, if it sees a *, it will surely not need the parentheses. hopefully this is true! jajaja
    //THIS METHOD DOESNT CHECK IF THE PREVIOUS SET OF NUMBERS IS NOT ORGANIZED YET
    // 3 + 4, 5 ... if they hit * we get fuckarinoed
    
    private func checkP(var index: Int) -> Bool{
        //checks if we have a + / -  after to need a parentheses
        var needsP = false
        var inParentheses = 0
        //+1 for open, -1 cor closed, only account for checkP if its 0
        for(index; index < currentDiscription.count; index++){
            if(currentDiscription[index] == "("){
                inParentheses++
            }else if(currentDiscription[index] == ")"){
                inParentheses--
            }else if( (currentDiscription[index] == "+" || currentDiscription[index] == "-") && inParentheses <= 0){
                needsP = true
                break
            }else if( (currentDiscription[index] == "*" || currentDiscription[index] == "/") && inParentheses <= 0){
                break
            }
        }
        return needsP
    }
    
    private func findLastComma() -> Int {
        var a = currentDiscription
        var index = a.count
        while(a.count>0 && ", " != a.removeLast()){
            index = a.count
        }
        return --index
    }
    
    func evaluate() -> Double?{
        let (result, remainder) = evaluate(opStack)
        print("This has a result of \(result) and the rest of opStack is") 
        //this currently keeps the whole operandStack and doesn't replace the already completed terms with the newer one. I may want to add something like opStack = remainder and then append result to keep opStak updated with computations we already know
        println(remainder)
        return result
    }
    
    func clear(){
        opStack = [Op]()
        println("The calculator has been reset")
        currentDiscription.removeAll(keepCapacity: false)
        //IS THIS THE WAY TO CLEAR ARRAYS
    }
    
    func pushOperand(operand: Double) -> Double?{
        opStack.append(Op.Operand(operand))
        updateDiscription(Op.Operand(operand))
        return evaluate()
    }
    
    func pushOperand(symbol: String) -> Double?{
        opStack.append(Op.Variable(symbol))
        updateDiscription(Op.Variable(symbol))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double?{
        if let operation = knownOps[symbol]{
            opStack.append(operation)
            updateDiscription(operation)
        }
        return evaluate()
    }
}