//
//  String+CodeGen.swift
//  VectorIOCodeGen
//
//  Created by David Beck on 6/18/18.
//

import Foundation


extension String {
    func leftPad(_ character: Character = "\t", count: Int = 1) -> String {
        return self
            .components(separatedBy: .newlines)
            .map({ String(repeating: character, count: count) + $0 })
            .joined(separator: "\n")
    }
}
