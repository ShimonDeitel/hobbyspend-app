import Foundation

struct HobbyspendItem: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var createdAt: Date = Date()
    var item: String
    var hobby: String
    var cost: Double
}
