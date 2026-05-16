import 'package:flutter/material.dart';
import '../../../shared/services/api_service.dart';
import '../../../shared/models/service_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../helpers/image_helper.dart';

class ServicesProvider extends ChangeNotifier {
  List<ServiceCategory> _services = [];
  List<SubOption> _currentSubOptions = [];
  List<ServiceDetail> _currentDetails = [];

  bool _isLoading = false;
  bool _isSubOptionsLoading = false;
  bool _isDetailsLoading = false;
  String? _error;

  List<ServiceCategory> get services => _services;
  List<SubOption> get currentSubOptions => _currentSubOptions;
  List<ServiceDetail> get currentDetails => _currentDetails;
  bool get isLoading => _isLoading;
  bool get isSubOptionsLoading => _isSubOptionsLoading;
  bool get isDetailsLoading => _isDetailsLoading;
  String? get error => _error;

  Future<void> fetchServices() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await ApiService.fetchServices();

    if (result.isSuccess && result.data != null) {
      _services = result.data!.asMap().entries.map((entry) {
        int idx = entry.key;
        var service = entry.value;
        return ServiceCategory(
          id: service['serviceId'].toString(),
          name: service['serviceName'],
          tintColor: AppColors.categoryTints[idx % AppColors.categoryTints.length],
          accentColor: AppColors.categoryAccents[idx % AppColors.categoryAccents.length],
          imagePath: ImageHelper.getServiceImage(
            service['serviceId'].toString(),
          ),
        );
      }).toList();
    } else {
      _error = result.errorMessage;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<List<SubOption>> fetchSubOptions(String serviceId) async {
    _isSubOptionsLoading = true;
    notifyListeners();

    final result = await ApiService.fetchSubOptions(serviceId);

    if (result.isSuccess && result.data != null) {
      final List<dynamic> subOptions = result.data!['subOptions'] ?? [];
      _currentSubOptions = subOptions
          .map((e) => SubOption.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      _currentSubOptions = [];
    }

    _isSubOptionsLoading = false;
    notifyListeners();
    return _currentSubOptions;
  }

  Future<void> fetchServiceDetails(
    String serviceId,
    String subOptionId,
  ) async {
    _isDetailsLoading = true;
    _currentDetails = [];
    notifyListeners();

    final result = await ApiService.fetchServiceDetails(serviceId, subOptionId);

    if (result.isSuccess && result.data != null) {
      _currentDetails = result.data!
          .map((e) => ServiceDetail.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    _isDetailsLoading = false;
    notifyListeners();
  }
}
