
import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet var table: UITableView!
    
    @IBOutlet weak var cityNameTextField: UITextField!
    
    @IBOutlet weak var zipcodeTextField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    private var hourlyModels = [HourlyWeatherEntry]()
    private var locationModels : SelectedLocation?
    private var currentWeatherModels : CurrentWeather?
    
   private var weatherFetchService = WeatherFetchService()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Register 2 cells
        table.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        table.register(LocationTableViewCell.nib(), forCellReuseIdentifier: LocationTableViewCell.identifier)
        
        table.delegate = self
        table.dataSource = self

        table.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
        view.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
        
        setupDelegates()
        initializeDefault()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupDelegates(){
        cityNameTextField.delegate = self
        zipcodeTextField.delegate = self
    }
    
    private func initializeDefault(){
        submitButton.isEnabled = false
        [cityNameTextField, zipcodeTextField].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        
        if  let city = cityNameTextField.text,
            let zipcode = zipcodeTextField.text,
            city.isEmpty,
            zipcode.isEmpty{
            submitButton.isEnabled = false
            return
        }
        
        submitButton.isEnabled = true
    }

   
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        var queryParameter = ""
        if let city = cityNameTextField.text,
            !city.isEmpty {
            queryParameter = city
        }else if let zipcode = zipcodeTextField.text,
            !zipcode.isEmpty {
            queryParameter = zipcode
        }
        
        weatherFetchService.requestWeatherForLocation(query: queryParameter) {
            (hourly : [HourlyWeatherEntry]?,
            location :  SelectedLocation?,
            currentWeather : CurrentWeather?) in
            
            guard let hourlyModelsResponse = hourly,
                let locationModelsResponse = location,
                let currentWeatherModelsResponse = currentWeather
                else {
                    return
            }
            
            self.hourlyModels = hourlyModelsResponse
            self.locationModels = locationModelsResponse
            self.currentWeatherModels = currentWeatherModelsResponse
            
            // Update user interface
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
    }
    
    
}


// MARK: - TableView delegates and datasource
extension ViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 ||  section == 1{
            return 1
        }
      return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.identifier, for: indexPath) as! LocationTableViewCell
            guard let model = locationModels,
                  let currentWeather = currentWeatherModels
            else{
                    cell.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
                    return cell
            }
            
            cell.configure(with: model, currentWeather: currentWeather)
            cell.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
            return cell
        }
        
            let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as! HourlyTableViewCell
            cell.configure(with: hourlyModels)
            cell.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
            return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 || indexPath.section == 1{
            return 200
        }
        return 0
    }

}

// MARK: - Keyboard dismiss
extension ViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
