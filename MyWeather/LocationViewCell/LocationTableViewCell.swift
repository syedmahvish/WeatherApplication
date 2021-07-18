import UIKit

class LocationTableViewCell: UITableViewCell {
   
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var feelsLikeLabel: UILabel!
    
     static let identifier = "LocationTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "LocationTableViewCell", bundle: nil)
    }
    
    /// Configure UI for given location details like location name, dateTime and weather condition
    ///
    /// - Parameters:
    ///   - model: takes current location description as SelectedLocation model take contains name and datetime
    ///   - currentWeather: current location weather as CurrentWeather model takes contains temperature, cloud info and feels like temperature
    func configure(with model: SelectedLocation?, currentWeather : CurrentWeather?) {
        guard let model  = model,
              let currentWeather = currentWeather
        else{
                self.locationLabel.text = "Please enter valid CityName or Zipcode"
                return
        }
        
        
        self.locationLabel.text = model.name
        self.dateTimeLabel.text = getTimeForDateString(model.localtime ?? "")
        
        self.iconImageView.contentMode = .scaleAspectFit
        
        let cloudValue = currentWeather.cloud ?? 0
        
        if cloudValue >= 50 {
            self.iconImageView.image = UIImage(named: "rain")
        }else{
            self.iconImageView.image = UIImage(named: "clear")
        }
        
        if let temp = currentWeather.temp_c{
            self.tempLabel.text = getFormattedTempString(temp)
        }else{
            self.tempLabel.text = "-"
        }
        
        
        
        if let feelsLiketemp = currentWeather.feelslike_c{
            self.feelsLikeLabel.text = "Feels like \(getFormattedTempString(feelsLiketemp))"
        }else{
            self.feelsLikeLabel.text = "-"
        }
        
    }

    /// This method takes temparature in double format and return with unit in string format
    /// It uses Measurement to format temperature into valid unit string
    /// - Parameter temp: Temperature in double
    /// - Returns: valid string with unit (degree celcius)

    private func getFormattedTempString(_ temp : Double) -> String{
        let measurement = Measurement(value: temp, unit: UnitTemperature.celsius)
        
        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.unitStyle = .short
        measurementFormatter.numberFormatter.maximumFractionDigits = 0
        measurementFormatter.unitOptions = .temperatureWithoutUnit
        
        return measurementFormatter.string(from: measurement)
    }
    
    /// Takes date string and returns format date string with day, date and time
    /// using DateFormatter
    ///
    /// - Parameter dateString: date string
    /// - Returns: formatted date string with day, date and time
    private func getTimeForDateString(_ dateString: String) -> String {
        let format = DateFormatter()
        format.dateFormat = "YYYY-mm-dd hh:mm"
        let date = format.date(from: dateString)
        format.dateStyle = .full
        
        guard let validdate = date
            else{ return ""}
        
        return format.string(from: validdate)
    }

    
}
