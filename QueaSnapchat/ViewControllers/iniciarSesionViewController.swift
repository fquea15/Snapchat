//
//  ViewController.swift
//  QueaSnapchat
//
//  Created by Ruben Freddy Quea Jacho on 7/11/23.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import Firebase
import FirebaseDatabase



class iniciarSesionViewController: UIViewController{

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func IniciarSesionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!){
            (user, error) in
            if error != nil {
                self.showUserNotFoundAlert()
            }else{
                self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
            }
        }
    }
    
    func showUserNotFoundAlert() {
        let alert = UIAlertController(title: "Error", message: "Usuario no encontrado. ¿Desea crear un nuevo usuario?", preferredStyle: .alert)

        let createButton = UIAlertAction(title: "Crear", style: .default) { (action) in
            self.performSegue(withIdentifier: "crearUsuarioSegue", sender: nil)
        }

        let cancelButton = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)

        alert.addAction(createButton)
        alert.addAction(cancelButton)

        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func InciarSesionGoogleTapped(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
       let config = GIDConfiguration(clientID: clientID)
       GIDSignIn.sharedInstance.configuration = config
       GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
         guard error == nil else {
             return
         }

         guard let user = result?.user,
           let idToken = user.idToken?.tokenString
         else {
             return
         }
         let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                        accessToken: user.accessToken.tokenString)
       Auth.auth().signIn(with: credential) { result, error in
           if let error = error {
               print("Error al iniciar sesión con Google: \(error.localizedDescription)")
           } else {
               print("Inicio de sesión exitoso con Google")
           }
       }
           
       }
    }
    

    
}



