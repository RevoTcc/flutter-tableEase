import 'package:table_ease/models/authentication/user_auth_model.dart';
import 'package:table_ease/models/item/item_model.dart';

import 'user_controller_impl.dart';

abstract class UserController {
  Future<void> saveCostumer(UserAuth user);

  Future<void> addItemData(
    String spaceId,
    double itemPrice,
  );

  Future<void> removeItemData(
    String spaceId,
    Item item,
  );

  factory UserController() {
    return UserControllerImpl();
  }
}
