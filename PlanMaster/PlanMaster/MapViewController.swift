//
//  MapViewController.swift
//  PlanMaster
//
//  Created by Jenny Kim on 4/29/22.
//  jkim4020@usc.edu

import CoreLocation
import GoogleMaps
import MapKit
import MessageUI
import UIKit

class MapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate, MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func sendText(sender: UIBarButtonItem) {
        if MFMessageComposeViewController.canSendText() {
            let controller = MFMessageComposeViewController()

            let messageBody = NSLocalizedString("MSG_BODY", comment: "Message Body")
            
            controller.body = messageBody + (sharedPlan.selectedPlan()?.getDestination()[sharedPlan.selectedDestinationIndex!].place)!
            controller.messageComposeDelegate = self
            present(controller, animated: true, completion: nil)
        }
    }

    private var sharedPlan = PlansModel.shared
    var locationManager: CLLocationManager!
    var userLocation: CLLocation = .init(latitude: 34.02102777966185, longitude: -118.28714771444962)

    // marker of user's current location
    var markMe = GMSMarker()

    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var mapLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        locationManager.delegate = self
        // set the accuracy
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        // ask for authorization
        locationManager.requestWhenInUseAuthorization()
        let INVALID_NUM: Double = 1000

        // start updating the location if it got authorized
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }

        // selected destination
        let thisDestination = sharedPlan.selectedPlan()?.getDestination()[sharedPlan.selectedDestinationIndex!]

        // if lat and long of destination are received
        if thisDestination!.lat != INVALID_NUM {
            // hide the label
            mapLabel.layer.opacity = 0
            // make the camera show the destination
            let camera = GMSCameraPosition.camera(withLatitude: thisDestination!.lat, longitude: thisDestination!.long, zoom: 10.0)
            let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            view = mapView

            // create and set the marker of destination
            // color of marker: red (default)
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: thisDestination!.lat, longitude: thisDestination!.long)
            marker.title = thisDestination?.place
            marker.snippet = thisDestination?.time
            marker.map = mapView

            // set a marker showing user's location
            // localize text
            let markMeTitle = NSLocalizedString("YOURE_HERE", comment: "You're here")
            markMe.title = markMeTitle
            // change the color of the marker to blue
            markMe.icon = GMSMarker.markerImage(with: .blue)
            markMe.map = mapView
        }
        // else, show the label instead of the map
        else {
            mapView.isHidden = true
            mapLabel.layer.opacity = 1
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0]
        // change the position of the marker indicating user's location
        markMe.position = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)

        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}
