
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var brownButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var orangeButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    @IBOutlet weak var pinkButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    private let ctaService = CTANetworkService()
    private var trainVMs: [CTAViewModel] = []
    
    let routeMap: [String: String] = [
        "Red": "red",
        "Blue": "blue",
        "Brown": "brn",
        "Green": "g",
        "Orange": "org",
        "Purple": "p",
        "Pink": "pink",
        "Yellow": "y"
    ]
    
    var selectedRoutes: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        tableView.delegate = self
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails",
           let detailsVC = segue.destination as? CTADetailsViewController,
           let selectedIndexPath = tableView.indexPathForSelectedRow {
            detailsVC.selectedTrain = trainVMs[selectedIndexPath.row]
        }
    }
    


    
    @IBAction func routeButtonTapped(_ sender: UIButton) {

        guard let label = sender.titleLabel?.text,
        //sends label (KEY) to map and stores the value in routeCode
              let routeCode = routeMap[label] else { return }
        //route 'rt' parameters are stored in selectedRoutes array
        selectedRoutes.append(routeCode)
        //disables button after users taps it
        sender.isEnabled = false
    }
     
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        Task {
            do {
                let routes = try await ctaService.fetchCTARoutes(selectedRoutes: selectedRoutes)
                trainVMs = ctaService.makeCTAViewModels(from: routes)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.resetSelection()
                }
            } catch {
                DispatchQueue.main.async {
                    self.showErrorAlert(for: error)
                    self.resetSelection()
                }
            }
        }
    }

    private func showErrorAlert(for error: Error) {
        let alert = UIAlertController(
            title: "Unable to Load Trains",
            message: self.errorMessage(for: error),
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: "OK",
            style: .default,
            handler: { _ in
                self.dismiss(animated: true)
            }
        ))
        
        present(alert, animated: true)
    }

    private func errorMessage(for error: Error) -> String {
   
            return "Failed to load train data. Error: \(error.localizedDescription)"
        
    }
    func resetSelection() {
        redButton.isEnabled = true
        blueButton.isEnabled = true
        brownButton.isEnabled = true
        greenButton.isEnabled = true
        orangeButton.isEnabled = true
        purpleButton.isEnabled = true
        pinkButton.isEnabled = true
        yellowButton.isEnabled = true
        
        selectedRoutes.removeAll()

    }
    
    
    
     

 }
extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return trainVMs.count
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TrainCell", for: indexPath)
    let vm   = trainVMs[indexPath.row]
      
      //reverse lookup in routeMap
      let displayName = routeMap.first { $0.value == vm.routeName }?.key ?? vm.routeName.capitalized
    //displays actual color name of Train Line
      cell.textLabel?.text = displayName
      cell.detailTextLabel?.text = "Next Destination: \(vm.nextStationName ?? "Unknown")"

    return cell
  }
    
    
}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTrain = trainVMs[indexPath.row]
        print("Selected Train Details:", selectedTrain)
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showDetails", sender: self)
    }
}
