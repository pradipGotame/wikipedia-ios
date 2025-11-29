//~~~**DELETE THIS HEADER**~~~

import Testing
@testable import Wikipedia
import MapKit
import CoreLocation
import Combine

struct DeepLinkEventHandlerTest {
    private var cancellables = Set<AnyCancellable>()
    
    @Test("testing deeplink event trigger")
    mutating func testEvent() {
        let parameter = DeepLinkParameters(
            region: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 123, longitude: 456), span: .init(latitudeDelta: 0.05, longitudeDelta: 0.5)
            ),
            name: "Amsterdamn"
        )
        
        DeepLinkEventHandler.shared.deepLinkSubject
            .sink { parameter in
                #expect(parameter.name == "Amsterdamn")
                #expect(parameter.region.center.latitude == Double(123))
            }
            .store(in: &cancellables)
        
        DeepLinkEventHandler.shared.deepLinkSubject.send(parameter)
    }
}
