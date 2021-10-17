//
//  TruthTableView.swift
//  Truthy
//
//  Created by abmfy on 2021/10/17.
//

import SwiftUI

struct TruthTableView: View {
    var nameList: [Character]
    var columns: [Column]
    
    var body: some View {
        ScrollView(.horizontal.union(.vertical)) {
            HStack {
                Divider()
                ForEach(columns, id: \.title) { column in
                    VStack {
                        Text(column.title)
                            .font(.headline.monospaced())
                            .foregroundColor(.accentColor)
                        ForEach(column.truthValue, id: \.self) { truth in
                            Text(truth ? "T" : "F")
                        }
                    }
                    Divider()
                }
            }
            .padding()
            .font(.body.monospaced())
        }
    }
}

struct TruthTableView_Previews: PreviewProvider {
    static var previews: some View {
        TruthTableView(nameList: ["P", "Q", "R"], columns: [Column(title: "Hi", expression: .proposition("Q"), truthValue: [true, true, false, true])])
    }
}
