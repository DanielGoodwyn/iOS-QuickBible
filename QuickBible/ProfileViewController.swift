import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
protocol ProfileViewControllerDelegate : NSObjectProtocol{
    func presentViewControllerWithIdentifier(data: String)
}
class ProfileViewController: UIViewController, UITextFieldDelegate {
    weak var delegate : ProfileViewControllerDelegate?
    @IBOutlet weak var constraint: NSLayoutConstraint!
    @IBOutlet weak var onlineIndicator: UIView!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var profile: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var toggleNight: UIButton!
    @IBOutlet weak var resetPassword: UIButton!
    @IBOutlet weak var goToBible: UIButton!
    var uid = ""
    var username = ""
    var email = ""
    var password = ""
    var night = false
    var currentFontFamily = "Poppins-Regular"
    var currentFontSize: CGFloat = 18
    var userIsSignedIn = false
    var currentPage = "profile"
    var handle: NSObjectProtocol!
    var whiteColor = UIColor.white
    var blackColor = UIColor.black
    var grayColor = UIColor.gray
    var keyboardHeight = CGFloat(0)
    var ref: DatabaseReference!
    
    
    //MARK:
    
    
    override func viewWillLayoutSubviews() { checkIfOnline() }
    var online = false
    func checkIfOnline() {
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if let connected = snapshot.value as? Bool, connected {
                self.online = true
                self.onlineIndicator.alpha = 0
            } else {
                self.online = false
                self.onlineIndicator.alpha = 1
            }
        })
    }
    
    
    //MARK:
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.tintColor = blackColor
        emailTextField.tintColor = blackColor
        passwordTextField.tintColor = blackColor
        usernameTextField.layer.borderColor = blackColor.cgColor
        emailTextField.layer.borderColor = blackColor.cgColor
        passwordTextField.layer.borderColor = blackColor.cgColor
        usernameTextField.layer.borderWidth = 1.0
        emailTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderWidth = 1.0
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHideNotification), name: UIResponder.keyboardDidHideNotification, object: nil)
        ref = Database.database().reference()
        getValues()
        checkIfUserIsSignedIn()
        if userIsSignedIn {
            setValues()
        }
        setStyle()
        addDoneButtonOnKeyboard()
        usernameTextField.returnKeyType = .next
        emailTextField.returnKeyType = .next
        passwordTextField.returnKeyType = .done
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    @IBAction func signUp(_ sender: Any) { signUp() }
    @IBAction func signIn(_ sender: Any) { signIn() }
    @IBAction func signOut(_ sender: Any) { signOut() }
    @IBAction func update(_ sender: Any) { update() }
    @IBAction func toggleNight(_ sender: Any) {
        if userIsSignedIn {
            ref.child("users/" + self.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                self.night = value?["night"] as? Bool ?? false
                if self.night {
                    self.night = false
                } else {
                    self.night = true
                }
                self.setStyle()
                self.ref.child( ("users/" + self.uid + "/night") ).setValue(self.night)
            }) { (error) in
                self.alert(alertText: error.localizedDescription)
            }
        } else {
            alert(alertText: "No user is signed in")
        }
    }
    @IBAction func resetPassword(_ sender: Any) {
        getValues()
        if email != "" {
            Auth.auth().sendPasswordReset(withEmail: self.email) { error in
                self.alert(alertText: "Email sent.")
            }
        } else {
            alert(alertText: "please type email")
        }
    }
    @IBAction func goToBible(_ sender: Any) {
        if userIsSignedIn {
            UserDefaults.standard.set(true, forKey: "BibleViewController")
            if online {
                ref.child( ("users/" + uid + "/currentPage") ).setValue(currentPage)
            }
            if let delegate = delegate {
                delegate.presentViewControllerWithIdentifier(data: "BibleViewController")
            }
            currentPage = "bible"
            self.dismiss(animated: false, completion: nil)
        } else {
            alert(alertText: "No user is signed in")
        }
    }
    @objc func dismissKeyboard() {
        self.view.layoutIfNeeded()
        profile.center.y = self.view.center.y
        view.endEditing(true)
    }
    @objc func keyboardWillShowNotification(notification: NSNotification) {
        if let info = notification.userInfo {
            let rect:CGRect = info["UIKeyboardFrameEndUserInfoKey"] as! CGRect
            self.view.layoutIfNeeded()
            let halfProfileViewFrameHeight = (profile.frame.height / 2)
            let limit: CGFloat = ( halfProfileViewFrameHeight * -1) + 28
            constraint.constant = ( ( (profile.frame.height - (rect.height + 20) ) / 2) + ( halfProfileViewFrameHeight * -1) )
            if constraint.constant < limit {
                constraint.constant = limit
            }
        }
    }
    @objc func keyboardDidHideNotification(notification: NSNotification) {
        self.view.layoutIfNeeded()
        profile.center.y = self.view.center.y
    }
    @objc func doneButtonAction() {
        passwordTextField.resignFirstResponder()
        enterKey()
    }
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50) )
        doneToolbar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        passwordTextField.inputAccessoryView = doneToolbar
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        let nextTag = textField.tag + 1
        let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder?
        if nextResponder != nil {
            nextResponder?.becomeFirstResponder()
        } else {
            enterKey()
            textField.resignFirstResponder()
        }
        return true
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
        setStyle()
    }
    func getValues() {
        checkIfUserIsSignedIn()
        self.username = self.usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.email = self.emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.password = self.passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.checkIfUserIsSignedIn()
        self.setStyle()
    }
    func setValues() {
        checkIfOnline()
        self.ref.child("users").child(self.uid).observe(.value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.currentPage = value?["currentPage"] as? String ?? ""
            self.username = value?["username"] as? String ?? ""
            self.email = value?["email"] as? String ?? ""
            self.usernameTextField.text = self.username
            self.emailTextField.text = self.email
            self.night = value?["night"] as? Bool ?? false
            self.currentFontFamily = value?["currentFontFamily"] as? String ?? "Poppins-Regular"
            self.currentFontSize = value?["currentFontSize"] as? CGFloat ?? 18
            self.setStyle()
            self.signUpButton.titleLabel?.minimumScaleFactor = 0.25
            self.signUpButton.titleLabel?.numberOfLines = 1
            self.signUpButton.titleLabel?.adjustsFontSizeToFitWidth = true
            self.signUpButton.titleLabel?.minimumScaleFactor = 0.25
            self.signInButton.titleLabel?.numberOfLines = 1
            self.signInButton.titleLabel?.adjustsFontSizeToFitWidth = true
            self.signOutButton.titleLabel?.minimumScaleFactor = 0.25
            self.signOutButton.titleLabel?.numberOfLines = 1
            self.signOutButton.titleLabel?.adjustsFontSizeToFitWidth = true
            self.ref.child( ("users/" + self.uid + "/night") ).setValue(self.night)
            self.profile.frame = CGRect(x: self.signUpButton.frame.minX, y: self.signUpButton.frame.minY, width: self.signUpButton.frame.width, height: self.currentFontSize * 14)
            if self.currentPage == "bible" {
                UserDefaults.standard.set(true, forKey: "BibleViewController")
                if self.online {
                    self.ref.child( ("users/" + self.uid + "/currentPage") ).setValue(self.currentPage)
                }
                if let delegate = self.delegate {
                    delegate.presentViewControllerWithIdentifier(data: "BibleViewController")
                }
                self.dismiss(animated: false, completion: nil)
            }
        }) { (error) in
            self.alert(alertText: error.localizedDescription)
            self.setStyle()
        }
    }
    func signUp() {
        getValues()
        if username != "" && email != "" && password != "" {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                self.checkIfUserIsSignedIn()
                if let _error = error {
                    self.alert(alertText:_error.localizedDescription)
                } else {
                    self.ref.child( ("users/" + self.uid + "/night") ).setValue(false)
                    self.ref.child( ("users/" + self.uid + "/username") ).setValue(self.username)
                    self.ref.child( ("users/" + self.uid + "/email") ).setValue(self.email)
                    self.ref.child( ("users/" + self.uid + "/bottomNavigationMode") ).setValue("Verse")
                    self.ref.child( ("users/" + self.uid + "/currentBook") ).setValue(1)
                    self.ref.child( ("users/" + self.uid + "/currentChapter") ).setValue(1)
                    self.ref.child( ("users/" + self.uid + "/currentVerse") ).setValue(1)
                    self.ref.child( ("users/" + self.uid + "/currentPage") ).setValue("profile")
                    self.ref.child( ("users/" + self.uid + "/currentFontFamily") ).setValue("Poppins-Regular")
                    self.ref.child( ("users/" + self.uid + "/currentFontSize") ).setValue(18)
                    self.ref.child( ("users/" + self.uid + "/selectedVerses/0") ).setValue("x")
                    self.userIsSignedIn = true
                    do {
                        DispatchQueue.main.asyncAfter ( deadline : .now ( ) + 2 ) {
                            self.ref.child( ("users/" + self.uid + "/currentPage") ).setValue("bible")
                            self.dismiss(animated: false, completion: nil)
                        }
                    }
                }
            }
        } else {
            alert(alertText: "please type username, email, and password")
        }
    }
    func signIn() {
        getValues()
        if email != "" && password != "" {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard self != nil else { return }
                if (error != nil) {
                    self?.signUp()
                } else {
                    do {
                        DispatchQueue.main.asyncAfter ( deadline : .now ( ) + 2 ) {
                            self?.dismiss(animated: false, completion: nil)
                        }
                    }
                }
            }
        } else {
            alert(alertText: "please type email and password")
        }
    }
    func signOut() {
        if userIsSignedIn {
            getValues()
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                checkIfUserIsSignedIn()
            } catch let signOutError as NSError {
                checkIfUserIsSignedIn()
                alert(alertText:signOutError.localizedDescription)
            }
            night = false
            checkIfUserIsSignedIn()
            usernameTextField.text = ""
            emailTextField.text = ""
            passwordTextField.text = ""
            currentFontFamily = "Poppins-Regular"
            currentFontSize = 18
            setStyle()
        } else {
            alert(alertText: "No user is signed in")
        }
    }
    func update() {
        if userIsSignedIn {
            getValues()
            if username != "" && email != "" {
                ref.child( ("users/" + uid + "/email") ).setValue(email)
                ref.child( ("users/" + uid + "/username") ).setValue(username)
                Auth.auth().currentUser?.updateEmail(to: email) { (error) in
                }
            } else {
                alert(alertText:"please type username and email")
            }
        } else {
            alert(alertText: "No user is signed in")
        }
    }
    func setStyle() {
        usernameTextField.tintColor = grayColor
        emailTextField.tintColor = grayColor
        passwordTextField.tintColor = grayColor
        usernameTextField.layer.borderColor = blackColor.cgColor
        emailTextField.layer.borderColor = blackColor.cgColor
        passwordTextField.layer.borderColor = blackColor.cgColor
        usernameTextField.layer.borderWidth = 1.0
        emailTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderWidth = 1.0
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        if night == true {
            toggleNight.setTitle("NIGHT", for: .normal)
            background.backgroundColor = blackColor
            usernameTextField.backgroundColor = blackColor
            emailTextField.backgroundColor = blackColor
            passwordTextField.backgroundColor = blackColor
            usernameTextField.layer.borderColor = whiteColor.cgColor
            emailTextField.layer.borderColor = whiteColor.cgColor
            passwordTextField.layer.borderColor = whiteColor.cgColor
            usernameTextField.textColor = whiteColor
            emailTextField.textColor = whiteColor
            passwordTextField.textColor = whiteColor
            signUpButton.backgroundColor = whiteColor
            signUpButton.setTitleColor(blackColor, for: .normal)
            signInButton.backgroundColor = whiteColor
            signInButton.setTitleColor(blackColor, for: .normal)
            signOutButton.backgroundColor = whiteColor
            signOutButton.setTitleColor(blackColor, for: .normal)
            updateButton.backgroundColor = whiteColor
            updateButton.setTitleColor(blackColor, for: .normal)
            toggleNight.backgroundColor = whiteColor
            toggleNight.setTitleColor(blackColor, for: .normal)
            goToBible.backgroundColor = whiteColor
            goToBible.setTitleColor(blackColor, for: .normal)
            resetPassword.backgroundColor = whiteColor
            resetPassword.setTitleColor(blackColor, for: .normal)
        } else {
            toggleNight.setTitle("DAY", for: .normal)
            background.backgroundColor = whiteColor
            usernameTextField.backgroundColor = whiteColor
            emailTextField.backgroundColor = whiteColor
            passwordTextField.backgroundColor = whiteColor
            usernameTextField.layer.borderColor = blackColor.cgColor
            emailTextField.layer.borderColor = blackColor.cgColor
            passwordTextField.layer.borderColor = blackColor.cgColor
            usernameTextField.textColor = blackColor
            emailTextField.textColor = blackColor
            passwordTextField.textColor = blackColor
            signUpButton.backgroundColor = blackColor
            signUpButton.setTitleColor(whiteColor, for: .normal)
            signInButton.backgroundColor = blackColor
            signInButton.setTitleColor(whiteColor, for: .normal)
            signOutButton.backgroundColor = blackColor
            signOutButton.setTitleColor(whiteColor, for: .normal)
            updateButton.backgroundColor = blackColor
            updateButton.setTitleColor(whiteColor, for: .normal)
            toggleNight.backgroundColor = blackColor
            toggleNight.setTitleColor(whiteColor, for: .normal)
            goToBible.backgroundColor = blackColor
            goToBible.setTitleColor(whiteColor, for: .normal)
            resetPassword.backgroundColor = blackColor
            resetPassword.setTitleColor(whiteColor, for: .normal)
        }
        if !userIsSignedIn {
            updateButton.backgroundColor = grayColor
            toggleNight.backgroundColor = grayColor
            goToBible.backgroundColor = grayColor
            resetPassword.backgroundColor = blackColor
        }
        self.usernameTextField.font = UIFont(name:self.currentFontFamily, size:self.currentFontSize)
        self.emailTextField.font = UIFont(name:self.currentFontFamily, size:self.currentFontSize)
        self.passwordTextField.font = UIFont(name:self.currentFontFamily, size:self.currentFontSize)
        self.usernameTextField.font = UIFont(name:self.currentFontFamily, size:self.currentFontSize)
        self.emailTextField.font = UIFont(name:self.currentFontFamily, size:self.currentFontSize)
        self.passwordTextField.font = UIFont(name:self.currentFontFamily, size:self.currentFontSize)
        self.usernameTextField.font = UIFont(name:self.currentFontFamily, size:self.currentFontSize)
        self.emailTextField.font = UIFont(name:self.currentFontFamily, size:self.currentFontSize)
        self.passwordTextField.font = UIFont(name:self.currentFontFamily, size:self.currentFontSize)
        self.signUpButton.titleLabel!.font = UIFont(name:self.currentFontFamily, size:self.currentFontSize)
        self.signInButton.titleLabel!.font = UIFont(name:self.currentFontFamily, size:self.currentFontSize)
        self.signOutButton.titleLabel!.font = UIFont(name:self.currentFontFamily, size:self.currentFontSize)
        self.updateButton.titleLabel!.font = UIFont(name:self.currentFontFamily, size:self.currentFontSize)
        self.toggleNight.titleLabel!.font = UIFont(name:self.currentFontFamily, size:self.currentFontSize)
        self.goToBible.titleLabel!.font = UIFont(name:self.currentFontFamily, size:self.currentFontSize)
        self.resetPassword.titleLabel!.font = UIFont(name:self.currentFontFamily, size:self.currentFontSize)
    }
    func enterKey() {
        if userIsSignedIn {
            update()
        } else {
            signIn()
        }
    }
    func alert(alertText: String) {
        let alert = UIAlertController(title: "!", message: alertText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in}))
        self.present(alert, animated: true, completion: nil)
    }
}
