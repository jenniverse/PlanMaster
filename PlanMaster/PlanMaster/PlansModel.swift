//
//  PlansModel.swift
//  PlanMaster
//
//  Created by Jenny Kim on 4/18/22.
//  jkim4020@usc.edu

import Foundation
import UIKit

class PlansModel: NSObject, PlansDataModel {
    private var plans = [Plan]()
    var selectedIndex: Int?
    var selectedDestinationIndex: Int?
    private var transportations = [Transportation]()
    private var destinations = [Destination]()
    static let shared = PlansModel()
    var planFilePath: String = ""
    
    override init() {
        super.init()
        
        let documentFolderPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        self.planFilePath = "\(documentFolderPath.first!)/plans.json"
        
        load()
        
        let filePath = URL(string: planFilePath)
        if filePath == nil || !FileManager.default.fileExists(atPath: filePath?.path ?? planFilePath) {
            self.transportations = [Transportation(type: 1, name: "Line A", from: "USC", to: "Santa Monica")]
            self.destinations = [Destination(place: "Santa Monica", time: "14:30", lat: 34.0099233, long: -118.496758)]
            self.plans = [Plan(icon: "😀", title: "Example Title", with: "Myself", date: Date(), transportation: transportations, destination: destinations)]
        }
        self.selectedIndex = nil
        self.selectedDestinationIndex = nil
    }
    
    func save() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(plans)
            let str = String(data: data, encoding: .utf8)
            let filePath = URL(string: planFilePath)!
            try! str?.write(to: filePath, atomically: true, encoding: .utf8)
        }
        catch {
            print("there is an error with encoding \(error)")
        }
    }
    
    func load() {
        do {
            let filePath = URL(string: planFilePath)
            if filePath == nil || !FileManager.default.fileExists(atPath: filePath?.path ?? planFilePath) {
                print("file doesn't exist")
                return
            }
            let data = try Data(contentsOf: filePath!)
            let decoder = JSONDecoder()
            plans = try decoder.decode([Plan].self, from: data)
        }
        catch {
            print("there is an error with decoding \(error)")
        }
    }
    
    func plan(at index: Int) -> Plan? {
        if index >= 0, index < plans.count {
            return plans[index]
        }
        else {
            return nil
        }
    }
    
    func numberOfPlans() -> Int {
        return plans.count
    }
    
    func insert(icon: String, title: String, with: String, date: Date, transportation: [Transportation], destination: [Destination], at index: Int) {
        var newindex: Int
        newindex = index
        if index < 0 {
            newindex = 0
        }
        if index > plans.count {
            newindex = plans.count
        }
        let newPlan = Plan(icon: icon, title: title, with: with, date: date, transportation: transportation, destination: destination)
        plans.insert(newPlan, at: newindex)
        save()
    }
    
    func insertDestination(name: String, time: String, lat: Double, long: Double, at index: Int) {
        let thisPlan = plans[selectedIndex!]
        
        var newindex: Int
        newindex = index
        if index > thisPlan.numberOfDestinations() {
            newindex = thisPlan.numberOfDestinations()
        }
        
        let newDestination = Destination(place: name, time: time , lat: lat, long: long)
        plans[selectedIndex!].destination.insert(newDestination, at: newindex)
        save()
    }
    
    func insertTransportation(type: Int, name: String, from: String, to: String, at index: Int) {
        let thisPlan = plans[selectedIndex!]
        
        var newindex: Int
        newindex = index
        if index > thisPlan.numberOfTransportation() {
            newindex = thisPlan.numberOfTransportation()
        }
        let newTransportation = Transportation(type: type, name: name, from: from, to: to)
        plans[selectedIndex!].transportation.insert(newTransportation, at: newindex)
        save()
    }
    
    func numOfDestination() -> Int {
        return plans[selectedIndex!].numberOfDestinations()
    }
    
    func numOfTransportation() -> Int {
        return plans[selectedIndex!].numberOfTransportation()
    }

    func removePlan(at index: Int) {
        if index >= 0, index < plans.count {
            plans.remove(at: index)
        }
        save()
    }
    
    func removeDestination(at index: Int) {
        plans[selectedIndex!].destination.remove(at: index)
        save()
    }
    
    func removeTransportation(at index: Int) {
        plans[selectedIndex!].transportation.remove(at: index)
        save()
    }
    
    func rearrangePlans(from: Int, to: Int) {
        let tempPlan = plan(at: from)
        
        removePlan(at: from)
        insert(icon: tempPlan!.getIcon(), title: tempPlan!.getTitle(), with: tempPlan!.getWith(), date: tempPlan!.getDate(), transportation: tempPlan!.getTransportation(), destination: tempPlan!.getDestination(), at: to)
        save()
    }
    
    func selectedPlan() -> Plan? {
        return plan(at: selectedIndex!)
    }
}
