import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart'; // Optional: for advanced date formatting

class EventDetailScreen extends StatelessWidget {
  final String eventId;

  const EventDetailScreen({super.key, required this.eventId});

  // Helper function to format Firestore Timestamp
  String _formatTimestamp(
    Timestamp? timestamp, {
    String defaultText = 'Not specified',
  }) {
    if (timestamp == null) {
      return defaultText;
    }
    DateTime dateTime = timestamp.toDate();
    // Consider using intl package for locale-aware formatting
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    // Example using intl: return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Title will be set dynamically after data loads
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        // Specify type
        future:
            FirebaseFirestore.instance.collection('events').doc(eventId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print(
              'Error fetching event details: ${snapshot.error}',
            ); // Log error
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Event not found.'));
          }

          // Extract data safely
          final eventData = snapshot.data!.data();
          if (eventData == null) {
            return const Center(child: Text('Event data is empty.'));
          }

          final title = eventData['title'] as String? ?? 'No Title';
          final description =
              eventData['description'] as String? ??
              'No Description available.';
          final posterUrl = eventData['poster_image_url'] as String?;
          final eventTimestamp = eventData['event_datetime'] as Timestamp?;
          final ticketOpenTimestamp =
              eventData['ticket_open_datetime'] as Timestamp?;
          final category = eventData['category'] as String? ?? 'General';
          // We'll ignore venue_id for now, as we don't have venue details yet

          // Format dates
          final formattedEventDate = _formatTimestamp(
            eventTimestamp,
            defaultText: 'Date TBD',
          );
          final formattedTicketOpenDate = _formatTimestamp(
            ticketOpenTimestamp,
            defaultText: 'Not announced',
          );

          return CustomScrollView(
            // Use CustomScrollView for flexible layout with image
            slivers: [
              SliverAppBar(
                // Make AppBar part of the scrollable area
                expandedHeight: 250.0, // Height for the poster image
                pinned: true, // Keep AppBar visible when scrolling
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    title,
                    style: const TextStyle(fontSize: 16.0),
                  ), // Event title in AppBar
                  background:
                      posterUrl != null && posterUrl.isNotEmpty
                          ? Image.network(
                            posterUrl,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => const Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          )
                          : Container(
                            color: Colors.grey,
                            child: const Center(
                              child: Icon(
                                Icons.event,
                                size: 100,
                                color: Colors.white,
                              ),
                            ),
                          ), // Placeholder
                ),
              ),
              SliverList(
                // The rest of the content
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Event Details',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow(Icons.category, 'Category', category),
                        _buildDetailRow(
                          Icons.calendar_today,
                          'Date',
                          formattedEventDate,
                        ),
                        _buildDetailRow(
                          Icons.confirmation_number_outlined,
                          'Ticket Open',
                          formattedTicketOpenDate,
                        ),
                        // We'll add venue details later when we have the venue data model
                        // _buildDetailRow(Icons.location_on, 'Venue', venueName),
                        const SizedBox(height: 16),
                        Text(
                          'Description',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(description),
                        const SizedBox(height: 24),
                        // Placeholder for Booking Button (add functionality later)
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: Implement booking logic or navigation
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Booking not implemented yet.'),
                                ),
                              );
                            },
                            child: const Text('Book Tickets'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          );
        },
      ),
    );
  }

  // Helper widget to build detail rows consistently
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          const SizedBox(width: 16),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)), // Use Expanded to handle long values
        ],
      ),
    );
  }
}
