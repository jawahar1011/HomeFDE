class ImageHelper {

  // MAIN SERVICES
  static String getServiceImage(String serviceId) {
    final imageMap = {
      '1': 'assets/handyman.png',
      '2': 'assets/repair.png',
      '3': 'assets/paint-roller.png',
      '4': 'assets/shipping-truck.png',
      '5': 'assets/cleaning.png',
      '6': 'assets/makeup.png',
      '7': 'assets/mop.png',
      '8': 'assets/cement.png',
      '9': 'assets/agreement.png',
      '10': 'assets/house.png',
    };

    return imageMap[serviceId] ?? 'assets/menu.png';
  }

  // SUB OPTIONS
  static String getSubOptionImage(int id) {
    final images = {

      // HOME MAINTENANCE
      1: 'assets/HandyManServices/electrician.webp',
      2: 'assets/HandyManServices/Carpenter.webp',
      3: 'assets/HandyManServices/plumber.webp',
      4: 'assets/HandyManServices/cover-image.jpg',
      5: 'assets/HandyManServices/tile-grouting.webp',

      // FUTURE
      // 6: makeup
      // 7: rentals
      // 8: real estate
    };

    return images[id] ?? 'assets/default.png';
  }

  // BANNERS
  static String getBannerImage(int subOptionId) {
    final banners = {
      1: 'assets/banners/electrician_banner.jpg',
      2: 'assets/banners/carpenter_banner.jpg',
      3: 'assets/banners/plumber_banner.jpg',
    };

    return banners[subOptionId] ??
        'assets/banners/default_banner.jpg';
  }
}