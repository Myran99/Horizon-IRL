import Foundation

enum VehicleStatus: String, Hashable {
    case cruising = "Cruising"
    case parked = "Parked"
    case atMeet = "At meet"
}

enum BusinessCategory: String, CaseIterable, Hashable {
    case workshop = "Workshop"
    case detailing = "Detailing"
    case tuning = "Tuning"
    case tireShop = "Tire Shop"
    case partsStore = "Parts Store"
    case trackOrganizer = "Track Organizer"
}

enum EventHost: Hashable {
    case user(UUID)
    case business(UUID)
}

enum PromotionTier: String, Hashable {
    case standard = "Standard"
    case promoted = "Promoted"
    case premium = "Premium"
}

struct UserProfile: Identifiable, Hashable {
    let id: UUID
    var name: String
    var handle: String
    var bio: String
    var city: String
    var avatarSystemName: String
    var latitude: Double
    var longitude: Double
}

struct BusinessProfile: Identifiable, Hashable {
    let id: UUID
    var name: String
    var category: BusinessCategory
    var description: String
    var contactEmail: String
    var phone: String
    var website: String
    var socialHandle: String
    var locationName: String
    var latitude: Double
    var longitude: Double
    var isPremium: Bool
    var promotionTier: PromotionTier
}

struct CarBuild: Identifiable, Hashable {
    let id: UUID
    var ownerID: UUID
    var imageSystemNames: [String]
    var brand: String
    var model: String
    var year: Int
    var description: String
    var specs: [String]
    var modifications: [String]
    var upvotes: Int
    var isUpvoted: Bool
    var latitude: Double
    var longitude: Double
    var status: VehicleStatus

    var displayName: String {
        "\(year) \(brand) \(model)"
    }

    var primaryImageSystemName: String {
        imageSystemNames.first ?? "car.side.fill"
    }
}

struct CarMeet: Identifiable, Hashable {
    let id: UUID
    var host: EventHost
    var title: String
    var description: String
    var date: Date
    var locationName: String
    var latitude: Double
    var longitude: Double
    var imageSystemNames: [String]
    var attendeeIDs: Set<UUID>
    var promotionTier: PromotionTier
    var isPromoted: Bool

    var attendeeCount: Int {
        attendeeIDs.count
    }

    var primaryImageSystemName: String {
        imageSystemNames.first ?? "calendar"
    }
}
