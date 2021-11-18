import FirebaseCore
import FirebaseFirestore

typealias DB = Firestore

class Database: NSObject {
    static let shared = Database()
    
    private override init() { }
    
    func configure() {
        FirebaseApp.configure()
    }
    
    func db() -> DB {
        let settings = FirestoreSettings()
        let firestore = Firestore.firestore()
        settings.isPersistenceEnabled = true
        firestore.settings = settings
        return firestore
    }
}
