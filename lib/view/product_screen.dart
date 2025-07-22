import 'package:flay_admin_panel/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/dashboard_controller.dart';
import '../core/resources/app_colors.dart';


class ProductsContentScreen extends StatefulWidget {
  const ProductsContentScreen({super.key});

  @override
  State<ProductsContentScreen> createState() => _ProductsContentScreenState();
}

class _ProductsContentScreenState extends State<ProductsContentScreen> {

  final List<Product> _products = List.generate(
    5,
    (i) => Product(
      image: 'assets/images/wo.jpeg',
      title: 'White Tshirt',
      sizeInfo: 'Size: S, M, L, XL',
      price: 'Rs 549',
      category: 'Fashion',
      stockLeft: 486,
      soldCount: 676,
      rating: 4.5,
      reviewCount: 143,
    ),
  );


  int _currentPage = 1;
  final int _totalPages = 3;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  Title 
          Row(
            children: [
              const Expanded(
                child: Text(
                  'All Products List',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              ElevatedButton(
                onPressed: () {  Get.find<DashboardController>().changeSection(4);},
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFFFF6C30),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: const Text('Add Product'),
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

          //  Products Table 
           SizedBox(
                width: double.infinity,
           
            child: Card( color: AppColors.background,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: DataTable(
                columnSpacing: 16,
                headingRowHeight: 56,
                dataRowMinHeight:40 ,
                columns: const [
                  DataColumn(label: Checkbox(value: false, onChanged: null)),
                  DataColumn(label: Text('Product Name & Size')),
                  DataColumn(label: Text('Price')),
                  DataColumn(label: Text('Stock')),
                  DataColumn(label: Text('Category')),
                  DataColumn(label: Text('Rating')),
                  DataColumn(label: Text('Action')),
                ],
                rows: _products.map((p) {
                  return DataRow(cells: [
                    DataCell(Checkbox(value: false, onChanged: (_) {},)),
                    DataCell(Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(p.image,
                              width: 48, height: 38, fit: BoxFit.fill),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(p.title,
                                style:
                                    const TextStyle(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text(p.sizeInfo,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ],
                    )),
                    DataCell(Text(p.price)),
                    DataCell(Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${p.stockLeft} item left',
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)),
                        Text('${p.soldCount} sold',
                            style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    )),
                    DataCell(Text(p.category)),
                    DataCell(Row(
                      children: [
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(0),
                      ),
                          child: Row(
                            children: [
                              const Icon(Icons.star, size: 14, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text('${p.rating}',
                                  style: const TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text('${p.reviewCount} Review',
                            style: const TextStyle(fontSize: 12)),
                      ],
                    )),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_red_eye_outlined),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Color(0xFFFF6C30)),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon:
                              const Icon(Icons.edit, color: Color(0xFFFF6C30)),
                          onPressed: () {},
                        ),
                      ],
                    )),
                  ]);
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 16),

          //  Pagination
          Align(
            alignment: Alignment.centerRight,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              children: [
                TextButton(
                  onPressed: _currentPage > 1
                      ? () => setState(() => _currentPage--)
                      : null,
                  child: const Text('Prev'),
                ),
                for (var i = 1; i <= _totalPages; i++)
                  InkWell(
                    onTap: () => setState(() => _currentPage = i),
                    child: Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _currentPage == i
                            ? const Color(0xFFFF6C30)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        '$i',
                        style: TextStyle(
                          color: _currentPage == i
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                TextButton(
                  onPressed: _currentPage < _totalPages
                      ? () => setState(() => _currentPage++)
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
}