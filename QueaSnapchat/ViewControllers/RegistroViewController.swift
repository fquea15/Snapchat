//
//  RegistroViewController.swift
//  QueaSnapchat
//
//  Created by Ruben Freddy Quea Jacho on 19/11/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegistroViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func RegistrarTapped(_ sender: Any) {
        Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: {
            (user, error) in
            print("Intentando crear un usuario")
            if error != nil {
                print("Se presento el siguiente error al crear el usuario: \(error)")
            }else {
                print("el usuario fue creado exitosamente")
                Database.database().reference().child("usuarios").child(user!.user.uid).child("email").setValue(user!.user.email)
                
                let alerta = UIAlertController(title: "Creacion de Usuario", message: "Usuario \(self.emailTextField.text!) se creo correctamente.", preferredStyle: .alert)
                let btnOk = UIAlertAction(title: "Aceptar", style: .default,handler: {
                    (UIAlertAction)  in
                    self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
                })
                alerta.addAction(btnOk)
                self.present(alerta, animated: true, completion: nil)
            }
        })

    }

}
