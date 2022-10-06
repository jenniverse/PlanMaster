//
//  TransportationViewController.swift
//  PlanMaster
//
//  Created by Jenny Kim on 4/25/22.
//  jkim4020@usc.edu

import UIKit

class TransportationViewController: UIViewController, UITextFieldDelegate {
    private var plansShared = PlansModel.shared
    
    var onNewTransportationAdded: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        // disable the save button
        saveButton.isEnabled = false
        // dismiss the keyboard when background is tapped
        hideKeyboardWhenTappedAround()
        nameTextField.delegate = self
        fromTextField.delegate = self
        toTextField.delegate = self
        // set the tags for each textField
        nameTextField.tag = 0
        fromTextField.tag = 1
        toTextField.tag = 2
        
        nameTextField.becomeFirstResponder()
    }
    
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var transportationSegmentedControl: UISegmentedControl!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var fromTextField: UITextField!
    @IBOutlet var toTextField: UITextField!
    
    // when cancel is tapped, empty the textFields and dismiss the viewController
    @IBAction func cancelButtonDidTapped(_ sender: UIBarButtonItem) {
        nameTextField.text = nil
        fromTextField.text = nil
        toTextField.text = nil
        dismiss(animated: true, completion: nil)
    }
    
    // when save is tapped, save the new plan, empty the textFields, and dismiss the viewController
    @IBAction func saveButtonDidTapped(_ sender: UIBarButtonItem) {
        plansShared.insertTransportation(type: transportationSegmentedControl.selectedSegmentIndex, name: nameTextField.text!, from: fromTextField.text!, to: toTextField.text!, at: plansShared.numOfTransportation())
        dismiss(animated: true, completion: nil)
        transportationSegmentedControl.selectedSegmentIndex = 0
        nameTextField.text = nil
        fromTextField.text = nil
        toTextField.text = nil
        
        onNewTransportationAdded?()
    }
    
    // when return is tapped, move to the next textField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // move to the next textField
        let nextTag = textField.tag + 1
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    // check if any of textFields are empty
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        let title = textField == nameTextField ? newString : nameTextField.text!
        let from = textField == fromTextField ? newString : fromTextField.text!
        let to = textField == toTextField ? newString : toTextField.text!
        print(title)
        // if all textFields are not empty, enable the save button
        if !title.isEmpty, !from.isEmpty, !to.isEmpty {
            saveButton.isEnabled = true
        }
        // else, keep the save button disabled
        else {
            saveButton.isEnabled = false
            print("title is empty")
        }
        return true
    }
}
