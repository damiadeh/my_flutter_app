import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import './connected_products.dart';

mixin ProductsModel on ConnectedProductsModel {
  
  bool _showFavorites = false;

  List<Product> get allProducts {
    return List.from(products);
  }

  int get selectedProductIndex {
    return selProductIndex;
  }

  List<Product> get displayedProducts {
    if(_showFavorites) {
      return products.where((Product product) => product.isFavorite).toList();
    }
    return List.from(products);
  }

  Product get selectedProduct {
    if (selectedProductIndex == null) {
      return null;
    }
    return products[selectedProductIndex];
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }


  void deleteProduct() {
    products.removeAt(selectedProductIndex);
    notifyListeners();
  }

  

  void updateProduct( String title, String description, String image, double price) {
    final updatedProduct = Product(
        title: title,
        description: description,
        image: image,
        price: price,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId);
    products[selectedProductIndex] = updatedProduct;
    notifyListeners();
  }

    void toggleFavouriteProduct() {
    final bool currentFavStatus = selectedProduct.isFavorite;
    final bool newFavStatus = !currentFavStatus;
    final Product updatedProduct = Product(
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        userEmail: selectedProduct.userEmail,
        isFavorite: newFavStatus);
        products[selectedProductIndex] = updatedProduct;
        notifyListeners();
  }

  void selectProduct(int index) {
    selProductIndex = index;
    if(index != null){
      notifyListeners();
    }
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}
