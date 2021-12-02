//
//  LoginViewController.swift
//  PokemonGO
//
//  Created by Josue Herrera Rodrigues on 20/10/21.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var senha: UITextField!
    
    @IBAction func login(_ sender: Any) {
        loginUsuario()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let autenticacaoAutomatica = Auth.auth()
        autenticacaoAutomatica.addStateDidChangeListener { autenticacaoAutomatica, usuario in
            
            // Verificando se o Usuario esta logado e acessando direto
            if usuario != nil {
                self.performSegue(withIdentifier: "loginUsuarioSegue", sender: nil)
                
            }
        }
    }
    
//  Fechando o teclado apos clicar fora do campo
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func loginUsuario() {
        
        if let email = username.text {
            if let senha = senha.text {
                
                if email == "" || senha == "" {
                    
                    exibirMensagem(titulo: "ATENÇÃO!!", mensagem: "Todos os campos devem ser devidamente preenchidos.")
                    
                }else{
                    
                    let autenticacao = Auth.auth()
                    
                    autenticacao.signIn(withEmail: email, password: senha) { usuario, erro in
                        if erro == nil {
                            if usuario == nil {
                                self.exibirMensagem(titulo: "Erro ao autenticar!", mensagem: "Problema ao realizar autenticação, tente novamente")
                                
                            }else{
                                
                                // Redirecionando o usuario para tela principal ao clicar no botao
                                self.performSegue(withIdentifier: "loginUsuarioSegue", sender: nil)
                            }
                            
                        }else{
                            
                            let erroR = erro! as NSError
                            if let codigoErro = erroR.userInfo["FIRAuthErrorUserInfoNameKey"] {
                                
                                let erroTexto = codigoErro as! String
                                var messagemErro = ""
                                
                                switch erroTexto {
                                    
                                case "ERROR_INVALID_EMAIL" :
                                    messagemErro = "E-mail invalido, digite um e-mail valido e tente novamente!"
                                    break
                                    
                                case "ERROR_USER_NOT_FOUND" :
                                    messagemErro = "Usuario não cadastrado!"
                                    break
                                    
                                case "ERROR_WRONG_PASSWORD" :
                                    messagemErro = "Senha digitada não confere com o E-mail preenchido!"
                                    break
                                    
                                default:
                                    messagemErro = "E-mail e/ou senha digita estão incorreto!"
                                }
                                
                                self.exibirMensagem(titulo: "Dados Invalidos", mensagem: messagemErro)
                            }
                        }
                    }
                }
            }
            
        }else{
            exibirMensagem(titulo: "ATENÇÃO!!", mensagem: "Verifique os dados digitados e tente novamente.")
        }
    }
    
    func exibirMensagem (titulo: String, mensagem: String) {
        
        let alerta = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        
        let confirmar = UIAlertAction(title: "Confirmar", style: .default, handler: nil)
        
        alerta.addAction(confirmar)
        
        self.present(alerta, animated: true, completion: nil)
        
    }
}
