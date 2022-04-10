import Foundation

enum Action : UInt8 , CaseIterable  {
    case _up_ = 0;
    case down = 255; //  ~0
    case right = 1;
    case _left = 254; // ~1
}
class State: CustomStringConvertible , Hashable{
    open var index = -1
    private var validMoves = [Action]()
    private var x : Int
    private var y : Int
    init(x : Int , y :Int  , validMoves : [Action] ) {
        self.validMoves = validMoves;
        self.x = x;
        self.y = y;
        self.index = y*width + x
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
