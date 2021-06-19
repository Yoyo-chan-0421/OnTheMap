//
//  MapViewController.swift
//  On the Map
//
//  Created by YoYo on 2021-06-12.
//
//88888b.d88b.  8888b. 88888b. .d8888b
//888 "888 "88b    "88b888 "88b88K
//888  888  888.d888888888  888"Y8888b.
//888  888  888888  888888 d88P     X88
//888  888  888"Y88888888888P"  88888P'
//                     888
//                     888
//                     888


import Foundation
import UIKit
import MapKit
class MapViewController: UIViewController{
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        addAnnotation()
        reloadInputViews()
        print(mapView)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        Client.logout {
            print("Successfully Logout")
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
               
            
    
        }
    }
    func getPin(completionHandler: @escaping ([StudentLocation], Error?) -> Void){
        let session = URLSession.shared.dataTask(with: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!) { data, response, error in
            guard let data = data else{
                DispatchQueue.main.async {
                    completionHandler([], error)
                }
                return
            }
            let decoder = JSONDecoder()
            do{
                print(String(data: data, encoding: .utf8 ) ?? "")
                let request = try decoder.decode(StudenLocationFinal.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(request.results, nil)
                }
            }catch{
                DispatchQueue.main.async {
                    completionHandler([], error)
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func addAnnotation(){
        Client.getStudentLocation { data, error in
            guard let data = data else{
                print("error")
                return
            }
            AnnotationModel.data = data
            if (AnnotationModel.data.count <= 0){
                self.showError(error: "Was not able to load the Studen Pins")
            }
            for dictionary in AnnotationModel.data{
           
                      let annotation = MKPointAnnotation()
                annotation.title = (dictionary.firstName == nil ? "" : "\(dictionary.firstName) ") + (dictionary.lastName == nil ? "" : "\(dictionary.lastName) ")
                 annotation.subtitle = dictionary.mediaURL
           
                annotation.coordinate = CLLocationCoordinate2DMake(dictionary.latitude, dictionary.longitude)
           
                self.mapView.addAnnotation(annotation)
            }
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }
        

    }
    func showError(error: String){
        let alertVc = UIAlertController(title: "", message: error, preferredStyle: .alert)
        alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVc, animated: true, completion: nil)
    }
}



extension MapViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
        }else{
            pinView!.annotation = annotation
        }
        return pinView
    }
        
        
 
        
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        if control == view.rightCalloutAccessoryView
        {
            if let toOpen = view.annotation?.subtitle!
            {
                UIApplication.shared.open(URL(string: toOpen)! , options: [:], completionHandler: nil)
            }
        }
    }

}
