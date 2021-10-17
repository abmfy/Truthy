//
//  ContentView.swift
//  Shared
//
//  Created by abmfy on 2021/10/16.
//

import SwiftUI

struct ContentView: View {
    @State var expression: String = ""
    @State var nameList: [Character] = []
    @State var columns: [Column] = []
    @State var analysisError = false
    @State var errorType: AnalysisError!
    @Environment(\.horizontalSizeClass) var horizontal
    
    let buttons = [Parenthesis.leftParenthesis.rawValue,
        LogicalUnaryOperator.not.rawValue,
        LogicalBinaryOperator.and.rawValue, LogicalBinaryOperator.or.rawValue,
        LogicalBinaryOperator.implicate.rawValue,
        LogicalBinaryOperator.doubleImplicate.rawValue,
        Parenthesis.rightParenthesis.rawValue,]
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("", text: $expression)
                    .textFieldStyle(.roundedBorder)
                    
                HStack {
                    ForEach(buttons, id: \.self) { op in
                        Button(String(op)) {
                            expression += String(op)
                        }
                    }
                }
                HStack {
                    Spacer()
                    Spacer()
                    ForEach(TruthTable.nameList, id: \.self) { name in
                        Button(String(name)) {
                            expression += String(name)
                        }
                    }
                    Spacer()
                    Button(role: .destructive, action: {
                        if !expression.isEmpty {
                            expression.removeLast()
                        }
                    }) {
                        Image(systemName: "delete.backward.fill")
                    }
                }
                if horizontal == .compact {
                    TruthTableView(nameList: nameList, columns: columns)
                        .border(Color.blue)
                }
            }
            .buttonStyle(.bordered)
            .padding()
            .navigationTitle("Truthy")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        do {
                            try TruthTable.generate(string: expression)
                        } catch let error as AnalysisError {
                            errorType = error
                            analysisError = true
                            return
                        } catch {
                            fatalError()
                        }
                        nameList = TruthTable.nameList
                        columns = TruthTable.columns
                    }) {
                        Image(systemName: "play.fill")
                    }
                    .alert("Analysis Error", isPresented: $analysisError, actions: {}) {
                        switch errorType {
                        case let .operandNumberError(op, num):
                            Text("Operand count doesn't match. Operator \(String(op)) expects \(num) operand(s).")
                        case let .propositionalVariableNotDefined(op):
                            Text("Propositional variable \(String(op)) not defined.")
                        case .extraneousExpression:
                            Text("Extraneous expression. Please check if two expressions are connected without logical connectives.")
                        case .parenthesisMatchError:
                            Text("Parentheses don't match. Check if there is extra parenthesis.")
                        case .noExpression:
                            Text("There is no expression to be analyzed.")
                        default:
                            Text("")
                        }
                    }
                }
            }
            TruthTableView(nameList: nameList, columns: columns)
        }
        .font(.body.monospaced())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
