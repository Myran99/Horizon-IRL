import SwiftUI

struct BuildDetailView: View {
    let store: MockCarSocialStore
    let buildID: UUID

    private var build: CarBuild? {
        store.builds.first { $0.id == buildID }
    }

    var body: some View {
        if let build {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ZStack(alignment: .bottomLeading) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.gray.opacity(0.14))
                        Image(systemName: build.primaryImageSystemName)
                            .font(.system(size: 104))
                            .foregroundStyle(.tint)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        Text(build.status.rawValue)
                            .font(.caption.weight(.bold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(.thinMaterial)
                            .clipShape(Capsule())
                            .padding(14)
                    }
                    .frame(height: 260)

                    VStack(alignment: .leading, spacing: 8) {
                        Text(build.displayName)
                            .font(.largeTitle.weight(.bold))
                        NavigationLink {
                            ProfileView(store: store, user: store.owner(for: build))
                        } label: {
                            Label(store.owner(for: build).handle, systemImage: "person.circle")
                        }
                    }

                    Button {
                        store.toggleUpvote(for: build)
                    } label: {
                        Label("\(build.upvotes) upvotes", systemImage: build.isUpvoted ? "hand.thumbsup.fill" : "hand.thumbsup")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)

                    SectionBlock(title: "Build Notes") {
                        Text(build.description)
                            .foregroundStyle(.secondary)
                    }

                    SectionBlock(title: "Specs") {
                        TagGrid(items: build.specs, systemImage: "gauge.with.dots.needle.bottom.50percent")
                    }

                    SectionBlock(title: "Modifications") {
                        TagGrid(items: build.modifications, systemImage: "wrench.and.screwdriver")
                    }

                    SectionBlock(title: "Photos") {
                        HStack(spacing: 12) {
                            ForEach(build.imageSystemNames, id: \.self) { imageName in
                                Image(systemName: imageName)
                                    .font(.title)
                                    .frame(width: 76, height: 76)
                                    .background(.gray.opacity(0.12))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(build.model)
            .navigationBarTitleDisplayMode(.inline)
        } else {
            ContentUnavailableView("Build not found", systemImage: "car")
        }
    }
}

struct SectionBlock<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct TagGrid: View {
    let items: [String]
    let systemImage: String

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 10)], alignment: .leading, spacing: 10) {
            ForEach(items, id: \.self) { item in
                Label(item, systemImage: systemImage)
                    .font(.subheadline)
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
}

#Preview {
    let store = MockCarSocialStore()
    return NavigationStack {
        BuildDetailView(store: store, buildID: store.builds[0].id)
    }
}
