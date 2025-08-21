import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart' as geo;

import '../models/stick_review.dart';

class LocationPage extends StatefulWidget {
  final List<StickReview> reviews;

  const LocationPage({super.key, required this.reviews});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String? _topLocation;
  LatLng? _topLatLng;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _computeTopLocation();
  }

  void _computeTopLocation() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    // Tæl forekomster pr. lokation
    final counts = <String, int>{};
    for (final r in widget.reviews) {
      final loc = r.location?.trim();
      if (loc != null && loc.isNotEmpty) {
        counts[loc] = (counts[loc] ?? 0) + 1;
      }
    }

    if (counts.isEmpty) {
      setState(() {
        _loading = false;
        _topLocation = null;
      });
      return;
    }

    // Find lokation med flest pinde
    String top = counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;

    // Geocode top-lokationen
    try {
      final results = await geo.locationFromAddress(top);
      if (results.isNotEmpty) {
        final first = results.first;
        setState(() {
          _topLocation = top;
          _topLatLng = LatLng(first.latitude, first.longitude);
          _loading = false;
        });
      } else {
        setState(() {
          _topLocation = top;
          _topLatLng = null;
          _loading = false;
          _error = "Kunne ikke geokode '$top'.";
        });
      }
    } catch (e) {
      setState(() {
        _topLocation = top;
        _topLatLng = null;
        _loading = false;
        _error = "Geocoding-fejl: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_topLocation == null) {
      return const Center(
        child: Text("Ingen lokationer endnu. Tilføj en anmeldelse med lokation."),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Row(
            children: [
              const Icon(Icons.location_on),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Flest pinde fundet: $_topLocation",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                onPressed: _computeTopLocation,
                child: const Text("Opdater"),
              ),
            ],
          ),
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(_error!, style: const TextStyle(color: Colors.red)),
          ),
        const SizedBox(height: 8),
        Expanded(
          child: _topLatLng == null
              ? const Center(child: Text("Ingen kortvisning tilgængelig."))
              : FlutterMap(
                  options: MapOptions(
                    initialCenter: _topLatLng!,
                    initialZoom: 12,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.stick_review_app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _topLatLng!,
                          width: 40,
                          height: 40,
                          child: const Icon(Icons.place, size: 36),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
