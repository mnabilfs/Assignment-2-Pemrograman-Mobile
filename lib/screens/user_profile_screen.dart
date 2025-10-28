import 'package:flutter/material.dart';
import '../services/location_service.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final LocationService _locationService = LocationService();
  String _currentCity = 'MEDAN';
  bool _isLoadingLocation = false;

  final List<Cinema> cinemas = [
    Cinema(name: 'XI CINEMA', isExpanded: false),
    Cinema(name: 'PONDOK KELAPA 21', isExpanded: false),
    Cinema(name: 'CGV', isExpanded: false),
    Cinema(name: 'CINEPOLIS', isExpanded: false),
    Cinema(name: 'CP MALL', isExpanded: false),
    Cinema(name: 'HERMES', isExpanded: false),
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final city = await _locationService.getCurrentCity();
      setState(() {
        _currentCity = city.toUpperCase();
        _isLoadingLocation = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting location: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: const BoxDecoration(
                color: Color(0xFF3E4B6B),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.amber, size: 20),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'THEATER',
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: _isLoadingLocation ? null : () => _showCityDialog(),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.black87,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _isLoadingLocation
                                      ? const Text(
                                          'Getting location...',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey,
                                          ),
                                        )
                                      : Text(
                                          _currentCity,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.grey[700],
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: cinemas.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                dividerColor: Colors.transparent,
                              ),
                              child: ExpansionTile(
                                title: Text(
                                  cinemas[index].name,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                trailing: Icon(
                                  cinemas[index].isExpanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: Colors.grey[700],
                                ),
                                onExpansionChanged: (expanded) {
                                  setState(() {
                                    cinemas[index].isExpanded = expanded;
                                  });
                                },
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Details for ${cinemas[index].name}',
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          'Address: Jl. Example Street No. 123',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Phone: +62 812-3456-7890',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCityDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select City'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.my_location),
                title: const Text('Use Current Location'),
                onTap: () {
                  Navigator.pop(context);
                  _getCurrentLocation();
                },
              ),
              ListTile(
                title: const Text('MEDAN'),
                onTap: () {
                  setState(() {
                    _currentCity = 'MEDAN';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('JAKARTA'),
                onTap: () {
                  setState(() {
                    _currentCity = 'JAKARTA';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('SURABAYA'),
                onTap: () {
                  setState(() {
                    _currentCity = 'SURABAYA';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('BANDUNG'),
                onTap: () {
                  setState(() {
                    _currentCity = 'BANDUNG';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class Cinema {
  final String name;
  bool isExpanded;

  Cinema({required this.name, required this.isExpanded});
}