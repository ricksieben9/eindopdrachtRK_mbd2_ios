//
//  Pokemon.swift
//  eindopdrachtRK_iOS
//
//  Created by Macbook 14 on 07/02/2020.
//  Copyright © 2020 RK. All rights reserved.
//

import Foundation

//Codable wordt gebruikt om van een JSON naar een swift format te gaan
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

// '?' betekend dat het object optioneel is. dus het int? betekent dat het OF leeg is, OF een int
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
