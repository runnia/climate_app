
import UIKit

protocol ChangeCityDelegate {
    func userEnteredNewCityName(city : String)
}

class SecondViewController: UIViewController {
    
    var delegate : ChangeCityDelegate?
    
    @IBAction func changeCityPressed(_ sender: Any) {
        let cityName = textField.text!
        delegate?.userEnteredNewCityName(city: cityName)
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

}
