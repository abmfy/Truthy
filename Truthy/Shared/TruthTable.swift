//
//  TruthTable.swift
//  Truthy
//
//  Created by abmfy on 2021/10/16.
//

import Foundation

struct Column {
    var title: String
    var expression: Expression
    var truthValue: [Bool]
}

enum TruthTable {
    static var assignment: [Character: Bool] = [:]
    static var nameList: [Character] = ["P", "Q", "R", "S", "T"]
    static var nameListS: [Character] = nameList
    
    static var columns: [Column] = []
    static var id: [Expression: Int] = [:]
    static var expression: Expression!
    
    static func assign(_ n: Int) {
        if n == nameListS.count {
            for i in 0 ..< columns.count {
                columns[i].truthValue.append(columns[i].expression.value)
            }
            return
        }
        assignment[nameListS[n]] = false
        assign(n + 1)
        assignment[nameListS[n]] = true
        assign(n + 1)
    }
    
    static func generate(string: String) throws {
        if string.isEmpty {
            return
        }
        columns = []
        id = [:]
        nameListS = []
        assignment = [:]
        do {
            try expression = InversePolishExpression.transform(expression: string)
        } catch {
            throw error
        }
        for c in nameList {
            if assignment[c] != nil {
                nameListS.append(c)
            }
        }
        assignment = [:]
        let _ = expression.value
        assign(0);
        var temp: [Column] = []
        for column in columns {
            if column.title.count == 1 {
                temp.append(column)
            }
        }
        for column in columns {
            if column.title.count != 1 {
                temp.append(column)
            }
        }
        columns = temp
    }
}
