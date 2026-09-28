//
//  FormFields.swift
//  iExpense
//
//  Created by Dragomir Mindrescu on 27.04.2025.
//

import SwiftUI

/// Standard text input field with consistent styling
struct TextFormField: View {
    let label: String
    @Binding var text: String
    var placeholder: String = ""
    var keyboardType: UIKeyboardType = .default
    var leadingIcon: String? = nil
    var trailingIcon: String? = nil
    var trailingAction: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Field label
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Input field
            HStack(alignment: .center) {
                if let iconName = leadingIcon {
                    Image(systemName: iconName)
                        .foregroundColor(.secondary)
                        .frame(width: 20)
                }
                
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                
                if let iconName = trailingIcon {
                    Button(action: {
                        trailingAction?()
                    }) {
                        Image(systemName: iconName)
                            .foregroundColor(.secondary)
                    }
                    .disabled(trailingAction == nil)
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
            .background(Color(.tertiarySystemBackground))
            .cornerRadius(10)
        }
    }
}

/// Currency input field with automatic decimal point insertion
struct CurrencyFormField: View {
    let label: String
    @Binding var amount: String
    var currencySymbol: String
    var clearAction: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Field label
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Currency input field
            HStack(alignment: .center) {
                Text(currencySymbol)
                    .foregroundColor(.secondary)
                    .font(.title3)
                    .fontWeight(.medium)
                
                TextField("0.00", text: $amount)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.leading)
                    .onChange(of: amount) { _, newValue in
                        let formatted = formatCurrencyInput(newValue)
                        if amount != formatted {
                            amount = formatted
                        }
                    }
                
                Spacer()
                
                // Clear button
                if !amount.isEmpty {
                    Button(action: {
                        if let clearAction = clearAction {
                            clearAction()
                        } else {
                            amount = ""
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
            .background(Color(.tertiarySystemBackground))
            .cornerRadius(10)
        }
    }
    
    /// Format the input so that decimal point is automatically inserted (e.g. typing 7, 0, 8 produces 7.08)
    private func formatCurrencyInput(_ input: String) -> String {
        let digits = input.filter { $0.isNumber }
        
        guard let cents = Int(digits), cents > 0 else {
            return ""
        }
        
        let cappedCents = min(cents, 999_999_999)
        let dollars = Double(cappedCents) / 100.0
        return String(format: "%.2f", dollars)
    }
}

#Preview {
    VStack(spacing: 24) {
        TextFormField(
            label: "Title",
            text: .constant("Groceries"),
            placeholder: "Enter title",
            leadingIcon: "pencil"
        )
        
        TextFormField(
            label: "Notes",
            text: .constant("Weekly shopping"),
            placeholder: "Add notes",
            trailingIcon: "xmark.circle.fill",
            trailingAction: {}
        )
        
        CurrencyFormField(
            label: "Amount",
            amount: .constant("123.45"),
            currencySymbol: "$"
        )
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
