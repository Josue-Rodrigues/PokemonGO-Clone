//
//  PokemonAnotacao.swift
//  PokemonGO
//
//  Created by Josue Herrera Rodrigues on 29/09/21.
//

import UIKit
import MapKit

// Customizando a CLASS MKANNOTATION

class PokemonAnotacao: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var pokemon: Pokemon
    
    init(coordenadas: CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coordenadas
        self.pokemon = pokemon
    }
}
