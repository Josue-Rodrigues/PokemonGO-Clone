//
//  CadastroViewController.swift
//  PokemonGO
//
//  Created by Josue Herrera Rodrigues on 20/10/21.
//

import UIKit
import FirebaseAuth

class CadastroViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var senha: UITextField!
    @IBOutlet weak var confirmarSenha: UITextField!
    @IBOutlet weak var nomeCompleto: UITextField!
    @IBOutlet weak var dataNascimento: UITextField!
    
    @IBAction func cadastrar(_ sender: Any) {
        cadastrarUsuario()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//  Fechando o teclado apos clicar fora do campo
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        
    }
    
    func cadastrarUsuario () {
        
        if let emailR = email.text {
            if let senhaR = senha.text {
                if let confirmarSenhaR = confirmarSenha.text {
                    if let nomeCompetoR = nomeCompleto.text {
                        if let dataNascimentoR = dataNascimento.text {
                            
                            if nomeCompetoR == "" || dataNascimentoR == "" || emailR == "" || senhaR == "" || confirmarSenhaR == "" {

                                exibirMensagem(titulo: "ATENÇÃO!!", mensagem: "Todos os campos devem ser devidamente preenchidos.")
                                
                            }else{
                                
                                if senhaR == confirmarSenhaR {
                                    
                                    let autenticar = Auth.auth()
                                    autenticar.createUser(withEmail: emailR, password: senhaR) { usuario, erro in
                                        if erro == nil {
                                            if usuario == nil {
                                                
                                                self.exibirMensagem(titulo: "ATENÇÃO!!", mensagem: "Erro ao autenticar acesso do usuario, feche a janela e tente novamente.")
                                                
                                            }else{
                                                
                                                let alerta = UIAlertController(title: "CONGRATULATION", message: "Cadastro realizado com sucesso. Aproveite o app e indique para sua rede de amigos", preferredStyle: .alert)
                                                
                                                let confirmar = UIAlertAction(title: "Confirmar", style: .default) { (ação) in
                                                    self.performSegue(withIdentifier: "cadastroUsuarioSegue", sender: nil) }
                                                
                                                alerta.addAction(confirmar)
                                            
                                                self.present(alerta, animated: true, completion: nil)
                                            }
                                            
                                        }else{
                                            
                                            let erroR = erro! as NSError
                                            if let codigoErro = erroR.userInfo["FIRAuthErrorUserInfoNameKey"] {
                                                
                                                let erroTexto = codigoErro as! String
                                                var mensagemErro = ""
                                                
                                                switch erroTexto {
                                                    
                                                case "ERROR_INVALID_EMAIL" :
                                                    mensagemErro = "E-mail invalido, digite um e-mail valido!"
                                                    break
                                                    
                                                case "ERROR_WEAK_PASSWORD" :
                                                    mensagemErro = "Senha deve conter no minimo 6 caracteres, sendo letras e numeros"
                                                    break
                                                    
                                                case "ERROR_EMAIL_ALREADY_IN_USE" :
                                                    mensagemErro = "Este E-mail ja esta sendo utilizado, cria a conta com um novo E-mail"
                                                    break
                                                    
                                                default:
                                                    mensagemErro = "Dados digitados estão incorretos"
                                                }
                                                
                                                self.exibirMensagem(titulo: "Dados Invalidos", mensagem: mensagemErro)
                                                
                                            }else{
                                                
                                                self.exibirMensagem(titulo: "ATENÇÃO!!", mensagem: "Confira todos os dados e tente novamente.")
                                                
                                            }
                                        }
                                    }
                                    
                                }else{
                                    
                                    exibirMensagem(titulo: "ATENÇÃO!!", mensagem: "Os campos de *Senha* e *Confirmar Senha* devem ser identicos. Feche a janela e tente novamente")
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func exibirMensagem(titulo: String, mensagem: String) {
        
        let alerta = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        
        let confirmar = UIAlertAction(title: "Confimar", style: .default , handler: nil)
        
        alerta.addAction(confirmar)
        
        self.present(alerta, animated: true, completion: nil)
        
    }
}
