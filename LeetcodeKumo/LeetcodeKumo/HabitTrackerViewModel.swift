//
//  HabitTrackerViewModel.swift
//  LeetcodeKumo
//
//  Created by Katie Cheng on 23/08/2024.
//

import Foundation
import SwiftUI

class HabitTrackerViewModel: ObservableObject {
    @Published var users: [User] = [
        User(name: "Katie", streak: 0, recentProblem: nil, lastLoggedDate: nil, totalProblems: 0),
        User(name: "Aiturgan", streak: 0, recentProblem: nil, lastLoggedDate: nil, totalProblems: 0),
        User(name: "Kayleen", streak: 0, recentProblem: nil, lastLoggedDate: nil, totalProblems: 0)
    ]
    
    var sortedUsers: [User] {
        users.sorted {
            if $0.streak == $1.streak {
                return $0.totalProblems > $1.totalProblems // Sort by total problems if streaks are the same
            }
            return $0.streak > $1.streak // Sort by streak in descending order
        }
    }
    
    func logProblem(for user: User, problemName: String, date: Date) {
        
        if let index = users.firstIndex(where: { $0.name == user.name }) {
            let calendar = Calendar.current
            let lastDate = users[index].lastLoggedDate
                        
            if let lastDate = lastDate {
                let isSameDay = calendar.isDate(lastDate, inSameDayAs: date)
                let hoursDifference = calendar.dateComponents([.hour], from: lastDate, to: date).hour ?? 0

                if isSameDay {
                    // Do nothing if the date is the same
                    print("Problem logged on the same day. Streak not updated.")
                } else if hoursDifference <= 24 {
                    // Increment streak if the date is different but within 24 hours
                    users[index].streak += 1
                } else {
                    // Reset streak if more than 24 hours have passed
                    users[index].streak = 1
                }
            } else {
                // First time logging a problem
                users[index].streak = 1
            }

            // Update the most recent problem, last logged date, and total problems count
            users[index].recentProblem = problemName
            users[index].lastLoggedDate = date
            users[index].totalProblems += 1

            print("User \(users[index].name) now has a streak of \(users[index].streak), total problems: \(users[index].totalProblems), and logged problem: \(problemName) on \(formattedDate(date))")
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}

