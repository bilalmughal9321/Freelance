import MapKit
import SwiftUI

struct TripDetails: View {
    init(
        trip: TripsModel,
        addAction: Binding<() -> Void>,
        deletionHandler: @escaping () -> Void
    ) {
        _trip = .init(initialValue: trip)
        _addAction = addAction
        self.deletionHandler = deletionHandler
    }

    private let deletionHandler: () -> Void

    @Binding private var addAction: () -> Void

    @State private var trip: TripsModel
    @State private var eventFormMode: EventForm.Mode?
    @State private var isDeleteConfirmationPresented = false
    @State private var isLoading = false
    @State private var error: Error?

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var vm: JournalViewModel

    var body: some View {
        contentView
            .onAppear {
                addAction = { eventFormMode = .add }
                Task {
                    await reloadTrip()
                }
            }
            .navigationTitle(trip.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: toolbar)
            .sheet(item: $eventFormMode) { mode in
                EventForm(tripId: trip.id, mode: mode) {
                    Task {
                        await reloadTrip()
                    }
                }.environmentObject(vm)
            }
            .confirmationDialog("Delete Trip?", isPresented: $isDeleteConfirmationPresented) {
                Button("Delete Trip", role: .destructive) {
                    Task {
                        await deleteTrip()
                    }
                }
            }
            .loadingOverlay(isLoading)
    }

    @ToolbarContentBuilder
    private func toolbar() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button("Delete Trip", systemImage: "trash", role: .destructive) {
                isDeleteConfirmationPresented = true
            }
            .tint(.red)
        }
    }

    @ViewBuilder
    private var contentView: some View {
        if trip.events.isEmpty {
            emptyView
        } else {
            eventsView
        }
    }

    private var eventsView: some View {
        ScrollView(.vertical) {
            ForEach(trip.events) { event in
                EventCell(
                    event: event,
                    edit: {
                        eventFormMode = .edit(event)
                    },
                    mediaUploadHandler: { data in
                        Task {
                            await uploadMedia(eventId: event.id, data: data)
                        }
                    },
                    mediaDeletionHandler: { mediaId in
                        Task {
                            await deleteMedia(withId: mediaId)
                        }
                    }
                )
            }
        }
        .refreshable {
            await reloadTrip()
        }
    }

    private var emptyView: some View {
        ContentUnavailableView(
            label: {
                Label("Nothing here yet!", systemImage: "face.dashed")
                    .labelStyle(.titleOnly)
            },
            description: {
                Text("Add an event to start your trip journal.")
            }
        )
    }

    // MARK: - Networking

    private func uploadMedia(eventId: Event.ID, data: Data) async {
        isLoading = true
        let request = MediaCreate(eventId: eventId, base64Data: data)
        
        let params: [String: Any] = [
            "caption": "sample caption",
            "base64_data": data.base64EncodedString(),
            "event_id": eventId
        ]
        
        do {
            try await vm.uploadMedia(param: params)
            await reloadTrip()
        } catch {
            self.error = error
        }
        isLoading = false
    }

    private func deleteMedia(withId mediaId: MediasModel.ID) async {
        isLoading = true
        do {
            try await vm.deleteMedia(id: mediaId)
            await reloadTrip()
        } catch {
            self.error = error
        }
        isLoading = false
    }

    private func reloadTrip() async {
        let id = trip.id
        do {
            if let updatedTrip = try await vm.configureTrip(id: id, method: .GET) {
                trip = updatedTrip
            }
            
        } catch {
            self.error = error
        }
    }

    private func deleteTrip() async {
        isLoading = true
        do {
            try await vm.configureTrip(id: trip.id, method: .DELETE)
            await MainActor.run {
                deletionHandler()
                dismiss()
            }
        } catch {
            self.error = error
        }
        isLoading = false
    }
}
