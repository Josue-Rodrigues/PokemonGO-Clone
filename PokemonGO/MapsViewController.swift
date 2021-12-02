//
//  ViewController.swift
//  PokemonGO
//
//  Created by Josue Herrera Rodrigues on 16/09/21.
//

import UIKit
import MapKit
import CoreData
import FirebaseAuth

class MapsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var maps: MKMapView!
    var gerenciadorLocalizacao = CLLocationManager()
    var contador = 0
    var coreDataPokemon: CoreDataPokemon!
    var pokemons: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        maps.delegate = self
        
        configuraGenrenciadorLocalizacao()
        
        // Recuperando os Pokemons
        coreDataPokemon = CoreDataPokemon()
        pokemons = coreDataPokemon.recuperarTodosPokemons()
        
        
        // Exibir anotacoes (Pokemons)
        // Criando um timer de repetição - (withTimeInterval = 10s) - A cada 10s repete a linha abaixo
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            
            if let coordenadas = self.gerenciadorLocalizacao.location?.coordinate {
                
                let totalPokemons = UInt32(self.pokemons.count)
                // Gerando Pokemons Aleatorios
                let indicePokemonAleatorio = arc4random_uniform(totalPokemons)
                // Convertendo para Inteiro
                let pokemon = self.pokemons[ Int(indicePokemonAleatorio) ]
                
                let anotacao = PokemonAnotacao(coordenadas: coordenadas, pokemon: pokemon)
                
                // Gerando coordenadas aleatorias
                let latitudeAleatoria = (Double(arc4random_uniform(200))-100) / 100000.0
                let longitudeAleatoria = (Double(arc4random_uniform(200))-100) / 100000.0
                // Incrementando valores a latitude e longitude
                anotacao.coordinate.latitude += latitudeAleatoria
                anotacao.coordinate.longitude += longitudeAleatoria
                // Apresentando as anotacoes no mapa
                self.maps.addAnnotation( anotacao )
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let anotacaoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        if annotation is MKUserLocation {
            
            // Definindo a imagem que aparecera como "Usuario"
            anotacaoView.image = UIImage(named: "player")
            
            // Definindo e ajustando o tamnaho do imagem do "Usuario"
            var frameUsuario = anotacaoView.frame
            
            frameUsuario.size.height = 50
            frameUsuario.size.width = 50
            
            anotacaoView.frame = frameUsuario
            
            return anotacaoView
            
        }else{
            
            // Recuperando o pokemon
            let pokemon = (annotation as! PokemonAnotacao).pokemon
            
            // Definindo a imagem que aparecera como "Anotacoes" - Pokemons
            anotacaoView.image = UIImage(named: pokemon.nomeimagem!)
            
            // Definindo e ajustando o tamanho da imagem do pokemon
            var framePokemon = anotacaoView.frame
            
            framePokemon.size.height = 60
            framePokemon.size.width = 40
            
            anotacaoView.frame = framePokemon
            
            return anotacaoView
            
        }
    }
    
    // Definindo acao para quando selecionado a anotacao
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let anotacao = view.annotation
        let pokemon = (view.annotation as! PokemonAnotacao).pokemon
        
        mapView.deselectAnnotation( anotacao, animated: true )
        
        // Se a anotacao selecionada for o usuario ira retorna vazio
        if anotacao is MKUserLocation {
            
            return
            
        }
        
        // Recuperando as coordenadas do pokemon selecionado e centralizando ele na tela
        if let coordAnotacao = anotacao?.coordinate {
            
            // LatitudinalMeters e LongitudinalMeters = Aproximacao da visualizacao do mapa
            let regiao = MKCoordinateRegion (center: coordAnotacao, latitudinalMeters: 200, longitudinalMeters: 200)
            
            maps.setRegion(regiao, animated: true)
        }
        
        // Definindo um tempo para inicio da sequencia = 1 segundo
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { Timer in
            
            if let coord = self.gerenciadorLocalizacao.location?.coordinate {
                
                // Se o pokemon estiver dentro do campo de centralizacao do usuario, entao ira captura o pokemon e gerar um alerta.
                if self.maps.visibleMapRect.contains(MKMapPoint(coord)) {
                    self.coreDataPokemon.salvarPokemon(pokemon: pokemon)
                    self.maps.removeAnnotation( anotacao! )
                    
                    let alerta = UIAlertController(title: "Congratulation!!", message: "Pokemon " + pokemon.nome! + " capturado com sucesso!!", preferredStyle: .alert)
                    
                    let confirmar = UIAlertAction(title: "Confirmar", style: .default , handler: nil)
                    
                    alerta.addAction(confirmar)
                    
                    self.present(alerta, animated: true, completion: nil)
                    
                }else{
                    
                    // Caso nao esteja dentro do campo de centralizacao do usuario, ira gerar um alerta avisando
                    let alerta = UIAlertController(title: "Erro ao tentar capturar pokemon!!", message: "Pokemon " + pokemon.nome! + " esta fora do raio de captura. Se aproxime e tente novamente", preferredStyle: .alert)
                    
                    let confirmar = UIAlertAction(title: "Tentar novamente", style: .default , handler: nil)
                    
                    alerta.addAction(confirmar)
                    
                    self.present(alerta, animated: true, completion: nil)
                    
                }
            }
        }
    }
    
    func configuraGenrenciadorLocalizacao(){
        
        // O objeto gerenciador sera administrado pela view controller, pois ela ja esta herdando do CLLocation
        gerenciadorLocalizacao.delegate = self
        // Configurando precisao
        gerenciadorLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
        // Solicitar permissao de acesso ao GPS
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        // Iniciar localizacao do Usuario
        gerenciadorLocalizacao.startUpdatingLocation()
    }
    
    func centralizarLocalizacao(){
        
        // Recuperando as coordenadas e centralizando
        if let coordenadas = gerenciadorLocalizacao.location?.coordinate {
            
            // LatitudinalMeters e LongitudinalMeters = Aproximacao da visualizacao do mapa
            let regiao = MKCoordinateRegion (center: coordenadas, latitudinalMeters: 200, longitudinalMeters: 200)
            
            maps.setRegion(regiao, animated: true)
        }
    }
    
    // Checando resposta do Usuario - Autorizacao para uso da localizacao
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        // Se a resposta for diferente (!=) de autorizado e diferente (!=) de não determinado, então:
        if status != .authorizedWhenInUse && status != .notDetermined {
            
            // Criando um alerta para solicitacao de permissao
            let alertaController = UIAlertController(title: "Permissão de acesso a localização", message: "Necessario a permissão de acesso de sua localização para que você possa caçar Pokemon!! Por favor habilite", preferredStyle: .alert)
            
            // Criando um Closure após o Handler
            let acaoConfiguracao = UIAlertAction(title: "Abrir configurações", style: .default , handler: { (alertaConfiguracoes) in
                
                // Levando o usuario até a tela de configuracoes
                if let configuracoes = NSURL(string:  UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(configuracoes as URL)
                }
            })
            
            // Criando o botao CANCELAR
            let acaoCancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
            
            // Adicionando os botoes no alerta
            alertaController.addAction(acaoConfiguracao)
            alertaController.addAction(acaoCancelar)
            
            // Apresentando o alerta na tela
            present(alertaController, animated: true, completion: nil)
            
        }
    }
    
    // Localizando o usuario
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Se o contador foi menor que 4 - (Quantidade suficiente para aproximar e centralizar 1 unica vez)
        if contador < 4 {
            // Chama a funca de Centralizacao do mapa
            centralizarLocalizacao()
            // Funcao de incremento na variavel contador
            contador += 1
            
        }else{
            
            // Interrompe a centralizacao e deixar o mapa livre
            gerenciadorLocalizacao.stopUpdatingLocation()
            
        }
    }
    
    @IBAction func botaoCentralizar(_ sender: Any) {
        
        // Chama a funcao de centralizacao do mapa
        centralizarLocalizacao()
        
    }
    
    @IBAction func abrirPokedex(_ sender: Any) {
        
    }
    
    func alertaPokemonNaoCapturado (){
        
        let alerta = UIAlertController(title: "Erro ao tentar capturar pokemon!!", message: "Pokemon fora do raio de captura. Tente novamente", preferredStyle: .alert)
        
        let confirmar = UIAlertAction(title: "Tentar outro Pokemon", style: .default , handler: nil)
        
        alerta.addAction(confirmar)
        
        present(alerta, animated: true, completion: nil)
        
    }
    
    @IBAction func sair(_ sender: Any) {
        
        let alerta = UIAlertController(title: "ATENÇÃO!!", message: "Você esta prestes a sair do jogo, deseja realmente fazer isto??", preferredStyle: .alert)
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .destructive , handler: nil)
        
        //      Caso o usuario confirme a acao ao clicar no botao confirmar, sera executado o codigo de SignOut abaixo
        let continuar = UIAlertAction(title: "Continuar", style: .default, handler: {(action) in
            
            do {
//              Realizando o Logoff do usuario
                try Auth.auth().signOut()
//              Caso o usuario clique em continuar a tela atual sera fecha ele sera direcionado para a tela de inicio
                self.dismiss(animated: true, completion: nil)
                
                print("Sucesso ao deslogar o usuario")
                
            } catch {
                print("Errou ao deslogar o usuario")
            }
            
        })
        
        alerta.addAction(cancelar)
        alerta.addAction(continuar)
        
        present(alerta, animated: true, completion: nil)
        
    }
}

