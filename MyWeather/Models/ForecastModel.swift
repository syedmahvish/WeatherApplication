import Foundation

struct Forecast : Codable{
    let forecastday : [HourlyWeather]
}

struct HourlyWeather: Codable {
    let hour: [HourlyWeatherEntry]
}

struct HourlyWeatherEntry: Codable {
    let time : String?
    let temp_c : Double?
    let temp_f : Double?
    let condition : Condition
    let will_it_rain : Int?
}

