import Foundation
import Observation

@Observable
final class MockCarSocialStore {
    var currentUser: UserProfile
    var users: [UserProfile]
    var businesses: [BusinessProfile]
    var builds: [CarBuild]
    var meets: [CarMeet]

    init() {
        let currentUserID = UUID()
        let alexID = UUID()
        let mayaID = UUID()
        let jordanID = UUID()
        let nordicDetailID = UUID()
        let apexTrackID = UUID()
        let boostLabID = UUID()

        currentUser = UserProfile(
            id: currentUserID,
            name: "Liam Carter",
            handle: "@liamdrives",
            bio: "OEM+ builds, late-night city loops, and clean garage notes.",
            city: "Stockholm",
            avatarSystemName: "person.crop.circle.fill",
            latitude: 59.3293,
            longitude: 18.0686
        )

        users = [
            currentUser,
            UserProfile(
                id: alexID,
                name: "Alex Rivera",
                handle: "@boostedalex",
                bio: "Track days and turbo noises.",
                city: "Stockholm",
                avatarSystemName: "person.crop.circle",
                latitude: 59.3359,
                longitude: 18.0763
            ),
            UserProfile(
                id: mayaID,
                name: "Maya Chen",
                handle: "@mx5maya",
                bio: "Lightweight roadsters, sharp fitment, clean photos.",
                city: "Stockholm",
                avatarSystemName: "person.crop.circle",
                latitude: 59.3204,
                longitude: 18.0551
            ),
            UserProfile(
                id: jordanID,
                name: "Jordan Blake",
                handle: "@v8jordan",
                bio: "Classic muscle, modern brakes, Sunday cruises.",
                city: "Stockholm",
                avatarSystemName: "person.crop.circle",
                latitude: 59.3151,
                longitude: 18.0918
            )
        ]

        businesses = [
            BusinessProfile(
                id: nordicDetailID,
                name: "Nordic Detail Studio",
                category: .detailing,
                description: "Paint correction, ceramic coatings, and concours prep for enthusiast cars.",
                contactEmail: "hello@nordicdetail.example",
                phone: "+46 8 555 014",
                website: "nordicdetail.example",
                socialHandle: "@nordicdetail",
                locationName: "Sodermalm, Stockholm",
                latitude: 59.3167,
                longitude: 18.0716,
                isPremium: true,
                promotionTier: .premium
            ),
            BusinessProfile(
                id: apexTrackID,
                name: "Apex Track Days",
                category: .trackOrganizer,
                description: "Beginner-friendly and advanced track sessions with coaching and safety crews.",
                contactEmail: "events@apextrack.example",
                phone: "+46 8 555 221",
                website: "apextrack.example",
                socialHandle: "@apextrackdays",
                locationName: "Stockholm City Hub",
                latitude: 59.3438,
                longitude: 18.0415,
                isPremium: true,
                promotionTier: .promoted
            ),
            BusinessProfile(
                id: boostLabID,
                name: "BoostLab Performance",
                category: .tuning,
                description: "ECU calibration, dyno sessions, turbo kits, and build consultation.",
                contactEmail: "bookings@boostlab.example",
                phone: "+46 8 555 778",
                website: "boostlab.example",
                socialHandle: "@boostlab",
                locationName: "Nacka Strand",
                latitude: 59.3187,
                longitude: 18.1646,
                isPremium: false,
                promotionTier: .standard
            )
        ]

        builds = [
            CarBuild(
                id: UUID(),
                ownerID: alexID,
                imageSystemNames: ["car.side.fill", "gauge.with.dots.needle.bottom.50percent", "engine.combustion.fill"],
                brand: "Nissan",
                model: "Skyline GT-R",
                year: 1998,
                description: "Clean street build with reliable power and a grip-focused setup.",
                specs: ["RB26", "Single turbo", "AWD", "520 hp"],
                modifications: ["Nismo suspension", "Single turbo conversion", "Upgraded intercooler", "TE37 wheels"],
                upvotes: 342,
                isUpvoted: false,
                latitude: 59.3359,
                longitude: 18.0763,
                status: .cruising
            ),
            CarBuild(
                id: UUID(),
                ownerID: mayaID,
                imageSystemNames: ["car.rear.fill", "steeringwheel", "road.lanes"],
                brand: "Mazda",
                model: "MX-5",
                year: 2019,
                description: "Simple lightweight roadster set up for tight backroads.",
                specs: ["2.0 NA", "RWD", "Manual", "1,090 kg"],
                modifications: ["Coilovers", "Lightweight wheels", "Cat-back exhaust"],
                upvotes: 214,
                isUpvoted: true,
                latitude: 59.3204,
                longitude: 18.0551,
                status: .parked
            ),
            CarBuild(
                id: UUID(),
                ownerID: jordanID,
                imageSystemNames: ["car.fill", "engine.combustion", "flame.fill"],
                brand: "Ford",
                model: "Mustang Fastback",
                year: 1967,
                description: "Restomod classic with modern brakes and a tidy interior.",
                specs: ["Coyote V8", "RWD", "Manual", "430 hp"],
                modifications: ["Coyote swap", "Wilwood brakes", "Custom leather interior"],
                upvotes: 487,
                isUpvoted: false,
                latitude: 59.3151,
                longitude: 18.0918,
                status: .atMeet
            ),
            CarBuild(
                id: UUID(),
                ownerID: currentUserID,
                imageSystemNames: ["car.2.fill", "wrench.and.screwdriver.fill", "sparkles"],
                brand: "BMW",
                model: "M3",
                year: 2004,
                description: "Daily-driver E46 with a balanced chassis setup.",
                specs: ["S54", "RWD", "Manual", "343 hp"],
                modifications: ["KW coilovers", "CSL-style wheels", "Short shifter"],
                upvotes: 176,
                isUpvoted: false,
                latitude: 59.3293,
                longitude: 18.0686,
                status: .cruising
            )
        ]

        let calendar = Calendar.current
        meets = [
            CarMeet(
                id: UUID(),
                host: .business(nordicDetailID),
                title: "Detail & Coffee Showcase",
                description: "A premium business-hosted morning meet with demo wash bays, ceramic coating Q&A, and featured builds.",
                date: calendar.date(byAdding: .day, value: 2, to: .now) ?? .now,
                locationName: "Nordic Detail Studio",
                latitude: 59.3167,
                longitude: 18.0716,
                imageSystemNames: ["sparkles", "car.side.fill"],
                attendeeIDs: [alexID, mayaID],
                promotionTier: .premium,
                isPromoted: true
            ),
            CarMeet(
                id: UUID(),
                host: .business(apexTrackID),
                title: "Beginner Track Night",
                description: "Driver briefing, instructor ride-alongs, and paced sessions for first-time track drivers.",
                date: calendar.date(byAdding: .day, value: 6, to: .now) ?? .now,
                locationName: "Apex Track Days Hub",
                latitude: 59.3438,
                longitude: 18.0415,
                imageSystemNames: ["flag.checkered", "helmet"],
                attendeeIDs: [currentUserID, jordanID],
                promotionTier: .promoted,
                isPromoted: true
            ),
            CarMeet(
                id: UUID(),
                host: .user(currentUserID),
                title: "Evening Tunnel Cruise",
                description: "Meet up, talk routes, then head out for a relaxed city cruise.",
                date: calendar.date(byAdding: .day, value: 8, to: .now) ?? .now,
                locationName: "Nacka Strand",
                latitude: 59.3187,
                longitude: 18.1646,
                imageSystemNames: ["car.front.waves.up.fill"],
                attendeeIDs: [currentUserID, alexID],
                promotionTier: .standard,
                isPromoted: false
            )
        ]
    }

