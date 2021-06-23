//
//  FindAndAddLocationToTheMap.swift
//  On the Map
//
//  Created by YoYo on 2021-06-14.
//

import Foundation
import UIKit
import MapKit
class FindAndAddLocationToTheMap: UIViewController{
    //MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addPinButton: UIButton!
    @IBOutlet weak var addressTextField:  UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var image: UIImageView!
    var studentLocation: [StudentLocation] = []
    //MARK: The coordinates
   
    // MARK: Override
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addressTextField.text = ""
        self.linkTextField.text = ""
        hide(hide: true)
        mapView.delegate = self
        addressTextField.delegate = self
        linkTextField.delegate = self
        addressTextField.resignFirstResponder()
        linkTextField.resignFirstResponder()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        addAnnotation()
        
    }
    
    //MARK: IBActions
    @IBAction func backButton(){
            self.dismiss(animated: true, completion: nil)
        }
    @IBAction func addPinButtonTapped(){
        
        self.dismiss(animated: true, completion: nil)
        print("working?")
        Client.getPublicData(completionHandler: handleUserData(firstName:lastName:error:))
       
    }
    @IBAction func findeLocationButtonTapped(){
        hide(hide: false)
        if addressTextField.text == ""{
            showError(error: "Please input an address")
        }
        if linkTextField.text == ""{
            showError(error: "Please input a link")
        }
        if FindAndAddLocationToTheMap.isTheAddressCorrect(address: addressTextField.text ?? "", completionHandler: handlefindLocation(success:error:)){
            addressTextField.isHidden = true
            linkTextField.isHidden = true
        }
        addAnnotation()
        print("hello?")
    }
    //MARK: Handle
    func handleUserData(firstName: String?, lastName: String?, error: Error?){
        if error == nil{
            Client.postStudentLocation(firstName: firstName ?? "", lastName: lastName ?? "", mapString: addressTextField.text ?? "", mediaURL: linkTextField.text ?? "", completionHandler: handlePostStudentRequest(success:error:))
        }else{
            print("cannot post")
        }
    }
    func handlePostStudentRequest(success: Bool, error: Error?){
        if success{
            print("success Posting")
        }else{
            showError(error: "Please Retry")
        }
    }
    
    
    func handlefindLocation(success: Bool, error: Error?){
        if success{
            hide(hide: false)
            print("Found Location")
            print(LatAndLong.lat)
            print(LatAndLong.long)
            zoomIn()
        }else{
            hide(hide: true)
            showError(error: "Please input a correct location")
            
        }
    }
    //MARK: Check if the location is correct
    class func isTheAddressCorrect(address:String,completionHandler:@escaping  (Bool,Error?) -> Void) -> Bool
    {
        print("checking address?")
        var isValidated = false
        let locationManager = CLGeocoder()
        locationManager.geocodeAddressString(address, completionHandler:
        {
            (placemarks: [CLPlacemark]?, error: Error?) -> Void in
            if let placemark = placemarks?[0]
            {
                LatAndLong.lat = placemark.location!.coordinate.latitude
                LatAndLong.long = placemark.location!.coordinate.longitude
                completionHandler(true, error)
                isValidated = true
            }
            else
            {
                completionHandler(false,error)
            }
        }
    )
    
    return isValidated
    }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    //MARK: Shows the error
    func showError(error: String){
        let alertVc = UIAlertController(title: "", message: error, preferredStyle: .alert)
        alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVc, animated: true, completion: nil)
    }
    //MARK: Add the Pin
    func zoomIn(){
        let latitude: CLLocationDegrees = LatAndLong.lat
        let longitude: CLLocationDegrees = LatAndLong.long
        let latDelta: CLLocationDegrees = 0.05
        let longDelta: CLLocationDegrees = 0.05
        let span = MKCoordinateSpan (latitudeDelta: latitude, longitudeDelta: longitude)
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion (center: location, span: span)
    }
    
    func addAnnotation(){
        let annotation = MKPointAnnotation()
        annotation.title = self.addressTextField.text
        annotation.subtitle = self.linkTextField.text
        annotation.coordinate = CLLocationCoordinate2DMake(LatAndLong.lat, LatAndLong.long)
        self.mapView.setCenter(annotation.coordinate, animated: true)
        self.mapView.addAnnotation(annotation)
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        zoomIn()
        }
    
    
    func hide(hide: Bool){
        if hide == false{
            addressTextField.isHidden = true
            linkTextField.isHidden = true
            findLocationButton.isHidden = true
            image.isHidden = true
            mapView.isHidden = false
            addPinButton.isHidden = false
            self.view.backgroundColor = UIColor.white
        }else{
            addressTextField.isHidden = false
            linkTextField.isHidden = false
            findLocationButton.isHidden = false
            image.isHidden = false
            mapView.isHidden = true
            addPinButton.isHidden = true
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "2")!)
        }
    }
}

extension FindAndAddLocationToTheMap: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            _ = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                UIApplication.shared.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
}

extension FindAndAddLocationToTheMap: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addressTextField.resignFirstResponder()
        linkTextField.resignFirstResponder()
        return true
    }
    
    
}
