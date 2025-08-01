//
//  Memo.swift
//  Memono
//
//  Created by 조호근 on 8/1/25.
//

import Foundation

struct Memo: Identifiable, Equatable {
    let id: UUID
    var lines: [MemoLine]
    var createdAt: Date
    var updatedAt: Date
}

enum MemoLine: Identifiable, Equatable {
    case text(TextLine)
    case checklist(ChecklistLine)
    
    var id: UUID {
        switch self {
        case .text(let line): return line.id
        case .checklist(let line): return line.id
        }
    }
}
