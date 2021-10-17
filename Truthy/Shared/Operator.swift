//
//  Operator.swift
//  Truthy
//
//  Created by abmfy on 2021/10/16.
//

import Foundation

// ∧⋀↔→∨⋁ ⊽
// ⇔⇒
// Proves ⊢
// TODO: case xor = "⊽"
// TODO: case nor = "↓", nand = "↑"

protocol Operator {
    var precedence: Int { get }
}

enum Parenthesis: Character, Operator {
    case leftParenthesis = "(", rightParenthesis = ")"
    
    var precedence: Int {
        switch self {
        case .leftParenthesis:
            return .min
        case .rightParenthesis:
            return .min + 1
        }
    }
    
    func eqauls(_ rhs: Operator) -> Bool {
        if let r = rhs as? Parenthesis {
            return rawValue == r.rawValue
        }
        else {
            return false
        }
    }
}

enum LogicalUnaryOperator: Character, Operator, Hashable {
    case not = "¬"
    
    var precedence: Int {
        switch self {
        case .not:
            return 4
        }
    }
    
    func operate(_ operand: Bool) -> Bool {
        switch self {
        case .not:
            return !operand
        }
    }
    
    static func == (lhs: LogicalUnaryOperator, rhs: LogicalUnaryOperator) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

enum LogicalBinaryOperator: Character, Operator, Hashable {
    case or = "∨", and = "∧"
    case implicate = "→", doubleImplicate = "↔"
    
    var precedence: Int {
        switch self {
        case .and:
            return 3
        case .or:
            return 2
        case .implicate:
            return 1
        case .doubleImplicate:
            return 0
        }
    }
    
    func operate(_ operand1: Bool, _ operand2: Bool) -> Bool {
        switch self {
        case .and:
            return operand1 && operand2
        case .or:
            return operand1 || operand2
        case .implicate:
            return !operand1 || operand2
        case .doubleImplicate:
            return operand1 == operand2
        }
    }
    
    static func == (lhs: LogicalBinaryOperator, rhs: LogicalBinaryOperator) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}
