class Item {
  late String id;
  late String description;
  late double price;
  late String category;
  late String categoryIcon;
  late String userId;
  late String userName;
  late DateTime createdAt;
  bool? isSelected;

  Item(this.id, this.description, this.price, this.category, this.categoryIcon,
      this.userId, this.userName, this.createdAt,
      {this.isSelected = false});

  void toggleSelected() {
    isSelected = !isSelected!;
  }

  Item.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    description = data['description'];
    price = data['price'];
    category = data['category'];
    categoryIcon = data['categoryIcon'];
    userId = data['userId'];
    userName = data['userName'];
    createdAt = data['createdAt'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'price': price,
      'category': category,
      'categoryIcon': categoryIcon,
      'userId': userId,
      'userName': userName,
      'createdAt': createdAt
    };
  }
}
