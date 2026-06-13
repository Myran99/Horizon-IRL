import MapKit
import SwiftUI

struct LiveMapView: View {
    let store: MockCarSocialStore
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 59.3293, longitude: 18.0686),
            span: MKCoordinateSpan(latitudeDelta: 0.16, longitudeDelta: 0.16)
        )
    )

    var body: some View {
        ZStack(alignment: .top) {
            Map(position: $cameraPosition) {
                ForEach(store.builds) { build in
                    Annotation(
                        build.model,
                        coordinate: CLLocationCoordinate2D(latitude: build.latitude, longitude: build.longitude)
                    ) {
                        NavigationLink {
                            ProfileView(store: store, user: store.owner(for: build))
                        } label: {
                            LiveCarPin(build: build)
                        }
                        .buttonStyle(.plain)
                    }
                }

                ForEach(store.meets) { meet in
                    Annotation(
                        meet.title,
                        coordinate: CLLocationCoordinate2D(latitude: meet.latitude, longitude: meet.longitude)
                    ) {
                        NavigationLink {
                            MeetDetailView(store: store, meetID: meet.id)
                        } label: {
                            EventMapPin(meet: meet)
                        }
                        .buttonStyle(.plain)
                    }
                }

                ForEach(store.businesses) { business in
                    Annotation(
                        business.name,
                        coordinate: CLLocationCoordinate2D(latitude: business.latitude, longitude: business.longitude)
                    ) {
                        NavigationLink {
                            BusinessProfileView(store: store, business: business)
                        } label: {
                            BusinessMapPin(business: business)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .ignoresSafeArea(edges: .top)

            MapHeaderView(buildCount: store.builds.count, meetCount: store.meets.count)
        }
        .navigationTitle("Live Map")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            LiveMapRail(store: store)
        }
    }
}

struct MapHeaderView: View {
    let buildCount: Int
    let meetCount: Int

    var body: some View {
        HStack(spacing: 12) {
            Label("\(buildCount) live builds", systemImage: "car.side.fill")
            Label("\(meetCount) meets", systemImage: "calendar")
        }
        .font(.footnote.weight(.semibold))
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(.thinMaterial)
        .clipShape(Capsule())
        .padding(.top, 12)
    }
}

struct LiveCarPin: View {
    let build: CarBuild

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: build.primaryImageSystemName)
                .font(.title3)
                .frame(width: 42, height: 42)
                .background(.black)
                .foregroundStyle(.white)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(statusColor, lineWidth: 3)
                }
            Text(build.status.rawValue)
                .font(.caption2.weight(.bold))
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(.thinMaterial)
                .clipShape(Capsule())
        }
    }

    private var statusColor: Color {
        switch build.status {
        case .cruising:
            return .green
        case .parked:
            return .blue
        case .atMeet:
            return .orange
        }
    }
}

struct EventMapPin: View {
    let meet: CarMeet

    var body: some View {
        Image(systemName: meet.isPromoted ? "star.circle.fill" : "mappin.circle.fill")
            .font(.title)
            .foregroundStyle(meet.isPromoted ? Color.yellow : Color.red)
            .background(.black.opacity(0.75))
            .clipShape(Circle())
    }
}

struct BusinessMapPin: View {
    let business: BusinessProfile

    var body: some View {
        Image(systemName: business.isPremium ? "building.2.crop.circle.fill" : "building.2.fill")
            .font(.title2)
            .padding(7)
            .background(business.isPremium ? Color.purple : Color.gray)
            .foregroundStyle(.white)
            .clipShape(Circle())
    }
}

struct LiveMapRail: View {
    let store: MockCarSocialStore

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(store.meets.sorted { $0.isPromoted && !$1.isPromoted }) { meet in
                    NavigationLink {
                        MeetDetailView(store: store, meetID: meet.id)
                    } label: {
                        MapEventCard(meet: meet, hostName: store.hostName(for: meet))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .background(.thinMaterial)
    }
}

struct MapEventCard: View {
    let meet: CarMeet
    let hostName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label(meet.isPromoted ? "Promoted" : "Meet", systemImage: meet.isPromoted ? "star.fill" : "calendar")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(meet.isPromoted ? Color.yellow : Color.secondary)
                Spacer()
                Text("\(meet.attendeeCount)")
                    .font(.caption.weight(.bold))
            }
            Text(meet.title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
                .lineLimit(1)
            Text(hostName)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .lineLimit(1)
            Text(meet.locationName)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .frame(width: 230, alignment: .leading)
        .padding(12)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(meet.isPromoted ? .yellow.opacity(0.6) : .quaternary)
        }
    }
}

#Preview {
    NavigationStack {
        LiveMapView(store: MockCarSocialStore())
    }
}
