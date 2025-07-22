import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flay_admin_panel/model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/dashboard_controller.dart';


class CategoryContentScreen extends StatefulWidget {
  const CategoryContentScreen({super.key});

  @override
  State<CategoryContentScreen> createState() => _CategoryContentScreenState();
}

class _CategoryContentScreenState extends State<CategoryContentScreen> {

  final List<Category> categories = List.generate(
    7,
    (i) => Category(
      image: 'assets/images/women.jpeg',
      title: i == 0 ? 'Fashion Women' : 'Fashion',
      priceRange: i == 0 ? 'Rs 49 to 389' : 'Rs 54 to 342',
      createdBy: i == 0 ? 'Seller' : 'Admin',
      id: i == 0 ? 'FS1234' : 'FD6477',
      stock: i == 0 ? 14334 : 23455,
    ),
  );


  int currentPage = 1;
  final int totalPages = 3;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('categories')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Map Firestore docs to your Category model
        final categories = snapshot.data!.docs.map((doc) {
          final data = doc.data()! as Map<String, dynamic>;
          return Category(
            id:          doc.id,
            image:       data['imageUrl']   ?? 'assets/images/placeholder.png',
            title:       data['title']      ?? '',
            priceRange:  data['priceRange'] ?? '',
            createdBy:   data['createdBy']  ?? '',
            stock:       data['stock']?.toInt() ?? 0,
          );
        }).toList();
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'All Categories List',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {  
                       Get.find<DashboardController>().changeSection(3);
                      // Get.to(() => const AddCategoryScreen()),
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFFFF6C30),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: const Text('Add Category'),
                  ),
                  const SizedBox(width: 16),
                  DropdownButton<String>(
                    value: 'This Month',
                    items: const [
                      DropdownMenuItem(
                          value: 'This Month', child: Text('This Month')),
                      DropdownMenuItem(
                          value: 'Last Month', child: Text('Last Month')),
                    ],
                    onChanged: (_) {},
                  ),
                ],
              ),
        
              const SizedBox(height: 16),
        
 // ─── Data Table ────────────────────────────
              SizedBox(
                width: double.infinity,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: DataTable(
                    columnSpacing: 16,
                    headingRowHeight: 48,
                    dataRowMinHeight: 30,
                    columns: const [
                      DataColumn(label: Checkbox(value: false, onChanged: null)),
                      DataColumn(label: Text('Categories')),
                      DataColumn(label: Text('Created By')),
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Product Stock')),
                      DataColumn(label: Text('Action')),
                    ],
                    rows: categories.map((c) {
                      return DataRow(cells: [
                        DataCell(Checkbox(value: false, onChanged: (_) {})),
                        DataCell(Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/images/women.jpeg',
                                width: 48,
                                height: 38,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(c.title, style: const TextStyle(fontSize: 16)),
                          ],
                        )),
                        // DataCell(Text(c.priceRange,
                        //     style: const TextStyle(color: Colors.grey))),
                        DataCell(Text(c.createdBy,
                            style: const TextStyle(fontWeight: FontWeight.bold))),
                        DataCell(Text(c.id,
                            style: const TextStyle(color: Colors.grey))),
                        DataCell(Text(c.stock.toString())),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_red_eye_outlined),
                              onPressed: () {
                              },
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Color(0xFFFF6C30)),
                              onPressed: () async {
                                // delete document
                                await FirebaseFirestore.instance
                                    .collection('categories')
                                    .doc(c.id)
                                    .delete();
                              },
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Color(0xFFFF6C30)),
                              onPressed: () {
                                // navigate to edit screen
                              },
                            ),
                          ],
                        )),
                      ]);
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 16),
        
              // Pagination
              Align(
                alignment: Alignment.centerRight,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  children: [
                    TextButton(
                      onPressed: currentPage > 1
                          ? () => setState(() => currentPage--)
                          : null,
                      child: const Text('Prev'),
                    ),
                    for (var i = 1; i <= totalPages; i++)
                      InkWell(
                        onTap: () => setState(() => currentPage = i),
                        child: Container(
                          width: 32,
                          height: 32,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: currentPage == i
                                ? const Color(0xFFFF6C30)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border:
                                Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(
                            '$i',
                            style: TextStyle(
                              color: currentPage == i
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    TextButton(
                      onPressed: currentPage < totalPages
                          ? () => setState(() => currentPage++)
                          : null,
                      child: const Text('Next'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}