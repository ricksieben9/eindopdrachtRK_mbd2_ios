//
//  Pokemon.swift
//  eindopdrachtRK_iOS
//
//  Created by Macbook 14 on 07/02/2020.
//  Copyright © 2020 RK. All rights reserved.
//

import Foundation

// Codable is used so that we can convert from JSON to swift format
struct AllPokemon : Codable {
    var results : [results]
}

struct results : Codable {
    var name : String;
    var url : String
}

struct sprites : Codable {
    var front_default : String?
}

// '?' means an object is optionel. So 'int?' means that it's either empty or an int
struct pokemonDetail : Codable {
    var abilities : [abilityObj]?
    var base_experience : Int?
    var height : Int?
    var weight : Int?
    var sprites : sprites?
}

struct ability : Codable {
    var name : String
}

struct abilityObj : Codable {
    var ability : ability
}
