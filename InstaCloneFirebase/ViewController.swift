
import UIKit
import FirebaseAuth


class ViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: kullanıcı girişi
    @IBAction func signInClicked(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != "" {
            
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { AuthData, AuthError in
                if AuthError != nil {
                    self.makeAlert(title: "Error!", msg: AuthError?.localizedDescription ?? "Error")
                    
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        }else {
            makeAlert(title: "Error", msg: "Username/Password Girilmemiş olabilir kontrol ediniz.")
        }
        
    }
    // MARK: kullanıcı kayıdı
    @IBAction func signUpClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != ""{
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { authData, authError in
                
                //Kontrol
                if authError != nil {
                    self.makeAlert(title: "Error", msg: authError?.localizedDescription ?? "Error") // Msg ye böylede yazabiliriz otomatık hatanın ne oldugunu dondurur veya kendimiz yazabılırız. Fairbase den bir hata mesajı gelmezse  ?? kullanarak kendı mesajımı göster demiş oluruz.
                }else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }else {
            makeAlert(title: "Error", msg: "Username/Password Girilmemiş olabilir kontrol ediniz.")

        }
       
        
    }
    // Bir Uyarı Mesajı Göstermek İçin Alert Oluşturduk
    func makeAlert(title:String,msg:String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}

