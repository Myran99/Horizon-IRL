import SwiftUI

struct ProfileView: View {
    let store: MockCarSocialStore
    let user: UserProfile

    private var userBuilds: [CarBuild] {
        store.builds(for: user)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack(spacing: 16) {
                    Image(systemName: user.avatarSystemName)
                        .font(.system(size: 62))
                        .foregroundStyle(.tint)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(user.name)
                            .font(.title2.weight(.bold))
                        Text(user.handle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Label(user.city, systemImage: "location")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }

                Text(user.bio)
                    .foregroundStyle(.secondary)

                HStack(spacing: 12) {
                    StatView(value: "\(userBuilds.count)", label: "Builds")
                    StatView(value: "\(userBuilds.reduce(0) { $0 + $1.upvotes })", label: "Upvotes")
                    StatView(value: "\(store.meets.filter { $0.attendeeIDs.contains(user.id) }.count)", label: "Meets")
                }

                SectionBlock(title: user.id == store.currentUser.id ? "My Garage" : "Garage") {
                    if userBuilds.isEmpty {
                        ContentUnavailableView("No builds yet", systemImage: "car")
                    } else {
                        VStack(spacing: 12) {
                            ForEach(userBuilds) { build in
                                NavigationLink {
                                    BuildDetailView(store: store, buildID: build.id)
                                } label: {
                                    GarageRowView(build: build)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle(user.id == store.currentUser.id ? "Garage" : user.name)
    }
}

struct StatView: View {
    let value: String
    let label: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.title3.weight(.bold))
            Text(label)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct GarageRowView: View {
    let build: CarBuild

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: build.primaryImageSystemName)
                .font(.title2)
                .frame(width: 48, height: 48)
                .background(.gray.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(build.displayName)
                    .font(.headline)
                Text("\(build.upvotes) upvotes - \(build.status.rawValue)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(12)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(.quaternary)
        }
    }
}

#Preview {
    let store = MockCarSocialStore()
    NavigationStack {
        ProfileView(store: store, user: store.currentUser)
    }
}
