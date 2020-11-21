import UIKit
import FirebaseFirestore
import Firebase
import GoogleMobileAds

struct Variables {
    static var points = 300
}

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var pointsLabel: UIBarButtonItem!
    
    var JSON = ""
    var YTJSON = ""
    var subsCount = ""
    var subsJSONURL = ""
    var imageIconURL = ""
    var imgJSON = ""
    var indexCollectionView = IndexPath()
    let dataBase = Firestore.firestore()
    
    var bannerView: GADBannerView!
    
    
    @IBOutlet weak var SubscollectionsView: UICollectionView!
    
    override func viewDidAppear(_ animated: Bool) {
        
        bannerView.load(GADRequest())

        
        if let url = URL(string: "https://raw.githubusercontent.com/Ashwin-Paudel/yo/main/peoples.json") {
            do {
                let contents = try String(contentsOf: url)
                JSON = contents
            } catch {
                // contents could not be loaded
            }
        } else {
            // the URL was bad!
        }
        pointsLabel.title = "\(Variables.points) Points"
        
    }
    var itemsInttt: Int = 6

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        dataBase.collection("Channels").getDocuments { (snapshot, error) in
            self.itemsInttt = (snapshot?.documents.count)!
        }
        
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)

          addBannerViewToView(bannerView)
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
         bannerView.rootViewController = self
        bannerView.load(GADRequest())

        
        if let url = URL(string: "https://raw.githubusercontent.com/Ashwin-Paudel/yo/main/peoples.json") {
            do {
                let contents = try String(contentsOf: url)
                JSON = contents
                
            } catch {
                // contents could not be loaded
            }
        } else {
            // the URL was bad!
        }
    }
    func addBannerViewToView(_ bannerView: GADBannerView) {
       bannerView.translatesAutoresizingMaskIntoConstraints = false
       view.addSubview(bannerView)
       view.addConstraints(
         [NSLayoutConstraint(item: bannerView,
                             attribute: .bottom,
                             relatedBy: .equal,
                             toItem: bottomLayoutGuide,
                             attribute: .top,
                             multiplier: 1,
                             constant: 0),
          NSLayoutConstraint(item: bannerView,
                             attribute: .centerX,
                             relatedBy: .equal,
                             toItem: view,
                             attribute: .centerX,
                             multiplier: 1,
                             constant: 0)
         ])
      }
    //MARK: - Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataBase.collection("Channels").getDocuments { (snapshot, error) in
            
            self.itemsInttt = (snapshot?.documents.count)!
        }
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subcell", for: indexPath) as! SubCollectionViewCell
        
        
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1.0
        cell.verifyButton.layer.cornerRadius = 25
        cell.verifyButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        cell.layer.cornerRadius = 25
        dataBase.collection("Channels").getDocuments { (document, error) in
            let data = document!.documents[indexPath.item].data()
            let channels = data["channelID"] as! String
            let ytpoints = data["points"] as! Int
            
            let JSJSJSJSJSJ = "https://www.googleapis.com/youtube/v3/channels?id=\(channels)&part=snippet&key=GOOGLEAPIKEY"
            var CHTTitleJSON = ""
            if let url = URL(string: JSJSJSJSJSJ) {
                do {
                    let contents = try String(contentsOf: url)
                    CHTTitleJSON = contents
                } catch {
                    // contents could not be loaded
                }
            } else {
                // the URL was bad!
            }
            let jsonDataForCHT = CHTTitleJSON.data(using: .utf8)!
            let yTChannelTitle = try? JSONDecoder().decode(CHTRootClass.self, from: jsonDataForCHT)
            let channelTitle = yTChannelTitle?.items[0].snippet.localized.title
            cell.channelName.text = channelTitle
        }
        dataBase.collection("Channels").getDocuments { (document, error) in
            let data = document!.documents[indexPath.item].data()
            let channels = data["channelID"] as! String
            let ytpoints = data["points"] as! Int
            
            let JSJSJSJSJSJ = "https://www.googleapis.com/youtube/v3/channels?id=\(channels)&part=snippet&key=GOOGLEAPIKEY"
            var CHTTitleJSON = ""
            if let url = URL(string: JSJSJSJSJSJ) {
                do {
                    let contents = try String(contentsOf: url)
                    CHTTitleJSON = contents
                } catch {
                    // contents could not be loaded
                }
            } else {
                // the URL was bad!
            }
            
            self.imageIconURL = "https://www.googleapis.com/youtube/v3/channels?part=snippet&fields=items%2Fsnippet%2Fthumbnails%2Fdefault&id=\(channels)&key=GOOGLEAPIKEY"
            if let url = URL(string: self.imageIconURL) {
                do {
                    let contents = try String(contentsOf: url)
                    self.imgJSON = contents
                } catch {
                    // contents could not be loaded
                }
            } else {
                // the URL was bad!
            }
            let imageData = self.imgJSON.data(using: .utf8)!
            let imgDa: IMGRootClass = try! JSONDecoder().decode(IMGRootClass.self, from: imageData)
            let url11 = imgDa.items[0].snippet.thumbnails.default.url
            
            let data11111 = try? Data(contentsOf: URL(string: url11!)!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            cell.channelImage.image = UIImage(data: data11111!)
            
            cell.pointsLable.text = "\(ytpoints)"
            print(document!.documents[indexPath.item].data())
           // let documentData = docume3nt?.documents
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //https://www.googleapis.com/youtube/v3/channels?part=statistics&id=UCx7zp7a_k2RbCFnlNopnAew&key=GOOGLEAPIKEY
       
        //https://www.googleapis.com/youtube/v3/channels?part=snippet&fields=items%2Fsnippet%2Fthumbnails%2Fdefault&id=UCx7zp7a_k2RbCFnlNopnAew&key=GOOGLEAPIKEY
        
        dataBase.collection("Channels").getDocuments { [self] (document, error) in
            let data = document!.documents[indexPath.item].data()
            let channels = data["channelID"] as! String
            subsJSONURL = "https://www.googleapis.com/youtube/v3/channels?part=statistics&id=\(channels)&key=GOOGLEAPIKEY"
            if let url = URL(string: subsJSONURL) {
                do {
                    let contents = try String(contentsOf: url)
                    YTJSON = contents
                } catch {
                    // contents could not be loaded
                }
            } else {
                // the URL was bad!
            }
            // Find channel Title
            
            let jsonDataForYT = YTJSON.data(using: .utf8)!
             let subs: Welcome = try! JSONDecoder().decode(Welcome.self, from: jsonDataForYT)
            subsCount = subs.items[0].statistics.subscriberCount
            print("Subsss " + subs.items[0].statistics.subscriberCount)
            //https://www.googleapis.com/youtube/v3/search?key=GOOGLEAPIKEY&channelId=UCx7zp7a_k2RbCFnlNopnAew&part=snippet,id&order=date&maxResults=20
            indexCollectionView = indexPath
            print(indexPath.item)
            UIApplication.shared.openURL(URL(string: "https://www.youtube.com/channel/" + channels + "?sub_confirmation=1")!)
        }
        if let url = URL(string: subsJSONURL) {
            do {
                let contents = try String(contentsOf: url)
                YTJSON = contents
            } catch {
                // contents could not be loaded
            }
        } else {
            // the URL was bad!
        }
        
       
    }
    @IBAction func collectionViewRefresh(_ sender: Any) {
        SubscollectionsView.reloadData()
    }
    @IBAction func verifyButtonActions(_ sender: Any) {
        
        if let url = URL(string: subsJSONURL) {
            do {
                let contents = try String(contentsOf: url)
                YTJSON = contents
            } catch {
                // contents could not be loaded
            }
        } else {
            // the URL was bad!
        }
        let jsonDataForYT = YTJSON.data(using: .utf8)!
        if subsJSONURL == "" {
            let alert = UIAlertController(title: "Error", message: "You did not select a channel or subscribe to anyone", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

            self.present(alert, animated: true)
        } else {
         let subs: Welcome = try! JSONDecoder().decode(Welcome.self, from: jsonDataForYT)
        let subsCountReal = subs.items[0].statistics.subscriberCount
        print("SUBSSS" + " " + subsCount + " " + subsCountReal)
        if subsCount == subsCountReal {
            print("Nothing Happend")
            let alert = UIAlertController(title: "You didn't subscribe", message: "You do not get points", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else if Int(subsCount)! < Int(subsCountReal)! {
            print("Got a sub")
            
            dataBase.collection("Channels").getDocuments { [self] (document, error) in
                
                
                dataBase.collection("Channels").document("").delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                    }
                }
                
                
                
                
                
                
                let data = document!.documents[indexCollectionView.item].data()
                
                let points = data["points"] as! Int
                Variables.points += points
                print(Variables.points)
                pointsLabel.title = "\(Variables.points) Points"
                let alert = UIAlertController(title: "Yay!! You subscribed", message: "You get \(data["points"] as? Int) points", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                subsCount = subs.items[0].statistics.subscriberCount

                self.present(alert, animated: true)
            }
            
            let jsonData = JSON.data(using: .utf8)!
             let blogPosts: [YTSubs] = try! JSONDecoder().decode([YTSubs].self, from: jsonData)
            Variables.points += blogPosts[indexCollectionView.item].points
            print(Variables.points)
            pointsLabel.title = "\(Variables.points) Points"
            let alert = UIAlertController(title: "Yay!! You subscribed", message: "You get  \(blogPosts[indexCollectionView.item].points)  points", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            subsCount = subs.items[0].statistics.subscriberCount

            self.present(alert, animated: true)
        } else if Int(subsCount)! > Int(subsCountReal)! {
            let alert = UIAlertController(title: "You didn't subscribe, lost a sub", message: "You do not get points", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

            self.present(alert, animated: true)
            
            print("Lost a sub")
        }
        }
    }
}

struct YTSubs: Decodable {
    let channelName: String
    let channelURL: String
    let channelID: String
    let points: Int
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}





//MARK: - CHTRootClass
public struct CHTRootClass: Decodable {

        public var etag : String!
        public var items : [CHTItem]!
        public var kind : String!
        public var pageInfo : CHTPageInfo!
        
}


//MARK: - CHTDefault
public struct CHTDefault: Decodable {

        public var height : Int!
        public var url : String!
        public var width : Int!
        
}
//MARK: - CHTHigh
public struct CHTHigh: Decodable {

        public var height : Int!
        public var url : String!
        public var width : Int!
        
}
//MARK: - CHTItem
public struct CHTItem: Decodable {

        public var etag : String!
        public var id : String!
        public var kind : String!
        public var snippet : CHTSnippet!
        
}
public struct CHTLocalized: Decodable {

        public var descriptionField : String!
        public var title : String!
        
}
public struct CHTMedium: Decodable {

        public var height : Int!
        public var url : String!
        public var width : Int!
        
}
//MARK: - CHTPageInfo
public struct CHTPageInfo: Decodable {

        public var resultsPerPage : Int!
        public var totalResults : Int!
        
}
//MARK: - CHTSnippet
public struct CHTSnippet: Decodable {

        public var country : String!
        public var customUrl : String!
        public var descriptionField : String!
        public var localized : CHTLocalized!
        public var publishedAt : String!
        public var thumbnails : CHTThumbnail!
        public var title : String!
        
}
//MARK: - CHTThumbnail
public struct CHTThumbnail: Decodable {

        public var defaultField : CHTDefault!
        public var high : CHTHigh!
        public var medium : CHTMedium!
        
}










// MARK: - Welcome
struct Welcome: Decodable {
    let kind, etag: String
    let pageInfo: PageInfo
    let items: [Item]
}

// MARK: - Item
struct Item: Decodable {
    let kind, etag, id: String
    let statistics: Statistics
}

// MARK: - Statistics
struct Statistics: Decodable {
    let viewCount, subscriberCount: String
    let hiddenSubscriberCount: Bool
    let videoCount: String
}

// MARK: - PageInfo
struct PageInfo: Decodable {
    let totalResults, resultsPerPage: Int
}



struct IMGRootClass: Decodable {
         var items : [IMGItem]!
}
struct IMGItem: Decodable {
        var snippet : IMGSnippet!
}
 struct IMGSnippet: Decodable {
         var thumbnails : IMGThumbnail!
}
 struct IMGThumbnail: Decodable {
    var `default` : IMGDefault!
}
 struct IMGDefault: Decodable {
         var height : Int!
         var url : String!
         var width : Int!
}
