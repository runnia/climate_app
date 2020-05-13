
import UIKit

class WeatherDataModel {

    //Declare your model variables here
    var temperature : Int = 0
    var condition : Int = 0
    var city : String = ""
    var weatherIconName : String = ""
    var firstTemp : Int = 0
    var secondTemp : Int = 0
    var thirdTemp : Int = 0
    var firstCondition : Int = 0
    var secondCondition : Int = 0
    var thirdCondition : Int = 0
    var firstWeatherIconName : String = ""
    var secondWeatherIconName : String = ""
    var thirdWeatherIconName : String = ""

    // функция возвращает название картинки с погодой
    func updateWeatherIcon(condition: Int) -> String {
        
    switch (condition) {
    
        case 0...300 :
            return "storm"
        
        case 301...500 :
            return "rain"
        
        case 501...600 :
            return "heavyrain"
        
        case 601...700 :
            return "rainsnow"
        
        case 701...771 :
            return "windy"
        
        case 772...799 :
            return "storm"
        
        case 800 :
            return "sunny"
        
        case 801...804 :
            return "cloudy1"
        
        case 900...903, 905...1000  :
            return "cloud"
        
        case 903 :
            return "snow"
        
        case 904 :
            return "sunny"
        
        default :
            return "dontknow"
        }

    }
}
