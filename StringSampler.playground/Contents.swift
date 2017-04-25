//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let hexString = "1F61D"
var hex: UInt32 = 0x0
let scanner = Scanner(string: hexString)
scanner.scanHexInt32(&hex)

if let scalar = UnicodeScalar(hex) {
    let string = String(describing: scalar)
    print(string)
}
