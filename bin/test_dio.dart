import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(BaseOptions(headers: {'Accept': 'application/json', 'Authorization': 'Bearer 5|fV5K0S4b3IzAF0Ej9pk5eUqQhWzdLI0DeaybGWbs752a4653'}));
  dio.interceptors.add(LogInterceptor(requestBody: true)); // Enable requestBody like the app
  
  final formData = FormData.fromMap({
    'origin_country_id': 2,
    'origin_facility_id': 2,
    'destination_country_id': 1,
    'destination_facility_id': 1,
    'service_type_id': 1,
    'delivery_type': 'pickup',
    'supplier_name': 'Amazon',
    'supplier_tracking_number': 'TRK123',
    'expected_arrival_at_warehouse': '2026-05-19',
    'items[0][commodity_type]': 'Electronics',
    'items[0][price]': 25,
  }, ListFormat.multiCompatible);

  formData.files.add(MapEntry(
    'documents[]',
    MultipartFile.fromString('fake image content', filename: 'test.jpg', contentType: DioMediaType('image', 'jpeg')),
  ));

  try {
    final response = await dio.post('http://localhost:8080/api/v1/shipment-requests', data: formData);
    print('SUCCESS: ${response.data}');
  } on DioException catch (e) {
    print('ERROR: ${e.response?.statusCode}');
    print('DATA: ${e.response?.data}');
  }
}
