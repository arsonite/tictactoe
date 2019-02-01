import UIKit

class SecondViewController: UIViewController {
    @IBOutlet weak var reset: UIButton!
    @IBOutlet weak var nameDisplay: UILabel!
    
    var names: [String]!
    var i: Int! = 0
    var placeButtonsLocked: Bool!
    var restartButtonLocked: Bool!
    var gameover: Bool!
    
    var brain: TTTBrain!
    
    var timer: Timer! = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        brain = TTTBrain(playerNames: names)
        
        self.view.backgroundColor = UIColor.gray
        resetButtons()
        placeButtonsLocked = true
        restartButtonLocked = true
        gameover = false
        reset.setTitle("Determining who begins...", for: UIControl.State.normal)
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(roll), userInfo: nil, repeats: true)
    }
    
    /* Simulates a chance roll determining who begins */
    @objc func roll() {
        if i % 2 == 0 {
            nameDisplay.text = brain.p1.name
        } else {
            nameDisplay.text = brain.p2.name
        }
        i = i + 1
        
        if i != 20 {
            return
        }
        
        if brain.aiActivated {
            brain.current = brain.p1
        } else {
            if Bool.random() {
                brain.current = brain.p1
            } else {
                brain.current = brain.p2
            }
        }
        nameDisplay.text = brain.current.name
        reset.setTitle("It's your turn", for: UIControl.State.normal)
        self.view.backgroundColor = brain.current.color
        placeButtonsLocked = false
        timer.invalidate()
    }
    
    func resetButtons() {
        for case let button as UIButton in self.view.subviews {
            button.setTitle("", for: UIControl.State.normal)
        }
    }
    
    /* Checks the three win conditions and determines a winner or a draw */
    func checkWinConditions() {
        brain.checkWinConditions()
        
        if brain.winner == nil && brain.current.marked.count > 4 {
            nameDisplay.text = "Draw!"
            self.view.backgroundColor = UIColor.gray
        } else if brain.winner != nil {
            nameDisplay.text = "\(brain.winner.name!) won!"
            self.view.backgroundColor = brain.winner.color
        } else if brain.winner == nil {
            return
        }
        restartButtonLocked = false
        gameover = true
        reset.setTitle("> Press here to restart <", for: UIControl.State.normal)
        placeButtonsLocked = true
 }
    
    /* Restars the game and empties/sets value on default */
    func restart() {
        resetButtons()
        brain.p1.marked = []
        brain.p2.marked = []
        if brain.aiActivated {
            brain.current = brain.p1
        } else {
            if brain.winner != nil {
                brain.winner.marked = []
                brain.current = brain.winner
                brain.winner = nil
            } else {
                if Bool.random() {
                    brain.current = brain.p1
                } else {
                    brain.current = brain.p2
                }
            }
        }
        self.view.backgroundColor = brain.current.color
        nameDisplay.text = brain.current.name
        gameover = false
        reset.setTitle("It's your turn", for: UIControl.State.normal)
        restartButtonLocked = true
        placeButtonsLocked = false
    }
    
    @IBAction func placeMarker(_ sender: UIButton!) {
        if placeButtonsLocked || sender.currentTitle != "" { return }
        
        if brain.aiActivated {
            placeMarkerWithAI(sender)
            return
        }
        
        brain.current.marked.append(sender.tag)
        
        sender.setTitle(brain.current.symbol, for: UIControl.State.normal)
        sender.setTitleColor(brain.current.color, for: UIControl.State.normal)
        
        checkWinConditions()
        if(gameover) { return }
        
        switchPlayer()
    }
    
    func placeMarkerWithAI(_ sender: UIButton!) {
        var marker: Int!
        
        marker = sender.tag
        
        brain.current.marked.append(marker)
        sender.setTitle(brain.current.symbol, for: UIControl.State.normal)
        sender.setTitleColor(brain.current.color, for: UIControl.State.normal)

        checkWinConditions()
        if(gameover) { return }

        switchPlayer()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
            marker = self.brain.makeMove()
            self.brain.current.marked.append(marker)
            if let button = self.view.viewWithTag(marker) as? UIButton
            {
                button.setTitle(self.brain.current.symbol, for: UIControl.State.normal)
                button.setTitleColor(self.brain.current.color, for: UIControl.State.normal)
            }
            
            self.checkWinConditions()
            if(self.gameover) { return }
            
            self.switchPlayer()
        }
    }
    
    func switchPlayer() {
        if brain.current.name == brain.p1.name {
            brain.p1.marked = brain.current.marked
            brain.current = brain.p2
        } else {
            brain.p2.marked = brain.current.marked
            brain.current = brain.p1
        }
        nameDisplay.text = brain.current.name
        self.view.backgroundColor = brain.current.color
    }
    
    @IBAction func resetGame(_ sender: Any) {
        if(restartButtonLocked) { return }
        restart()
    }
}
