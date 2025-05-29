//
//  to_do_listApp.swift
//  to do list
//
//  Created by Hugo Blanchard on 08/03/2025.
//

import SwiftUI
import SwiftData

@main
struct to_do_listApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ToDo.self)
    }
}

@Model class ToDo {
    var title: String
    var isCompleted: Bool
    
    init(title: String, isCompleted: Bool) {
        self.title = title
        self.isCompleted = isCompleted
    }
}

extension Bool: @retroactive Comparable {
    public static func <(lhs: Self, rhs: Self) -> Bool {
        !lhs && rhs
    }
}
