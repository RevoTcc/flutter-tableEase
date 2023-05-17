class Member {
  late String displayName;
  late String userId;
  late double totalPrice;
  late int itemsCount;

  Member({
    required this.displayName,
    required this.userId,
    required this.totalPrice,
    required this.itemsCount,
  });

  Member.fromMap(Map<String, dynamic> data) {
    displayName = data['displayName'];
    userId = data['uid'];
    totalPrice = data['totalPrice'] ?? 0.0;
    itemsCount = data['itemsCount'] ?? 0;
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'uid': userId,
      'totalPrice': totalPrice,
      'itemsCount': itemsCount
    };
  }
}
