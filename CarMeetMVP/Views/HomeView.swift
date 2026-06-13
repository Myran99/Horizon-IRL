import SwiftUI

struct BuildsView: View {
    let store: MockCarSocialStore

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(store.builds.sorted { $0.upvotes > $1.upvotes }) { build in
                    NavigationLink {
                        BuildDetailView(store: store, buildID: build.id)
                    } label: {
                        BuildCardView(
                            build: build,
                            owner: store.owner(for: build),
                            onUpvote: { store.toggleUpvote(for: build) }
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .navigationTitle("Top Builds")
    }
}

struct BuildCardView: View {
    let build: CarBuild
    let owner: UserProfile
    let onUpvote: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.gray.opacity(0.14))
                Image(systemName: build.primaryImageSystemName)
                    .font(.system(size: 76))
                    .foregroundStyle(.tint)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                Text(build.status.rawValue)
                    .font(.caption.weight(.bold))
                    .padding(.horizontal, 9)
                    .padding(.vertical, 5)
                    .background(.thinMaterial)
                    .clipShape(Capsule())
                    .padding(10)
            }
            .frame(height: 190)

            VStack(alignment: .leading, spacing: 8) {
                Text(build.displayName)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.primary)
                Text(owner.handle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(build.description)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }

            HStack {
                Button(action: onUpvote) {
                    Label("\(build.upvotes)", systemImage: build.isUpvoted ? "hand.thumbsup.fill" : "hand.thumbsup")
                        .font(.subheadline.weight(.semibold))
                }
                .buttonStyle(.bordered)

                Spacer()

                Text("\(build.specs.count) specs")
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(14)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(.quaternary)
        }
    }
}

#Preview {
    NavigationStack {
        BuildsView(store: MockCarSocialStore())
    }
}
