import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var player1: UITextField!
    @IBOutlet weak var player2: UITextField!
    @IBOutlet weak var player2Label: UILabel!
    @IBOutlet weak var errDisplay: UILabel!
    
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var aiLabel: UILabel!
    
    let orange: UIColor! = UIColor.init(red: 1.0, green: 0.53, blue: 0, alpha: 1.0)
    let green: UIColor! = UIColor.init(red: 0.29, green: 0.84, blue: 0.38, alpha: 1.0)
    let gray: UIColor! = UIColor.gray
    
    let err: String! = "You didn't enter a name for Player "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Necessary snippet to ensure textFieldShouldReturn() works */
        self.player1.delegate = self
        self.player2.delegate = self
        
        /* Parses the paper texture from the assets folder and
         * sets it as the background of the view
         */
        let bg = UIImage(named: "paper_tex")
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = bg
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
        
        switcher.setOn(false, animated: true)
        aiLabel.textColor = gray
    }
    
    /* Function to close keyboard when return key is pressed */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    /* Sets the statusbar to light-theme */
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /* This function prepares for a segue and assigns the values
     * of the textfields to attributes defined in SecondViewController
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller2 = segue.destination as! SecondViewController
        controller2.names = [player1.text!, player2.text!]
    }
    
    /* Resets the error-display when textfield is clicked */
    @IBAction func textfieldClicked(_ sender: Any) {
        errDisplay.text = ""
    }
    
    /* Method to perform a segue and switch to SecondViewController */
    @IBAction func switchPage(_ sender: Any) {
        if (player1.text?.isEmpty)! {
            errDisplay.text = err + "One!"
            return;
        }
        
        if(!switcher.isOn) {
            if (player1.text?.isEmpty)! && (player2.text?.isEmpty)! {
                errDisplay.text = err + "One and Two!"
                return
            } else if (player2.text?.isEmpty)! {
                errDisplay.text = err + "Two!"
                return
            }
        } else {
            player2.text = "aicode00"
        }
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    @IBAction func switched(_ sender: Any) {
        if switcher.isOn {
            aiLabel.textColor = green
            player2Label.textColor = gray
            player2.textColor = gray
            player2.backgroundColor = gray
            player2.isUserInteractionEnabled = false
            return
        }
        aiLabel.textColor = gray
        player2Label.textColor = orange
        player2.textColor = orange
        player2.backgroundColor = UIColor.white
        player2.isUserInteractionEnabled = true
    }
}
