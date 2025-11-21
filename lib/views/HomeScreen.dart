import 'package:flutter/material.dart';
import '../models/bus_station.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService();

  List<BusStation> _allStations = []; 
  List<BusStation> _filteredStations = []; 
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Cargar datos al iniciar
  Future<void> _loadData() async {
    final stations = await _apiService.getAllStations();
    setState(() {
      _allStations = stations;
      _isLoading = false;
    });
  }

  void _filterStations(String query) {
    if (query.isEmpty) {
      setState(() => _filteredStations = []);
      return;
    }

    final lowerQuery = query.toLowerCase();
    setState(() {
      _filteredStations = _allStations.where((station) {
        final nameMatches = station.name.toLowerCase().contains(lowerQuery);
        final routeMatches = station.routes.any((route) => 
            route.toLowerCase().contains(lowerQuery));
            
        return nameMatches || routeMatches;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeroSection(),
                  
                  Transform.translate(
                    offset: const Offset(0, -30),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: _buildSearchCard(),
                    ),
                  ),

                  _buildResultsArea(),
                ],
              ),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Stack(
      children: [
        SizedBox(
          height: 300,
          width: double.infinity,
          child: Image.asset(
            'assets/image1.jpeg',
            fit: BoxFit.cover,
          ),
        ),
        Container(
          height: 300,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withOpacity(0.3), Colors.black.withOpacity(0.7)],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.directions_bus, color: Colors.white, size: 32),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Koox Campeche",
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text("Sistema de Transporte Público", style: TextStyle(color: Colors.red[100], fontSize: 12)),
                  ],
                )
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                "Encuentra tu Paradero",
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "Busca el paradero más cercano a tu ubicación",
                style: TextStyle(color: Colors.grey[200], fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: _isLoading ? "Cargando paraderos..." : "Busca por nombre, dirección o ruta...",
            border: InputBorder.none,
            icon: const Icon(Icons.search, color: Colors.grey),
          ),
          onChanged: _filterStations, 
        ),
      ),
    );
  }

  Widget _buildResultsArea() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.only(top: 20),
        child: CircularProgressIndicator(color: Colors.red),
      );
    }

    if (_searchController.text.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.red[50], shape: BoxShape.circle),
              child: const Icon(Icons.search, size: 40, color: Colors.red),
            ),
            const SizedBox(height: 16),
            const Text("Busca tu paradero", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              "Introduce el nombre del paradero o ruta para encontrar las paradas.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
             const SizedBox(height: 24),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _quickSearchCard("Centro"), 
                _quickSearchCard("Mercado"),
              ],
            )
          ],
        ),
      );
    }
    
    if (_filteredStations.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Text("No se encontraron resultados."),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredStations.length,
      itemBuilder: (context, index) {
        final station = _filteredStations[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.location_on, color: Colors.red),
            title: Text(station.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Lat: ${station.latitude}, Lng: ${station.longitude}", style: const TextStyle(fontSize: 10)),
                const SizedBox(height: 4),
                Text(
                  station.routes.take(3).join(", "), // Muestra max 3 rutas
                  style: TextStyle(color: Colors.red[800], fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              print("Click en ${station.name}");
            },
          ),
        );
      },
    );
  }

  Widget _quickSearchCard(String title) {
    return InkWell(
      onTap: () {
        _searchController.text = title;
        _filterStations(title); 
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Icon(Icons.place, color: Colors.red),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      color: Colors.grey[900],
      child: Column(
        children: [
          const Text("© 2025 Koox Campeche", style: TextStyle(color: Colors.grey)),
          Text("Conectando Campeche", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ],
      ),
    );
  }
}