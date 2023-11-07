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



class iniciarSesionViewController: UIViewController, GIDSignIn{

    
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
                print("Se presento el siguiente error: \(error)")
            }else{
                print("Inicio de sesion exitoso")
            }
        }
    }
    @IBAction func InciarSesionGoogleTapped(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Crea el objeto de configuración de inicio de sesión de Google.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Inicia el flujo de inicio de sesión de Google.
            GIDSignIn.sharedInstance().signIn(withPresenting: self) { [unowned self] (result: GIDGoogleUser?, error: Error?) in
                guard let result = result else {
                    
                    return
                }

            guard let user = result?.user,
                let idToken = user.authentication.idToken
            else {
                // Maneja el caso donde no se obtuvo el usuario o el token de ID.
                print("No se pudo obtener el usuario o el token de ID.")
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.authentication.accessToken)

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    // Maneja el error al autenticar con Firebase.
                    print("Error al autenticar con Firebase: \(error.localizedDescription)")
                    return
                }

                // Si no hay errores, el inicio de sesión con Google fue exitoso.
                print("Inicio de sesión con Google exitoso!")
            }
        }
    }
    
}



