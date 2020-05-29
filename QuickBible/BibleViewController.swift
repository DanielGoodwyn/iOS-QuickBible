import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

protocol BibleViewControllerDelegate: NSObjectProtocol{
    func presentViewControllerWithIdentifier(data: String)
}
class BibleViewController: UIViewController, XMLParserDelegate, UITableViewDataSource, UITableViewDelegate {
    weak var delegate: BibleViewControllerDelegate?
    
    //MARK: Launch Firebase
    
    var ref = Database.database() .reference()
    
    @IBOutlet weak var statusBar: UIView!
    @IBOutlet weak var mainBackground: UIView!
    @IBOutlet weak var displayBackground: UIView!
    @IBOutlet weak var displayContainer: UIView!
    @IBOutlet weak var menuBackground: UIView!
    @IBOutlet weak var menuProfile: UIView!
    @IBOutlet weak var menuSettings: UIView!
    @IBOutlet weak var menuVersions: UIView!
    @IBOutlet weak var menuHistory: UIView!
    @IBOutlet weak var menuViewHighlights: UIView!
    @IBOutlet weak var menuReferences: UIView!
    @IBOutlet weak var menuAudio: UIView!
    @IBOutlet weak var menuHighlight: UIView!
    @IBOutlet weak var menuCopy: UIView!
    @IBOutlet weak var fullscreenBackground: UIView!
    @IBOutlet weak var content: UITableView!
    @IBOutlet weak var nightModeImage: UIImageView!
    @IBOutlet weak var randomImage: UIImageView!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var menuProfileImage: UIImageView!
    @IBOutlet weak var menuSettingsImage: UIImageView!
    @IBOutlet weak var menuVersionsImage: UIImageView!
    @IBOutlet weak var menuHistoryImage: UIImageView!
    @IBOutlet weak var menuViewHighlightsImage: UIImageView!
    @IBOutlet weak var menuReferencesImage: UIImageView!
    @IBOutlet weak var menuAudioImage: UIImageView!
    @IBOutlet weak var menuHighlightImage: UIImageView!
    @IBOutlet weak var menuCopyImage: UIImageView!
    @IBOutlet weak var nightMode: UIButton!
    @IBOutlet weak var random: UIButton!
    @IBOutlet weak var left: UIButton!
    @IBOutlet weak var right: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var previousBookLabel: UILabel!
    @IBOutlet weak var currentBookLabel: UILabel!
    @IBOutlet weak var nextBookLabel: UILabel!
    @IBOutlet weak var previousChapterLabel: UILabel!
    @IBOutlet weak var currentChapterLabel: UILabel!
    @IBOutlet weak var nextChapterLabel: UILabel!
    @IBOutlet weak var menuProfileLabel: UILabel!
    @IBOutlet weak var menuSettingsLabel: UILabel!
    @IBOutlet weak var menuVersionsLabel: UILabel!
    @IBOutlet weak var menuHistoryLabel: UILabel!
    @IBOutlet weak var menuViewHighlightsLabel: UILabel!
    @IBOutlet weak var menuReferencesLabel: UILabel!
    @IBOutlet weak var menuAudioLabel: UILabel!
    @IBOutlet weak var menuHighlightLabel: UILabel!
    @IBOutlet weak var menuCopyLabel: UILabel!
    @IBOutlet weak var fullscreenTitle: UILabel!
    @IBOutlet weak var fullscreenText: UITextView!
    let booksOfBible = ["Genesis", "Exodus", "Leviticus", "Numbers", "Deuteronomy", "Joshua", "Judges", "Ruth", "1 Samuel", "2 Samuel", "1 Kings", "2 Kings", "1 Chronicles", "2 Chronicles", "Ezra", "Nehemiah", "Esther", "Job", "Psalms", "Proverbs", "Ecclesiastes", "Song of Solomon", "Isaiah", "Jeremiah", "Lamentations", "Ezekiel", "Daniel", "Hosea", "Joel", "Amos", "Obadiah", "Jonah", "Micah", "Nahum", "Habakkuk", "Zephaniah", "Haggai", "Zechariah", "Malachi", "Matthew", "Mark", "Luke", "John", "Acts", "Romans", "1 Corinthians", "2 Corinthians", "Galatians", "Ephesians", "Philippians", "Colossians", "1 Thessalonians", "2 Thessalonians", "1 Timothy", "2 Timothy", "Titus", "Philemon", "Hebrews", "James", "1 Peter", "2 Peter", "1 John", "2 John", "3 John", "Jude", "Revelation"]
    let booksOfBiblePaths = ["Genesis", "Exodus", "Leviticus", "Numbers", "Deuteronomy", "Joshua", "Judges", "Ruth", "1_Samuel", "2_Samuel", "1_Kings", "2_Kings", "1_Chronicles", "2_Chronicles", "Ezra", "Nehemiah", "Esther", "Job", "Psalms", "Proverbs", "Ecclesiastes", "Songs", "Isaiah", "Jeremiah", "Lamentations", "Ezekiel", "Daniel", "Hosea", "Joel", "Amos", "Obadiah", "Jonah", "Micah", "Nahum", "Habakkuk", "Zephaniah", "Haggai", "Zechariah", "Malachi", "Matthew", "Mark", "Luke", "John", "Acts", "Romans", "1_Corinthians", "2_Corinthians", "Galatians", "Ephesians", "Philippians", "Colossians", "1_Thessalonians", "2_Thessalonians", "1_Timothy", "2_Timothy", "Titus", "Philemon", "Hebrews", "James", "1_Peter", "2_Peter", "1_John", "2_John", "3_John", "Jude", "Revelation"]
    let numberOfChaptersInBooksOfBible = [50, 40, 27, 36, 34, 24, 21, 4, 31, 24, 22, 25, 29, 36, 10, 13, 10, 42, 150, 31, 12, 8, 66, 52, 5, 48, 12, 14, 3, 9, 1, 4, 7, 3, 3, 3, 2, 14, 4, 28, 16, 24, 21, 28, 16, 16, 13, 6, 6, 4, 4, 5, 3, 6, 4, 3, 1, 13, 5, 5, 3, 5, 1, 1, 1, 22]
    var versesInBible = [String]()
    var crossReferences = [String]()
    var selectedVerses = ["x"]
    var versesInCurrentChapter = [String]()
    var highlights = [Int]()
    var historyTitles: Array<String> = Array()
    var historyBooks: Array<Int> = Array()
    var historyChapters: Array<Int> = Array()
    var historyVerses: Array<Int> = Array()
    var highlightsTitles: Array<String> = Array()
    var highlightsBooks: Array<Int> = Array()
    var highlightsChapters: Array<Int> = Array()
    var highlightsVerses: Array<Int> = Array()
    var referencesTitles: Array<String> = Array()
    var referencesBooks: Array<Int> = Array()
    var referencesChapters: Array<Int> = Array()
    var referencesVerses: Array<Int> = Array()
    var uid = ""
    var currentPage = "bible"
    var currentFontFamily = "Poppins-Regular"
    var bottomNavigationMode = "Verse"
    var contentMode = "Verses"
    var element = ""
    var parsedBook = "0."
    var parsedChapter = "0."
    var touchesEnded = true
    var night = false
    var bookFreeze = false
    var shouldFreeze = false
    var shouldClearSelection = false
    var fullscreenIsActive = false
    var touchBottomNavigationIsActive = false
    var touchBottomNavigationIsMoving = false
    var touchTopNavigationIsActive = false
    var touchIsCancelled = false
    var chapterHasRendered = false
    var shouldUseFormerLocation = false
    var hapticsDidFire = false
    var formerBook = 1
    var formerChapter = 1
    var bookFormer = 1
    var chapterFormer = 1
    var verseFormer = 1
    var currentBook = 1
    var currentChapter = 1
    var currentVerse = 1
    var currentFontSize: CGFloat = 18
    var screenWidth: CGFloat = 0
    var screenHeight: CGFloat = 0
    var bottomPadding: CGFloat = 0.0
    var topPadding: CGFloat = 0.0
    var touchesBeganX: CGFloat = 0.5
    var touchesBeganTime = NSDate() .timeIntervalSince1970
    var colorWhite = UIColor.white
    var colorLightGray = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.00)
    var colorGray = UIColor.gray
    var colorDarkGray = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.00)
    var colorBlack = UIColor.black
    var colorClear = UIColor.clear
    var colorSelected = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
    var colorHighlight = UIColor(red: 0, green: 0.25, blue: 1, alpha: 0.25)
    var feedbackGenerator: UIImpactFeedbackGenerator? = nil
    var online = false
    override var canBecomeFirstResponder: Bool {get {return true} }
    
    //MARK: Import Resources
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [: ]) {
        element = elementName
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let parsedContent = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if !parsedContent.isEmpty {
            if element == "c" {
                parsedChapter = parsedContent
            }
            if element == "h" {
                parsedBook = parsedContent
            }
            if element == "v" {
                versesInBible.append(parsedBook + "_" + parsedChapter + ":" + parsedContent)
            }
        }
    }
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
    }
    
    //MARK: Launch
    
    override func viewWillLayoutSubviews() { checkIfOnline() }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Launch Firebase
        
        uid = Auth.auth() .currentUser?.uid ?? ""
        
        //MARK: Set Screen Size
        
        setScreenSize();
        
        //MARK: Define Views
        
        menuProfileImage.image = UIImage(named: "person")
        menuSettingsImage.image = UIImage(named: "cog")
        menuVersionsImage.image = UIImage(named: "versions")
        menuHistoryImage.image = UIImage(named: "clock")
        menuViewHighlightsImage.image = UIImage(named: "lines")
        menuReferencesImage.image = UIImage(named: "reference")
        menuAudioImage.image = UIImage(named: "play")
        menuHighlightImage.image = UIImage(named: "highlighter")
        menuCopyImage.image = UIImage(named: "copy")
        randomImage.image = UIImage(named: "random")
        leftImage.image = UIImage(named: "left")
        rightImage.image = UIImage(named: "right")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ProfileViewController")
        controller.modalPresentationStyle = .fullScreen
        
        //MARK: Import Resources
        
        let parser = XMLParser(contentsOf: NSURL(fileURLWithPath :(Bundle.main.path(forResource: "web", ofType: "xml"))!)as URL)
        parser?.delegate = self
        parser?.parse()
        
        let bundle = Bundle.main
        let path = bundle.path(forResource: "ref", ofType: "csv")
        let file = FileManager.default
        let data = file.contents(atPath: path!)! as NSData
        let string = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)! as String
        let referenceSubstrings = string.split{$0.isNewline }
        for item in referenceSubstrings {
            crossReferences.append(String(item))
        }
        
        //MARK: Listen to Firebase
        
        if uid == "" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
                self.dismiss(animated: false, completion: nil)
            }
        } else {
            ref.child(( "users/" + uid + "/currentPage")).setValue("bible")
            ref.child(( "users/" + uid + "/highlights")).observe(.value, with: {(snapshot)in
                self.locate(isRandom: false)
            }) {(error)in
                self.alert(alertText: error.localizedDescription)
            }
            ref.child(( "users/" + uid + "/selectedVerses")).observe(.value, with: {(snapshot)in
                let value = snapshot.value as? NSDictionary
                self.selectedVerses = value?["selectedVerses"] as? [String] ?? ["x"]
                if self.shouldClearSelection {
                    self.selectedVerses = ["x"]
                    self.storeSelection()
                }
                self.setSelection()
            }) {(error)in
                self.alert(alertText: error.localizedDescription)
            }
            ref.child("users/" + uid).observe(.value, with: {(snapshot)in
                let value = snapshot.value as? NSDictionary
                self.currentPage = value?["currentPage"] as? String ?? ""
                if self.currentPage != "bible" {
                    if !self.isBeingDismissed {
                        self.dismiss(animated: false, completion: nil)
                    }
                }
                if self.currentBook != self.formerBook || self.currentChapter != self.formerChapter {
                    self.shouldClearSelection = true
                } else {
                    self.shouldClearSelection = false
                }
                let book = value?["currentBook"] as? Int ?? 1
                let chapter = value?["currentChapter"] as? Int ?? 1
                let verse = value?["currentVerse"] as? Int ?? 1
                if book != self.currentBook || chapter != self.currentChapter || verse != self.currentVerse {
                    self.currentBook = value?["currentBook"] as? Int ?? 1
                    self.currentChapter = value?["currentChapter"] as? Int ?? 1
                    self.currentVerse = value?["currentVerse"] as? Int ?? 1
                    self.locate(isRandom: false)
                }
                self.selectedVerses = value?["selectedVerses"] as? [String] ?? ["x"]
                if self.shouldClearSelection {
                    self.selectedVerses = ["x"]
                    self.storeSelection()
                }
                self.setSelection()
                self.currentBook = value?["currentBook"] as? Int ?? 1
                self.currentChapter = value?["currentChapter"] as? Int ?? 1
                self.currentVerse = value?["currentVerse"] as? Int ?? 1
                self.topLabel.text = " " + (self.booksOfBible[self.currentBook - 1] + " " + self.currentChapter.description + ":" + self.currentVerse.description) + " "
                let formerBottomNavigationMode = self.bottomNavigationMode
                self.bottomNavigationMode = value?["bottomNavigationMode"] as? String ?? ""
                if formerBottomNavigationMode != self.bottomNavigationMode {
                    self.locate(isRandom: false)
                }
                self.night = value?["night"] as? Bool ?? false
                self.currentFontFamily = value?["currentFontFamily"] as? String ?? "Poppins-Regular"
                self.currentFontSize = value?["currentFontSize"] as? CGFloat ?? 18
                if !self.chapterHasRendered {
                    self.locate(isRandom: false)
                    self.chapterHasRendered = true
                }
                self.setStyle()
                self.formerBook = self.currentBook
                self.formerChapter = self.currentChapter
                self.checkIfOnline()
            }) {(error)in
                self.alert(alertText: error.localizedDescription)
                self.checkIfOnline()
            }
        }
        setStyle()
        
        //MARK: Middle - Listeners
        
        content.delegate = self
        content.dataSource = self
        content.separatorStyle = UITableViewCell.SeparatorStyle.none
        let contentLongPress = UILongPressGestureRecognizer(target: self, action: #selector(contentTouched(_ :)))
        content.addGestureRecognizer(contentLongPress)
        content.allowsMultipleSelection = true
        content.allowsMultipleSelectionDuringEditing = true
        
        let previousButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(previousButtonTap))
        let previousButtonLongGesture = UILongPressGestureRecognizer(target: self, action: #selector(previousButtonLong(gesture :)))
        previousButtonTapGesture.numberOfTapsRequired = 1
        previousButton.addGestureRecognizer(previousButtonTapGesture)
        previousButton.addGestureRecognizer(previousButtonLongGesture)
        
        let nextButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(nextButtonTap))
        let nextButtonLongGesture = UILongPressGestureRecognizer(target: self, action: #selector(nextButtonLong(gesture :)))
        nextButtonTapGesture.numberOfTapsRequired = 1
        nextButton.addGestureRecognizer(nextButtonTapGesture)
        nextButton.addGestureRecognizer(nextButtonLongGesture)
        
        //MARK: Bottom - Listener
        
        bottomLabel.isUserInteractionEnabled = true
        
        //MARK: Edge - Listeners
        
        let edgePanLeft = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(leftScreenEdgeSwiped))
        edgePanLeft .edges = .left
        view.addGestureRecognizer(edgePanLeft)
        let edgePanRight = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(rightScreenEdgeSwiped))
        edgePanRight .edges = .right
        view.addGestureRecognizer(edgePanRight)
        
        //MARK: Check if Online
        
        if !online {
            locate(isRandom: false)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        uid = Auth.auth() .currentUser?.uid ?? ""
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.standard.set(false, forKey: "BibleViewController")
        currentPage = "profile"
        ref.child(( "users/" + uid + "/currentPage")) .setValue("profile")
        if let delegate = delegate {
            delegate.presentViewControllerWithIdentifier(data: "ProfileViewController")
        }
        becomeFirstResponder()
    }
    
    //MARK: Screen - Listeners
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !fullscreenIsActive {
            lightFeedback()
            verseFormer = currentVerse
            chapterFormer = currentChapter
            bookFormer = currentBook
            touchesBeganTime = NSDate() .timeIntervalSince1970
            if let touch = touches.first {
                let position = touch.location(in: view)
                touchesBeganX = position.x
                setScreenSize()
                var rightPadding = CGFloat(0)
                var leftPadding = CGFloat(0)
                if #available(iOS 11.0, *) {
                    let window = UIApplication.shared.keyWindow
                    topPadding = window?.safeAreaInsets.top ?? 0
                    bottomPadding = window?.safeAreaInsets.bottom ?? 0
                    rightPadding = window?.safeAreaInsets.right ?? 0
                    leftPadding = window?.safeAreaInsets.left ?? 0
                }
                if position.x > leftPadding + left.frame.size.width + 8 && position.x < screenWidth - rightPadding + right.frame.size.width + 8 {
                    if position.y < topPadding + 114 {
                        if position.x < (36 + 8) {
                            nightMode(( Any).self)
                        } else if position.x > screenWidth - (36 + 8) {
                            goToRandomVerse()
                        } else {
                            if contentMode == "Verses" {
                                displayBackground.alpha = 0.9
                                touchTopNavigationIsActive = true
                            }
                            touchBottomNavigationIsActive = false
                            touchIsCancelled = true
                        }
                    } else if position.y > bottomPadding - 114 {
                        if position.x < (36 + 8) {
                            previousChapter(( Any).self)
                        } else if position.x > screenWidth - (36 + 8) {
                            nextChapter(( Any).self)
                        } else {
                            touchBottomNavigationIsActive = true
                            touchTopNavigationIsActive = false
                            touchIsCancelled = true
                            if contentMode != "Verses" {
                                setScreenSize()
                                let xw = (position.x - (screenWidth * 0.1)) / (screenWidth * (0.8))
                                summonContent(xw: xw)
                            }
                        }
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.654321) {
                    if self.touchIsCancelled {
                        self.touchIsCancelled = false
                    } else if position.y > self.topPadding + 114 {
                        self.touchTopNavigationIsActive = false
                        self.touchIsCancelled = true
                    }
                }
            }
            bookFreeze = false
            if shouldUseFormerLocation {
                currentVerse = verseFormer
                currentChapter = chapterFormer
                currentBook = bookFormer
                selectedVerses.removeAll()
                locate(isRandom: false)
                storeLocation()
                shouldUseFormerLocation = false
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if !fullscreenIsActive {
                touchesEnded = false
                let position = touch.location(in: view)
                if touchesBeganX > position.x + 25 || touchesBeganX < position.x - 25 {
                    touchBottomNavigationIsMoving = true
                }
                setScreenSize()
                var xw = (position.x - (screenWidth * 0.1)) / (screenWidth * (0.8))
                if xw <= 0 {
                    xw = 0
                } else if xw > 1 {
                    xw = 1
                }
                var yh = (position.y - (screenHeight * 0.1)) / (screenHeight * (0.8))
                if yh <= 0 {
                    yh = 0
                } else if yh > 1 {
                    yh = 1
                }
                if touchTopNavigationIsActive {
                    currentVerse = 1
                    var dispatchIncrement = 0.1
                    repeat {
                        DispatchQueue.main.asyncAfter(deadline: .now() + dispatchIncrement) {
                            if !( self.currentBook == Int(yh * CGFloat(self.booksOfBible.count))) {
                                self.shouldFreeze = false
                            }
                        }
                        dispatchIncrement = dispatchIncrement + 0.1
                    } while dispatchIncrement <= 1.2
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
                        if !self.bookFreeze && self.shouldFreeze && !self.touchesEnded {
                            self.bookFreeze = true
                            self.mediumFeedback()
                        }
                        if self.currentBook == Int(yh * CGFloat(self.booksOfBible.count)) {
                            self.shouldFreeze = true
                        }
                    }
                    if !bookFreeze {
                        currentBook = Int(yh * CGFloat(booksOfBible.count))
                        if currentBook < 1 {
                            currentBook = 1
                        } else if currentBook > booksOfBible.count {
                            currentBook = booksOfBible.count
                        }
                    }
                    currentChapter = 1 + Int(xw * CGFloat(numberOfChaptersInBooksOfBible[currentBook - 1]))
                    if currentChapter < 1 {
                        currentChapter = 1
                    } else if currentChapter > numberOfChaptersInBooksOfBible[currentBook - 1] {
                        currentChapter = numberOfChaptersInBooksOfBible[currentBook - 1]
                    }
                    topLabel.text = " " + (booksOfBible[currentBook - 1] + " " + currentChapter.description + ":" + currentVerse.description) + " "
                    if currentBook > 39 {
                        displayContainer.frame = CGRect(x: displayContainer.frame.origin.x, y: currentFontSize, width: displayContainer.frame.size.width, height :(displayContainer.frame.size.height))
                        displayContainer.frame.origin.y = currentFontSize
                    } else {
                        displayContainer.frame = CGRect(x: displayContainer.frame.origin.x, y: displayBackground.frame.size.height - displayContainer.frame.size.height, width: displayContainer.frame.size.width, height: displayContainer.frame.size.height)
                        displayContainer.frame.origin.y = displayBackground.frame.size.height - (( currentFontSize * 5) + (5 * 8))
                    }
                    previousBookLabel.alpha = 0.5
                    previousChapterLabel.alpha = 0.5
                    nextBookLabel.alpha = 0.5
                    nextChapterLabel.alpha = 0.5
                    if currentBook > 1 {
                        previousBookLabel.text = "" + booksOfBible[currentBook - 2]
                    } else {
                        previousBookLabel.text = "•"
                        previousBookLabel.alpha = 0.25
                    }
                    currentBookLabel.text = "" + booksOfBible[currentBook - 1]
                    if currentBook < booksOfBible.count - 1 {
                        nextBookLabel.text = "" + booksOfBible[currentBook]
                    } else {
                        nextBookLabel.text = "•"
                        nextBookLabel.alpha = 0.25
                    }
                    previousChapterLabel.text = (currentChapter - 1).description
                    currentChapterLabel.text = currentChapter.description
                    nextChapterLabel.text = (currentChapter + 1).description
                    if previousChapterLabel.text == "0" {
                        previousChapterLabel.text = "•"
                        previousChapterLabel.alpha = 0.25
                    }
                    if currentChapter == numberOfChaptersInBooksOfBible[currentBook - 1] {
                        nextChapterLabel.text = "•"
                        nextChapterLabel.alpha = 0.25
                    }
                }
                if touchBottomNavigationIsActive && touchBottomNavigationIsMoving {
                    if contentMode != "Verses" {
                        summonContent(xw: xw)
                    } else {
                        if bottomNavigationMode == "Verse" {
                            var currentVerseChoice = Int(xw * CGFloat(versesInCurrentChapter.count))
                            if currentVerseChoice < 1 {
                                currentVerseChoice = 1
                            }
                            currentVerse = currentVerseChoice
                        } else if bottomNavigationMode == "Chapter" {
                            selectedVerses.removeAll()
                            var currentChapterChoice = Int(xw * CGFloat(numberOfChaptersInBooksOfBible[currentBook - 1]))
                            if currentChapterChoice < 1 {
                                currentChapterChoice = 1
                            }
                            currentChapter = currentChapterChoice
                            currentVerse = 1
                        } else if bottomNavigationMode == "Book" {
                            selectedVerses.removeAll()
                            var currentBookChoice = Int(xw * CGFloat(booksOfBible.count))
                            if currentBookChoice < 1 {
                                currentBookChoice = 1
                            }
                            currentBook = currentBookChoice
                            currentChapter = 1
                            currentVerse = 1
                        }
                        topLabel.text = " " + (booksOfBible[currentBook - 1] + " " + currentChapter.description + ":" + currentVerse.description) + " "
                        locate(isRandom: false)
                        storeLocation()
                    }
                }
            }
            if shouldUseFormerLocation {
                currentVerse = verseFormer
                currentChapter = chapterFormer
                currentBook = bookFormer
                locate(isRandom: false)
                storeLocation()
                shouldUseFormerLocation = false
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !fullscreenIsActive {
            heavyFeedback()
            touchBottomNavigationIsActive = false
            touchesEnded = true
            if contentMode == "Verses" {
                if let touch = touches.first {
                    let position = touch.location(in: view)
                    if position.y > bottomPadding + 114 {
                        setScreenSize()
                        if position.x > (36 + 8) && position.x < screenWidth - (36 + 8) {
                            if !touchBottomNavigationIsMoving {
                                touchBottomNavigationIsActive = false
                                shouldUseFormerLocation = true
                                setScreenSize()
                                if position.x < (screenWidth / 2) {
                                    if bottomNavigationMode == "Verse" {
                                        bottomNavigationMode = "Book"
                                    } else if bottomNavigationMode == "Book" {
                                        bottomNavigationMode = "Chapter"
                                    } else if bottomNavigationMode == "Chapter" {
                                        bottomNavigationMode = "Verse"
                                    }
                                } else {
                                    if bottomNavigationMode == "Verse" {
                                        bottomNavigationMode = "Chapter"
                                    } else if bottomNavigationMode == "Chapter" {
                                        bottomNavigationMode = "Book"
                                    } else if bottomNavigationMode == "Book" {
                                        bottomNavigationMode = "Verse"
                                    }
                                }
                                ref.child(( "users/" + uid + "/bottomNavigationMode")) .setValue(bottomNavigationMode)
                                if shouldUseFormerLocation {
                                    currentVerse = verseFormer
                                    currentChapter = chapterFormer
                                    currentBook = bookFormer
                                    locate(isRandom: false)
                                    storeLocation()
                                    shouldUseFormerLocation = false
                                }
                            }
                        }
                    }
                }
            }
            if NSDate() .timeIntervalSince1970 - touchesBeganTime > 0.2 {
                if contentMode == "Verses" {
                    displayBackground.alpha = 0
                    if touchTopNavigationIsActive || touchBottomNavigationIsActive {
                        topLabel.text = " " + (booksOfBible[currentBook - 1] + " " + currentChapter.description + ":" + currentVerse.description) + " "
                        locate(isRandom: false)
                        storeLocation()
                    } else {
                        touchIsCancelled = true
                    }
                    if shouldUseFormerLocation {
                        currentVerse = verseFormer
                        currentChapter = chapterFormer
                        currentBook = bookFormer
                        locate(isRandom: false)
                        storeLocation()
                        shouldUseFormerLocation = false
                    }
                    touchBottomNavigationIsMoving = false
                    mediumFeedback()
                }
            } else {
                if contentMode == "Verses" {
                    if touchTopNavigationIsActive {
                        displayBackground.alpha = 0
                        contentMode = "Books"
                        leftImage.alpha = 0
                        rightImage.alpha = 0
                        topLabel.text = contentMode
                        summonContent(xw: 0)
                        content.scrollToRow(at: NSIndexPath(row: 0, section: 0)as IndexPath, at: .top, animated: false)
                    }
                } else {
                    locate(isRandom: false)
                }
            }
            touchTopNavigationIsActive = false
        }
    }
    
    //MARK: Top - Listeners
    
    @IBAction func nightMode(_ sender: Any) {
        var isChanged = false
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: {(snapshot)in
            let value = snapshot.value as? NSDictionary
            self.night = value?["night"] as? Bool ?? false
            if self.night {
                self.night = false
            } else {
                self.night = true
            }
            self.setStyle()
            self.ref.child(( "users/" + self.uid + "/night")) .setValue(self.night)
            isChanged = true
        }) {(error)in
            self.alert(alertText: error.localizedDescription)
            if self.night {
                self.night = false
            }
        }
        if !isChanged {
            if self.night {
                self.night = false
            } else {
                self.night = true
            }
            setStyle()
        }
        heavyFeedback()
    }
    @IBAction func random(_ sender: Any) {
        goToRandomVerse()
        heavyFeedback()
    }
    @IBAction func fullscreenBack(_ sender: Any) {
        lightFeedback()
        fullscreenBackground.alpha = 0
        fullscreenIsActive = false
        fullscreenText.scrollRangeToVisible(NSMakeRange(0, 0))
    }
    
    //MARK: Top - Function
    
    func goToRandomVerse() {
        currentBook = Int.random(in: 0..<booksOfBible.count) + 1
        let numberOfChaptersInBook = numberOfChaptersInBooksOfBible[currentBook - 1]
        currentChapter = (Int.random(in: 0..<numberOfChaptersInBook)) + 1
        selectedVerses.removeAll()
        locate(isRandom: true)
        storeLocation()
    }
    
    //MARK: Middle - Functions
    
    @objc func previousButtonTap() {
        if contentMode == "Verses" {
            if currentChapter != 1 {
                currentChapter = currentChapter - 1
                currentVerse = 1
            } else if currentBook != 1 {
                currentBook = currentBook - 1
                currentVerse = 1
                currentChapter = numberOfChaptersInBooksOfBible[currentBook - 1]
            }
            selectedVerses.removeAll()
            locate(isRandom: false)
            mediumFeedback()
            storeLocation()
        }
    }
    @objc func previousButtonLong(gesture: UILongPressGestureRecognizer) {
        if contentMode == "Verses" {
            if gesture.state == UIGestureRecognizer.State.began {
                if currentBook != 1 {
                    currentBook = currentBook - 1
                    currentVerse = 1
                    currentChapter = 1
                }
                selectedVerses.removeAll()
                locate(isRandom: false)
                heavyFeedback()
                storeLocation()
            }
        }
    }
    @objc func nextButtonTap() {
        if contentMode == "Verses" {
            if currentChapter != numberOfChaptersInBooksOfBible[currentBook - 1] {
                currentChapter = currentChapter + 1
                currentVerse = 1
            } else {
                if currentBook != booksOfBible.count {
                    currentBook = currentBook + 1
                    currentVerse = 1
                    currentChapter = 1
                }
            }
            selectedVerses.removeAll()
            locate(isRandom: false)
            mediumFeedback()
            storeLocation()
        }
    }
    @objc func nextButtonLong(gesture: UILongPressGestureRecognizer) {
        if contentMode == "Verses" {
            if gesture.state == UIGestureRecognizer.State.began {
                if currentBook != booksOfBible.count {
                    currentBook = currentBook + 1
                    currentVerse = 1
                    currentChapter = 1
                }
                selectedVerses.removeAll()
                locate(isRandom: false)
                heavyFeedback()
                storeLocation()
            }
        }
    }
    
    //MARK: Bottom - Listeners
    
    @IBAction func previousChapter(_ sender: Any) {
        if contentMode == "Verses" {
            if bottomNavigationMode == "Verse" {
                if currentVerse != 1 {
                    currentVerse = currentVerse - 1
                }
                lightFeedback()
            } else if bottomNavigationMode == "Chapter" {
                selectedVerses.removeAll()
                if currentChapter != 1 {
                    currentChapter = currentChapter - 1
                    currentVerse = 1
                } else if currentBook != 1 {
                    currentBook = currentBook - 1
                    currentVerse = 1
                    currentChapter = numberOfChaptersInBooksOfBible[currentBook - 1]
                }
                mediumFeedback()
            } else if bottomNavigationMode == "Book" {
                selectedVerses.removeAll()
                if currentBook != 1 {
                    currentBook = currentBook - 1
                    currentVerse = 1
                    currentChapter = 1
                }
                heavyFeedback()
            }
            locate(isRandom: false)
            storeLocation()
        }
    }
    @IBAction func nextChapter(_ sender: Any) {
        if contentMode == "Verses" {
            if bottomNavigationMode == "Verse" {
                if currentVerse != versesInCurrentChapter.count {
                    currentVerse = currentVerse + 1
                }
                lightFeedback()
            } else if bottomNavigationMode == "Chapter" {
                selectedVerses.removeAll()
                if currentChapter != numberOfChaptersInBooksOfBible[currentBook - 1] {
                    currentChapter = currentChapter + 1
                    currentVerse = 1
                } else {
                    if currentBook != booksOfBible.count {
                        currentBook = currentBook + 1
                        currentVerse = 1
                        currentChapter = 1
                    }
                }
                mediumFeedback()
            } else if bottomNavigationMode == "Book" {
                selectedVerses.removeAll()
                if currentBook != booksOfBible.count {
                    currentBook = currentBook + 1
                    currentVerse = 1
                    currentChapter = 1
                }
                heavyFeedback()
            }
            locate(isRandom: false)
            storeLocation()
        }
    }
    
    //MARK: Content - Listener
    
    @objc func contentTouched(_ sender: UITapGestureRecognizer) {
        menuBackground.alpha = 0.95
        if !hapticsDidFire {
            heavyFeedback()
            hapticsDidFire = true
        }
        setScreenSize()
        let point = sender.location(in: self.view)
        let x = point.x
        let y = point.y
        var horizontal = ""
        var vertical = ""
        if x < screenWidth / 3 {
            horizontal = "left"
        } else if x > screenWidth * 2 / 3 {
            horizontal = "right"
        } else {
            horizontal = "center"
        }
        if y < screenHeight / 3 {
            vertical = "top"
        } else if y > screenHeight * 2 / 3 {
            vertical = "bottom"
        } else {
            vertical = "center"
        }
        let selectedColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.25)
        menuProfile.backgroundColor = colorClear
        menuSettings.backgroundColor = colorClear
        menuVersions.backgroundColor = colorClear
        menuHistory.backgroundColor = colorClear
        menuViewHighlights.backgroundColor = colorClear
        menuReferences.backgroundColor = colorClear
        menuAudio.backgroundColor = colorClear
        menuHighlight.backgroundColor = colorClear
        menuCopy.backgroundColor = colorClear
        if vertical == "top" && horizontal == "left" {
            menuProfile.backgroundColor = selectedColor
        }
        if vertical == "top" && horizontal == "center" {
            menuSettings.backgroundColor = selectedColor
        }
        if vertical == "top" && horizontal == "right" {
            menuVersions.backgroundColor = selectedColor
        }
        if vertical == "center" && horizontal == "left" {
            menuHistory.backgroundColor = selectedColor
        }
        if vertical == "center" && horizontal == "center" {
            menuViewHighlights.backgroundColor = selectedColor
        }
        if vertical == "center" && horizontal == "right" {
            menuReferences.backgroundColor = selectedColor
        }
        if vertical == "bottom" && horizontal == "left" {
            menuAudio.backgroundColor = selectedColor
        }
        if vertical == "bottom" && horizontal == "center" {
            menuHighlight.backgroundColor = selectedColor
        }
        if vertical == "bottom" && horizontal == "right" {
            menuCopy.backgroundColor = selectedColor
        }
        if sender.state == .ended {
            menuBackground.alpha = 0
            if vertical == "top" && horizontal == "left" {
                lightFeedback()
                hapticsDidFire = false
                goToProfile()
            }
            if vertical == "top" && horizontal == "center" {
                lightFeedback()
                hapticsDidFire = false
                settings()
            }
            if vertical == "top" && horizontal == "right" {
                lightFeedback()
                hapticsDidFire = false
                versions()
            }
            if vertical == "center" && horizontal == "left" {
                lightFeedback()
                hapticsDidFire = false
                listHistory()
            }
            if vertical == "center" && horizontal == "center" {
                lightFeedback()
                hapticsDidFire = false
                listHighlights()
            }
            if vertical == "center" && horizontal == "right" {
                lightFeedback()
                hapticsDidFire = false
                listReferences()
            }
            if vertical == "bottom" && horizontal == "left" {
                lightFeedback()
                hapticsDidFire = false
                playAudio()
            }
            if vertical == "bottom" && horizontal == "center" {
                lightFeedback()
                hapticsDidFire = false
                highlightPassage()
            }
            if vertical == "bottom" && horizontal == "right" {
                lightFeedback()
                hapticsDidFire = false
                copyPassage()
            }
        }
    }
    
    //MARK: Edge - Listener
    
    @objc func leftScreenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            previousButtonTap()
        }
    }
    @objc func rightScreenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            nextButtonTap()
        }
    }
    
    //MARK: Menu - Top
    
    func goToProfile() {
        UserDefaults.standard.set(false, forKey: "BibleViewController")
        currentPage = "profile"
        if uid != "" {
            ref.child(( "users/" + uid + "/currentPage")) .setValue("profile")
        }
        if let delegate = delegate {
            delegate.presentViewControllerWithIdentifier(data: "ProfileViewController")
        }
        dismiss(animated: false, completion: nil)
    }
    func settings() {
        setScreenSize()
        let ascSettings: UIAlertController = UIAlertController(title: "Settings", message: "", preferredStyle: .actionSheet)
        let fullscreenButton = UIAlertAction(title: "Fullscreen", style: .default) { _ in
            self.lightFeedback()
            self.setFullscreen()
        }
        ascSettings.addAction(fullscreenButton)
        let fontFamilyActionButton = UIAlertAction(title: "Font Family", style: .default) { _ in
            self.lightFeedback()
            let ascFontFamily: UIAlertController = UIAlertController(title: "Font Family", message: "", preferredStyle: .actionSheet)
            let icelandActionButton = UIAlertAction(title: "Iceland", style: .default) { _ in
                self.setFontFamily(fontFamily: "Iceland")
            }
            ascFontFamily.addAction(icelandActionButton)
            let loraActionButton = UIAlertAction(title: "Lora", style: .default) { _ in
                self.setFontFamily(fontFamily: "Lora-Regular")
            }
            ascFontFamily.addAction(loraActionButton)
            let oswaldActionButton = UIAlertAction(title: "Oswald", style: .default) { _ in
                self.setFontFamily(fontFamily: "Oswald-Regular")
            }
            ascFontFamily.addAction(oswaldActionButton)
            let playfairActionButton = UIAlertAction(title: "Playfair", style: .default) { _ in
                self.setFontFamily(fontFamily: "PlayfairDisplay-Regular")
            }
            ascFontFamily.addAction(playfairActionButton)
            let poppinsActionButton = UIAlertAction(title: "Poppins", style: .default) { _ in
                self.setFontFamily(fontFamily: "Poppins-Regular")
            }
            ascFontFamily.addAction(poppinsActionButton)
            let ralewayActionButton = UIAlertAction(title: "Raleway", style: .default) { _ in
                self.setFontFamily(fontFamily: "Raleway-Regular")
            }
            ascFontFamily.addAction(ralewayActionButton)
            let robotoActionButton = UIAlertAction(title: "Roboto", style: .default) { _ in
                self.setFontFamily(fontFamily: "Roboto-Regular")
            }
            ascFontFamily.addAction(robotoActionButton)
            let satisfyActionButton = UIAlertAction(title: "Satisfy", style: .default) { _ in
                self.setFontFamily(fontFamily: "Satisfy-Regular")
            }
            ascFontFamily.addAction(satisfyActionButton)
            let sourceCodeActionButton = UIAlertAction(title: "Source Code", style: .default) { _ in
                self.setFontFamily(fontFamily: "SourceCodePro-Regular")
            }
            ascFontFamily.addAction(sourceCodeActionButton)
            let ubuntuActionButton = UIAlertAction(title: "Ubuntu", style: .default) { _ in
                self.setFontFamily(fontFamily: "Ubuntu-Regular")
            }
            ascFontFamily.addAction(ubuntuActionButton)
            let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                self.lightFeedback()
            }
            ascFontFamily.addAction(cancelActionButton)
            let popoverPresentationController = ascFontFamily.popoverPresentationController
            popoverPresentationController?.sourceView = self.view
            popoverPresentationController?.sourceRect = CGRect(x: self.screenWidth / 2, y: ( -1 * self.screenHeight / 2 ) + ( 1 / 6 * self.screenHeight ), width: self.screenWidth, height: self.screenHeight)
            self.present(ascFontFamily, animated: false, completion: nil)
        }
        ascSettings.addAction(fontFamilyActionButton)
        let fontSizeActionButton = UIAlertAction(title: "Font Size", style: .default) { _ in
            self.lightFeedback()
            let ascFontSize: UIAlertController = UIAlertController(title: "Font Family", message: "", preferredStyle: .actionSheet)
            let eighteenActionButton = UIAlertAction(title: "18", style: .default) { _ in
                self.setFontSize(fontSize: 18)
            }
            ascFontSize.addAction(eighteenActionButton)
            let twentyActionButton = UIAlertAction(title: "20", style: .default) { _ in
                self.setFontSize(fontSize: 20)
            }
            ascFontSize.addAction(twentyActionButton)
            let twentyTwoActionButton = UIAlertAction(title: "22", style: .default) { _ in
                self.setFontSize(fontSize: 22)
            }
            ascFontSize.addAction(twentyTwoActionButton)
            let twentyFourActionButton = UIAlertAction(title: "24", style: .default) { _ in
                self.setFontSize(fontSize: 24)
            }
            ascFontSize.addAction(twentyFourActionButton)
            let twentySixActionButton = UIAlertAction(title: "26", style: .default) { _ in
                self.setFontSize(fontSize: 26)
            }
            ascFontSize.addAction(twentySixActionButton)
            let twentyEightActionButton = UIAlertAction(title: "28", style: .default) { _ in
                self.setFontSize(fontSize: 28)
            }
            ascFontSize.addAction(twentyEightActionButton)
            let thirtyActionButton = UIAlertAction(title: "30", style: .default) { _ in
                self.setFontSize(fontSize: 30)
            }
            ascFontSize.addAction(thirtyActionButton)
            let thirtyTwoActionButton = UIAlertAction(title: "32", style: .default) { _ in
                self.setFontSize(fontSize: 32)
            }
            ascFontSize.addAction(thirtyTwoActionButton)
            let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                self.lightFeedback()
            }
            ascFontSize.addAction(cancelActionButton)
            let popoverPresentationController = ascFontSize.popoverPresentationController
            popoverPresentationController?.sourceView = self.view
            popoverPresentationController?.sourceRect = CGRect(x: self.screenWidth / 2, y: ( -1 * self.screenHeight / 2 ) + ( 1 / 6 * self.screenHeight ), width: self.screenWidth, height: self.screenHeight)
            self.present(ascFontSize, animated: false, completion: nil)
        }
        ascSettings.addAction(fontSizeActionButton)
        let clearHistoryActionButton = UIAlertAction(title: "Clear History", style: .default) { _ in
            self.lightFeedback()
            self.ref.child("users/" + self.uid + "/history").removeValue()
        }
        ascSettings.addAction(clearHistoryActionButton)
        let clearHighlightsActionButton = UIAlertAction(title: "Clear Highlights", style: .default) { _ in
            self.lightFeedback()
            self.ref.child("users/" + self.uid + "/highlights").removeValue()
        }
        ascSettings.addAction(clearHighlightsActionButton)
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.lightFeedback()
        }
        ascSettings.addAction(cancelActionButton)
        let popoverPresentationController = ascSettings.popoverPresentationController
        popoverPresentationController?.sourceView = self.view
        popoverPresentationController?.sourceRect = CGRect(x: screenWidth / 2, y: ( -1 * screenHeight / 2 ) + ( 1 / 6 * screenHeight ), width: screenWidth, height: screenHeight)
        present(ascSettings, animated: false, completion: nil)
    }
    func versions() {
        let urlString = "https://biblehub.com/" + booksOfBiblePaths[currentBook - 1].lowercased() + "/" + currentChapter.description + "-" + currentVerse.description + ".htm"
        if let url = URL(string: "\(urlString)"), !url.absoluteString.isEmpty {
            UIApplication.shared.open(url, options: [: ], completionHandler: nil)
        }
    }
    
    //MARK: Menu - Middle
    
    func listHistory() {
        ref.child(( "users/" + uid + "/history")) .observeSingleEvent(of: .value, with: {(snapshot)in
            let value = snapshot.value as? NSDictionary
            let allValues = value?.allValues as? [String] ?? [""]
            let allKeys = value?.allKeys as? [String] ?? [""]
            let offsets = allKeys.enumerated() .sorted{$0.element > $1.element }.map{$0.offset }
            var allValuesSorted = offsets.map{allValues[$0]}
            var allKeysSorted = offsets.map{allKeys[$0]}
            if allKeysSorted.count < 1 {
                allValuesSorted = [""]
                allKeysSorted = [""]
            } else if value != nil {
                self.historyBooks.removeAll()
                self.historyChapters.removeAll()
                self.historyVerses.removeAll()
                self.historyTitles.removeAll()
                for item in allValuesSorted {
                    let items = item.components(separatedBy: ".")
                    self.historyBooks.append(Int(items[0])!)
                    self.historyChapters.append(Int(items[1])!)
                    self.historyVerses.append(Int(items[2])!)
                    self.historyTitles.append(String(self.booksOfBible[Int(items[0])! - 1]) + " " + items[1] + ":" + items[2])
                }
                self.contentMode = "History"
                self.leftImage.alpha = 0
                self.rightImage.alpha = 0
                self.topLabel.text = self.contentMode
                self.summonContent(xw: 0)
                self.content.scrollToRow(at: NSIndexPath(row: 0, section: 0)as IndexPath, at: .top, animated: false)
            }
        })
    }
    func listHighlights() {
        contentMode = "Highlights"
        leftImage.alpha = 0
        rightImage.alpha = 0
        highlightsTitles.removeAll()
        highlightsBooks.removeAll()
        highlightsChapters.removeAll()
        highlightsVerses.removeAll()
        var highlightsOrder: Array<String> = Array()
        highlightsTitles = [String]()
        highlightsBooks = [Int]()
        highlightsChapters = [Int]()
        var chapters = [String]()
        var verses = [String]()
        var scriptures = [String]()
        highlightsVerses = [Int]()
        ref.child("users/" + uid + "/highlights").observeSingleEvent(of: .value, with: {(snapshot)in
            let value = snapshot.value as? NSDictionary
            if value != nil {
                let bookKeys = value?.allKeys as? [String] ?? [""]
                var bookValues = [NSDictionary]()
                for book in bookKeys {
                    let bookValue = value?.object(forKey: book)as? NSDictionary ?? [String: String]() as NSDictionary
                    bookValues.append(bookValue)
                    for dictionary in bookValues {
                        chapters = dictionary.allKeys as? [String] ?? [""]
                        verses = dictionary.allValues as? [String] ?? [""]
                    }
                    var i = 0
                    for chapter in chapters {
                        if chapter != "" && chapter != "\\\"\\\"" && chapter != "0" {
                            let versesForChapter = verses[i].components(separatedBy: ",")
                            for verseForChapter in versesForChapter {
                                if verseForChapter != "" && verseForChapter != "0" {
                                    scriptures.append(book + "." + chapter + "." + verseForChapter)
                                }
                            }
                        }
                        i = i + 1
                    }
                }
                for scripture in scriptures {
                    let items = scripture.components(separatedBy: ".")
                    self.highlightsBooks.append(Int(items[0])!)
                    self.highlightsChapters.append(Int(items[1])!)
                    self.highlightsVerses.append(Int(items[2])!)
                    self.highlightsTitles.append(String(self.booksOfBible[Int(items[0])! - 1]) + " " + items[1] + ":" + items[2])
                    let orderBooks = Int(items[0])!
                    let orderChapters = Int(items[1])!
                    let orderVerses = Int(items[2])!
                    highlightsOrder.append(String(format: "%02d%03d%03d", orderBooks, orderChapters, orderVerses))
                }
                let offsets = highlightsOrder.enumerated() .sorted{$0.element < $1.element }.map{$0.offset }
                self.highlightsTitles = offsets.map{self.highlightsTitles[$0]}
                self.highlightsBooks = offsets.map{self.highlightsBooks[$0]}
                self.highlightsChapters = offsets.map{self.highlightsChapters[$0]}
                self.highlightsVerses = offsets.map{self.highlightsVerses[$0]}
                highlightsOrder = offsets.map{highlightsOrder[$0]}
                self.topLabel.text = self.contentMode
                if self.highlightsTitles.count < 1 {
                    self.contentMode = "Verses"
                    self.leftImage.alpha = 1
                    self.rightImage.alpha = 1
                } else {
                    self.summonContent(xw: 0)
                }
                self.content.scrollToRow(at: NSIndexPath(row: 0, section: 0)as IndexPath, at: .top, animated: false)
            }
        })
    }
    func listReferences() {
        var referencesBooksUnsorted: Array<Int> = Array()
        var referencesChaptersUnsorted: Array<Int> = Array()
        var referencesVersesUnsorted: Array<Int> = Array()
        var referencesRelevanceUnsorted: Array<Int> = Array()
        var referencesTitlesUnsorted: Array<String> = Array()
        let prefix = String(currentBook) + "." + String(currentChapter) + "." + String(currentVerse) + ","
        var i = 0
        for item in crossReferences {
            if item.hasPrefix(prefix) {
                let items = item.components(separatedBy: ",")
                let referent = items[1].components(separatedBy: ".")
                referencesRelevanceUnsorted.append(Int(items[2])!)
                referencesBooksUnsorted.append(Int(referent[0])!)
                referencesChaptersUnsorted.append(Int(referent[1])!)
                referencesVersesUnsorted.append(Int(referent[2])!)
                referencesTitlesUnsorted.append(booksOfBible[referencesBooksUnsorted[i] - 1] + " " + String(referencesChaptersUnsorted[i]) + ":" + String(referencesVersesUnsorted[i]))
                i = i + 1
            }
        }
        let offsets = referencesRelevanceUnsorted.enumerated() .sorted{$0.element > $1.element }.map{$0.offset }
        referencesBooks = offsets.map{referencesBooksUnsorted[$0]}
        referencesChapters = offsets.map{referencesChaptersUnsorted[$0]}
        referencesVerses = offsets.map{referencesVersesUnsorted[$0]}
        referencesTitles = offsets.map{referencesTitlesUnsorted[$0]}
        contentMode = "Cross References"
        leftImage.alpha = 0
        rightImage.alpha = 0
        topLabel.text = " " + (booksOfBible[currentBook - 1] + " " + currentChapter.description + ":" + currentVerse.description) + " " + contentMode + " "
        summonContent(xw: 0)
        content.scrollToRow(at: NSIndexPath(row: 0, section: 0)as IndexPath, at: .top, animated: false)
    }
    
    //MARK: Menu - Bottom
    
    func playAudio() {
        let urlString = "https://audio.esv.org/hw/"
            + String(format: "%02d", currentBook)
            + String(format: "%03d", currentChapter)
            + String(format: "%03d", currentVerse)
            + "-"
            + String(format: "%02d", currentBook)
            + String(format: "%03d", currentChapter)
            + String(format: "%03d", versesInCurrentChapter.count)
        if let url = URL(string: "\(urlString)"), !url.absoluteString.isEmpty {
            UIApplication.shared.open(url, options: [: ], completionHandler: nil)
        }
    }
    func highlightPassage() {
        for item in selectedVerses {
            if item != "x" {
                if !highlights.contains(Int(item)! + 1) {
                    highlights.append(Int(item)! + 1)
                }
            }
        }
        if selectedVerses == ["x"] {
            if !highlights.contains(currentVerse) {
                highlights.append(currentVerse)
            }
        }
        storeHighlights()
        locate(isRandom: false)
        setSelection()
    }
    func copyPassage() {
        var selectedReferenceString = ""
        var clipboardText = ""
        let lineBreak = "\n"
        let includesX = selectedVerses.contains("x")
        if selectedVerses.count == 1 && !includesX || selectedVerses.count == 2 && includesX {
            for selectedVerse in selectedVerses {
                if selectedVerses != ["x"] {
                    clipboardText = booksOfBible[currentBook - 1] + " " + String(currentChapter) + ":" + versesInCurrentChapter[Int(selectedVerse)!]
                    if let range = clipboardText.range(of: ". ") {
                        clipboardText = clipboardText.replacingCharacters(in: range, with: lineBreak)
                    }
                }
            }
        } else {
            if selectedVerses == ["x"] || selectedVerses.isEmpty {
                selectedReferenceString = booksOfBible[currentBook - 1] + " " + String(currentChapter)
                clipboardText = selectedReferenceString
                for verse in versesInCurrentChapter {
                    clipboardText = clipboardText + lineBreak + verse
                }
            } else {
                selectedReferenceString = booksOfBible[currentBook - 1] + " " + String(currentChapter) + ":" + selectedReference()
                clipboardText = selectedReferenceString
            }
            selectedVerses = selectedVerses.sorted {$0.localizedStandardCompare($1) == .orderedAscending}
            for selectedVerse in selectedVerses {
                if selectedVerses != ["x"] {
                    clipboardText = clipboardText + lineBreak + versesInCurrentChapter[Int(selectedVerse)!]
                }
            }
        }
        UIPasteboard.general.string = clipboardText
    }
    
    //MARK: Settings - Functions
    
    func setFullscreen() {
        fullscreenIsActive = true
        fullscreenTitle.text = booksOfBible[currentBook - 1] + " " + String(currentChapter)
        fullscreenText.text = versesInCurrentChapter.joined(separator: "\n")
        fullscreenBackground.alpha = 1
    }
    func setFontFamily(fontFamily: String) {
        lightFeedback()
        currentFontFamily = fontFamily
        setStyle()
        ref.child(( "users/" + uid + "/currentFontFamily")) .setValue(currentFontFamily)
        locate(isRandom: false)    }
    func setFontSize(fontSize: CGFloat) {
        lightFeedback()
        currentFontSize = fontSize
        setStyle()
        ref.child(( "users/" + uid + "/currentFontSize")) .setValue(currentFontSize)
        locate(isRandom: false)
    }
    
    //MARK: Summon Content
    
    func summonContent(xw: CGFloat) {
        content.reloadData()
        content.layoutIfNeeded()
        var denominator = 0
        if contentMode == "Cross References" {
            denominator = referencesTitles.count
        } else if contentMode == "History" {
            denominator = historyTitles.count
        } else if contentMode == "Highlights" {
            denominator = highlightsTitles.count
        } else if contentMode == "Books" {
            denominator = booksOfBible.count
        }
        if contentMode != "Verses" {
            var numerator = Int(xw * CGFloat(denominator))
            if numerator < 1 {
                numerator = 1
            }
            if numerator < content.numberOfRows(inSection: 0) && content.numberOfRows(inSection: 0) > 0 {
                content.scrollToRow(at: NSIndexPath(row: numerator - 1, section: 0)as IndexPath, at: .top, animated: false)
            }
            do {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    if numerator < self.content.numberOfRows(inSection: 0) && self.content.numberOfRows(inSection: 0) > 0 {
                        self.content.scrollToRow(at: NSIndexPath(row: numerator - 1, section: 0)as IndexPath, at: .top, animated: false)
                    }
                }
                self.content.scrollToRow(at: NSIndexPath(row: numerator - 1, section: 0)as IndexPath, at: .top, animated: false)
            }
            bottomLabel.text = contentMode + " " + String(numerator) + "/" + String(denominator)
        }
    }
    
    //MARK: Location
    
    func locate(isRandom: Bool) {
        contentMode = "Verses"
        leftImage.alpha = 1
        rightImage.alpha = 1
        highlights = [Int]()
        if online {
            ref.child("users/" + uid + "/highlights/" + String(currentBook)) .observeSingleEvent(of: .value, with: {(snapshot)in
                let value = snapshot.value as? NSDictionary
                do {
                    let valuesString = value?[String(self.currentChapter)] as? String ?? ""
                    let valuesArray = valuesString.components(separatedBy: ",")
                    if !valuesArray.isEmpty {
                        self.highlights = valuesArray.map {(Int($0) ?? -1)}
                        self.highlights = self.highlights.filter {$0 != -1}
                    }
                }
                self.goTo(isRandom: isRandom)
            })
        } else {
            goTo(isRandom: isRandom)
        }
    }
    func goTo(isRandom: Bool) {
        versesInCurrentChapter = [String]()
        if shouldClearSelection {
            selectedVerses = [String]()
            storeSelection()
        }
        var n = 0
        for string in versesInBible {
            if string.starts(with: booksOfBible[currentBook - 1] + "_" + currentChapter.description + ":") {
                versesInCurrentChapter.append(versesInBible[n].replacingOccurrences(of :(booksOfBible[currentBook - 1] + "_" + currentChapter.description + ":"), with: ""))
            }
            n = n + 1
        }
        var chapter = ""
        for string in versesInCurrentChapter {
            chapter = chapter + string + " \n"
        }
        chapterHasRendered = true
        if isRandom {
            currentVerse = Int.random(in: 0..<versesInCurrentChapter.count) + 1
            storeLocation()
        }
        topLabel.text = " " + (booksOfBible[currentBook - 1] + " " + currentChapter.description + ":" + currentVerse.description) + " "
        content.reloadData()
        content.layoutIfNeeded()
        if currentVerse < content.numberOfRows(inSection: 0) && content.numberOfRows(inSection: 0) > 0 {
            content.layoutIfNeeded()
            content.setContentOffset(CGPoint(x: 0, y: CGFloat.greatestFiniteMagnitude), animated: false)
            content.layoutIfNeeded()
            content.scrollToRow(at: NSIndexPath(row: currentVerse - 1, section: 0)as IndexPath, at: .top, animated: false)
            content.layoutIfNeeded()
            content.scrollToRow(at: NSIndexPath(row: currentVerse - 1, section: 0)as IndexPath, at: .top, animated: false)
        }
        do {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.content.layoutIfNeeded()
                if self.currentVerse < self.content.numberOfRows(inSection: 0) && self.content.numberOfRows(inSection: 0) > 0 {
                    self.content.layoutIfNeeded()
                    self.content.scrollToRow(at: NSIndexPath(row: self.currentVerse - 1, section: 0)as IndexPath, at: .top, animated: false)
                    self.content.layoutIfNeeded()
                }
            }
            content.layoutIfNeeded()
            content.scrollToRow(at: NSIndexPath(row: currentVerse - 1, section: 0)as IndexPath, at: .top, animated: false)
            content.layoutIfNeeded()
        }
        var numerator = 0
        var denominator = 0
        if bottomNavigationMode == "Book" {
            numerator = currentBook
            denominator = 66
        } else if bottomNavigationMode == "Chapter" {
            numerator = currentChapter
            denominator = numberOfChaptersInBooksOfBible[currentBook - 1]
        } else if bottomNavigationMode == "Verse" {
            numerator = currentVerse
            denominator = versesInCurrentChapter.count
        }
        bottomLabel.text = bottomNavigationMode + " " + String(numerator) + "/" + String(denominator)
        setSelection()
    }
    func storeLocation() {
        do {
            ref.child(( "users/" + uid + "/currentBook")) .setValue(currentBook)
            ref.child(( "users/" + uid + "/currentChapter")) .setValue(currentChapter)
            ref.child(( "users/" + uid + "/currentVerse")) .setValue(currentVerse)
            let timestamp = String(Int(NSDate() .timeIntervalSince1970))
            let location = String(currentBook) + "." + String(currentChapter) + "." + String(currentVerse)
            ref.child(( "users/" + uid + "/history")) .observeSingleEvent(of: .value, with: {(snapshot)in
                let value = snapshot.value as? NSDictionary
                let allValues = value?.allValues as? [String] ?? [""]
                let allKeys = value?.allKeys as? [String] ?? [""]
                let offsets = allKeys.enumerated() .sorted{$0.element > $1.element }.map{$0.offset }
                var allValuesSorted = offsets.map{allValues[$0]}
                if allValuesSorted.count < 1 {
                    allValuesSorted = [""]
                }
                let mostRecentLocation = allValuesSorted[0]
                if mostRecentLocation != location {
                    self.ref.child(( "users/" + self.uid + "/history/" + timestamp)) .setValue(location)
                }
            })
        }
    }
    
    //MARK: Highlights
    
    func storeHighlights() {
        highlights = highlights.sorted()
        var versesArrayAsString = ""
        for item in highlights {
            versesArrayAsString = versesArrayAsString + String(item) + ","
        }
        versesArrayAsString = String(versesArrayAsString.dropLast())
        ref.child("users/" + uid + "/highlights/" + String(currentBook) + "/" + String(currentChapter)) .setValue(versesArrayAsString)
        ref.child("users/" + uid + "/highlights/" + String(currentBook) + "/" + String("\"\"")) .setValue("")
        ref.child(( "users/" + uid + "/highlights/66")) .updateChildValues(["\"\"": ""])
    }
    
    //MARK: Selection
    
    func storeSelection() {
        selectedVerses = selectedVerses.sorted{$0 < $1 }
        if selectedVerses.count > 1 {
            selectedVerses = selectedVerses.filter{$0 != "x"}
            ref.child(( "users/" + uid + "/selectedVerses")) .setValue(selectedVerses)
        } else {
            ref.child(( "users/" + uid + "/selectedVerses")) .setValue(["x"])
        }
        setSelection()
    }
    
    //MARK: Shake
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            goToRandomVerse()
            heavyFeedback()
        }
    }
    
    //MARK: Feedback
    
    func lightFeedback() {
        feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator?.prepare()
        feedbackGenerator?.impactOccurred()
    }
    func mediumFeedback() {
        feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator?.prepare()
        feedbackGenerator?.impactOccurred()
    }
    func heavyFeedback() {
        feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
        feedbackGenerator?.prepare()
        feedbackGenerator?.impactOccurred()
    }
    
    //MARK: Setters
    
    func setScreenSize() {
        screenWidth = UIScreen.main.bounds.width
        screenHeight = UIScreen.main.bounds.height
    }
    func setStyle() {
        contentMode = "Verses"
        leftImage.alpha = 1
        rightImage.alpha = 1
        if night == true {
            menuBackground.backgroundColor = colorBlack
            mainBackground.backgroundColor = colorBlack
            topLabel.backgroundColor = colorBlack
            topLabel.textColor = colorWhite
            bottomLabel.backgroundColor = colorBlack
            bottomLabel.textColor = colorWhite
            nightModeImage.image = UIImage(named: "moon")
            displayBackground.backgroundColor = colorBlack
            previousBookLabel.textColor = colorWhite
            currentBookLabel.textColor = colorWhite
            nextBookLabel.textColor = colorWhite
            previousChapterLabel.textColor = colorWhite
            currentChapterLabel.textColor = colorWhite
            nextChapterLabel.textColor = colorWhite
            menuProfileLabel.textColor = colorWhite
            menuSettingsLabel.textColor = colorWhite
            menuVersionsLabel.textColor = colorWhite
            menuHistoryLabel.textColor = colorWhite
            menuViewHighlightsLabel.textColor = colorWhite
            menuReferencesLabel.textColor = colorWhite
            menuAudioLabel.textColor = colorWhite
            menuHighlightLabel.textColor = colorWhite
            menuCopyLabel.textColor = colorWhite
            fullscreenTitle.textColor = colorWhite
            fullscreenBackground.backgroundColor = colorBlack
            fullscreenText.backgroundColor = colorBlack
            fullscreenText.textColor = colorWhite
        } else {
            menuBackground.backgroundColor = colorWhite
            mainBackground.backgroundColor = colorWhite
            topLabel.backgroundColor = colorWhite
            topLabel.textColor = colorBlack
            bottomLabel.backgroundColor = colorWhite
            bottomLabel.textColor = colorBlack
            nightModeImage.image = UIImage(named: "sun")
            displayBackground.backgroundColor = colorWhite
            previousBookLabel.textColor = colorBlack
            currentBookLabel.textColor = colorBlack
            nextBookLabel.textColor = colorBlack
            previousChapterLabel.textColor = colorBlack
            currentChapterLabel.textColor = colorBlack
            nextChapterLabel.textColor = colorBlack
            menuProfileLabel.textColor = colorBlack
            menuSettingsLabel.textColor = colorBlack
            menuVersionsLabel.textColor = colorBlack
            menuHistoryLabel.textColor = colorBlack
            menuViewHighlightsLabel.textColor = colorBlack
            menuReferencesLabel.textColor = colorBlack
            menuAudioLabel.textColor = colorBlack
            menuHighlightLabel.textColor = colorBlack
            menuCopyLabel.textColor = colorBlack
            fullscreenTitle.textColor = colorBlack
            fullscreenBackground.backgroundColor = colorWhite
            fullscreenText.backgroundColor = colorWhite
            fullscreenText.textColor = colorBlack
        }
        topLabel.layer.masksToBounds = true
        topLabel.layer.borderWidth = 2
        topLabel.layer.borderColor = colorGray.cgColor
        topLabel.font = UIFont(name: currentFontFamily, size: currentFontSize)
        topLabel.adjustsFontSizeToFitWidth = true
        topLabel.minimumScaleFactor = 0.2
        topLabel.numberOfLines = 1
        bottomLabel.layer.masksToBounds = true
        bottomLabel.layer.borderWidth = 2
        bottomLabel.layer.borderColor = colorGray.cgColor
        bottomLabel.font = UIFont(name: currentFontFamily, size: currentFontSize)
        bottomLabel.adjustsFontSizeToFitWidth = true
        bottomLabel.minimumScaleFactor = 0.2
        bottomLabel.numberOfLines = 1
        content.reloadData()
        setSelection()
        fullscreenTitle.font = UIFont(name: currentFontFamily, size: currentFontSize)
        fullscreenText.font = UIFont(name: currentFontFamily, size: currentFontSize)
        previousBookLabel.font = UIFont(name: currentFontFamily, size: currentFontSize)
        currentBookLabel.font = UIFont(name: currentFontFamily, size: currentFontSize)
        nextBookLabel.font = UIFont(name: currentFontFamily, size: currentFontSize)
        previousChapterLabel.font = UIFont(name: currentFontFamily, size: currentFontSize)
        currentChapterLabel.font = UIFont(name: currentFontFamily, size: currentFontSize)
        nextChapterLabel.font = UIFont(name: currentFontFamily, size: currentFontSize)
        let menuFontSizeMin: CGFloat = 10
        let menuFontSizeMax: CGFloat = 20
        let menuFontSizeRate: CGFloat = 1 / 2
        var menuFontSize: CGFloat = currentFontSize * menuFontSizeRate
        if menuFontSize < menuFontSizeMin {
            menuFontSize = menuFontSizeMin        }
        if menuFontSize > menuFontSizeMax {
            menuFontSize = menuFontSizeMax
        }
        menuProfileLabel.font = UIFont(name: currentFontFamily, size: menuFontSize)
        menuSettingsLabel.font = UIFont(name: currentFontFamily, size: menuFontSize)
        menuVersionsLabel.font = UIFont(name: currentFontFamily, size: menuFontSize)
        menuHistoryLabel.font = UIFont(name: currentFontFamily, size: menuFontSize)
        menuViewHighlightsLabel.font = UIFont(name: currentFontFamily, size: menuFontSize)
        menuReferencesLabel.font = UIFont(name: currentFontFamily, size: menuFontSize)
        menuAudioLabel.font = UIFont(name: currentFontFamily, size: menuFontSize)
        menuHighlightLabel.font = UIFont(name: currentFontFamily, size: menuFontSize)
        menuCopyLabel.font = UIFont(name: currentFontFamily, size: menuFontSize)
    }
    func setSelection() {
        var index = 0
        while index < selectedVerses.count {
            if selectedVerses[index] != "x" {
                content.selectRow(at: IndexPath(row: Int(selectedVerses[index]) ?? 0, section: 0), animated: false, scrollPosition: UITableView.ScrollPosition.none)
            }
            index = index + 1
        }
    }
    
    //MARK: Helpers
    
    func selectedReference() -> String {
        var workingArray = [String]()
        var i = 0
        for verse in versesInCurrentChapter {
            var containsVerse = false
            for selectedVerseNumber in selectedVerses {
                var selectedVerseNumberAsString = "-1"
                if selectedVerseNumber != "x" {
                    selectedVerseNumberAsString = String(Int(selectedVerseNumber)! + 1) + "."
                }
                if verse.hasPrefix(selectedVerseNumberAsString) {
                    containsVerse = true
                }
            }
            if containsVerse {
                workingArray.append(String(i + 1))
            } else {
                workingArray.append(",")
            }
            containsVerse = false
            i = i + 1
        }
        i = 0
        var verseRange = [[""]]
        var range = [""]
        verseRange.removeAll()
        range.removeAll()
        for item in workingArray {
            if item != "," && item != "" {
                range.append(item)
            } else if range.count != 0 && range != [""] {
                verseRange.append(range)
                range.removeAll()
            }
            i = i + 1
        }
        if range.count != 0 {
            verseRange.append(range)
            range = [""]
        }
        i = 0
        var verseRangesString = ""
        for item in verseRange {
            if item[0] == item[item.count - 1] {
                verseRangesString = verseRangesString + item[0]
            } else {
                verseRangesString = verseRangesString + item[0] + "-" + item[item.count - 1]
            }
            verseRangesString = verseRangesString + ", "
            
            i = i + 1
        }
        verseRangesString = String(verseRangesString.dropLast(2))
        if selectedVerses[0] == "x" {
            return "x"
        } else {
            return verseRangesString
        }
    }
    func alert(alertText: String) {
        let alert = UIAlertController(title: "!", message: alertText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler :{action in}))
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Scroll
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let threshold = currentFontSize * 3
        if currentOffset < -1 * threshold {
            previousButtonTap()
        } else if currentOffset > maximumOffset + threshold {
            nextButtonTap()
        }
        leftImage.alpha = 1
        rightImage.alpha = 1
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold = currentFontSize * 2
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if currentOffset < -1 * threshold {
            leftImage.alpha = 0.5
        } else if currentOffset > maximumOffset + threshold {
            rightImage.alpha = 0.5
        } else {
            leftImage.alpha = 1
            rightImage.alpha = 1
        }
    }
    
    //MARK: Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var amount = 0
        if contentMode == "Verses" {
            amount = versesInCurrentChapter.count
        } else if contentMode == "Cross References" {
            amount = referencesTitles.count
        } else if contentMode == "History" {
            amount = historyTitles.count
        } else if contentMode == "Highlights" {
            amount = highlightsTitles.count
        } else if contentMode == "Books" {
            amount = booksOfBible.count
        }
        return amount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = (tableView.dequeueReusableCell(withIdentifier: "cell")as UITableViewCell?)!
        cell.textLabel?.font = UIFont(name: currentFontFamily, size: currentFontSize)
        let selectedBackground = UIView()
        if night {
            cell.textLabel?.textColor = colorWhite
            cell.backgroundView?.backgroundColor = colorBlack
            cell.backgroundColor = colorBlack
            tableView.backgroundView?.backgroundColor = colorBlack
            tableView.backgroundColor = colorBlack
            selectedBackground.backgroundColor = colorDarkGray
        } else {
            cell.textLabel?.textColor = colorBlack
            cell.backgroundView?.backgroundColor = colorWhite
            cell.backgroundColor = colorWhite
            tableView.backgroundView?.backgroundColor = colorWhite
            tableView.backgroundColor = colorWhite
            selectedBackground.backgroundColor = colorLightGray
        }
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 17
        cell.layer.borderWidth = 2
        cell.layer.shadowOffset = CGSize(width: -1, height: 1)
        if contentMode == "Verses" {
            if indexPath.row == currentVerse - 1 {
                cell.layer.borderColor = colorGray.cgColor
            } else {
                if night {
                    cell.layer.borderColor = colorBlack.cgColor
                } else {
                    cell.layer.borderColor = colorWhite.cgColor
                }
            }
            if highlights.contains(indexPath.row + 1) {
                cell.layer.backgroundColor = colorHighlight.cgColor
                selectedBackground.backgroundColor = colorSelected
            }
            cell.textLabel?.text = versesInCurrentChapter[indexPath.row]
        } else if contentMode == "Cross References" {
            cell.textLabel?.text = referencesTitles[indexPath.row]
            cell.layer.borderColor = colorClear.cgColor
            selectedBackground.backgroundColor = colorClear
        } else if contentMode == "History" {
            cell.textLabel?.text = historyTitles[indexPath.row]
            cell.layer.borderColor = colorClear.cgColor
            selectedBackground.backgroundColor = colorClear
        } else if contentMode == "Highlights" {
            cell.textLabel?.text = highlightsTitles[indexPath.row]
            cell.layer.borderColor = colorClear.cgColor
            selectedBackground.backgroundColor = colorClear
        } else if contentMode == "Books" {
            cell.textLabel?.text = booksOfBible[indexPath.row]
            cell.layer.borderColor = colorClear.cgColor
            selectedBackground.backgroundColor = colorClear
        }
        if contentMode == "Verses" {
            cell.textLabel?.textAlignment = .left
        } else {
            cell.textLabel?.textAlignment = .center
        }
        cell.selectedBackgroundView = selectedBackground
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        return cell
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let erase = UITableViewRowAction(style: .destructive, title: "×") {(action, indexPath)in
            self.highlights = self.highlights.filter{$0 != indexPath.row + 1}
            self.storeHighlights()
            self.setSelection()
        }
        if highlights.contains(indexPath.row + 1) {
            if contentMode == "Verses" {
                return [erase]
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mediumFeedback()
        if contentMode == "Verses" {
            selectedVerses.append(String(indexPath.row))
            selectedVerses.sort()
            storeSelection()
        } else if contentMode == "Cross References" {
            currentBook = referencesBooks[indexPath.row]
            currentChapter = referencesChapters[indexPath.row]
            currentVerse = referencesVerses[indexPath.row]
            storeLocation()
            locate(isRandom: false)
        } else if contentMode == "History" {
            currentBook = historyBooks[indexPath.row]
            currentChapter = historyChapters[indexPath.row]
            currentVerse = historyVerses[indexPath.row]
            storeLocation()
            locate(isRandom: false)
        } else if contentMode == "Highlights" {
            currentBook = highlightsBooks[indexPath.row]
            currentChapter = highlightsChapters[indexPath.row]
            currentVerse = highlightsVerses[indexPath.row]
            storeLocation()
            locate(isRandom: false)
        } else if contentMode == "Books" {
            currentBook = indexPath.row + 1
            currentChapter = 1
            currentVerse = 1
            storeLocation()
            locate(isRandom: false)
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        mediumFeedback()
        if contentMode == "Verses" {
            while selectedVerses.contains(String(indexPath.row)) {
                if let itemToRemoveIndex = selectedVerses.firstIndex(of: String(indexPath.row)) {
                    selectedVerses.remove(at: itemToRemoveIndex)
                    selectedVerses = selectedVerses.filter{$0 != "x"}
                    selectedVerses.append("x")
                }
            }
            storeSelection()
        }
    }
    
    //MARK: Check if Online
    
    func checkIfOnline() {
        let connectedRef = Database.database() .reference(withPath: ".info/connected")
        connectedRef.observe(.value, with :{snapshot in
            if let connected = snapshot.value as? Bool, connected {
                self.online = true
                self.statusBar.alpha = 0
            } else {
                self.online = false
                self.statusBar.alpha = 1
            }
        })
    }
}
