import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var items: [HobbyspendItem] = []
    @Published var isPro: Bool = false

    static let freeLimit = 30

    private let fileURL: URL = {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent("hobbyspend_items.json")
    }()

    init() {
        load()
        if items.isEmpty {
            items = Store.seedData()
            save()
        }
    }

    static func seedData() -> [HobbyspendItem] {
        [
        HobbyspendItem(item: "Fishing rod", hobby: "Fishing", cost: 65.0),
        HobbyspendItem(item: "Yarn set", hobby: "Knitting", cost: 22.0)
        ]
    }

    var canAddMore: Bool {
        isPro || items.count < Store.freeLimit
    }

    func add(_ item: HobbyspendItem) {
        guard canAddMore else { return }
        items.insert(item, at: 0)
        save()
    }

    func update(_ item: HobbyspendItem) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: HobbyspendItem) {
        items.removeAll { $0.id == item.id }
        save()
    }

    func load() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        if let decoded = try? JSONDecoder().decode([HobbyspendItem].self, from: data) {
            items = decoded
        }
    }

    func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
