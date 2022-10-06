//
//  Plan.swift
//  PlanMaster
//
//  Created by Jenny Kim on 4/18/22.
//  jkim4020@usc.edu

import Foundation
import CoreLocation

struct Destination: Equatable, Encodable, Decodable {
    var place: String
    var time: String
    var lat: Double
    var long: Double
    init(place: String, time: String, lat: Double, long: Double) {
        self.place = place
        self.time = time
        self.lat = lat
        self.long = long
    }
}

struct Transportation: Equatable, Encodable, Decodable {
    var type: Int
    var name: String
    var from: String
    var to: String
    init(type: Int, name: String, from: String, to: String) {
        self.type = type
        self.name = name
        self.from = from
        self.to = to
    }
}

struct Plan: Equatable, Encodable, Decodable {
    private var title: String
    private var with: String
    private var date: Date
    var transportation: [Transportation]
    var destination: [Destination]
    private var icon: String
    
    func getIcon() -> String {
        return icon
    }
    
    func getTitle() -> String {
        return title
    }

    func getWith() -> String {
        return with
    }

    func getDate() -> Date {
        return date
    }

    func getTransportation() -> [Transportation] {
        return transportation
    }

    func getDestination() -> [Destination] {
        return destination
    }
    
    func numberOfDestinations() -> Int {
        return destination.count
    }
    
    func numberOfTransportation() -> Int {
        return transportation.count
    }

    init(icon: String, title: String, with: String, date: Date, transportation: [Transportation], destination: [Destination]) {
        self.title = title
        self.with = with
        self.date = date
        self.transportation = transportation
        self.destination = destination
        self.icon = icon
    }
}
