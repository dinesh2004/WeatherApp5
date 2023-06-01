//
//  WeatherViewModel.swift
//  Weather
//
//  Created by B S, DINESH (Contractor) on 29/05/23.
//

import Foundation
import Network
import UIKit

class WeatherViewModel{
    
   let ntwMonitor = NWPathMonitor()
    var isConnected = false
    
    init(){
        ntwMonitor.pathUpdateHandler = { nwPath in
            switch nwPath.status{
                
            case .satisfied:
                print("Connection available")
                self.isConnected = true
            case .unsatisfied:
                print("Connection not available")
                self.isConnected = false
            case .requiresConnection:
                print("Connecting....")
                self.isConnected = false
            default:
                break
                
            }
        }
        ntwMonitor.start(queue: DispatchQueue(label: "myqueue"))
    }
    
    
    
   private let shared = WebUtility.shared
    
    
    func getWeatherDataVM(lat:Double,long:Double,handler: @escaping ([WeatherList])->Void){
        
        if isConnected{
            WebUtility.shared.getWeatherData(lat: lat, long: long, handler: handler)
        }else{
          
        }
        
    }
    
    
    
    func downloadIconVM(iconName:String,callback: @escaping (URL)->Void){
        
        WebUtility.shared.downloadIcon(iconName: iconName, callback: callback)
        
    }
    
    
}
