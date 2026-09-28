//
//  MainTabView.swift
//  iExpense
//
//  Created by Dragomir Mindrescu on 27.04.2025.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    @StateObject private var viewModel = ExpenseViewModel()
    @StateObject private var analyticsViewModel = AnalyticsViewModel(expenses: [])
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    @State private var selectedTab = 0
    @State private var showingAddExpense = false

    var body: some View {
        NavigationView {
            TabView(selection: Binding(
                get: { selectedTab },
                set: { newTab in
                    if newTab == 2 {
                        showingAddExpense = true
                    } else {
                        selectedTab = newTab
                    }
                }
            )) {
                HomeView(viewModel: viewModel, analyticsViewModel: analyticsViewModel)
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                    .tag(0)

                AnalyticsView(analyticsViewModel: analyticsViewModel)
                    .tabItem {
                        Label("Analytics", systemImage: "chart.pie.fill")
                    }
                    .tag(1)

                Color.clear
                    .tabItem {
                        Label("Add", systemImage: "plus.circle.fill")
                    }
                    .tag(2)

                ExpensesListView(viewModel: viewModel)
                    .tabItem {
                        Label("Transactions", systemImage: "list.bullet.rectangle.portrait.fill")
                    }
                    .tag(3)

                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
                    .tag(4)
            }
            .id(settingsViewModel.selectedCurrency)
            .sheet(isPresented: $showingAddExpense) {
                AddExpenseView(viewModel: viewModel)
            }
        }
        .preferredColorScheme(settingsViewModel.selectedTheme.colorScheme)
        .onAppear {
            analyticsViewModel.updateExpenses(viewModel.expenses)
            
            // Register for the notification to switch tabs
            NotificationCenter.default.addObserver(forName: NSNotification.Name("SwitchToExpensesTab"), object: nil, queue: .main) { _ in
                selectedTab = 3 // Switch to Transactions tab
            }
        }
        .onChange(of: viewModel.expenses) {
            analyticsViewModel.updateExpenses(viewModel.expenses)
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(SettingsViewModel())
}
