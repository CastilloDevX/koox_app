import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/bus_station.dart';

class ApiService {
  static const String baseUrl = 'https://koox-api.vercel.app';

  Future<List<BusStation>> getAllStations() async {
    try {
      print("1. Intentando conectar a: $baseUrl/paradas"); 
      final url = Uri.parse('$baseUrl/paradas');
      final response = await http.get(url);

      print("2. Código de respuesta: ${response.statusCode}"); 

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        print("3. Respuesta recibida (raw): $jsonResponse"); 

        if (jsonResponse['ok'] == true && jsonResponse['body'] is List) {
          final List<dynamic> data = jsonResponse['body'];
          print("4. Cantidad de paradas encontradas: ${data.length}"); 
          
          if (data.isNotEmpty) {
             print("Ejemplo de parada: ${data[0]}");
          }

          return data.map((item) => BusStation.fromJson(item)).toList();
        } else {
          print("ERROR: El formato del body no es una lista o 'ok' es false");
          return [];
        }
      } else {
        print("ERROR: El servidor respondió con error ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print('ERROR CRÍTICO EN API: $e'); 
      return [];
    }
  }
}