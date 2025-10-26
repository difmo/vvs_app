import 'package:flutter/material.dart';
import 'events_detail_page.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String _selectedFilter = 'Newest First';

  final List<Map<String, String>> _events = [
    {
      "title": "Marriage",
      "description":
      "A marriage is a sacred union between two individuals, celebrating love and commitment.",
      "fullDescription":
      "Marriage is a lifelong bond between two people who promise to love and support each other. It represents trust, companionship, and shared growth in every stage of life.",
      "location": "Delhi",
      "image": "assets/images/Enganged.jpg"
    },
    {
      "title": "Engagement",
      "description":
      "Engagement is a formal agreement between two people to marry, symbolizing commitment.",
      "fullDescription":
      "Engagement is a formal agreement or commitment between two people to marry, symbolizing love, trust, and mutual respect. It is often marked by the exchange of rings and celebrated with family and friends. Beyond a social ritual, engagement represents a promise to support and cherish one another through life’s challenges and joys. It serves as a period of preparation, allowing couples to plan their future together.",
      "location": "Lucknow",
      "image": "assets/images/Enganged.jpg"
    },
    {
      "title": "Birthday",
      "description":
      "🎉 Our little star is turning one! Join us as we celebrate this magical day.",
      "fullDescription":
      "Birthdays are special occasions to celebrate the journey of life and the joy of togetherness. Join us for a cheerful celebration full of smiles, cakes, and happiness.",
      "location": "Lucknow",
      "image": "assets/images/birthday.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Events",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Search Bar ---
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: "Search events...",
                  prefixIcon: Icon(Icons.search, size: 22),
                  isDense: true,
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 8),

              // --- Location Bar ---
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(
                  hintText: "Location",
                  prefixIcon: Icon(Icons.location_on_outlined, size: 22),
                  isDense: true,
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 8),

              // --- Dropdown Filter ---
              DropdownButtonHideUnderline(
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedFilter,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down),
                    items: const [
                      DropdownMenuItem(
                          value: 'Newest First',
                          child: Text("Newest First")),
                      DropdownMenuItem(
                          value: 'Price: Low to High',
                          child: Text("Price: Low to High")),
                      DropdownMenuItem(
                          value: 'Price: High to Low',
                          child: Text("Price: High to Low")),
                      DropdownMenuItem(
                          value: 'Most Popular',
                          child: Text("Most Popular")),
                    ],
                    onChanged: (value) {
                      setState(() => _selectedFilter = value!);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // --- Text: Showing events ---
              const Text(
                "Showing events",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),

              // --- Events List ---
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _events.length,
                  itemBuilder: (context, index) {
                    final event = _events[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EventDetailsPage(
                              title: event['title']!,
                              image: event['image']!,
                              description: event['fullDescription']!,
                              location: event['location']!,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(14),
                                topRight: Radius.circular(14),
                              ),
                              child: Image.asset(
                                event['image']!,
                                height: screenWidth * 0.45,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event['title']!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    event['description']!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on_outlined,
                                          size: 14, color: Colors.orange),
                                      const SizedBox(width: 4),
                                      Text(
                                        event['location']!,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
