

import UIKit
import FirebaseStorage
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class UploadVC: UIViewController , UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var uploadButton: UIButton! // Neden buttonu burada outlet olarak tanımladık, cunku resim seçilene kadar button gözükmesin istersem
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.isUserInteractionEnabled = true // imageview 'ı tıklanabilir hale getirdik
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    

    @objc func chooseImage(){
        
        let pickerController = UIImagePickerController() // kullanıcının kütüphanesine , galerisine erişebilmek için
        pickerController.delegate = self   // hata verir Vermemesi için yukarıda UploadVC  classında bir kaç sınıf inheritance(UIImagePickerControllerDelegate,UINavigationControllerDelegate) etmem gerekiyor.,
        pickerController.sourceType = .photoLibrary  // veriyi nereden alacağını söylüyoruz.
        present(pickerController, animated: true, completion: nil)
    }
    //Kullanıcı Resim seçtikten sonra ne yapılmasını ıstedıgımızı söylemek ıcın oluşturulan method.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageView.image = info[.originalImage] as? UIImage // cast ettik
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func makeAlertMessage(title:String,msg:String){
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func actionButtonClicked(_ sender: Any) {
        
        // MARK: Firebase'de storage 'e ulaşma adımı
        let storage = Storage.storage()
        let storageReference =  storage.reference() // biz bu referansı kullanarak nereye kayıt edeceğimizi seçiyoruz.Klasörün referansı
        let mediaFolder = storageReference.child("media") // Eğer firebasede biz kendimiz media dosyasını oluşturmasaydık otomatikmen kendi oluştururdu.
        
        // MARK: Resimi Kayıt Etme, veriye çevirme adımı,Kayıt işlemi,Biz görseli alıp veriye çevirmemiz ve bunu data olarak kayıt etmemiz gerekiyor.
        // 0.5 resimi nekadar sıkıştırayım dıye sordugu kısım
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString // her verinin kendi ID numarasına göre kayıt edilmesi için
            
            let  imageReference = mediaFolder.child("\(uuid).jpg")  // oluşturulacak görselin referansı
            
            // metadata ekstra bılgı eklemek ıstıyorsak kullanabılırız.Bız nil yaptık şuan ıcın
            imageReference.putData(data, metadata: nil) { metaData, metaError in
                
                if metaError != nil {
                    self.makeAlertMessage(title: "Error!", msg: metaError?.localizedDescription ?? "Veritabanına Yüklenirken Bir Hata Oluştu...")
                }else {
                    //metaDatayı kullanarak kullanıcının kayıt ettiği şeyin hangi url'e  kayıt edildiğini almak istiyoruz
                    imageReference.downloadURL { url, urlError in
                        
                        //hata yoksa işlemleri gerçekleştirme lartı
                        if urlError == nil {
                            
                            let imageUrl = url?.absoluteString   // yağtığı iş url'i al stringe çevir demek
                            
                            // MARK: DATABASE-Kayıt etme İşlemi ..., Yukarıda Resimi storage'e ekledik sonra adını tarıhını vb..Kulanıcının yorumu , resimin url ini Kayıt ediyoruz.(VIDEO 155 )
                             
                            let firestoreDatabase = Firestore.firestore()
                            var firestoreReference : DocumentReference? = nil   // db ye yazmak okumak ve degısık ıslemler yapabılmek ıcın oluşturulan referans
                            
                            //Oluşturulan içerik
                            let firestorePost = ["imageUrl":imageUrl!,"postedBy": Auth.auth().currentUser!.email! ,"PostComment":self.commentText.text! , "date": FieldValue.serverTimestamp() ,"likes": 0] as [String : Any]//postedBy postu yapan kim olduğu,o anki kayıtlı kullanıcı olcak
                            
                            // referansımız vasıtası ile  postumuzu db ye yollayıp kayıt ettik
                             firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { Error in
                                
                                if Error != nil {
                                    self.makeAlertMessage(title: "Error!", msg: Error?.localizedDescription ?? "Database'e Yüklenirken Bir Hata Oluştu")
                                }else {
                                    //DATABASE Kayıt edildiyse , yapılacak işlemler
                                    
                                    // 1) ekranı temizleme işlemi
                                    self.imageView.image = UIImage(named: "selectt.png")
                                    self.commentText.text = ""
                                    // 2) 1.ekrana gitme işlemi
                                    self.tabBarController?.selectedIndex = 0  // kayıt işlemi gerçekleştiğinde beni tabbarın sıfırıncı index inde bulunan sayfaya götür demiş oluyoruz
                                }
                            })
                        }
                    }
                    
                }
            }
            
        }
        
        
    }
    

}
