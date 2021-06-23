//
//  LoginViewController.swift
//  On the Map
//
//  Created by YoYo on 2021-06-10.
//

import UIKit
class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        usernameTextField.text = ""
        passwordTextField.text = ""
        activityIndicator.isHidden = true
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "1")!)
        activityIndicator.hidesWhenStopped = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        usernameTextField.text = ""
        passwordTextField.text = ""
    }
   
    @IBAction func loginButtonTapped(_ sender: Any) {
        setLogging(true)
        Client.postSession(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "",completionHandler: handleLoginRequest(success:error:))
    }
    
    
    func handleLoginRequest(success: Bool, error: Error?){
        if !success{
            showLoginFailure(message: error?.localizedDescription ?? "")
        }else{
            print(Client.Auth.sessionId)
            print("Login Success")
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
        setLogging(false)
        }
    
   
    


func showLoginFailure(message: String){
    let alerVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
    alerVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    show(alerVC, sender: nil)
}
    func setLogging(_ loggingIn: Bool){
        if loggingIn{
            activityIndicator.startAnimating()
        }else{
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
        usernameTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
    }
}


extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
}

