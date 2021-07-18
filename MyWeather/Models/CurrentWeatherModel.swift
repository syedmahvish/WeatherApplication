import Foundation

struct CurrentWeather: Codable {
    let temp_c : Double?
    let temp_f : Double?
    let cloud : Int?
    let wind_mph : Double?
    let wind_kph : Double?
    let feelslike_c : Double?
}
