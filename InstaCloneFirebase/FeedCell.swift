

import UIKit
import FirebaseFirestore

class FeedCell: UITableViewCell {

    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var commentText: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    
    @IBOutlet weak var documentIdLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func likeClickedButton(_ sender: Any) {
        
        let fireStoreDatabase = Firestore.firestore()
        
        if let likeCount = Int(likeLabel.text!){
            
            let likeStore = ["likes" : likeCount + 1 ] as [String : Any]
            
            fireStoreDatabase.collection("Posts").document(documentIdLabel.text!).setData(likeStore, merge: true)  // butun verılerı tekrar guncelleme sadece "likes" ı güncelle demiş oluyoruz boyle " .setData()" kullanarak.
        }
        
    }
}
