import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ServiceDetailScreen extends StatefulWidget {

  final String serviceId;
  final String subOptionId;
  final String title;

  const ServiceDetailScreen({
    super.key,
    required this.serviceId,
    required this.subOptionId,
    required this.title,
  });

  @override
  State<ServiceDetailScreen> createState() =>
      _ServiceDetailScreenState();
}

class _ServiceDetailScreenState
    extends State<ServiceDetailScreen> {

  List<dynamic> categories = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  Future<void> fetchDetails() async {

    final response = await http.get(
      Uri.parse(
        'http://localhost:4000/api/servicedetails/service/${widget.serviceId}/suboption/${widget.subOptionId}',
      ),
    );

    if (response.statusCode == 200) {

      setState(() {

        categories = jsonDecode(response.body);

        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(

        itemCount: categories.length,

        itemBuilder: (context, index) {

          final category = categories[index];

          return Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  category['category'],

                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                ...category['subCategories']
                    .map<Widget>((sub) {

                  return Card(

                    margin:
                    const EdgeInsets.only(
                      bottom: 16,
                    ),

                    child: ListTile(

                      title: Text(
                        sub['subCategoryName'],
                      ),

                      subtitle: Text(
                        '₹${sub['price']} • ${sub['time']}',
                      ),

                      trailing: ElevatedButton(
                        onPressed: () {},
                        child: const Text('Add'),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}