//
//  JsonDecoder.swift
//  DogBreedClassifier
//
//  Created by Chris Saad on 9/27/18.
//  Copyright © 2018 Chris Saad. All rights reserved.
//

import UIKit

struct Response: Decodable {
    let encoding: String?
    let version: String?
    let petfinder: Petfinder?
}

struct Pets: Decodable {
    let pet: [Pet]?
}

struct Petfinder: Decodable {
    let pets: Pets?
    let lastOffset: Dictionary<String, String>?
    let header: Header?
}

struct Header: Decodable {
    let timestamp: Dictionary<String, String>?
    let status: Status?
    let version: Dictionary<String, String>?
}

struct Status: Decodable {
    let message: Dictionary<String, String>?
    let code: Dictionary<String, String>?
}

struct Pet: Decodable {
    let id: Dictionary<String, String>?
    let shelterId: Dictionary<String, String>? = nil
    let shelterPetId: Dictionary<String, String>? = nil
    let name: Dictionary<String, String>?
    let animal: Dictionary<String, String>?
    let breeds: Breeds? = nil
    let mix: Dictionary<String, String>?
    let age: Dictionary<String, String>?
    let sex: Dictionary<String, String>?
    let size: Dictionary<String, String>?
    let options: Option? = nil
    let description: Dictionary<String, String>?
    let lastUpdate: Dictionary<String, String>?
    let status: Dictionary<String, String>?
    let media: Media?
    let contact: Contact?
    
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case animal
        case mix
        case age
        case sex
        case size
        case description
        case lastUpdate
        case status
        case media
        case contact
        
    }
    
}

struct Option: Decodable {
    let option: [Dictionary<String, String>]?
}


struct Breeds: Decodable {
    let breed: Dictionary<String?, String?>?
}


struct Contact: Decodable {
    let phone: Dictionary<String, String>?
    let state: Dictionary<String, String>?
    let address2: Dictionary<String, String>?
    let email: Dictionary<String, String>?
    let city: Dictionary<String, String>?
    let zip: Dictionary<String, String>?
    let fax: Dictionary<String, String>?
    let address1: Dictionary<String, String>?
}


struct Media: Decodable {
    let photos: Photo?
}

struct Photo: Decodable {
    let photo: [Dictionary<String, String>]?
}

//
//struct PhotoInst: Decodable {
//    let size: String?
//    let t: String?
//    let id: String?
//}

