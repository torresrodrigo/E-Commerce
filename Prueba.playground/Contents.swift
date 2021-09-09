import UIKit

var putNumber = 7

func generateRandom(forNumber number: Int) -> Int {
    let ramdomNumber = Int.random(in: 2...6)
    return ramdomNumber
}

print("Numero random: \(generateRandom(forNumber: putNumber))")
