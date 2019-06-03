import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import '../models/product.dart';
import '../models/user.dart';

mixin ConnectedProductsModel on Model {
  List<Product> products = [];
  User authenticatedUser;
  int selProductIndex;

  void addProduct(
      String title, String description, String image, double price) {
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image':
          'https://www.jamescandy.com/media/catalog/product/cache/1/image/650x/040ec09b1e35df139433887a97daa66f/f/r/fralingers-chocolate-covered-paddle-pops.jpg',
      'price': price
    };
    http.post('https://myapp-9fd44.firebaseio.com/products.json',
        body: json.encode(productData)).then((http.Response response) {
          final Map<String, dynamic> responseData = json.decode(response.body);
         
           final newProduct = Product(
        id: responseData['name'],
        title: title,
        description: description,
        image: image,
        price: price,
        userEmail: authenticatedUser.email,
        userId: authenticatedUser.id);
    products.add(newProduct);
    notifyListeners();
        });
   
  }

  void fetchProducts() {
    http.get('https://myapp-9fd44.firebaseio.com/products.json').then(
      (http.Response response) {
        print(json.decode(response.body));
      }
    );
  }
}
