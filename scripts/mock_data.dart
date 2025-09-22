import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:faker/faker.dart';

class PocketBaseManager {
  final String pbUrl;
  final String collectionName;
  final String apiToken;
  final Faker faker = Faker();

  PocketBaseManager({
    required this.pbUrl,
    required this.collectionName,
    required this.apiToken,
  });

  Map<String, dynamic> generateFakeProduct() {
    // สร้าง user ปลอม
    final user = {
      'name': faker.person.name(),
      'email': faker.internet.email(),
    };

    // สร้าง reviews ปลอม 1-5 รีวิว
    final reviews = List.generate(
        faker.randomGenerator.integer(5, min: 1), 
        (_) => {
              'user': faker.person.name(),
              'review': faker.lorem.sentence(),
              'rating': faker.randomGenerator.integer(5, min: 1),
            });

    return {
      'name': faker.food.restaurant(),
      'price': faker.randomGenerator.integer(200, min: 10),
      'description': faker.lorem.sentence(),
      'imageUrl': 'https://picsum.photos/200/200?random=${faker.randomGenerator.integer(1000)}',
      'user': user,
      'reviews': reviews,
    };
  }


  Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiToken',
      };

  // Generate N fake products
  Future<void> generate(int count) async {
    for (int i = 0; i < count; i++) {
      final product = generateFakeProduct();

      // 1️⃣ Insert product first
      final productUrl = Uri.parse('$pbUrl/$collectionName/records');
      final productResp = await http.post(
        productUrl,
        headers: headers,
        body: jsonEncode({
          'name': product['name'],
          'price': product['price'],
          'description': product['description'],
          'imageUrl': product['imageUrl'],
          'user': product['user'],
        }),
      );

      if (productResp.statusCode == 200 || productResp.statusCode == 201) {
        final insertedProduct = jsonDecode(productResp.body);
        final productId = insertedProduct['id'];
        print('Inserted product: ${product['name']}');

        // 2️⃣ Insert reviews separately
        for (var review in product['reviews']) {
          final reviewUrl = Uri.parse('$pbUrl/reviews/records');
          final reviewResp = await http.post(
            reviewUrl,
            headers: headers,
            body: jsonEncode({
              'user': review['user'],
              'review': review['review'],
              'rating': review['rating'],
              'productId': productId, // Link to product
            }),
          );

          if (reviewResp.statusCode == 200 || reviewResp.statusCode == 201) {
            print('Inserted review by: ${review['user']}');
          } else {
            print('Failed review insert: ${reviewResp.body}');
          }
        }

      } else {
        print('Failed product insert: ${productResp.body}');
      }
    }
  }


  // Delete all records
  Future<void> deleteAll() async {
    final url = Uri.parse('$pbUrl/$collectionName/records');
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final items = data['items'] as List;
      for (var item in items) {
        final deleteUrl = Uri.parse('$pbUrl/$collectionName/records/${item['id']}');
        final delResp = await http.delete(deleteUrl, headers: headers);
        if (delResp.statusCode == 200) {
          print('Deleted: ${item['id']}');
        } else {
          print('Failed to delete: ${item['id']}');
        }
      }
    } else {
      print('Failed to fetch items for deletion: ${response.body}');
    }
  }

  // Delete specific number of records
  Future<void> deleteSome(int count) async {
    final url = Uri.parse('$pbUrl/$collectionName/records');
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final items = (data['items'] as List).take(count).toList();
      for (var item in items) {
        final deleteUrl = Uri.parse('$pbUrl/$collectionName/records/${item['id']}');
        final delResp = await http.delete(deleteUrl, headers: headers);
        if (delResp.statusCode == 200) {
          print('Deleted: ${item['id']}');
        } else {
          print('Failed to delete: ${item['id']}');
        }
      }
    } else {
      print('Failed to fetch items for deletion: ${response.body}');
    }
  }
}

// CLI example
Future<void> main(List<String> args) async {
  final manager = PocketBaseManager(
    pbUrl: 'http://127.0.0.1:8090/api/collections',
    collectionName: 'product',
    apiToken: 'YOUR_API_TOKEN_HERE',
  );

  if (args.isEmpty) {
    print('Usage: dart run main.dart [generate|deleteAll|deleteSome] [count]');
    return;
  }

  final command = args[0];
  switch (command) {
    case 'generate':
      final count = args.length > 1 ? int.parse(args[1]) : 100;
      await manager.generate(count);
      break;
    case 'deleteAll':
      await manager.deleteAll();
      break;
    case 'deleteSome':
      final count = args.length > 1 ? int.parse(args[1]) : 10;
      await manager.deleteSome(count);
      break;
    default:
      print('Unknown command: $command');
  }
}
