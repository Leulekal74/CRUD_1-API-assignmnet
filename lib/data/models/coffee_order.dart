class CoffeeOrder {
  final int? id;
  final String title;
  final String body;

  CoffeeOrder({
    this.id,
    required this.title,
    required this.body,
  });

  factory CoffeeOrder.fromJson(Map<String, dynamic> json) {
    return CoffeeOrder(
      id: json['id'] as int?,
      title: json['title'] ?? 'No Name Menu',
      body: json['body'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'body': body,
    };
  }
}