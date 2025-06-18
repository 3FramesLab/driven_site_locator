class DiscountAgainstBrand {
  final List<String> brands;
  final String discount;

  DiscountAgainstBrand({
    required this.brands,
    required this.discount,
  });

  factory DiscountAgainstBrand.fromJson(Map<String, dynamic> json) {
    return DiscountAgainstBrand(
      brands:
          ((json['brands'] ?? []) as List).map((e) => e.toString()).toList(),
      discount: json['discount'] ?? '',
    );
  }
}
