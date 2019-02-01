import UIKit

struct Player {
    var name: String!
    var color: UIColor!
    var symbol: String!
    var marked: [Int]
}

class TTTBrain {
    var p1: Player!
    var p2: Player!
    var winner: Player!
    var current: Player!
    
    var aiActivated: Bool!
    
    let green: UIColor! = UIColor.init(red: 0.29, green: 0.84, blue: 0.38, alpha: 1.0)
    let red: UIColor! = UIColor.init(red: 0.98, green: 0.28, blue: 0.29, alpha: 1.0)
    let orange: UIColor! = UIColor.init(red: 1.0, green: 0.53, blue: 0, alpha: 1.0)
    
    init(playerNames names: [String]) {
        p1 = Player(name: names[0], color: red, symbol: "O", marked: [Int]())
        if(names[1] == "aicode00") {
            p2 = Player(name: "A.I.", color: green, symbol: "X", marked: [Int]())
            aiActivated = true
          return
        }
        p2 = Player(name: names[1], color: orange, symbol: "X", marked: [Int]())
        aiActivated = false
    }
    
    /* Checks win-condition of three in a column */
    func col(arr: [Int], i: Int!) -> Bool! {
        return arr.contains(i) && arr.contains(3 + i) && arr.contains(6 + i);
    }
    
    /* Checks win-condition of three in a row */
    func row(arr: [Int], i: Int!) -> Bool! {
        return arr.contains(i * 3) && arr.contains(i * 3 + 1) && arr.contains(i * 3 + 2);
    }
    
    /* Checks win-condition of three in a diagonal line */
    func diag(arr: [Int]) -> Bool! {
        return arr.contains(0) && arr.contains(4) && arr.contains(8) ||
            arr.contains(2) && arr.contains(4) && arr.contains(6);
    }
    
    /* Checks the three win conditions and determines a winner or a draw */
    func hasWon() -> Bool {
        var i: Int! = 0
        while i <= 2 {
            if col(arr: current.marked, i: i) {
                return true;
            } else if row(arr: current.marked, i: i) {
                return true
            }
            i = i + 1
        }
        return diag(arr: current.marked);
    }
    
    func checkWinConditions() {
        if hasWon() {
            winner = current
            return
        }
        winner = nil
    }
    
    func makeMove() -> Int {
        let board: [Int]! = p1.marked + p2.marked
        var rnd: Int = Int.random(in: 0 ... 8)
        while board.contains(rnd) {
            rnd = Int.random(in: 0 ... 8)
        }
        return rnd
    }
}
