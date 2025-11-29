//~~~**DELETE THIS HEADER**~~~

import Testing
@testable import Wikipedia

@Suite("WikipediaDeepLinkHandler")
struct WikipediaDeepLinkHandlerTest {
    
    @Test("validating place tabs")
    func testWrongHost() {
        let url = URL(string: "wikipedia://places?lat=1234&lon=456&title=Amsterdam")!
        let target = WikipediaDeepLinkHandler.parse(url)
        #expect(target == .unknown, "url host should be places")
    }
    
    @Test("validating deeplink host")
    func testParcedPlaceAndTitle() async throws {
        let url = URL(string: "wikipedia://places?lat=1234&lon=456&title=Amsterdam")!
        
        let target = WikipediaDeepLinkHandler.parse(url)
        
        if case .places(let mKCoordinateRegion, let name) = target {
            #expect(mKCoordinateRegion.center.latitude == 1234.0)
            #expect(mKCoordinateRegion.center.longitude == 456.0)
            #expect( name == "Amsterdam")
        } else {
            Issue.record("Expected places but got none")
        }
    }
    
    @Test("validating deeplink scheme")
    func testWrongScheme() {
        let url = URL(string: "wikipediaa://placess?lat=1234&lon=456&title=Amsterdam")!
        let target = WikipediaDeepLinkHandler.parse(url)
        #expect(target == .unknown, "url scheme should be wikipedia")
    }
    
    @Test("validating deeplink url")
    func testWrongDeepLinkURL() {
        let url = URL(string: "wikipedia://places")!
        let target = WikipediaDeepLinkHandler.parse(url)
        #expect(target == .unknown, "url missing required parameter lat, lon, title")
    }
}
