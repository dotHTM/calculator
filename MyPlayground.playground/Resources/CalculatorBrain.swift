//
//  CalculatorBrain.swift
//  calculator
//
//  Created by Michael Cramer on 7/13/16.
//  Copyright © 2016 Michael Cramer. All rights reserved.
//

import Foundation

class CalculatorBrain
{
  private var accumulator = 0.0
  private var internalProgram = [AnyObject]()

  var description: String {
    get {
      var result = ""
      for step in internalProgram {
        if let strStep = (step as? String) {
        result = result + strStep
        }
      }
      return result
    }
  }

  func setOperand(operand: Double) {
    accumulator = operand
    internalProgram.append(operand)
  }

  private var operations: Dictionary<String, Operation> = [
    "π" : Operation.Constant(M_PI),
    "e" : Operation.Constant(M_E),
    "√" : Operation.UnaryOperation(sqrt),
    "cos" : Operation.UnaryOperation(cos),
    "+" : Operation.BinaryOperation({ $0 + $1 }),
    "−" : Operation.BinaryOperation({ $0 - $1 }),
    "×" : Operation.BinaryOperation({ $0 * $1 }),
    "÷" : Operation.BinaryOperation({ $0 / $1 }),
    "=" : Operation.Equals,
    ]

  enum Operation {
    case Constant(Double)
    case UnaryOperation((Double) -> Double)
    case BinaryOperation((Double, Double) -> Double)
    case Equals
  }

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

  func clear() {
    accumulator = 0.0
    pending = nil
    internalProgram.removeAll()
  }


  func performOperation(symbol: String) {
    if let operation = operations[symbol] {
      switch operation {
      case .Constant(let value): accumulator = value
      case .UnaryOperation(let function): accumulator = function(accumulator)
      case .BinaryOperation(let function):
        if pending != nil { performOperation("=") }
        pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
      case .Equals:
        if pending != nil{
          accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
          pending = nil
        }

      }
    }
    internalProgram.append(symbol)
 
  }

  var result: Double {
    get{
      return accumulator
    }
  }
  
}