    func owner(for build: CarBuild) -> UserProfile {
        users.first { $0.id == build.ownerID } ?? currentUser
    }

    func builds(for user: UserProfile) -> [CarBuild] {
        builds.filter { $0.ownerID == user.id }
    }

    func business(id: UUID) -> BusinessProfile? {
        businesses.first { $0.id == id }
    }

    func hostName(for meet: CarMeet) -> String {
        switch meet.host {
        case .user(let userID):
            return users.first { $0.id == userID }?.handle ?? "Community host"
        case .business(let businessID):
            return businesses.first { $0.id == businessID }?.name ?? "Business host"
        }
    }

    func toggleUpvote(for build: CarBuild) {
        guard let index = builds.firstIndex(where: { $0.id == build.id }) else { return }
        builds[index].isUpvoted.toggle()
        builds[index].upvotes += builds[index].isUpvoted ? 1 : -1
    }

    func toggleJoin(for meet: CarMeet) {
        guard let index = meets.firstIndex(where: { $0.id == meet.id }) else { return }
        if meets[index].attendeeIDs.contains(currentUser.id) {
            meets[index].attendeeIDs.remove(currentUser.id)
        } else {
            meets[index].attendeeIDs.insert(currentUser.id)
        }
    }

    func createMeet(title: String, description: String, date: Date, locationName: String) {
        let newMeet = CarMeet(
            id: UUID(),
            host: .user(currentUser.id),
            title: title,
            description: description,
            date: date,
            locationName: locationName,
            latitude: currentUser.latitude,
            longitude: currentUser.longitude,
            imageSystemNames: ["car.front.waves.up.fill"],
            attendeeIDs: [currentUser.id],
            promotionTier: .standard,
            isPromoted: false
        )
        meets.insert(newMeet, at: 0)
    }
}
