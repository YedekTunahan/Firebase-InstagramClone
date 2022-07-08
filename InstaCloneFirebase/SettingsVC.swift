
import UIKit
import FirebaseAuth

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logouthClicked(_ sender: Any) {
        
        do{
            try Auth.auth().signOut()  // Şimdi bunu çalıştırdıktan sonra performsegu diyerek giriş ekranına gidebilirz.Ayrıca SceneDelegate klasöründe  Auth işlemini ayrı bir fonksıyon olarak tanımlayıp bu fonksıyonu çağırabiliriz ve bu işlemi tekrar çalıştırıp gerçekten bir sıkıntı varmı yokmu onu anlamaya çalışabılırız.Ancak şuan  o kadar kasmıyoruz
            
            self.performSegue(withIdentifier: "toSecondVC", sender: nil)
        }catch{
            print("error")
        }
       
    }
    

}
