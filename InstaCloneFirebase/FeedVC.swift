
import UIKit
import FirebaseFirestore
import SDWebImage  // RESIMLERI GÖSTEREBILMEK ICIN

class FeedVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userUrlImageArray = [String]()
    var documentIdArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirestore()
        
    }
    
    // MARK: DB'den veri alma methodu
    func getDataFromFirestore(){
        
        let fireStoreDatabase = Firestore.firestore()
        fireStoreDatabase.collection("Posts").order(by:"date", descending: true).addSnapshotListener { snapshot, error in // orderBy ekliyerek tarihe göre al ve true diyerek güncelden başla eskiye dogru sırala demıs oluyoruz.
            if error != nil {
                print("hata alındı")
            }else{
                //snapshot boş değil veya nil değil ise işlemleri yap
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                    //Bir Yeni veri yüklendiğinde Butun arrayleri temizleyip yeniden yazdırmak için tableview de tekrar tekrar yazırmaması ıcın
                    self.userUrlImageArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    
                    
                    for document in snapshot!.documents{  // snapshot.document bana bir dizi verir.
                        
                        let documentID = document.documentID // firebasedeki Dokuman ID me yani Oluşturulan her bir gönderi ID sini alıyorum,Ve bunu Kullanarak aşağıdada bir gönderimin içerisinde bulunan değişkenlerimin bilgilerini alacağım
                        self.documentIdArray.append(documentID)
                        
                        if let postedBy = document.get("postedBy") as? String {
                            self.userEmailArray.append(postedBy)
                        }
                        if let postComment = document.get("PostComment") as? String {
                            self.userCommentArray.append(postComment)
                        }
                        if let imageUrl = document.get("imageUrl") as? String {
                            self.userUrlImageArray.append(imageUrl)
                        }
                        if let likes = document.get("likes") as? Int {
                            self.likeArray.append(likes)
                        }
                        
                    }
                    
                    self.tableView.reloadData()
                }
                
            }
        }
    }
    
    
    //MARK:  TableView Kodları
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! FeedCell  // Casting ederek türünü değiştiriyoruz. Inheritance yapmış oluyoruz."cell." diyerek içerisindeki butun değişkenlere ulaşabiliyoruz
        cell.userEmailLabel.text = userEmailArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.commentText.text = userCommentArray[indexPath.row]
        cell.userImageView.sd_setImage(with: URL(string: self.userUrlImageArray[indexPath.row])) // buradaki method firebasedeki imageurl ımı kendi dönüştürüp telefonumda göstermemize yarıyor.
        cell.documentIdLabel.text = documentIdArray[indexPath.row] 
        return cell
    }

}
