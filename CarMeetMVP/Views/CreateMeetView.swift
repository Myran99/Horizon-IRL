import SwiftUI

struct CreateMeetView: View {
    let store: MockCarSocialStore
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var description = ""
    @State private var date = Date()
    @State private var locationName = ""

    private var canCreate: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !locationName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Community meetup") {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                    DatePicker("Date and time", selection: $date)
                    TextField("Location", text: $locationName)
                }

                Section("Map placement") {
                    Text("For the MVP, new meetups use your current mock map position. Firebase can later replace this with geocoding and live location services.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Create Meetup")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        store.createMeet(
                            title: title,
                            description: description,
                            date: date,
                            locationName: locationName
                        )
                        dismiss()
                    }
                    .disabled(!canCreate)
                }
            }
        }
    }
}

#Preview {
    CreateMeetView(store: MockCarSocialStore())
}
