//
//  DetailsVC.swift
//  Weather
//
//  Created by B S, DINESH (Contractor) on 26/05/23.
//

import UIKit

class DetailsVC: UIViewController {
    
    var fetchedData : [WeatherList]? = nil
    var weatherIconVM = WeatherViewModel()
    
    //Ganesh Aguru
    


    @IBOutlet weak var minmaxL: UILabel!
    @IBOutlet weak var mainTempL: UILabel!
    @IBOutlet weak var placeL: UILabel!
    @IBOutlet weak var weatherDescL: UILabel!
    
    @IBOutlet weak var iconIV: UIImageView!
    
    
    //weather details labels
    @IBOutlet weak var apparentTempL: UILabel!
    @IBOutlet weak var visibilityL: UILabel!
    @IBOutlet weak var airPressureL: UILabel!
    @IBOutlet weak var directionL: UILabel!
    @IBOutlet weak var humudityL: UILabel!
    @IBOutlet weak var windSpeedL: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradientlayer = CAGradientLayer()
        gradientlayer.frame = view.bounds
        
        gradientlayer.colors = [UIColor.white.cgColor,UIColor.systemPurple.cgColor]
        gradientlayer.startPoint=CGPoint(x: 0.0, y: 0.0)
        gradientlayer.endPoint=CGPoint(x: 1.0, y: 1.0)
        view.layer.insertSublayer(gradientlayer, at: 0)

      
        if let description = fetchedData?[0].weather[0].description{
            let vString = description.capitalized
            weatherDescL.text = vString
        }else{
            weatherDescL.text = nil
        }
      
        placeL.text = fetchedData?[0].name
        
        if let mainTemp = fetchedData?[0].main.temp{
            let mainTemp = String(mainTemp)
            mainTempL.text = "\(mainTemp)°C"
        }else{}
        
        if let icon = fetchedData?[0].weather[0].icon{
            print(icon)
            

            
            weatherIconVM.downloadIconVM(iconName: icon) { url in
                let iconData = try! Data(contentsOf: url)
                
                DispatchQueue.main.async {
                    self.iconIV.image = UIImage(data: iconData)
                }
            }
            
            
            

        }
        

        if let minmaxTemp = fetchedData?[0].main{
            let min = String(minmaxTemp.temp_min)
            let max = String(minmaxTemp.temp_max)
            minmaxL.text = "\(min)°C/\(max)°C"
        }else{}
        

        if let apparentTemp = fetchedData?[0].main.feels_like{
            let feelslike = String(apparentTemp)
            
            apparentTempL.text = feelslike
        }
        
        if let visibility = fetchedData?[0].visibility{
            let visibile = String(visibility)
            visibilityL.text = visibile
        }
        
        if let airP = fetchedData?[0].main.pressure{
            let pressure = String(airP)
            airPressureL.text = pressure
        }
        if let dir = fetchedData?[0].wind.deg{
            let direction = String(dir)
            directionL.text = direction
        }
        
        if let humid = fetchedData?[0].main.humidity{
            let humidity = String(humid)
            humudityL.text = humidity
        }
        
        if let ws = fetchedData?[0].wind.speed{
            let windSpeed = String(ws)
            windSpeedL.text = windSpeed
        }
      
       
    }
    

    

}
