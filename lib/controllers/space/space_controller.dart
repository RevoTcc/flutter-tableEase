import 'space_controller_impl.dart';

abstract class SpaceController {
  Future<void> createSpace(int spaceId);

  Future<bool> checkSpaceExistence(String spaceId);

  Future<void> addMemberToSpace(String spaceId, String? displayName);

  Future<void> addItemDetails(String spaceId, double debt);

  Future<void> removeItemDetails(String spaceId, double debt);

  factory SpaceController() {
    return SpaceControllerImpl();
  }
}
