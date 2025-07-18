class ProductNutrition {
  final String product;  // 상품 명
  final String company;  // 제조시 명
  final String calorie;  // 열량
  final String? protein;  // 단백질
  final String? fat;      // 지방
  final String? carbs;    // 탄수화물
  final String? sugar;    // 당류
  final String? sodium;   // 나트륨

  ProductNutrition({
    required this.product,
    required this.company,
    required this.calorie,
    this.protein,
    this.fat,
    this.carbs,
    this.sugar,
    this.sodium
  });

  factory ProductNutrition.fromJson(Map<String, dynamic> json) {
    return ProductNutrition(
      product: json['FOOD_NM_KR'],
      company: json['MAKER_NM'] ?? '',
      calorie: (json['AMT_NUM1'] as String).split('.').first ?? '',
      protein: json['AMT_NUM3'],
      fat: json['AMT_NUM4'] ,
      carbs: json['AMT_NUM6'] ,
      sugar: json['AMT_NUM7'] ?? '',
      sodium: json['AMT_NUM13'] ?? '',

    );
  }
}