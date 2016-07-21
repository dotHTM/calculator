//
//  CalculatorBrain.swift
//  calculator
//
//  Created by Michael Cramer on 7/13/16.
//  Copyright © 2016 Michael Cramer. All rights reserved.
//

import Foundation

let M_PHI = 1.6180339887498948482

class CalculatorBrain
{
    // MARK: - Variables and such

    var calculationErrorMessage = " "
    var description = " "
    var isPartialResult = false
    var result: Double {
        get{
            return accumulator
        }
    }
    
    // MARK: Private
    
    private var accumulator = 0.0
    private var internalProgram = [AnyObject]()
    
    // MARK: Clear
    
    func clear() {
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
        description = " "
        calculationErrorMessage = " "
    }
    
    // MARK: - Operations
    
    func setOperand(operand: Double) {
        accumulator = operand
        internalProgram.append(operand)
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π"   : Operation.Constant(M_PI),
        "e"   : Operation.Constant(M_E),
        "ɸ"   : Operation.Constant(M_PHI),
        "√"   : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "sin" : Operation.UnaryOperation(sin),
        "tan" : Operation.UnaryOperation(tan),
        "1/x" : Operation.UnaryOperation({
            if $0 != 0 {
                return 1.0 / $0
            } else {
                return 0.0
            }
        }),
        "ln"   : Operation.UnaryOperation(log),
        "log"  : Operation.UnaryOperation(log10),
        "log2" : Operation.UnaryOperation(log2),
        "+"    : Operation.BinaryOperation({ $0 + $1 }),
        "−"    : Operation.BinaryOperation({ $0 - $1 }),
        "×"    : Operation.BinaryOperation({ $0 * $1 }),
        "÷"    : Operation.BinaryOperation({ $0 / $1 }),
        "="    : Operation.Equals,
        ]
    
    enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    // MARK: Binary Operations Pending and Execute
    
    private var pending: PendingBinaryOperationInfo?
    
    struct PendingBinaryOperationInfo {
        var binaryFunction: ((Double, Double) -> Double)
        var firstOperand: Double
    }
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList {
        get{
            return internalProgram
        }
        set{
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand)
                    } else if let operation = op as? String {
                        performOperation(operation)
                    }
                }
            }
        }
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil{
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
            isPartialResult = false
        }
    }

    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
                
            case .Constant(let value):
                accumulator = value
                
                
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
                executePendingBinaryOperation()
                
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
                isPartialResult = true
                
                
            case .Equals:
                executePendingBinaryOperation()
            }
        }
        internalProgram.append(symbol)
    }
    
    
    
}