//
//  Registration.swift
//  HotelManzana
//
//  Created by Adnann Muratovic on 04.12.21.
//

import Foundation

struct Registration: Codable {
    var firstname: String
    var lastname: String
    var email: String
    
    var checkInDate: Date
    var checkOutDate: Date
    var numberOfAdults: Int
    var numberOfChildren: Int
    
    var wifi: Bool
    var roomType: RoomType
    
    static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentDirectory.appendingPathComponent("registration").appendingPathExtension("plist")
    
    static func saveRegistration(_ registration: [Registration]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedRegistration = try? propertyListEncoder.encode(registration)
        
        try? codedRegistration?.write(to: archiveURL, options: .noFileProtection)
    }
    
    static func loadRegistration() -> [Registration]? {
        guard let codedRegistration = try? Data(contentsOf: archiveURL) else { return nil }
        
        let propertyListDecoder = PropertyListDecoder()
        
        return try! propertyListDecoder.decode([Registration].self, from: codedRegistration)
    }
}

struct RoomType: Equatable, Codable {
    var id: Int
    var name: String
    var shortName: String
    var price: Int
    
    // Equatable Protocol Implementation for RoomType
    static func ==(lhs: RoomType, rhs: RoomType) -> Bool {
        return lhs.id == rhs.id
    }
    
    static var all: [RoomType] {
        return [RoomType(id: 0,
                         name: "Two Queens",
                         shortName: "2Q",
                         price: 179),
                RoomType(id: 1,
                         name: "One King",
                         shortName: "K",
                         price: 209),
                RoomType(id: 2,
                         name: "Penthouse Suite",
                         shortName: "PHS",
                         price: 309)
        ]
    }
}
