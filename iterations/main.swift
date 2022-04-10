//
//  main.swift
//  AI - vi - test1
//
//  Created by Erfan on 3/6/20.
//  Copyright © 2020 Erfan. All rights reserved.
//

import Foundation
import Cocoa
///////////
enum Action : UInt8 , CaseIterable  {
    case _up_ = 0;
    case down = 255; //  ~0
    case right = 1;
    case _left = 254; // ~1
}
class State: CustomStringConvertible , Hashable{
    
    private var validMoves = [Action]()
    private var x : Int
    private var y : Int
    init(x : Int , y :Int  , validMoves : [Action] ) {
        self.validMoves = validMoves;
        self.x = x;
        self.y = y;
    }
    public var description : String {
        return "x = \(x) , y = \(y)"
    }
    
    public func getXY() -> (x : Int , y : Int){
        return (self.x , self.y)
    }
    
    public func getX() -> Int{
        return Int(self.x);
    }
    public func getY() -> Int{
        return Int(self.y);
    }
    public func getValidMoves() -> [Action] {
        return validMoves;
    }
    static func == (lhs: State, rhs: State) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}
func Actions(s : State) -> [Action] {
    return s.getValidMoves();
}
var utilities: Array<Double> = []
var height = 0
var width = 0
var policy : [State : Action] = [:]
//var grid : [[State]] = []
var states: Array<State?> = []
var blocks: Array<Int> = []
var goalStates = [Int]()
var goals:  Array<Int> = []
func Reward(s : State) -> Double {
    if(goals.contains(s.getY()*width + s.getX())){
        return 2
    }
    return -0.04
}
func P(s_prime : State , s : State , a : Action) -> Double{
    let p : Double = 0.8
    if(s_prime.getY() - s.getY() == 1 ){
        // action is down
        if(a == Action.down){
            return p;
        }
        if(a == Action._up_){
            return 0;
        }
    }
    else
    if(s_prime.getY() - s.getY() == -1 ){
       // action is up
        if(a == Action._up_){
            return p;
        }
        if(a == Action.down){
            return 0;
        }
    }
    else
    if(s_prime.getX() - s.getX() == 1 ){
        // action is right
        if(a == Action.right){
            return p;
        }
        if(a == Action._left){
            return 0;
        }
    }
    else
    if(s_prime.getX() - s.getX() == -1 ){
        // action is left
        if(a == Action._left){
            return p;
        }
        if(a == Action.right){
            return 0;
        }
    }
    return (1 - p) / 2
}

func utility(s : State) -> Double {
    return utilities[s.getY()*width + s.getX()]
}
/////// Value Iteration ///
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
func makePolicy() -> Void {
    for s in states{
        if(s == nil){
            continue
        }
        var M : Double = -1000.0
        var tmp : Double = -1000.0
        var action : Action? = nil
        for a in /*Action.allCases */Actions(s: s!) {
            let s_prime = getNextState(s: s!, a: a)
            let s_prime_index = s_prime.getY()*width + s_prime.getX()
            tmp = Reward(s: s_prime) + (P(s_prime: s_prime, s: s!, a: a)*utilities[s_prime_index]);
            if(tmp > M){
                M = tmp
                action = a
            }
        }
        
//        for a in Action.allCases {
//            let s_prime = getNextState(s: s!, a: a)
//            let s_prime_index = s_prime.getY()*width + s_prime.getX()
//            tmp = utilities[s_prime_index];
//            if(tmp > M){
//                M = tmp
//                action = a
//            }
//        }
        policy[s!] = action!
    }
}
func pi(s : State) -> Action {
    return policy[s]!
}
//var trasnlateActions : [Action : Action] = [Action._up_ : Action.right , Action.right]
func printUtilities() -> Void {
   
    for i in (0..<height) {
        for j in 0..<width{
            if(states[i*width + j] == nil){
                print("****", separator: " ", terminator: "\t")
                continue
            }
            //print(String(format: "%.2f", utilities[i*width + j]), separator: " ", terminator: "\t")
        
            //print((policy[states[i*width + j]!]!), separator: " ", terminator: "\t")
            print(String(format: "%.3f", utility(s: states[i*width + j]!) ), separator: " ", terminator: "\t")
            //print("\(utility(s: states[i*width + j]!)*10)", separator: " ", terminator: "\t")

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
           //print(String(format: "%.2f", utilities[i*width + j]), separator: " ", terminator: "\t")
            //print((states[i*width + j]!.getValidMoves().count), separator: " ", terminator: "\t")

        }
        print(i)
    }
    for j in 0..<width{
        print(j, separator: " ", terminator: " \t\t")
    }
    print()
}

