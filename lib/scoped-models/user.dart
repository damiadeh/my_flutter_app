import 'package:scoped_model/scoped_model.dart';

import './connected_products.dart';
import '../models/user.dart';

mixin UserModel on ConnectedProductsModel {

  void login(String email, String password) {
    authenticatedUser = User(id: '3333f', email: email, password: password);
  }
}
