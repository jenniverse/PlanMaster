//
//  DestinationViewController.swift
//  PlanMaster
//
//  Created by Jenny Kim on 4/25/22.
//  jkim4020@usc.edu

import GoogleMaps
import GooglePlaces
import UIKit

extension DestinationViewController: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    // if user used autocomplete, get the information about the destination
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name ?? "default")")
        print("Place ID: \(place.placeID ?? "default")")
        print("Place coordinates: \(place.coordinate)")
        dismiss(animated: true, completion: nil)

        latTitle.layer.opacity = 1
        longTitle.layer.opacity = 1
        // fill in the textFileds with information received from autocomplete
        destinationTextField.text = place.name
        latLabel.text = String(place.coordinate.latitude)
        longLabel.text = String(place.coordinate.longitude)
        // enable the save button
        saveButton.isEnabled = true
    }

    // handle the error
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }

    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }

    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

class DestinationViewController: UIViewController, UITextFieldDelegate {
    private var placesClient: GMSPlacesClient!
    private var plansShared = PlansModel.shared

    var onNewDestinationAdded: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        // hide lat and long labels
        latTitle.layer.opacity = 0
        longTitle.layer.opacity = 0
        // empty the textfields
        latLabel.text = nil
        longLabel.text = nil
        // disable the save button
        saveButton.isEnabled = false
        // dismiss the keyboard when background is tapped
        hideKeyboardWhenTappedAround()
        destinationTextField.delegate = self
        placesClient = GMSPlacesClient.shared()
    }

    @IBAction func searchButtonDidTapped(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        // Specify the place data types to return.
        // get name, placeID, and coordinate of the location
        let fields = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.coordinate.rawValue))
        autocompleteController.placeFields = fields

        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter

        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }

    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var destinationTextField: UITextField!
    @IBOutlet var timePicker: UIDatePicker!

    @IBOutlet var latTitle: UILabel!
    @IBOutlet var longTitle: UILabel!

    @IBOutlet var latLabel: UILabel!
    @IBOutlet var longLabel: UILabel!

    // when cancel is tapped, empty the textFiled and dismiss the viewController
    @IBAction func cancelButtonDidTapped(_ sender: UIBarButtonItem) {
        destinationTextField.text = nil
        dismiss(animated: true, completion: nil)
    }

    // when save is tapped, insert Destination, empty the textFields, and dismiss the viewController
    @IBAction func saveButtonDidTapped(_ sender: UIBarButtonItem) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let INVALID_NUM: Double = 1000

        // set the lat and long if it's provided
        // else, set it as INVALID_NUM, which is 1000
        let latVal = latLabel.text ?? "\(INVALID_NUM)"
        let longVal = longLabel.text ?? "\(INVALID_NUM)"

        plansShared.insertDestination(name: destinationTextField.text!, time: formatter.string(from: timePicker.date), lat: Double(latVal)!, long: Double(longVal)!, at: plansShared.numOfDestination())
        destinationTextField.text = nil
        timePicker.date = Date()
        // dismiss the viewcontroller
        dismiss(animated: true, completion: nil)
        onNewDestinationAdded?()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // check if textField is empty and change the status of save button
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)

        let title = textField == destinationTextField ? newString : destinationTextField.text!
        print(title)
        // if textfield is not empty, enable the save button
        if !title.isEmpty {
            saveButton.isEnabled = true
        }
        // else, keep the save button disabled
        else {
            saveButton.isEnabled = false
            print("Destination is empty")
        }
        return true
    }
}
