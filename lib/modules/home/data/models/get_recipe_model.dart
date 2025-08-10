import 'dart:convert';

GetRecipeModel getRecipeModelFromJson(String str) => GetRecipeModel.fromJson(json.decode(str));

String getRecipeModelToJson(GetRecipeModel data) => json.encode(data.toJson());

class GetRecipeModel {
  List<Recipe>? recipes;
  int? total;
  int? skip;
  int? limit;

  GetRecipeModel({
    this.recipes,
    this.total,
    this.skip,
    this.limit,
  });

  factory GetRecipeModel.fromJson(Map<String, dynamic> json) => GetRecipeModel(
        recipes: json["recipes"] == null ? [] : List<Recipe>.from(json["recipes"]!.map((x) => Recipe.fromJson(x))),
        total: json["total"],
        skip: json["skip"],
        limit: json["limit"],
      );

  Map<String, dynamic> toJson() => {
        "recipes": recipes == null ? [] : List<dynamic>.from(recipes!.map((x) => x.toJson())),
        "total": total,
        "skip": skip,
        "limit": limit,
      };
}

class Recipe {
  int? id;
  String? name;
  List<String>? ingredients;
  List<String>? instructions;
  int? prepTimeMinutes;
  int? cookTimeMinutes;
  int? servings;
  String? difficulty;
  String? cuisine;
  int? caloriesPerServing;
  List<String>? tags;
  int? userId;
  String? image;
  double? rating;
  int? reviewCount;
  List<String>? mealType;

  Recipe({
    this.id,
    this.name,
    this.ingredients,
    this.instructions,
    this.prepTimeMinutes,
    this.cookTimeMinutes,
    this.servings,
    this.difficulty,
    this.cuisine,
    this.caloriesPerServing,
    this.tags,
    this.userId,
    this.image,
    this.rating,
    this.reviewCount,
    this.mealType,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json["id"],
        name: json["name"],
        ingredients: json["ingredients"] == null ? [] : List<String>.from(json["ingredients"]!.map((x) => x)),
        instructions: json["instructions"] == null ? [] : List<String>.from(json["instructions"]!.map((x) => x)),
        prepTimeMinutes: json["prepTimeMinutes"],
        cookTimeMinutes: json["cookTimeMinutes"],
        servings: json["servings"],
        difficulty: json["difficulty"],
        cuisine: json["cuisine"],
        caloriesPerServing: json["caloriesPerServing"],
        tags: json["tags"] == null ? [] : List<String>.from(json["tags"]!.map((x) => x)),
        userId: json["userId"],
        image: json["image"],
        rating: json["rating"]?.toDouble(),
        reviewCount: json["reviewCount"],
        mealType: json["mealType"] == null ? [] : List<String>.from(json["mealType"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "ingredients": ingredients == null ? [] : List<dynamic>.from(ingredients!.map((x) => x)),
        "instructions": instructions == null ? [] : List<dynamic>.from(instructions!.map((x) => x)),
        "prepTimeMinutes": prepTimeMinutes,
        "cookTimeMinutes": cookTimeMinutes,
        "servings": servings,
        "difficulty": difficulty,
        "cuisine": cuisine,
        "caloriesPerServing": caloriesPerServing,
        "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
        "userId": userId,
        "image": image,
        "rating": rating,
        "reviewCount": reviewCount,
        "mealType": mealType == null ? [] : List<dynamic>.from(mealType!.map((x) => x)),
      };
}
