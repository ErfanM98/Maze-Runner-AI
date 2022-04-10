//
//  main.swift
//  AI - Q-Learning
//
//  Created by Erfan on 3/16/20.
//  Copyright © 2020 Erfan, Farid. All rights reserved.
//

import Foundation

var Q = [ State : [Action : Double]]()
var N = [ State : [Action : Int]]()


var map = [Action._left : 0.0 , Action._up_ : 0.0 , Action.down : 0, Action.right : 0]
var freqMap = [Action._left : 0 , Action._up_ : 0 , Action.down : 0, Action.right : 0]

var height = 0
var width = 0
var policy : [State : Action] = [:]

var states: Array<State?> = []
var blocks: Array<Int> = []
var goals:  Array<Int> = []
func Reward(s : State ) -> Double {
    if(goals.contains(s.getY()*width + s.getX())){
        return 10
    }
    
    return -0.2
}
func f(_ u : Double , _ n: Int) -> Double {
    if(n < 1){
        return 10.0
    }
    return u
}
func qLearning(_ startState : State) -> Void {
    print("s is \(startState)")

    let alpha : Double = 0.0 // Learning Rate
    let gamma : Double = 1.0 // Discount Factor
    var delta = Double.infinity
    let error = 0.001
    while (delta > error) {

        
        var s = startState
        var iterations = 0
        while(
            !isTerminal(s)
            //iterations < 800
            ){
            
            var a : Action? = nil
            var maxTmp : Double = -Double.infinity
            // pick best action :
            for action in Actions(s: s){
                var next = getNextState(s: s, a: action)
                if(Q[next]![action]! - Double(N[s]![action]!)*0.05 > maxTmp){
                    maxTmp = Q[next]![action]! - Double(N[s]![action]!)*0.05
                    a = action
                }
            }
            let s_prime = getNextState(s: s, a: a!)
            let r = Reward(s: s_prime) // - Double(N[s]![a]!)
                
            N[s]![a!] = N[s]![a!]! + 1
            let n = N[s]![a!]
            let qs = Q[s]
            Q[s]![a!] =
                 r + (gamma*Q[s_prime]!.values.max()!)
                
            print("going to \(s) q \(Q[s]![a!]!)")
            
            s = s_prime
            
            iterations += 1
        }
        
        break
        
    }
    printPolicies()
    print("############  up ############")
    printUtilities(Action._up_)
    print("###########  down ############")
    printUtilities(Action.down)
    print("############ right ############")
    printUtilities(Action.right)
    print("############ left ############")
    printUtilities(Action._left)
}

let path = "/Users/erfan/Downloads/HW2_AI2/HW2_AI2/sample_5.txt"
//let path = "/Users/erfan/Downloads/HW2_AI2/HW2_AI2/sample_25.txt"

var contents : String? = try String(contentsOfFile: path, encoding: .utf8)

var lines : [String.SubSequence]? = contents!.replacingOccurrences(of: "\r\n", with:"\n" )
    
    .replacingOccurrences(of: "0 0 1 0\n1 0 0 0", with: "0 0 0 0\n0 0 0 0")
    
    .split(separator: "\n")
print("line = \(lines![0])")
width = Int(lines![0].split(separator: " ")[0])!
height = Int(lines![0].split(separator: " ")[1])!

states = Array(repeating: nil, count: width*height)


var index = 0
var stateIndex = 0
print("width = \(width), height = \(height)")
lines?.removeFirst();
var lastLine = lines?.last!.split(separator: " ")
let AgentPos = Int(lastLine![0])! - 1
lastLine?.removeFirst()
// now last line only contains positions of the goal state\
// add the goals
for item in lastLine!{
    //utilities[Int(item)! - 1] = 1.0
    index = Int(item)! - 1
    stateIndex = (index%width)*width + (index / width)
    goals.append(stateIndex)
    
}

lines?.removeLast()
var line : [Substring?]? = nil
index = 0
for i in lines!{
    //print(i)
    stateIndex = index
    stateIndex = (index%width)*width + (index / width)
    var validMoves = [Action]()
    //var freqMap : Dictionary<Action , Int> = [:]
    line = i.split(separator: " ")
    if(line![0] == "1"){
        freqMap[Action._up_] = 0
        validMoves.append(Action._up_)
        //validMoves.append(Action.left)
    }
    if(line![1] == "1"){
        freqMap[Action.right] = 0
        validMoves.append(Action.right)
        //validMoves.append(Action.down)
    }
    if(line![2]! == "1"){
        freqMap[Action.down] = 0
        validMoves.append(Action.down)
        //validMoves.append(Action.right)
    }
    if(line![3] == "1"){
        freqMap[Action._left] = 0
        validMoves.append(Action._left)
        //validMoves.append(Action.up)
    }
    if(validMoves.count == 0){
        states[stateIndex] = nil
        blocks.append(stateIndex)
        //utilities[index] = -1000
        index += 1
        continue
    }
    //utilities[index] = Double(index)
    let s = State(x: Int(stateIndex%width) , y: Int(stateIndex / width) , validMoves : validMoves)
    states[stateIndex] = s
    Q[s] = map
    N[s] = freqMap;
    index += 1
    //print("\(i) -> valid moves \(validMoves)")
    policy[states[stateIndex]!] = s.getValidMoves()[0]
}
lines = nil

qLearning(states[AgentPos]!)

var x = 0;
var y = 0;

