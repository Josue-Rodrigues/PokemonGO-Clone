//
//  CoreDataPokemon.swift
//  PokemonGO
//
//  Created by Josue Herrera Rodrigues on 29/09/21.
//

import UIKit
import CoreData

class CoreDataPokemon {
    
//  Recuperando o Context
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        return context!
        
    }
    
//  Salvando os pokemons capturados
    func salvarPokemon(pokemon:Pokemon) {
        
        let context = getContext()
        pokemon.capturado = true
        
        do {
            try context.save()
        } catch {
        }
    }
    
//  Adicionando todos os pokemons
    func adicionarTodosPokemons(){
        
        let context = getContext()
        
//      Chamando a funcao CRIARPOKEMON e atribuindo valores a ela
        self.criarPokemon(nome: "Arcanino", nomeimagem: "Arcanino", capturado: false)
        self.criarPokemon(nome: "Bulbasaur", nomeimagem: "Bulbasaur", capturado: false)
        self.criarPokemon(nome: "Charmander", nomeimagem: "Charmander", capturado: true)
        self.criarPokemon(nome: "Eevee", nomeimagem: "Eevee", capturado: false)
        self.criarPokemon(nome: "Butterfly", nomeimagem: "Butterfly", capturado: false)
        self.criarPokemon(nome: "Gendar", nomeimagem: "Gendar", capturado: false)
        self.criarPokemon(nome: "Meowth", nomeimagem: "Meowth", capturado: false)
        self.criarPokemon(nome: "Pidgeot", nomeimagem: "Pidgeot", capturado: false)
        self.criarPokemon(nome: "Pikachu", nomeimagem: "Pikachu", capturado: false)
        self.criarPokemon(nome: "Psyduck", nomeimagem: "Psyduck", capturado: false)
        self.criarPokemon(nome: "Sapphire", nomeimagem: "Sapphire", capturado: false)
        self.criarPokemon(nome: "Squirtle", nomeimagem: "Squirtle", capturado: false)
        self.criarPokemon(nome: "Tentacool", nomeimagem: "Tentacool", capturado: false)
        
//      Salvando os dados de pokemon
        
        do {
            try context.save()
        } catch {
            
        }
    }
    
//  Criando os pokemons
    func criarPokemon(nome: String, nomeimagem: String, capturado: Bool) {
        
        let context = self.getContext()
        let pokemon = Pokemon(context: context)
        
        pokemon.nome = nome
        pokemon.nomeimagem = nomeimagem
        pokemon.capturado = capturado
        
    }
    
    func recuperarTodosPokemons() -> [Pokemon] {
        
        let context = self.getContext()
        
        do {
            
            let pokemons = try context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
            
//          Verificando se conseguimos recuperar algum pokemon, caso contrario adicionaremos todos
            if pokemons.count == 0 {
                self.adicionarTodosPokemons()
                return self.recuperarTodosPokemons()
                
            }
            
//          Caso ja tenha Pokemons adicionados ele retornara a POKEMONS
            return pokemons
            
        } catch {
        }
        
        return []
    }
    
    func recuperarPokemonsCapturados(capturado: Bool) -> [Pokemon] {
        
        let context = self.getContext()
        
        let requisicao = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
        requisicao.predicate = NSPredicate(format: "capturado = true")
        
        do {
            
            let pokemons = try context.fetch(requisicao) as [Pokemon]
            
            return pokemons
            
        } catch {
        }
        return []
    }
    
    func recuperarPokemonsNaoCapturados(capturado: Bool) -> [Pokemon] {
        
        let context = self.getContext()
        
        let requisicao = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
        requisicao.predicate = NSPredicate(format: "capturado = false")
        
        do {
            
            let pokemons = try context.fetch(requisicao) as [Pokemon]
            
            return pokemons
            
        } catch {
        }
        return []
    }
}
