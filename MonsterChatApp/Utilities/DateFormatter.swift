import Foundation
import SwiftUI

class CustomDateFormatter {
    private let formatter: DateFormatter
    
    init() {
        formatter = DateFormatter()
        formatter.dateFormat = "h:mma"
    }
    
    func fDate(_ date: Date) -> String {
        return formatter.string(from: date)
    }
}

// Usage
let customFormatter = CustomDateFormatter()
let formattedDate = customFormatter.fDate(Date())

