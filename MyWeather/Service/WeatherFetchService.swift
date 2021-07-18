import Foundation


/***
 This class fetch weather forecast for given cityname or zipcode
 */
class WeatherFetchService {
    
    private let API_KEY = "08ee85dd3bb64105bec195503212906"
    
    private var hourlyModels = [HourlyWeatherEntry]()
    private var locationModels : SelectedLocation?
    private var currentWeatherModels : CurrentWeather?
    
    typealias CompletionHandler = (_ hourlyModels : [HourlyWeatherEntry]?,
                                    _ locationModels : SelectedLocation?,
                                    _ currentWeatherModels : CurrentWeather?) -> Void
    
    /// This method takes city name or zipcode as query ,
    /// makes API call for given query
    ///
    /// - Parameters:
    ///   - query: which can be city name or zipcode
    ///   - completionHandler: returns tuple of hourly data, current location description and weather condition
    
    func requestWeatherForLocation(query : String, completionHandler : @escaping CompletionHandler) {
        
        let urlOriginalString = "https://api.weatherapi.com/v1/forecast.json?key=\(API_KEY)&q=\(query)"
        let urlString = urlOriginalString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let validurlString = urlString
            else{
                return
        }
        
        let url = URL(string:validurlString)
        
        guard let validUrl = url
            else{
                print("Invalid Url")
                return
        }
        
        URLSession.shared.dataTask(with: validUrl, completionHandler: { data, response, error in
            
            // Validation
            guard let data = data, error == nil else {
                print("Something went wrong")
                return
            }
            
            // Convert data to models/some object
            
            var json: WeatherResponse?
            do {
                json = try JSONDecoder().decode(WeatherResponse.self, from: data)
            }
            catch {
                completionHandler(nil,nil,nil)
                print("Found Error: \(error)")
            }
            
            guard let result = json else {
                completionHandler(nil,nil,nil)
                return
            }
            
            self.locationModels = result.location
            self.currentWeatherModels = result.current
            
            let forecastDay = result.forecast.forecastday
            let forecastHours = forecastDay[0].hour
            self.hourlyModels = forecastHours
            
            completionHandler(self.hourlyModels, self.locationModels, self.currentWeatherModels)

        }).resume()
    }
    
}
