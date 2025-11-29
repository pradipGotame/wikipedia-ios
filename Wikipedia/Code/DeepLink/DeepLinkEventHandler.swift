
import Combine
import MapKit

final class DeepLinkEventHandler {
    static let shared = DeepLinkEventHandler()

    let deepLinkSubject = PassthroughSubject<DeepLinkParameters, Never>()
}

struct DeepLinkParameters {
    var region: MKCoordinateRegion
    var name: String
}
