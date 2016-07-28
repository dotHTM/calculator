//: Playground - noun: a place where people can play

import Foundation
public extension String {
    public func replacing(range: CountableClosedRange<Int>, with replacementString: String) -> String {
        let start = characters.index(characters.startIndex, offsetBy: range.lowerBound)
        let end   = characters.index(start, offsetBy: range.count)
        return self.replacingCharacters(in: start ..< end, with: replacementString)
    }
}
var test = "Forty Two"



for index in 1 ..< test.characters.count {
    print(
        test.replacing(
            range: 1...index, with: "XXXX"
        )
    )
}


// See also:
infix operator ..+ {}
public func ..+ <Bound: Strideable>(lhs: Bound, rhs: Bound.Stride) -> CountableClosedRange<Bound> {
    return lhs ... lhs.advanced(by: rhs)
}
test.replacing(range: 1 ..+ 2, with: "XXXX")
