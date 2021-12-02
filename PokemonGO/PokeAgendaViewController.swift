//
//  PokeAgendaViewController.swift
//  PokemonGO
//
//  Created by Josue Herrera Rodrigues on 29/09/21.
//

import UIKit

class PokeAgendaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var pokemonsCapturados: [Pokemon] = []
    var pokemonsNaoCapturados: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let coreDataPokemon = CoreDataPokemon()
        
        self.pokemonsCapturados = coreDataPokemon.recuperarPokemonsCapturados(capturado: true)
        self.pokemonsNaoCapturados = coreDataPokemon.recuperarPokemonsNaoCapturados(capturado: false)
        
    }
//  Definindo a quantidade de secoes que serao utilizadas
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
//  Determinando o nome de cada secao atraves de um parametro
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return "Capturados"
            
        }else{
            return "Não Capturados"
        }
    }
    
//  Definindo a quantidade de itens que ira aparecer em cada secao
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return pokemonsCapturados.count
        }else{
            return pokemonsNaoCapturados.count
        }
    }
    
//  Definindo o que ira aparecer em cada um das secoes
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let pokemon: Pokemon
        
        if indexPath.section == 0 {
            pokemon = pokemonsCapturados[indexPath.row]
            
        }else{
            pokemon = pokemonsNaoCapturados[indexPath.row]
        }
        
//      Transportando o nome e a imagem de cada Pokemon para sua respectiva celula e linha
        let celula = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "celula")
        celula.textLabel?.text = pokemon.nome
        celula.imageView?.image = UIImage(named: pokemon.nomeimagem!)
        
//      Retornando e apresentando essa informacoes na tela para o usuario
        return celula
        
    }
    
    @IBAction func retornoMapa(_ sender: AnyObject) {
//      Dando a funcao de retorno ao mapa ao clicar no botao
        dismiss(animated: true, completion: nil)
        
    }
}
