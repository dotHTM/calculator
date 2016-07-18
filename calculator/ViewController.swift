//
//  ViewController.swift
//  calculator
//
//  Created by Michael Cramer on 7/12/16.
//  Copyright © 2016 Michael Cramer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  private var userIsInTheMiddleOfTyping = false
  private let decimalSeperator = "."
  private var decimalSubPower = 0.0
  private var unitSubFactor = 10.0

  @IBOutlet weak var descriptionDisplay: UILabel!


  @IBOutlet private weak var display: UILabel!

  private func appendToDisplay(digit: String) {
    let textCurrentlyInDisplay = display.text!
    display.text = textCurrentlyInDisplay + digit
    userIsInTheMiddleOfTyping = true
  }

  private func setDisplayTo(digit: String){
    display.text = digit
    userIsInTheMiddleOfTyping = true
  }

  var displayValue: Double {
    get {
      return Double(display.text!)!
    }
    set{
      display.text = String(newValue)
    }
  }

  var descriptionDisplayValue: String {
    get {
      return descriptionDisplay.text!
    }
    set {
      descriptionDisplay.text = newValue
    }
  }

  @IBAction private func touchDigit(sender: UIButton) {
    let digit =  sender.currentTitle!

    if userIsInTheMiddleOfTyping {
      if !( display.text!.containsString(".") && digit == ".") {
        display.text = display.text! + digit
      }
    } else {
      switch digit {
      case "0": break
      case ".":
        display.text = "0."
        userIsInTheMiddleOfTyping = true
      default:
        display.text = digit
        userIsInTheMiddleOfTyping = true
      }
    }
    descriptionDisplayValue = brain.description
  }

  var savedProgram: CalculatorBrain.PropertyList?

  @IBAction func save() {
    savedProgram = brain.program
  }

  @IBAction func restore() {
    if savedProgram != nil {
      brain.program = savedProgram!
      userIsInTheMiddleOfTyping = false
      updateDisplayAfterButton()
    }
  }

  private var brain: CalculatorBrain = CalculatorBrain()

  private func updateDisplayAfterButton() {
    displayValue = brain.result
    descriptionDisplayValue = brain.description
    if brain.isPartialResult {
      descriptionDisplayValue = descriptionDisplayValue + "..."
    } else {
descriptionDisplayValue = descriptionDisplayValue + "="
    }


  }

  @IBAction private func performOpperation(sender: UIButton) {

    if userIsInTheMiddleOfTyping {
      brain.setOperand(displayValue)
      userIsInTheMiddleOfTyping = false
    }
    if let mathematicalSymbol = sender.currentTitle {
      brain.performOperation(mathematicalSymbol)
    }
    updateDisplayAfterButton()

  }

  @IBAction private func clearInput(sender: UIButton) {
    userIsInTheMiddleOfTyping = false
    brain.clear()
    updateDisplayAfterButton()
  }
}

