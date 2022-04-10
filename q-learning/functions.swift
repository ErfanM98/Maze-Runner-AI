
import Foundation

func printUtilities(_ action : Action) -> Void {
    
    for i in (0..<height) {
        for j in 0..<width{
            if(states[i*width + j] == nil){
                print("****", separator: " ", terminator: "\t")
                continue
            }
        
            print(String(format: "%.3f",
                         
                         Q[states[i*width + j]!]![action]!
                
            
            ), separator: " ", terminator: "\t")
            
        }
        print()
    }
}
func printPolicies() -> Void {
    for j in 0..<width{
        print(j, separator: " ", terminator: " \t\t")
    }
    print()
    for i in (0..<height) {
        
        for j in 0..<width{
            if(states[i*width + j] == nil){
                print("****", separator: " ", terminator: "\t")
                continue
            }
            if(goals.contains(i*width + j)){
                print("GOAL", separator: " ", terminator: "\t")
                continue
            }
            print((pi(s: states[i*width + j]!)), separator: " ", terminator: "\t")
            
        }
        print(i)
    }
    for j in 0..<width{
        print(j, separator: " ", terminator: " \t\t")
    }
    print()
}

func isTerminal(_ s : State) -> Bool{
    return goals.contains(s.getX() + (width*s.getY()))
}
func Actions(s : State) -> [Action] {
    return s.getValidMoves();
}
func getNextState(s : State , a : Action) -> State {
    if(!s.getValidMoves().contains(a)){
        return s
    }
    let index = s.getY()*width + s.getX()
    switch a {
    case Action._up_:
        //print("upper is \(index - width)")
        return states[index - width]!
    //return states[index - 1]!
    case Action.down:
        //print("lower is \(index + width)")
        return states[index + width]!
    //return states[index + 1]!
    case Action.right:
        //print("right is \(index + 1)")
        return states[index + 1]!
    //return states[index + width]!
    case Action._left:
        return states[index - 1]!
        //return states[index - width]!
    }
}

func pi(s : State) -> Action {
    return policy[s]!
}

func makePolicy() -> Void {
    for s in states{
        if(s == nil){
            continue
        }
        var M : Double = -Double.infinity
        var tmp : Double = -1000.0
        var action : Action? = nil
        for a in /*Action.allCases */Actions(s: s!) {

            tmp =  Q[s!]![a]!;
            if(tmp > M){
                M = tmp
                action = a
            }
        }
        policy[s!] = action!
    }
}
