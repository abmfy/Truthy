//
//  Operand.swift
//  Truthy
//
//  Created by abmfy on 2021/10/16.
//

import Foundation

indirect enum Expression: Hashable {
    case proposition(Character)
    case unaryExpression(LogicalUnaryOperator, Expression)
    case binaryExpression(LogicalBinaryOperator, Expression, Expression)
    
    var description: String {
        switch self {
        case let .proposition(name):
            return String(name)
        case let .unaryExpression(op, expression):
            switch expression {
            case .proposition, .unaryExpression:
                return String(op.rawValue) + expression.description
            case .binaryExpression(_, _, _):
                return String(op.rawValue) + "(" + expression.description + ")"
            }
        case let .binaryExpression(op, expression1, expression2):
            var string = ""
            switch expression1 {
            case .proposition, .unaryExpression:
                string += expression1.description
            case .binaryExpression:
                string += "(" + expression1.description + ")"
            }
            string += String(op.rawValue)
            switch expression2 {
            case .proposition, .unaryExpression:
                string += expression2.description
            case .binaryExpression:
                string += "(" + expression2.description + ")"
            }
            return string
        }
    }
    
    var value: Bool {
        if TruthTable.id[self] == nil {
            switch self {
            case let .unaryExpression(_, expression):
                let _ = expression.value
            case let .binaryExpression(_, expression1, expression2):
                let _ = expression1.value
                _ = expression2.value
            default:
                break
            }
            TruthTable.id[self] = TruthTable.columns.count
            TruthTable.columns.append(.init(title: description,
                                            expression: self, truthValue: []))
        }
        
        switch self {
        case let .proposition(name):
            return TruthTable.assignment[name] ?? false
        case let .unaryExpression(op, expression):
            return op.operate(expression.value);
        case let .binaryExpression(op, expression1, expression2):
            return op.operate(expression1.value, expression2.value)
        }
    }
}
