//
//  TimePickerCard.swift
//  iExpense
//
//  Created by Dragomir Mindrescu on 27.04.2025.
//

import SwiftUI

/// An expandable time picker with toggle functionality
struct TimePickerCard: View {
    let title: String
    @Binding var selectedDate: Date
    @Binding var isExpanded: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)
            
            VStack(spacing: 0) {
                // Time display button
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        isExpanded.toggle()
                    }
                }) {
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.accentColor)
                        
                        Text(formattedTime())
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .foregroundColor(.secondary)
                            .rotationEffect(Angle(degrees: isExpanded ? 180 : 0))
                    }
                    .padding()
                    .background(Color(.tertiarySystemBackground))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                
                // Reserved space for time picker with clipping
                ZStack(alignment: .top) {
                    // Empty container for space
                    Color.clear
                        .frame(height: isExpanded ? (UIDevice.current.userInterfaceIdiom == .pad ? 250 : 200) : 0)
                    
                    // Time picker
                    DatePicker("", selection: $selectedDate, displayedComponents: .hourAndMinute)
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .padding(.horizontal)
                        .onChange(of: selectedDate) { _, _ in
                            HapticFeedback.selection()
                        }
                        .opacity(isExpanded ? 1 : 0)
                        .frame(height: isExpanded ? nil : 0, alignment: .top)
                }
                .clipped() // Clip content when collapsing
            }
            .padding(.bottom, 12)
        }
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
    }
    
    private func formattedTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: selectedDate)
    }
}

#Preview {
    VStack(spacing: 20) {
        TimePickerCard(
            title: "Time",
            selectedDate: .constant(Date()),
            isExpanded: .constant(false)
        )
        
        TimePickerCard(
            title: "Time (Expanded)",
            selectedDate: .constant(Date()),
            isExpanded: .constant(true)
        )
    }
    .padding()
}
