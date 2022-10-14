//
//  User.swift
//  BasicRxSwift
//
//  Created by Tam Nguyen K.T. [7] VN.Danang on 14/10/2022.
//

import Foundation
import Alamofire
import RxRelay
import ObjectMapper

final class User: NSObject, Mappable {

    static var me: BehaviorRelay<User?> = BehaviorRelay(value: nil)

    internal init(id: NSNumber? = nil, name: String? = nil, username: String? = nil, email: String? = nil, address: Address? = nil, phone: String? = nil, website: String? = nil, company: Company? = nil) {
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.address = address
        self.phone = phone
        self.website = website
        self.company = company
    }
    

    var id: NSNumber?
    var name: String?
    var username: String?
    var email: String?
    var address: Address?
    var phone: String?
    var website: String?
    var company: Company?

    required init?(map: Map){
    }

    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        username <- map["username"]
        email <- map["email"]
        address <- map["address"]
        phone <- map["phone"]
        website <- map["website"]
        company <- map["company"]
    }
}

class Company: NSObject, Mappable {

    var name: String?
    var catchPhrase: String?
    var bs: String?

    required init?(map: Map){
    }

    func mapping(map: Map) {
        name <- map["name"]
        catchPhrase <- map["catchPhrase"]
        bs <- map["bs"]
    }
}

class Address: NSObject, Mappable {

    var street: String?
    var suite: String?
    var city: String?
    var zipcode: String?
    var geo: Geo?

    required init?(map: Map){
    }

    func mapping(map: Map) {
        street <- map["street"]
        suite <- map["suite"]
        city <- map["city"]
        zipcode <- map["zipcode"]
        geo <- map["geo"]
    }
}

class Geo: NSObject, Mappable {

    var lat: String?
    var lng: String?

    required init?(map: Map){
    }

    func mapping(map: Map) {
        lat <- map["lat"]
        lng <- map["lng"]
    }
}

