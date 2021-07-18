import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {

    static let identifier = "WeatherCollectionViewCell"

    static func nib() -> UINib {
        return UINib(nibName: "WeatherCollectionViewCell",
                     bundle: nil)
    }

    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    /// This method configure cell for hourly weather updates
    ///
    /// - Parameter model: hourly data model which is used to popluate UI for hourly data like temp, time and raining or not
    func configure(with model: HourlyWeatherEntry) {
        if let temp = model.temp_c{
            self.tempLabel.text = getFormattedTempString(temp)
        }else{
            self.tempLabel.text = "-"
        }
        
        self.timeLabel.text = getTimeForDateString(model.time ?? "")
        
        self.iconImageView.contentMode = .scaleAspectFit
        
        if model.will_it_rain == 1 {
            self.iconImageView.image = UIImage(named: "rain")
        }else {
            self.iconImageView.image = UIImage(named: "clear")
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
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
    
    /// Takes date string and returns format date string with time
    /// using DateFormatter
    ///
    /// - Parameter dateString: date string
    /// - Returns: formatted date string with time only
    private func getTimeForDateString(_ dateString: String) -> String {
        let format = DateFormatter()
        format.dateFormat = "YYYY-mm-dd HH:mm"
        let date = format.date(from: dateString)
        format.dateFormat = "h:mm a"
        
        guard let validdate = date
            else{ return ""}
        
        return format.string(from: validdate)
    }

}
