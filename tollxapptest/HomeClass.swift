//
//  HomeClass.swift
//  tollxapptest
//
//  Created by Kevin Abram on 8/16/17.
//  Copyright © 2017 Binus. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GoogleMaps
import GooglePlaces
import AVFoundation

class Homeclass: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, LocateOnTheMap, UISearchControllerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var selectView: UIView!
    
    @IBAction func buttonSelect(_ sender: UIButton) {
        selectView.isHidden = false
        
    }
    
    //map view
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var SideBarView: UIView!
    
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var textFieldView: UIView!
    
    @IBOutlet weak var fromSearchBar: UISearchBar!
    
    @IBOutlet weak var destinationSearchBar: UISearchBar!
    
    @IBOutlet weak var closeSideBarButton: UIButton!
    
    @IBOutlet weak var vehicleTypeSelectView: UIView!
    
    @IBOutlet weak var vehicleTypeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var vehichleTypeButton: UIButton!
    
    @IBOutlet weak var paymentTypeButton: UIButton!
    
   
    @IBOutlet weak var paymentTypeSelectView: UIView!
    
    @IBOutlet weak var paymentTypeSegmentedControl: UISegmentedControl!
    
    //    @IBOutlet weak var tableSearchView: UITableView!
    
    var latitudeFromm = CLLocationDegrees()
    var longitudeFromm = CLLocationDegrees()
    var latitudeTo = CLLocationDegrees()
    var longitudeTo = CLLocationDegrees()
    
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResult = [MKLocalSearchCompleter]()
    
    var locationManager = CLLocationManager()
    
    var searchResultController: SearchResultsController!
    var resultArray = [String]()
    
    var searchBarType: Int = 0
    
    var countLoop: Int = 0
    
    var countAlert: Int = 0
    
    var tollFarePrice: String = "7000"
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        
        let userLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(-6.222816, 106.648369)
        print(location.coordinate.latitude)
        
        
        
        let Region: MKCoordinateRegion = MKCoordinateRegionMake(userLocation, span)
        
        mapView.setRegion(Region, animated: true)
        
        self.mapView.showsUserLocation = true
        
        // tol alert
        if location.coordinate.latitude < -6.222816 && location.coordinate.latitude > -6.224352 && location.coordinate.longitude < 106.650021 && location.coordinate.longitude > 106.648326 && countAlert == 1 {
            
            if self.mapView.showsUserLocation == true {
                
                let alert = UIAlertController(title: "Toll Gate Alert", message: "14 kilometers to Alam Sutera Tol Gate with fare \(tollFarePrice) rupiah", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Ok",style: UIAlertActionStyle.default,handler:{action in alert.dismiss(animated: true,  completion: nil)
                    print("Ok")
                    
                }))
                
                
                self.present(alert,animated: true,completion: nil)
                let message = alert.message
                let utterace =  AVSpeechUtterance(string: message!)
                utterace.voice = AVSpeechSynthesisVoice(language: "en-US")
                utterace.rate = 0.5
                
                let synthesizer = AVSpeechSynthesizer()
                synthesizer.speak(utterace)
                
                countAlert = 2
            }
            
            
        }
        
        
        
    }
    
    @IBOutlet weak var tollGateName: UILabel!
    
    @IBOutlet weak var farePrice: UILabel!
    
    @IBOutlet weak var tollDistance: UILabel!
    
    @IBAction func journeyStart(_ sender: Any) {

        countAlert = 1
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }

        mapView.delegate = self
        mapView.showsScale = true
        mapView.showsPointsOfInterest = true
        mapView.showsUserLocation = true
        
        tollGateName.text = "Tomang toll gate"
        
        
        farePrice.text = "\(tollFarePrice)"
        
        tollDistance.text = "14KM"
    
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // let positionFrom:CLLocationCoordinate2D = CLLocationCoordinate2DMake( location.coordinate, lon)
        
        
        selectView.isHidden = true
        
        leadingConstraint.constant = -300
        
        UIView.animate(withDuration: 0.3 , animations: {
            self.view.layoutIfNeeded()
        })
        

        
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        mapView.delegate = self
        mapView.showsScale = true
        mapView.showsPointsOfInterest = true
        mapView.showsUserLocation = true
        
        //load suggestion
        searchCompleter.delegate = self as? MKLocalSearchCompleterDelegate
        
        textFieldView.backgroundColor = UIColor.clear
        
        fromSearchBar.delegate = self
        destinationSearchBar.delegate = self
        
        vehicleTypeSelectView.isHidden = true
        paymentTypeSelectView.isHidden = true
        //        tableSearchView.isHidden = true
    }
    
    //nama dan foto sidebar
    @IBOutlet weak var namaSide: UILabel!
    
    
    @IBOutlet weak var profilePhoto: UIImageView!
    
    //logic button sidebar
    var menuShowing = true
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    
    @IBAction func profileAction(_ sender: Any) {
        
        performSegue(withIdentifier: "profileSegue", sender: self)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchResultController = SearchResultsController()
        searchResultController.delegate = self
        
    }
    
    @IBAction func openSidebar(_ sender: Any) {
        if (menuShowing)
        {
            leadingConstraint.constant = -300
            
            UIView.animate(withDuration: 0.3 , animations: {
                self.view.layoutIfNeeded()
            })
        }else
        {
            leadingConstraint.constant = 0
            
            UIView.animate(withDuration: 0.3 , animations: {
                self.view.layoutIfNeeded()
            })
        }
        
        menuShowing = !menuShowing
    }
    
    @IBAction func closeSideBar(_ sender: Any) {
        
        if (menuShowing)
        {
            leadingConstraint.constant = -300
            
            UIView.animate(withDuration: 0.3 , animations: {
                self.view.layoutIfNeeded()
            })
        }else
        {
            leadingConstraint.constant = 0
            
            UIView.animate(withDuration: 0.3 , animations: {
                self.view.layoutIfNeeded()
            })
        }
        
        menuShowing = !menuShowing
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    //load location suggestion
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        let searchController = UISearchController(searchResultsController: searchResultController)
        
        searchController.searchBar.delegate = self
        self.present(searchController, animated: true, completion: nil)
        
        
        let placeClient = GMSPlacesClient()
        
        placeClient.autocompleteQuery(searchText, bounds: nil, filter: nil) { (results, error) -> Void in
            self.resultArray.removeAll()
            if results == nil{
                return
            }
            
            for result in results! {
                if let result = result as? GMSAutocompletePrediction{
                    self.resultArray.append(result.attributedFullText.string)
                }
                
            }
            
            self.searchResultController.reloadDataWithArray(self.resultArray)
            
        }
        
        if searchBar == fromSearchBar{
            //print("from")
            //tableSearchView.isHidden = false
        
            let searchController = UISearchController(searchResultsController: searchResultController)
            
            searchController.searchBar.delegate = self
            self.present(searchController, animated: true, completion: nil)
            
            
            let placeClient = GMSPlacesClient()
            
            placeClient.autocompleteQuery(searchText, bounds: nil, filter: nil) { (results, error) -> Void in
                self.resultArray.removeAll()
                if results == nil{
                    return
                }
                
                for result in results! {
                    if let result = result as? GMSAutocompletePrediction{
                        self.resultArray.append(result.attributedFullText.string)
                    }
                    
                }
                
                self.searchResultController.reloadDataWithArray(self.resultArray)
                
            }
            
        }else if searchBar == destinationSearchBar{
            //print("to")
            //tableSearchView.isHidden = false
            let searchController = UISearchController(searchResultsController: searchResultController)
            
            searchController.searchBar.delegate = self
            self.present(searchController, animated: true, completion: nil)
            
            
            let placeClient = GMSPlacesClient()
            
            placeClient.autocompleteQuery(searchText, bounds: nil, filter: nil) { (results, error) -> Void in
                self.resultArray.removeAll()
                if results == nil{
                    return
                }
                
                for result in results! {
                    if let result = result as? GMSAutocompletePrediction{
                        self.resultArray.append(result.attributedFullText.string)
                    }
                    
                }
                
                self.searchResultController.reloadDataWithArray(self.resultArray)
            }
        }
        self.searchResultController.reloadDataWithArray(self.resultArray)
    }
    
    
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        fromSearchBar.isHidden = true
        destinationSearchBar.isHidden = true
        
        
        if searchBar == fromSearchBar{
            
             locationManager.stopUpdatingLocation()
          

            print("from")
            //tableSearchView.isHidden = false
            searchBarType = 1
            let searchController = UISearchController(searchResultsController: searchResultController)
            
            searchController.searchBar.delegate = self
            self.present(searchController, animated: true, completion: nil)
            
            
        }else if searchBar == destinationSearchBar {
            
            print("to")
            //          tableSearchView.isHidden = false
            searchBarType = 2
            let searchController = UISearchController(searchResultsController: searchResultController)
            
            searchController.searchBar.delegate = self
            self.present(searchController, animated: true, completion: nil)
            
        }
        self.searchResultController.reloadDataWithArray(self.resultArray)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        fromSearchBar.isHidden = false
        destinationSearchBar.isHidden = false
    }
    
       
    
    //buat hide table klo yg lain yg diklik
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
      
        
        self.becomeFirstResponder()

        selectView.isHidden = true
        
        leadingConstraint.constant = -300
        
        UIView.animate(withDuration: 0.3 , animations: {
            self.view.layoutIfNeeded()
        })
        
        //        if touch.view != tableSearchView{
        //            tableSearchView.isHidden =  true
        //        }
    }
    
    
    override var canBecomeFirstResponder: Bool{
        
        return true
        
    }
    
   

    
    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
        
        if searchBarType == 1{
            
           let allAnnotations = self.mapView.annotations
            self.mapView.removeAnnotations(allAnnotations)
            
            
            let overlays = mapView.overlays
            mapView.removeOverlays(overlays)
            
            
            
            let positionFrom:CLLocationCoordinate2D = CLLocationCoordinate2DMake( lat, lon)
            
            latitudeFromm = lat
            longitudeFromm = lon
            
            let marker = MKPointAnnotation()
            marker.coordinate.longitude = positionFrom.longitude
            marker.coordinate.latitude = positionFrom.latitude
            self.mapView.addAnnotation(marker)
            
            
            let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
            
            let region:MKCoordinateRegion = MKCoordinateRegionMake(positionFrom, span)
            
            marker.title = "Address : \(title)"
            
            self.mapView.setRegion(region, animated: true)
            
            fromSearchBar.text = title

            
          //  countLoop = countLoop + 1
            
            
            
        }else if searchBarType == 2{
            
           let allAnnotations = self.mapView.annotations
           self.mapView.removeAnnotations(allAnnotations)
            
            
            let overlays = mapView.overlays
            mapView.removeOverlays(overlays)
            
            
         
            
            let position:CLLocationCoordinate2D = CLLocationCoordinate2DMake( lat, lon)
            
            latitudeTo = lat
            longitudeTo = lon
            
            let marker = MKPointAnnotation()
            marker.coordinate.longitude = position.longitude
            marker.coordinate.latitude = position.latitude
            self.mapView.addAnnotation(marker)
            
            let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
            
            let region:MKCoordinateRegion = MKCoordinateRegionMake(position, span)
            
            marker.title = "Address : \(title)"
            
            self.mapView.setRegion(region, animated: true)
            
            destinationSearchBar.text = title

            
          //  countLoop  = countLoop + 1
            
        }
        
        // get latitude and longitude
        
        let sourceLocation = CLLocationCoordinate2D(latitude: latitudeFromm, longitude: longitudeFromm)
        let destinationLocation = CLLocationCoordinate2D(latitude: latitudeTo, longitude: longitudeTo)
        
        //get placemark
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        // 7.
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        // 8.
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
        
        
        //        print(title)
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        return renderer
    }
    
    // tol 37.334446, -122.037663
    
    @IBAction func vehicleTypeClicked(_ sender: Any) {
        selectView.isHidden = true
        vehicleTypeSelectView.isHidden = false
    }
    
    @IBAction func vehicleTypeSelectViewClose(_ sender: Any) {
        selectView.isHidden = false
        vehicleTypeSelectView.isHidden = true
    }
    
    
    @IBAction func vehicleTypeChange(_ sender: Any) {
        if vehicleTypeSegmentedControl.selectedSegmentIndex == 0 {
            vehichleTypeButton.setImage(UIImage(named :"type1"), for: .normal)
            
            tollFarePrice = "7000"
            
            farePrice.text = "\(tollFarePrice)"
            
        }else if vehicleTypeSegmentedControl.selectedSegmentIndex == 1{
            vehichleTypeButton.setImage(UIImage(named :"type2"), for: .normal)
            
            tollFarePrice = "9000"
            
            farePrice.text = "\(tollFarePrice)"
            
        }else if vehicleTypeSegmentedControl.selectedSegmentIndex == 2{
            vehichleTypeButton.setImage(UIImage(named :"type3"), for: .normal)
            
            tollFarePrice = "10000"
            
            farePrice.text = "\(tollFarePrice)"
            
        }else if vehicleTypeSegmentedControl.selectedSegmentIndex == 3{
            vehichleTypeButton.setImage(UIImage(named :"type4"), for: .normal)
            
            tollFarePrice = "15000"
            
            farePrice.text = "\(tollFarePrice)"
            
        }else if vehicleTypeSegmentedControl.selectedSegmentIndex == 4{
            vehichleTypeButton.setImage(UIImage(named :"type5"), for: .normal)
            
            tollFarePrice = "19000"
            
            farePrice.text = "\(tollFarePrice)"
            
        }
        vehicleTypeSelectView.isHidden = true
        selectView.isHidden = false
    }
    
    @IBAction func paymentTypeClicked(_ sender: Any) {
        selectView.isHidden = true
        paymentTypeSelectView.isHidden = false
    }
    
    @IBAction func paymentTypeSelectViewClose(_ sender: Any) {
        paymentTypeSelectView.isHidden = true
        selectView.isHidden = false
    }
    
    @IBAction func paymentTypeChange(_ sender: Any) {
        if paymentTypeSegmentedControl.selectedSegmentIndex == 0{
            paymentTypeButton.setImage(UIImage(named: "note-icon-63268"), for: .normal)
        }else if paymentTypeSegmentedControl.selectedSegmentIndex == 1{
            paymentTypeButton.setImage(UIImage(named: "card-icon"), for: .normal)
        }
        paymentTypeSelectView.isHidden = true
        selectView.isHidden = false
    }
    
    
    
    
}

