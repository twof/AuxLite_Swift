import PromiseKit
import Alamofire

struct GetPartyInteractor {
    func execute(partyId: Int) {
        Alamofire.request("http://localhost:8080/party/\(partyId)")
    }
}
