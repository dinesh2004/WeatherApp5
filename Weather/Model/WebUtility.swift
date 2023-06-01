//
//  WebUtility.swift
//  Weather
//
//  Created by Aguru, Ganesh (Contractor) on 23/05/23.
// Absent days

import Foundation

struct WindInfo:Codable{
    var speed:Double
    var deg:Int
    //var gust:Double
}
//struct CloudInfo:Codable{
//    var speed:Double
//    //var deg:Int?
//    var gust:Double
//}
//
struct MainInfo:Codable{
    var temp:Double
    var feels_like:Double
    var temp_min:Double
    var temp_max:Double
    var pressure:Int
    var humidity:Int
   // var sea_level:Int
   //var grnd_level:Int
}

struct WeatherList :Codable{
    
    var weather:[WeatherSub]
    var main:MainInfo
    var visibility:Int
    var wind:WindInfo
    //var clouds: [CloudInfo]
    var name:String
    
    struct WeatherSub:Codable{
        var id:Int
        var main:String
        var description:String
        var icon:String
    }
    
}



struct WebUtility{
    
    static let shared = WebUtility()
    
    private init(){
        
    }
    

    //download the icon of the weather
    
    func downloadIcon(iconName:String, callback: @escaping (URL)->Void){
        
        let iconUrl = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
        
        let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
       
        let imagPath = docURL.appendingPathComponent(iconName)
        
        if FileManager.default.fileExists(atPath: imagPath.relativePath){
            callback(imagPath)
            return
        }
        
        let session = URLSession.shared
        if let imUrl = URL(string: iconUrl){
            let task = session.downloadTask(with: imUrl) { tempUrl, resp, err in
                if err == nil {
                    let status = (resp as! HTTPURLResponse).statusCode
                   
                    if status == 200{
                        try! FileManager.default.moveItem(at: tempUrl!, to: imagPath)
                        callback(imagPath)
                    }
                    else{
                        print("Something went wrong: \(status)")
                    }
                }
                else{
                    print("network issue")
                }
            }
            task.resume()
        }
        else{
            print("invalid image url")
        }
        
        
    }
    
    
    
    
    
    //higher order
    func getWeatherData(lat:Double,long:Double,handler:@escaping([WeatherList])->Void){
        
        //do http communication
        
        let weatherDataUrl = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=dc8606b5294e9f24b042383e39d8ccaa&units=metric"
        print(weatherDataUrl)
        // 1. reference of URLSeffion
        let session = URLSession.shared
        
        // 2. create request
        if let url = URL(string: weatherDataUrl) {
            
            // 3. Create Task
            
            let task = session.dataTask(with: url) { respData, httpResp, err in
                
                if err == nil{
                    
                    
                    let statusCode = (httpResp as! HTTPURLResponse).statusCode
                    
                    switch statusCode{
                    case 200...299:
                        print("Success")
                        let weatherList = parseData(jsonResponse: respData)
                        print("\(lat),\(long)")
                        print("respdata\(weatherList)")
                        print(weatherList.count)
                        //call the handler with weatherlist
                        handler(weatherList)
                    case 300...399:
                        print("Redirection")
                    case 400...499:
                        print("Client error")
                    case 500...599:
                        print("server error")
                    default:
                        print("Unknown error")
                    }
                    
                }else{
                    print("Request could not be completed because of network issue")
                }
                
            }
            task.resume()
        }else{
            print("Invalid url")
        }
        
        
        
    }
    
    
    
    //
    func parseData(jsonResponse:Data?)->[WeatherList]{
        
        guard let jResponse = jsonResponse else{
            return []
        }
        do{
            
           let weatherList = try JSONDecoder().decode(WeatherList.self, from: jResponse)
        
            return [weatherList]
            
        }catch{
            print(error)
        }
        return []
    }
    
}


