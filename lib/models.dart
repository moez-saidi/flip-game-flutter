class CategoryItem {
  int id;
  String name;
  String image;
  String created;
  int category;
  bool flipped;

  CategoryItem({this.id, this.name, this.image, this.created, this.category, this.flipped});

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
        id: json['id'],
        name: json['name'],
        image: json['image'],
        created: json['created'],
        category: json['category'],
        flipped: json['flipped']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['created'] = this.created;
    data['category'] = this.category;
    data['flipped'] = this.flipped;
    return data;
  }
}

class Category {
  int id;
  String name;
  String created;

  Category({this.id, this.name, this.created});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        id: json['id'], name: json['name'], created: json['created']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created'] = this.created;
    return data;
  }
}

class Mode {
  int id;
  String name;
  int count;
  int max_flip;
  int verticalState;
  int horizontalState;
  double size;
  String color;
  String timestamp;

  Mode(
      {this.id,
      this.name,
      this.count,
      this.verticalState,
      this.horizontalState,
      this.max_flip,
      this.size,
      this.color,
      this.timestamp});

  factory Mode.fromJson(Map<String, dynamic> json) {
    return Mode(
        id: json['id'],
        name: json['name'],
        count: json['count'],
        max_flip: json['max_flip'],
        verticalState: json['vertical_state'],
        horizontalState: json['horizontal_state'],
        size: json['size'],
        color: json['color'],
        timestamp: json['timestamp']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['count'] = this.count;
    data['max_flip'] = this.max_flip;
    data['vertical_state'] = this.verticalState;
    data['horizontal_state'] = this.horizontalState;
    data['size'] = this.size;
    data['color'] = this.color;
    data['timestamp'] = this.timestamp;
    return data;
  }
}
