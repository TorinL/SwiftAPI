//
//  Controller.swift
//  new-api
//
//  Created by Torin Longaker on 5/19/17.
//
//

import Foundation
import Kitura
import SwiftyJSON
import LoggerAPI
import CloudFoundryEnv
import Configuration
#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

public class Controller {
    
    let router: Router
    
    //let appEnv: AppEnv  //Declared in CloudFoundryEnv -- if not set, will run on localhost
    
    let appEnv = ConfigurationManager()
    
    
    
    var url: String {
        
        get { return appEnv.url }
        
    }
    
    var port: Int {
        
        get { return appEnv.port }
        
    }
    
    let vehicleArray: [Dictionary<String, Any>] = [
        ["make":"Dodge", "model":"Challenger", "Year": 2016],
        ["make":"Ford", "model":"Mustang", "Year": 1969],
        ["make":"Tesla", "model":"Model S", "Year": 2017],
    ]
    
    init() throws{
        
        router = Router()
        
        router.get("/", handler: getMain)
        router.get("/vehicles", handler: getAllVehicles)
        router.get("vehicles/random", handler: getRandomVehicle)
        
    }
    
    public func getMain(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        
        Log.debug("GET / router handler...")
        
        var json = JSON([:])
        
        json["udemy-course"].stringValue = "learning swift API development with Kitura & bluemix"
        
        json["name"].stringValue = "Torin Longaker"
        
        json["company"].stringValue = "Galvanize"
        
        try response.status(.OK).send(json:json).end() 
        
    }
    
    public func getAllVehicles(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        let json = JSON(vehicleArray)
        try response.status(.OK).send(json: json).end()
    }
    
    public func getRandomVehicle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        #if os(Linux)
            srandom(UInt32(NSDate().timeIntervalSince1970))
            let index = random() % vehicleArray.count
        #else
            let index = Int(arc4random_uniform(UInt32(vehicleArray.count)))
        #endif
    
        let json = JSON(vehicleArray[index])
        try response.status(.OK).send(json: json).end()
      }
    }

