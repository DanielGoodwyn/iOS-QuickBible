import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
class ViewController: UIViewController, BibleViewControllerDelegate, ProfileViewControllerDelegate {
    var ref: DatabaseReference!
    var uid = "uid"
    var identifier = "ProfileViewController"
    var userIsSignedIn = false
    var online = false
    override func viewWillLayoutSubviews() { checkIfOnline() }
    func checkIfOnline() {
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if let connected = snapshot.value as? Bool, connected {
                self.online = true
                self.onlineIndicatorView.alpha = 0
            } else {
                self.online = false
                self.onlineIndicatorView.alpha = 1
            }
        })
    }
    @IBOutlet weak var onlineIndicatorView: UIView!
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ToBibleViewController") {
            let bibleViewController = segue.destination as! BibleViewController
            bibleViewController.delegate = self
            identifier = "ToBibleViewController"
        }
        if (segue.identifier == "ProfileViewController") {
            let profileViewController = segue.destination as! ProfileViewController
            profileViewController.delegate = self
            identifier = "ProfileViewController"
        }
    }
    func presentViewControllerWithIdentifier(data: String) { identifier = data }
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        checkIfUserIsSignedIn()
    }
    override func viewDidAppear(_ animated: Bool) {
        checkIfUserIsSignedIn()
        if online {
            self.ref.child("users").child(self.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let currentPage = value?["currentPage"] as? String ?? ""
                if currentPage == "profile" {
                    self.identifier = "ProfileViewController"
                } else {
                    self.identifier = "BibleViewController"
                }
                self.presentViewController()
            }) { (error) in
                self.alert(alertText: error.localizedDescription)
                //self.presentViewController()
            }
        } else {
            presentViewController()
        }
    }
    func checkIfUserIsSignedIn() {
        do {
            if Auth.auth().currentUser != nil {
                self.uid = Auth.auth().currentUser!.uid
                self.userIsSignedIn = true
            } else {
                self.uid = ""
                userIsSignedIn = false
            }
        }
        if uid == "" {
            userIsSignedIn = false
        } else {
            userIsSignedIn = true
        }
    }
    func alert(alertText: String) {
        let alert = UIAlertController(title: "!", message: alertText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in}))
        self.present(alert, animated: true, completion: nil)
    }
    func presentViewController() {
        if identifier == "" {
            identifier = "BibleViewController"
        }
        let isBible = UserDefaults.standard.bool(forKey: "BibleViewController")
        if isBible {
            identifier = "BibleViewController"
        } else {
            identifier = "ProfileViewController"
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: identifier)
        if #available(iOS 13.0, *) {
            controller.isModalInPresentation = true
            controller.modalPresentationStyle = .fullScreen
        } else {
            // Fallback on earlier versions
        }
        self.present(controller, animated: false, completion: nil)
    }
}
