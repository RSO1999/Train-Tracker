
import Foundation

struct CTATTResponse: Codable {
    let ctatt: CtattContainer
}

struct CtattContainer: Codable {
    let timestamp: String
    let errorCode: String
    let errorName: String?
    let routes: [Route]

    enum CodingKeys: String, CodingKey {
        case timestamp = "tmst"
        case errorCode = "errCd"
        case errorName = "errNm"
        case routes = "route"
    }
}

struct Route: Codable {
    let name: String
    let trains: [Train]

    enum CodingKeys: String, CodingKey {
        case name = "@name"
        case trains = "train"
    }
}

struct Train: Codable {
    let runNumber: String
    let destStationID: String
    let destName: String
    let direction: String
    let nextStationID: String
    let nextStopID: String
    let nextStationName: String
    let predictedTime: String
    let arrivalTime: String
    let isApproaching: String
    let isDelayed: String
    let flags: String?
    let latitude: String
    let longitude: String
    let heading: String

    enum CodingKeys: String, CodingKey {
        case runNumber = "rn"
        case destStationID = "destSt"
        case destName = "destNm"
        case direction = "trDr"
        case nextStationID = "nextStaId"
        case nextStopID = "nextStpId"
        case nextStationName = "nextStaNm"
        case predictedTime = "prdt"
        case arrivalTime = "arrT"
        case isApproaching = "isApp"
        case isDelayed = "isDly"
        case flags
        case latitude = "lat"
        case longitude = "lon"
        case heading
    }
}
final class CTANetworkService {
    
    /*
     CTA ‘L’
     ‘L’ routes (rapid transit train services) are identified as follows:
     
     Red = Red Line (Howard-95th/Dan Ryan service)
     Blue = Blue Line (O’Hare-Forest Park service)
     Brn = Brown Line (Kimball-Loop service)
     G = Green Line (Harlem/Lake-Ashland/63rd-Cottage Grove service)
     Org = Orange Line (Midway-Loop service)
     P = Purple Line (Linden-Howard shuttle service)
     Pink = Pink Line (54th/Cermak-Loop service)
     Y = Yellow Line (Skokie-Howard [Skokie Swift] shuttle service)
     
     */

    // ⚠️ API Key Required:
    // The personal API key has been removed for security.
    // To run this app, generate your own CTA Train Tracker API key:
    // https://www.transitchicago.com/developers/traintrackerapply/
    // Then, replace the placeholder string below with your actual key.

    private let apiKey = "YOUR_API_KEY_HERE"

    
    func fetchCTARoutes(selectedRoutes: [String]) async throws -> [Route] {
           var allRoutes: [Route] = []

           for routeCode in selectedRoutes {
               var comps = URLComponents(string: "https://lapi.transitchicago.com/api/1.0/ttpositions.aspx")!
               comps.queryItems = [
                   .init(name: "key",        value: apiKey),
                   .init(name: "rt",         value: routeCode),
                   .init(name: "outputType", value: "JSON")
               ]
               let url = comps.url!

               let (data, _) = try await URLSession.shared.data(from: url)
               let decoded = try JSONDecoder().decode(CTATTResponse.self, from: data)

               allRoutes.append(contentsOf: decoded.ctatt.routes)
           }
           return allRoutes
       }
}

extension CTANetworkService {
  func makeCTAViewModels(from routes: [Route]) -> [CTAViewModel] {
    var vms: [CTAViewModel] = []
    for route in routes {
      for train in route.trains {
        vms.append(
          CTAViewModel(
            routeName:      route.name,
            runNumber:      train.runNumber,
            destStationID:  train.destStationID,
            destName:       train.destName,
            direction:      train.direction,
            nextStationID:  train.nextStationID,
            nextStopID:     train.nextStopID,
            nextStationName:train.nextStationName,
            predictedTime:  train.predictedTime,
            arrivalTime:    train.arrivalTime,
            isApproaching:  train.isApproaching,
            isDelayed:      train.isDelayed,
            flags:          train.flags,
            latitude:       train.latitude,
            longitude:      train.longitude,
            heading:        train.heading
          )
        )
      }
    }
    return vms
  }
}

