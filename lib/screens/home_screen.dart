import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import '../helpers/image_helper.dart';
import '../models/service_model.dart';
import '../screens/service_details_screen.dart';
import '../widgets/service_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String _selectedLocation = 'Hyderabad';

  List<ServiceCategory> services = [];

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  // ================= FETCH SERVICES =================

  Future<void> _fetchServices() async {

    try {

      final response = await http.get(
        Uri.parse('http://localhost:4000/api/services'),
      );

      if (response.statusCode == 200) {

        final List<dynamic> jsonData =
        jsonDecode(response.body);

        setState(() {

          services =
              jsonData.asMap().entries.map((entry) {

                int idx = entry.key;
                var service = entry.value;

                return ServiceCategory(

                  id:
                  service['serviceId'].toString(),

                  name:
                  service['serviceName'],

                  color:
                  _getColorForIndex(idx),

                  imagePath:
                  ImageHelper.getServiceImage(
                    service['serviceId'].toString(),
                  ),
                );
              }).toList();

          isLoading = false;
        });

      } else {

        setState(() {

          errorMessage =
          'Failed to load services';

          isLoading = false;
        });
      }

    } catch (e) {

      setState(() {

        errorMessage = e.toString();

        isLoading = false;
      });
    }
  }

  // ================= SHOW POPUP =================

  Future<void> _showServicePopup(
      BuildContext context,
      String serviceId,
      String serviceName,
      ) async {

    try {

      final response = await http.get(
        Uri.parse(
          'http://localhost:4000/api/services/$serviceId',
        ),
      );

      if (response.statusCode == 200) {

        final data = jsonDecode(response.body);

        final List<dynamic> subOptions =
        data['subOptions'];

        showDialog(
          context: context,

          builder: (context) {

            return Dialog(

              insetPadding:
              const EdgeInsets.all(24),

              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(24),
              ),

              child: Container(

                width: 950,
                height: 720,

                padding:
                const EdgeInsets.all(32),

                color: Colors.white,

                child: Column(

                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    // HEADER
                    Row(

                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                      children: [

                        Text(
                          serviceName,

                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight:
                            FontWeight.bold,
                            color:
                            Color(0xFF1A2956),
                          ),
                        ),

                        IconButton(

                          onPressed: () {
                            Navigator.pop(context);
                          },

                          icon: const Icon(
                            Icons.close,
                            size: 30,
                            color:
                            Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // GRID
                    Expanded(

                      child: GridView.builder(

                        itemCount:
                        subOptions.length,

                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(

                          crossAxisCount: 4,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 1,
                        ),

                        itemBuilder:
                            (context, index) {

                          final option =
                          subOptions[index];

                          return GestureDetector(

                            onTap: () {

                              Navigator.pop(context);

                              Navigator.push(
                                context,

                                MaterialPageRoute(

                                  builder: (_) =>
                                      ServiceDetailScreen(

                                        serviceId:
                                        serviceId,

                                        subOptionId:
                                        option['subOptionId']
                                            .toString(),

                                        title:
                                        option['subOptionName'],
                                      ),
                                ),
                              );
                            },

                            child: Container(

                              padding:
                              const EdgeInsets.all(16),

                              decoration: BoxDecoration(

                                color: Colors.white,

                                borderRadius:
                                BorderRadius.circular(18),

                                border: Border.all(
                                  color: const Color(
                                      0xFFE5E7EB),
                                ),

                                boxShadow: [

                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.04),

                                    blurRadius: 10,

                                    offset:
                                    const Offset(0, 3),
                                  ),
                                ],
                              ),

                              child: Column(

                                mainAxisAlignment:
                                MainAxisAlignment.center,

                                children: [

                                  // IMAGE
                                  Image.asset(

                                    ImageHelper
                                        .getSubOptionImage(
                                      option['subOptionId'],
                                    ),

                                    height: 70,

                                    fit: BoxFit.contain,

                                    errorBuilder:
                                        (
                                        context,
                                        error,
                                        stackTrace,
                                        ) {

                                      return const Icon(
                                        Icons
                                            .image_not_supported,
                                        size: 50,
                                        color: Colors.grey,
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 16),

                                  // NAME
                                  Text(

                                    option[
                                    'subOptionName'] ??
                                        '',

                                    textAlign:
                                    TextAlign.center,

                                    style:
                                    const TextStyle(

                                      fontSize: 15,

                                      fontWeight:
                                      FontWeight.w600,

                                      color:
                                      Color(0xFF374151),
                                    ),

                                    maxLines: 2,

                                    overflow:
                                    TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  // ================= COLORS =================

  Color _getColorForIndex(int index) {

    final colors = [

      const Color(0xFFE8F4F8),
      const Color(0xFFFFF4E8),
      const Color(0xFFE8F0FF),
      const Color(0xFFFFE8E8),
      const Color(0xFFF0E8FF),
    ];

    return colors[index % colors.length];
  }

  // ================= HEADER ICON =================

  Widget _headerIcon(IconData icon) {

    return Container(

      width: 52,
      height: 52,

      decoration: BoxDecoration(

        color: Colors.white,
        shape: BoxShape.circle,

        boxShadow: [

          BoxShadow(
            color:
            Colors.black.withOpacity(0.05),

            blurRadius: 10,

            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Icon(
        icon,
        color: const Color(0xFF3B4CB8),
      ),
    );
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {

    final screenWidth =
        MediaQuery.of(context).size.width;

    return Scaffold(

      backgroundColor:
      const Color(0xFFF8FAFC),

      body: Stack(

        children: [

          LayoutBuilder(

            builder:
                (context, constraints) {

              int crossAxisCount = 7;

              if (constraints.maxWidth < 1600) {
                crossAxisCount = 6;
              }

              if (constraints.maxWidth < 1300) {
                crossAxisCount = 5;
              }

              if (constraints.maxWidth < 1100) {
                crossAxisCount = 4;
              }

              if (constraints.maxWidth < 850) {
                crossAxisCount = 3;
              }

              if (constraints.maxWidth < 600) {
                crossAxisCount = 2;
              }

              return SingleChildScrollView(

                child: Stack(

                  children: [

                    Positioned(

                      top: 65,
                      right: 0,

                      child: SvgPicture.asset(
                        'assets/index-doodle-1.svg',
                        width: 280,
                      ),
                    ),

                    Positioned(

                      top: 60,
                      left: 0,

                      child: SvgPicture.asset(
                        'assets/index-doodle-2.svg',
                        width: 100,
                      ),
                    ),

                    Column(
                      children: [

                        // HEADER
                        Container(
                          height: 92,

                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 36,
                          ),

                          decoration:
                          const BoxDecoration(

                            color: Colors.white,

                            border: Border(
                              bottom: BorderSide(
                                color:
                                Color(0xFFE5E7EB),
                              ),
                            ),
                          ),

                          child: Row(
                            children: [

                              InkWell(

                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/home',
                                  );
                                },

                                child: Image.asset(
                                  'assets/landprop_logo.png',
                                  height: 100,
                                  fit: BoxFit.contain,
                                ),
                              ),

                              const Spacer(),

                              OutlinedButton(

                                onPressed: () {},

                                style:
                                OutlinedButton.styleFrom(

                                  side: const BorderSide(
                                    color:
                                    Color(0xFF3B4CB8),
                                  ),

                                  padding:
                                  const EdgeInsets.symmetric(
                                    horizontal: 28,
                                    vertical: 18,
                                  ),

                                  shape:
                                  RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(
                                      30,
                                    ),
                                  ),
                                ),

                                child: const Text(
                                  'Join as a pro',

                                  style: TextStyle(
                                    color:
                                    Color(0xFF3B4CB8),
                                    fontWeight:
                                    FontWeight.w600,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 16),

                              _headerIcon(
                                Icons.shopping_cart_outlined,
                              ),

                              const SizedBox(width: 16),

                              _headerIcon(
                                Icons.account_circle_outlined,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 80),

                        Text(
                          'Book reliable professionals\nfor your home',

                          textAlign: TextAlign.center,

                          style: TextStyle(

                            fontSize:
                            screenWidth < 900
                                ? 42
                                : 62,

                            fontWeight:
                            FontWeight.w700,

                            color:
                            const Color(0xFF1E293B),

                            height: 1.2,
                          ),
                        ),

                        const SizedBox(height: 50),

                        // SEARCH
                        Wrap(

                          alignment:
                          WrapAlignment.center,

                          spacing: 18,
                          runSpacing: 18,

                          children: [

                            // LOCATION
                            Container(

                              width: 320,
                              height: 72,

                              padding:
                              const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),

                              decoration: BoxDecoration(

                                color: Colors.white,

                                borderRadius:
                                BorderRadius.circular(
                                  16,
                                ),

                                border: Border.all(
                                  color:
                                  const Color(0xFFD6E4FF),
                                ),
                              ),

                              child: Row(
                                children: [

                                  const Icon(
                                    Icons.location_on,
                                    color:
                                    Color(0xFF64748B),
                                  ),

                                  const SizedBox(width: 14),

                                  Expanded(
                                    child: Column(

                                      mainAxisAlignment:
                                      MainAxisAlignment.center,

                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,

                                      children: [

                                        Text(
                                          _selectedLocation,

                                          style:
                                          const TextStyle(
                                            fontSize: 16,
                                            fontWeight:
                                            FontWeight.bold,
                                          ),
                                        ),

                                        const SizedBox(
                                            height: 2),

                                        const Text(
                                          'Select your location',

                                          style: TextStyle(
                                            fontSize: 13,
                                            color:
                                            Color(0xFF64748B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const Icon(
                                    Icons.arrow_drop_down,
                                  ),
                                ],
                              ),
                            ),

                            // SEARCH BAR
                            Container(

                              width:
                              screenWidth < 900
                                  ? 320
                                  : 520,

                              height: 72,

                              padding:
                              const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),

                              decoration: BoxDecoration(

                                color: Colors.white,

                                borderRadius:
                                BorderRadius.circular(16),

                                border: Border.all(
                                  color:
                                  const Color(0xFFD6E4FF),
                                ),
                              ),

                              child: const TextField(

                                decoration: InputDecoration(

                                  border:
                                  InputBorder.none,

                                  hintText:
                                  'What service do you need?',

                                  hintStyle: TextStyle(
                                    color:
                                    Color(0xFF94A3B8),
                                  ),

                                  suffixIcon: Icon(
                                    Icons.search,
                                    size: 32,
                                    color:
                                    Color(0xFF64748B),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 90),

                        // GRID
                        Padding(

                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 80,
                          ),

                          child: GridView.builder(

                            shrinkWrap: true,

                            physics:
                            const NeverScrollableScrollPhysics(),

                            itemCount:
                            services.length,

                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(

                              crossAxisCount:
                              crossAxisCount,

                              crossAxisSpacing: 18,
                              mainAxisSpacing: 18,

                              childAspectRatio: 1.15,
                            ),

                            itemBuilder:
                                (context, index) {

                              final service =
                              services[index];

                              return ServiceCard(

                                service: service,

                                onTap: () =>
                                    _showServicePopup(
                                      context,
                                      service.id,
                                      service.name,
                                    ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 120),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),

          // LOADER
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF3B4CB8),
              ),
            ),
        ],
      ),
    );
  }
}