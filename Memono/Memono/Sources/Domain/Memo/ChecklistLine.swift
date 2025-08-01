//
//  ChecklistLine.swift
//  Memono
//
//  Created by 조호근 on 8/1/25.
//

import Foundation

struct ChecklistLine: Identifiable, Equatable {
    let id: UUID
    var text: String
    var isChecked: Bool
}
