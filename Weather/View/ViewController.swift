//
//  ViewController.swift
//  Weather
//
//  Created by B S, DINESH (Contractor) on 23/05/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    
    var weatherData : [WeatherList] = []
    
    //create a reference to the view model
    var weatherVM = WeatherViewModel()

    @IBOutlet weak var searchL: UITextField!
    
    
    override func viewDidAppear(_ animated: Bool) {
        let connection = weatherVM.isConnected
      print(connection)
        if connection{
           
            
        }else{
            let alert = UIAlertController(title: "No Internet", message: "You are not connected to the Internet. Turn On!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Mobile Data", style: .default,handler: { action in
                print("Mobile data turned on..")
                
                
           let path = UIApplication.openSettingsURLString
                let pathnew = URL(string: path)
                UIApplication.shared.open(pathnew!)
                
                
            }))
            alert.addAction(UIAlertAction(title: "Wifi", style: .default,handler: { action in
                print("Wifi enabled...")
            }))
            alert.addAction(UIAlertAction(title: "close", style: .destructive))
            show(alert, sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var shouldAutorotate : Bool { return false }
        let gradientlayer = CAGradientLayer()
        gradientlayer.frame = view.bounds
        
        gradientlayer.colors = [UIColor.white.cgColor,UIColor.systemIndigo.cgColor]
        gradientlayer.startPoint=CGPoint(x: 0.0, y: 0.0)
        gradientlayer.endPoint=CGPoint(x: 1.0, y: 1.0)
        view.layer.insertSublayer(gradientlayer, at: 0)
      
        
    }



    @IBAction func citySearch(_ sender: UIButton) {
        let geoCoder = CLGeocoder()
        let place = searchL.text ?? ""
        print(place)
        
        geoCoder.geocodeAddressString(place) { geoData, _ in
            let lat:Double
            let long:Double
            lat = geoData?[0].location?.coordinate.latitude ?? 0
            long = geoData?[0].location?.coordinate.longitude ?? 0
            

            
            self.weatherVM.getWeatherDataVM(lat: lat, long: long) { weatherArray in
                DispatchQueue.main.async {
                      let vc = self.storyboard?.instantiateViewController(withIdentifier: "detailsvc") as! DetailsVC
                      vc.fetchedData = weatherArray
                      self.present(vc, animated: true)
                }
            }
            
        }
        
        
    }
    
    
    @IBAction func topCityClick(_ sender: UIButton) {
        let geoCoder = CLGeocoder()
        let selectedCity :String?
        selectedCity =  sender.titleLabel?.text
        geoCoder.geocodeAddressString(selectedCity ?? "") { geoData, _ in
            
            let lat = geoData?[0].location?.coordinate.latitude
            let latitude = Double(lat ?? 0)
            let long = geoData?[0].location?.coordinate.longitude
            let longitude = Double(long ?? 0)
//            print("Latitude:\(lat!),Longitude:\(long!)")
            

            
            self.weatherVM.getWeatherDataVM(lat: latitude, long: longitude) { weatherArray in
                DispatchQueue.main.async {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "detailsvc") as! DetailsVC
                    vc.fetchedData = weatherArray
                    self.present(vc, animated: true)
                }
            }
            
        }
        
        
        
        
        
    }
    
    
    @IBAction func currentWeatherClick(_ sender: UIButton) {
        
        var currentLocation: CLLocation!
        let locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways{
            currentLocation = locManager.location
        }
     
        
        let lat:Double
        let long:Double
        lat = currentLocation.coordinate.latitude
        long = currentLocation.coordinate.longitude

        
        self.weatherVM.getWeatherDataVM(lat: lat, long: long) { weatherArray in
            DispatchQueue.main.async {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "detailsvc") as! DetailsVC
                vc.fetchedData = weatherArray
                self.present(vc, animated: true)
            }
        }
        
    }
    
    
    
}

