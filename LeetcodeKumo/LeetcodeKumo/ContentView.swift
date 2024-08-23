//
//  ContentView.swift
//  LeetcodeKumo
//
//  Created by Katie Cheng on 23/08/2024.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = HabitTrackerViewModel()
    @State private var selectedUser: User? = nil
    @State private var problemName: String = ""
    @State private var showingLogSheet = false
    @State private var currentDate = Date()

    var body: some View {
        NavigationView {
            VStack {
                Text("LeetcodeKumo!")
                    .font(.largeTitle)
                    .padding(.top)
                
                List {
                    ForEach(Array(viewModel.sortedUsers.enumerated()), id: \.element.id) { index, user in
                        VStack(alignment: .leading) {
                            HStack {
                                Text("\(rank(for: index)) Place")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("\(user.name)")
                                    .font(.headline)
                            }
                            HStack {
                                Text("Total Problems: \(user.totalProblems)")
                                    .font(.subheadline)
                                Spacer()
                                                                
                                if user.streak > 0 {
                                    Text("🔥\(user.streak) day streak🔥")
                                    .font(.subheadline)
                                }
                                else {
                                    Text("\(user.streak) day streak")
                                }
                            }
                            if let recentProblem = user.recentProblem {
                                Text("Most Recent Problem: \(recentProblem)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            } else {
                                Text("No problems logged yet")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                    }
                }
                .listStyle(PlainListStyle())
                .refreshable {
                    refreshLeaderboard()
                }

                Spacer()

                Button(action: {
                    showingLogSheet = true
                }) {
                    Text("Log Leetcode Problem")
                        .font(.body)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
            .sheet(isPresented: $showingLogSheet) {
                LogProblemSheet(
                    selectedUser: $selectedUser,
                    problemName: $problemName,
                    currentDate: $currentDate,
                    viewModel: viewModel, // Pass the viewModel here
                    onSave: {
                        if let user = selectedUser, !problemName.isEmpty {
                            viewModel.logProblem(for: user, problemName: problemName, date: currentDate)
                            problemName = ""
                            selectedUser = nil
                            showingLogSheet = false
                        }
                    }
                )
            }
        }
    }
    
    private func rank(for index: Int) -> String {
        switch index {
        case 0:
            return "1st"
        case 1:
            return "2nd"
        case 2:
            return "3rd"
        default:
            return "\(index + 1)th"
        }
    }

    private func refreshLeaderboard() {
        viewModel.objectWillChange.send()
    }
}

struct LogProblemSheet: View {
    @Binding var selectedUser: User?
    @Binding var problemName: String
    @Binding var currentDate: Date
    @ObservedObject var viewModel: HabitTrackerViewModel // New parameter for viewModel
    var onSave: () -> Void
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            VStack {
                Text("Did you slay today?")
                    .font(.title)
                    .padding()

                Text("Date: \(formattedDate(currentDate))")
                    .font(.subheadline)
                    .padding(.bottom)

                Menu {
                    ForEach(viewModel.users) { user in
                        Button(user.name) {
                            selectedUser = user
                        }
                    }
                } label: {
                    Text(selectedUser?.name ?? "Select User")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }

                TextField("Enter the Leetcode problem name", text: $problemName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.top)
                    .padding(.bottom)

                Button(action: onSave) {
                    Text("Save")
                        .font(.body)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(selectedUser != nil && !problemName.isEmpty ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .disabled(selectedUser == nil || problemName.isEmpty)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Log Problem")
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss() // This will dismiss the sheet
            })
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}


#Preview {
    ContentView()
}
