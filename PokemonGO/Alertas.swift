//
//  Alertas.swift
//  PokemonGO
//
//  Created by Valeria Moreira pereira rodrigues on 25/10/21.
//

import UIKit

class alertas {
    
    func alerta(titulo: String, messagem: String, confirmar: String) {
        
        let alerta = UIAlertController(title: titulo, message: messagem, preferredStyle: .alert)
        
        let confirmar = UIAlertAction(title: confirmar, style: .default , handler: nil)
        
        alerta.addAction(confirmar)
    }
}
