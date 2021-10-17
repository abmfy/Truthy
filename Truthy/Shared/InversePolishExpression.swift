//
//  InversePolishExpression.swift
//  Truthy
//
//  Created by abmfy on 2021/10/16.
//

import Foundation

enum AnalysisError: Error {
    case operandNumberError(Character, Int)
    case propositionalVariableNotDefined(Character)
    case extraneousExpression
    case parenthesisMatchError
    case noExpression
}

enum InversePolishExpression {
    static func transform(expression: String) throws -> Expression {
        var operatorStack: [Operator] = []
        var expressionStack: [Expression] = []
        
        func popStack() throws {
            let top = operatorStack.popLast()
            switch top {
            case let x as LogicalUnaryOperator:
                if (expressionStack.count < 1) {
                    throw AnalysisError.operandNumberError(x.rawValue, 1)
                }
                let num = expressionStack.popLast()!
                expressionStack.append(.unaryExpression(x, num))
            case let x as LogicalBinaryOperator:
                let num1, num2: Expression
                if (expressionStack.count < 2) {
                    throw AnalysisError.operandNumberError(x.rawValue, 2)
                }
                num2 = expressionStack.popLast()!
                num1 = expressionStack.popLast()!
                expressionStack.append(.binaryExpression(x, num1, num2))
            case let x as Parenthesis where x == .leftParenthesis:
                throw AnalysisError.parenthesisMatchError
            default:
                break
            }
        }
        
        for character in expression {
            let op: Operator! = LogicalUnaryOperator(rawValue: character) ??
                 LogicalBinaryOperator(rawValue: character) ??
                 Parenthesis(rawValue: character)
            if op == nil {
                if !TruthTable.nameList.contains(character) {
                    throw AnalysisError.propositionalVariableNotDefined(character)
                }
                TruthTable.assignment[character] = true
                expressionStack.append(.proposition(character))
                continue
            }
            
            if op as? Parenthesis == .leftParenthesis {
                operatorStack.append(op)
                continue
            }
            
            while !operatorStack.isEmpty && operatorStack.last!.precedence > op.precedence {
                do {
                    try popStack()
                } catch {
                    throw error
                }
            }
            
            if op as? Parenthesis == .rightParenthesis {
                if operatorStack.isEmpty {
                    throw AnalysisError.parenthesisMatchError
                } else {
                    operatorStack.removeLast()
                }
            } else {
                operatorStack.append(op)
            }
        }
        
        while !operatorStack.isEmpty {
            do {
                try popStack()
            } catch {
                throw error
            }
        }
        
        if expressionStack.count > 1 {
            throw AnalysisError.extraneousExpression
        } else if expressionStack.isEmpty {
            throw AnalysisError.noExpression
        }
        
        return expressionStack.first!
    }
}
