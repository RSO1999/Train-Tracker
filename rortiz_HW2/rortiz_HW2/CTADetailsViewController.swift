
import UIKit

class CTADetailsViewController: UIViewController {
    
    @IBOutlet weak var CTADetailsTableView: UITableView!
    var selectedTrain: CTAViewModel!
    
    private let detailLabels = [
        "Route Name",
        "Run Number",
        "Destination Name",
        "Destination Station ID",
        "Direction Code",
        "Next Station Name",
        "Next Station ID",
        "Next Stop ID",
        "Predicted Time",
        "Arrival Time",
        "Is Approaching",
        "Is Delayed",
        "Flags",
        "Latitude",
        "Longitude",
        "Heading"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CTADetailsTableView.dataSource = self
        CTADetailsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "DetailCell")
    }
}

extension CTADetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailLabels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.numberOfLines = 0
        
        switch indexPath.row {
        case 0: cell.textLabel?.text = "Route: \(selectedTrain.routeName)"
        case 1: cell.textLabel?.text = "Run Number: \(selectedTrain.runNumber)"
        case 2: cell.textLabel?.text = "Destination: \(selectedTrain.destName)"
        case 3: cell.textLabel?.text = "Dest. Station ID: \(selectedTrain.destStationID)"
        case 4: cell.textLabel?.text = "Direction: \(selectedTrain.direction)"
        case 5: cell.textLabel?.text = "Next Station: \(selectedTrain.nextStationName)"
        case 6: cell.textLabel?.text = "Next Station ID: \(selectedTrain.nextStationID)"
        case 7: cell.textLabel?.text = "Next Stop ID: \(selectedTrain.nextStopID)"
        case 8: cell.textLabel?.text = "Predicted Time: \(formatDate(selectedTrain.predictedTime))"
        case 9: cell.textLabel?.text = "Arrival Time: \(formatDate(selectedTrain.arrivalTime))"
        case 10: cell.textLabel?.text = "Approaching: \(selectedTrain.isApproaching == "1" ? "Yes" : "No")"
        case 11: cell.textLabel?.text = "Delayed: \(selectedTrain.isDelayed == "1" ? "Yes" : "No")"
        case 12: cell.textLabel?.text = "Flags: \(selectedTrain.flags ?? "None")"
        case 13: cell.textLabel?.text = "Latitude: \(selectedTrain.latitude)"
        case 14: cell.textLabel?.text = "Longitude: \(selectedTrain.longitude)"
        case 15: cell.textLabel?.text = "Heading: \(selectedTrain.heading)°"
        default: break
        }
        
        return cell
    }
    
    private func formatDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0) 
        
        guard let date = inputFormatter.date(from: dateString) else {
            return dateString
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
        outputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        outputFormatter.amSymbol = "AM"
        outputFormatter.pmSymbol = "PM"
        
        return outputFormatter.string(from: date)
    }
}
