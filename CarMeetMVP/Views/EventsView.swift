import SwiftUI

struct EventsView: View {
    let store: MockCarSocialStore
    @State private var isCreatingMeet = false

    var body: some View {
        List {
            Section("Promoted") {
                ForEach(store.meets.filter { $0.isPromoted }) { meet in
                    NavigationLink {
                        MeetDetailView(store: store, meetID: meet.id)
                    } label: {
                        MeetRowView(meet: meet, hostName: store.hostName(for: meet), isJoined: meet.attendeeIDs.contains(store.currentUser.id))
                    }
                }
            }

            Section("Community") {
                ForEach(store.meets.filter { !$0.isPromoted }) { meet in
                    NavigationLink {
                        MeetDetailView(store: store, meetID: meet.id)
                    } label: {
                        MeetRowView(meet: meet, hostName: store.hostName(for: meet), isJoined: meet.attendeeIDs.contains(store.currentUser.id))
                    }
                }
            }
        }
        .navigationTitle("Meets")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isCreatingMeet = true
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("Create meet")
            }
        }
        .sheet(isPresented: $isCreatingMeet) {
            CreateMeetView(store: store)
        }
    }
}

struct MeetRowView: View {
    let meet: CarMeet
    let hostName: String
    let isJoined: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: meet.primaryImageSystemName)
                .font(.title2)
                .frame(width: 50, height: 50)
                .background(meet.isPromoted ? .yellow.opacity(0.16) : .gray.opacity(0.12))
                .foregroundStyle(meet.isPromoted ? Color.yellow : Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(meet.title)
                        .font(.headline)
                    if meet.isPromoted {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                    }
                }

                Text(hostName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(meet.date, format: .dateTime.weekday(.abbreviated).month().day().hour().minute())
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(isJoined ? "Joined" : "\(meet.attendeeCount)")
                .font(.caption.weight(.bold))
                .padding(.horizontal, 9)
                .padding(.vertical, 6)
                .background(isJoined ? Color.accentColor.opacity(0.14) : Color.gray.opacity(0.12))
                .clipShape(Capsule())
        }
        .padding(.vertical, 6)
    }
}

struct MeetDetailView: View {
    let store: MockCarSocialStore
    let meetID: UUID

    private var meet: CarMeet? {
        store.meets.first { $0.id == meetID }
    }

    var body: some View {
        if let meet {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    ZStack(alignment: .bottomLeading) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(meet.isPromoted ? .yellow.opacity(0.14) : .gray.opacity(0.14))
                        Image(systemName: meet.primaryImageSystemName)
                            .font(.system(size: 86))
                            .foregroundStyle(meet.isPromoted ? Color.yellow : Color.accentColor)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        if meet.isPromoted {
                            Label(meet.promotionTier.rawValue, systemImage: "star.fill")
                                .font(.caption.weight(.bold))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(.thinMaterial)
                                .clipShape(Capsule())
                                .padding(14)
                        }
                    }
                    .frame(height: 220)

                    VStack(alignment: .leading, spacing: 10) {
                        Text(meet.title)
                            .font(.largeTitle.weight(.bold))
                        Text(store.hostName(for: meet))
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        Label {
                            Text(meet.date, format: .dateTime.weekday(.wide).month().day().hour().minute())
                        } icon: {
                            Image(systemName: "calendar")
                        }
                        Label(meet.locationName, systemImage: "mappin.and.ellipse")
                    }

                    Text(meet.description)
                        .foregroundStyle(.secondary)

                    if case .business(let businessID) = meet.host, let business = store.business(id: businessID) {
                        NavigationLink {
                            BusinessProfileView(store: store, business: business)
                        } label: {
                            Label("View business profile", systemImage: "building.2")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                    }

                    Button {
                        store.toggleJoin(for: meet)
                    } label: {
                        let isJoined = meet.attendeeIDs.contains(store.currentUser.id)
                        Label(isJoined ? "Leave Meet" : "Join Meet", systemImage: isJoined ? "person.fill.checkmark" : "person.fill.badge.plus")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)

                    SectionBlock(title: "Attendees") {
                        Text("\(meet.attendeeCount) enthusiasts attending")
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()
            }
            .navigationTitle("Meet")
            .navigationBarTitleDisplayMode(.inline)
        } else {
            ContentUnavailableView("Meet not found", systemImage: "calendar")
        }
    }
}

struct BusinessProfileView: View {
    let store: MockCarSocialStore
    let business: BusinessProfile

    private var hostedEvents: [CarMeet] {
        store.meets.filter {
            if case .business(let businessID) = $0.host {
                return businessID == business.id
            }
            return false
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                HStack(alignment: .top, spacing: 14) {
                    Image(systemName: business.isPremium ? "building.2.crop.circle.fill" : "building.2.fill")
                        .font(.system(size: 54))
                        .foregroundStyle(business.isPremium ? Color.purple : Color.accentColor)

                    VStack(alignment: .leading, spacing: 6) {
                        Text(business.name)
                            .font(.title2.weight(.bold))
                        Text(business.category.rawValue)
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        Label(business.promotionTier.rawValue, systemImage: business.isPremium ? "crown.fill" : "tag")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(business.isPremium ? Color.purple : Color.secondary)
                    }
                }

                Text(business.description)
                    .foregroundStyle(.secondary)

                SectionBlock(title: "Contact") {
                    VStack(alignment: .leading, spacing: 10) {
                        Label(business.contactEmail, systemImage: "envelope")
                        Label(business.phone, systemImage: "phone")
                        Label(business.website, systemImage: "globe")
                        Label(business.socialHandle, systemImage: "at")
                        Label(business.locationName, systemImage: "mappin.and.ellipse")
                    }
                    .foregroundStyle(.secondary)
                }

                SectionBlock(title: "Business Events") {
                    VStack(spacing: 12) {
                        ForEach(hostedEvents) { meet in
                            NavigationLink {
                                MeetDetailView(store: store, meetID: meet.id)
                            } label: {
                                MapEventCard(meet: meet, hostName: business.name)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Business")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        EventsView(store: MockCarSocialStore())
    }
}