func valueIteration(discountFactor gamma : Double , maximumError : Double) -> Void {
    let error : Double = (maximumError) * ((1.0 - gamma)) / (gamma)
    print("error = \(error)")
    var delta : Double = 0.0
    var tempArray = utilities
    var index = -1
    var M : Double = -1000
    var iteration = 0
    utilities = tempArray;
    repeat {
        //print("replacing")
        //print(tempArray)
        //utilities = tempArray;
        
        delta = 0;
        // for each state s in S
        for s in states {
            if(s == nil){
                continue
            }
            index = s!.getY()*width + s!.getX()
            
            // calculate max (M)
            M = -1000
            //else{
            for a in /*Action.allCases */Actions(s: s!) {
                let s_prime = getNextState(s: s!, a: a)
                let s_prime_index = s_prime.getY()*width + s_prime.getX()
                M = max(M , P(s_prime: s_prime, s: s!, a: a)*tempArray[s_prime_index])
            }
            //}
            if(goals.contains(index)){
                M = 0
            }
            tempArray[index] = Reward(s: s!) + (gamma*M)
            //tempArray[11] = 1
            //tempArray[7] = -1
            delta = max(delta, abs(tempArray[index] - utilities[index]))
            utilities = tempArray;
        }
        iteration += 1
    } while (delta >= error)
    //iteration < 64
    makePolicy()
    print("value iteration finished with \(iteration) iterations")
}

func policyEvaluation(gamma : Double) -> Void{
//    var delta : Double = 0
//    var tmp : Double = 0
//    var sum : Double = 0
//    var it = 0
//    repeat {
//        delta = 0
//        for s in states{
//            if(s == nil){
//                continue
//            }
//            tmp = utility(s: s!)
//            let index = s!.getY()*width + s!.getX()
//            let s_prime = getNextState(s: s!, a: pi(s: s!))
//            sum = 0
//            for a in Actions(s: s!){
//                sum += (P(s_prime: s_prime, s: s!, a: a)) * (Reward(s: getNextState(s: s!, a: a)))
//            }
//            utilities[index] = Reward(s: s!) + (gamma*sum)
//            delta = max(delta , abs(tmp - utility(s: s!)))
//        }
//        it += 1
//    }while ((delta > 0.001))
    let error : Double = (0.0001) * ((1.0 - gamma)) / (gamma)
    //print("error = \(error)")
    var delta : Double = 0.0
    var iteration = 0
    repeat {
        delta = 0;
        // for each state s in S
        for s in states {
            if(s == nil){
                continue
            }
            let tmp = utility(s: s!)
            var sum = 0.0
            
            for a in Action.allCases {
                let s_prime = getNextState(s: s!, a: a)
                sum += (P(s_prime: s_prime, s: s!, a: pi(s: s!))*(Reward(s: s!) + (gamma*utility(s: s!))))
            }
            
            utilities[s!.getY()*width + s!.getX()] = sum
            
            delta = max(delta, abs(tmp - utility(s: s!)))
        }
        iteration += 1
    } while (delta >= error)
            //iteration <= 10
}


func policyIteration() -> Void {
    var policy_stable = false
    makePolicy()
    while(!policy_stable){
        policy_stable = true
        policyEvaluation(gamma: 0.75)
        for s in states {
            if(s == nil){
                continue
            }
            let temp = pi(s : s!)
            // find arg max :
            var bestSaction = Action.down
            var maxValue = -Double.infinity
            for a in Actions(s: s!){
                let nextStateUtility = utility(s: getNextState(s: s!, a: a))
                if(nextStateUtility > maxValue){
                    bestSaction = a
                    maxValue = nextStateUtility
                }
            }
            policy[s!] = bestSaction
            if(temp != bestSaction){
                policy_stable = false
            }
        }
    }
    
    
}

let path = "sample_5.txt"

var contents : String? = try String(contentsOfFile: path, encoding: .utf8)

var lines : [String.SubSequence]? = contents!.replacingOccurrences(of: "\r\n", with:"\n" )
    
    .replacingOccurrences(of: "0 0 1 0\n1 0 0 0", with: "0 0 0 0\n0 0 0 0")
    
    .split(separator: "\n")
print("line = \(lines![0])")
width = Int(lines![0].split(separator: " ")[0])!
height = Int(lines![0].split(separator: " ")[1])!

states = Array(repeating: nil, count: width*height)
utilities = Array(repeating: 0, count: width*height)

var AgentX : Int = 0;
var AgentY : Int = 0;
var AgentPos : Int = 0;
var index = 0
var stateIndex = 0
print("width = \(width), height = \(height)")
lines?.removeFirst();
var lastLine = lines?.last!.split(separator: " ")
AgentPos = Int(lastLine![0])!
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
    line = i.split(separator: " ")
    if(line![0] == "1"){
        validMoves.append(Action._up_)
        //validMoves.append(Action.left)
    }
    if(line![1] == "1"){
        validMoves.append(Action.right)
        //validMoves.append(Action.down)
    }
    if(line![2]! == "1"){
        validMoves.append(Action.down)
        //validMoves.append(Action.right)
    }
    if(line![3] == "1"){
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
    states[stateIndex] = State(x: Int(stateIndex%width) , y: Int(stateIndex / width) , validMoves : validMoves)
    index += 1
    //print("\(i) -> valid moves \(validMoves)")
    policy[states[stateIndex]!] = Action._up_
}
lines = nil
//valueIteration(discountFactor: 0.85, maximumError: 0.000001)
//policyIteration()
//policyEvaluation()
//printUtilities()
qLearning()
//printPolicies()
var x = 0;
var y = 0;

while true{
    print("enter x: ")
    x = Int(readLine()!)!
    print("enter y: ")
    y = Int(readLine()!)!
    let s = states[y*width+x]!
    print("move is \(pi(s: s))")
}
