import 'package:flutter/material.dart';

class ServiceCategory {
  final String id;
  final String name;
  final Color tintColor;
  final Color accentColor;
  final String imagePath;

  ServiceCategory({
    required this.id,
    required this.name,
    required this.tintColor,
    required this.accentColor,
    required this.imagePath,
  });
}

class SubOption {
  final int id;
  final String name;
  final String imagePath;

  SubOption({
    required this.id,
    required this.name,
    required this.imagePath,
  });

  factory SubOption.fromJson(Map<String, dynamic> json) {
    return SubOption(
      id: json['subOptionId'] ?? 0,
      name: json['subOptionName'] ?? '',
      imagePath: '',
    );
  }
}

class ServiceDetail {
  final String category;
  final List<SubCategoryItem> subCategories;

  ServiceDetail({
    required this.category,
    required this.subCategories,
  });

  factory ServiceDetail.fromJson(Map<String, dynamic> json) {
    return ServiceDetail(
      category: json['category'] ?? '',
      subCategories: (json['subCategories'] as List? ?? [])
          .map((e) => SubCategoryItem.fromJson(e))
          .toList(),
    );
  }
}

class SubCategoryItem {
  final String name;
  final String price;
  final String time;
  int quantity;

  SubCategoryItem({
    required this.name,
    required this.price,
    required this.time,
    this.quantity = 0,
  });

  factory SubCategoryItem.fromJson(Map<String, dynamic> json) {
    return SubCategoryItem(
      name: json['subCategoryName'] ?? '',
      price: json['price']?.toString() ?? '0',
      time: json['time'] ?? '',
    );
  }
}
