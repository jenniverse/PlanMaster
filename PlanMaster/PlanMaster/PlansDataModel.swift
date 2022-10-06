//
//  PlansDataModel.swift
//  PlanMaster
//
//  Created by Jenny Kim on 4/18/22.
//  jkim4020@usc.edu

import Foundation
protocol PlansDataModel {
    func plan(at index: Int) -> Plan?
    func numberOfPlans() -> Int
    func insert(icon: String, title:String, with: String, date: Date, transportation:[Transportation], destination: [Destination], at index: Int)
    func removePlan(at index: Int)
    func rearrangePlans(from: Int, to: Int)
    func selectedPlan() -> Plan?
}
