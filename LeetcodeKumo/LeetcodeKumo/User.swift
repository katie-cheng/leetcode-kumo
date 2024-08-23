//
//  User.swift
//  LeetcodeKumo
//
//  Created by Katie Cheng on 23/08/2024.
//

import Foundation
import SwiftUI

struct User: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var streak: Int
    var recentProblem: String?
    var lastLoggedDate: Date?
    var totalProblems: Int
}
