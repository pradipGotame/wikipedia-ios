
import Foundation
import MapKit
import CoreLocation

struct WikipediaDeepLinkHandler {
    enum Target: Equatable {
        static func == (lhs: Target, rhs: Target) -> Bool {
            switch (lhs, rhs) {
            case (.unknown, .unknown):
                return true
            case let (.places(region1, title1), .places(region2, title2)):
                return region1.center.latitude == region2.center.latitude &&
                       region1.center.longitude == region2.center.longitude &&
                       title1 == title2
            default:
                return false
            }
        }
        
        case places(MKCoordinateRegion, String)
        case unknown
    }
    
    enum Controller: String {
        case places = "places"
    }
    
    static func parse(_ url: URL) -> Target {
        guard url.scheme == "wikipedia",
              url.host == Controller.places.rawValue else {
            return .unknown
        }
        
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let items = components?.queryItems ?? []
        
        let latString = items.first(where: { $0.name == "lat" })?.value
        let lonString = items.first(where: { $0.name == "lon" })?.value
        let name      = items.first(where: { $0.name == "title"})?.value
        
        if let latString = latString,
           let lonString = lonString,
           let lat = Double(latString),
           let lon = Double(lonString),
           let name = name {
            
            let coord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            let region = MKCoordinateRegion(center: coord, span: .init(latitudeDelta: 0.05, longitudeDelta: 0.5))
            return .places(region, name)
        }
        
        return .unknown
    }
}
