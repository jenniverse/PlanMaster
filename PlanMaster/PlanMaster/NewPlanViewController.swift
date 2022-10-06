//
//  NewPlanViewController.swift
//  PlanMaster
//
//  Created by Jenny Kim on 4/18/22.
//  jkim4020@usc.edu

import UIKit

// function of dismissing keyboard when the background is tapped
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// set the primary language for the keyboard as emoji
class EmojiTextField: UITextField {
    // required for iOS 13
    override var textInputContextIdentifier: String? { "" }

    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                return mode
            }
        }
        return nil
    }
}

class NewPlanViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var withTextField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var iconTextField: UITextField!
    
    var onNewPlanAdded: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // disable the save button
        saveButton.isEnabled = false
        // dismiss keyboard when background is tapped
        hideKeyboardWhenTappedAround()

        titleTextField.delegate = self
        withTextField.delegate = self
        iconTextField.delegate = self
        
        titleTextField.becomeFirstResponder()
        // set the minimum date that user can select to current date
        datePicker.minimumDate = Date()
    }
    
    // when cancel is tapped, empty the textfields and dismiss the viewcontroller
    @IBAction func cancelButtonDidTapped(_ sender: UIBarButtonItem) {
        titleTextField.text = nil
        withTextField.text = nil
        dismiss(animated: true, completion: nil)
    }
    
    // when save is tapped, insert new plan, empty the textFields, and dismiss viewcontroller
    @IBAction func saveButtonDidTapped(_ sender: UIBarButtonItem) {
        let useIcon: String?
        if iconTextField.text == "" {
            // default icon
            useIcon = "📍"
        }
        else {
            useIcon = iconTextField.text
        }
        let useWith: String?
        if withTextField.text == "" {
            // default with value
            // localize text
            let withDefault = NSLocalizedString("MYSELF", comment: "Myself")
            useWith = withDefault
        }
        else {
            useWith = withTextField.text
        }
        
        PlansModel.shared.insert(icon: useIcon!, title: titleTextField.text!, with: useWith!, date: datePicker.date, transportation: [], destination: [], at: PlansModel.shared.numberOfPlans())
        dismiss(animated: true, completion: nil)
        titleTextField.text = nil
        withTextField.text = nil
        datePicker.date = Date()
        
        onNewPlanAdded?()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // check if textField is empty and change the status of save button
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        let title = textField == titleTextField ? newString : titleTextField.text!
        print(title)
        if !title.isEmpty {
            saveButton.isEnabled = true
        }
        else {
            saveButton.isEnabled = false
            print("title is empty")
        }
        
        let icon = textField == iconTextField ? newString : iconTextField.text!
        if icon.isEmpty == false, icon.count > 1 {
            // localize text
            let alertTitle = NSLocalizedString("NOTE", comment: "Note")
            let alertMsg = NSLocalizedString("MESSAGE", comment: "Icon should be an emoji or a letter")
            let alertController = UIAlertController(title: alertTitle, message: alertMsg, preferredStyle: .alert)
            let alertOK = NSLocalizedString("OK", comment: "Ok")
            let okAction = UIAlertAction(title: alertOK, style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
        
        return true
    }
}
