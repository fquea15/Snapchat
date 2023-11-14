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



class iniciarSesionViewController: UIViewController{

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func IniciarSesionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!){
            (user, error) in
            print("Intentando Iniciar Sesion")
            if error != nil {
                print("**************************")
                print("Se presento el siguiente error: \(error)")
                print("**************************")
                Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: {
                    (user, error) in
                    print("Intentando crear un usuario")
                    if error != nil {
                        print("Se presento el siguiente error al crear el usuario: \(error)")
                    }else {
                        print("el usuario fue creado exitosamente")
                        self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
                    }
                })
            }else{
                print("**************************")
                print("Inicio de sesion exitoso")
                print("*************************")
                self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
            }
        }
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
               print("************************************")
               print("Error al iniciar sesión con Google: \(error.localizedDescription)")
               print("************************************")
           } else {
               print("************************************")
               print("Inicio de sesión exitoso con Google")
               print("************************************")
           }
       }
           
       }
    }
    
}



