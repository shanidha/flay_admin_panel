// lib/view/add_product_content.dart

// import 'package:flay_admin_panel/controller/dashboard_controller.dart';
import 'package:flay_admin_panel/core/resources/app_colors.dart';
import 'package:flay_admin_panel/core/resources/app_images.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../shell/presentation/bloc/shell_bloc.dart';
import '../../../shell/presentation/bloc/shell_event.dart';
import '../../../shell/presentation/bloc/shell_state.dart';

class AddProductContentScreen extends StatelessWidget {
  const AddProductContentScreen({super.key});

  static const _kPrimary = Color(0xFFFF6C30);
  static const _kBorder = Color(0xFFE0E0E0);

  @override
  Widget build(BuildContext context) {
    final sizeOptions = ['XS','S','M','L','XL','2XL','3XL'];
    final colorOptions = [
      _kPrimary,
      Colors.black,
      Colors.blue,
      Colors.red,
      Colors.yellow,
      Colors.grey,
      Colors.green,
      Colors.purple,
      Colors.orangeAccent,
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // title
          const Text('Create Product',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),

          // — Upload photo
          Card(
            color: AppColors.background,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            elevation: 1,
            child: SizedBox(
              height: 180,
              child: DottedBorder(
                color: _kBorder,
                dashPattern: const [8,4],
                borderType: BorderType.RRect,
                radius: const Radius.circular(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text('Add Product',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: AppColors.kHintStyle)),
                    ),
              Divider(color: AppColors.lineColor,),
                    Column(
                      children: [
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: Image.asset(AppImages.browse,width: 20,height: 20,)),
                        Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'Drop your images here or click to ',
                              style: TextStyle(color: Colors.grey.shade600),
                              children: [
                                TextSpan(
                                  text: 'browse\n',
                                  style: const TextStyle(color: _kPrimary),
                                ),
                                TextSpan(
                                  text: '1600×1200 (4:3) recommended · PNG, JPG files allowed',
                                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // — Product Information card
          Card(  color: AppColors.background,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(child: _buildTextField(label: 'Product Name', hint: 'Item Name')),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTextField(label: 'Product Categories', hint: 'Choose a category')),
                  ]),

                  const SizedBox(height:16),
                  Row(children: [
                    Expanded(child: _buildTextField(label: 'Brand', hint: 'Brand Name')),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTextField(label: 'Weight', hint: 'In g & kg')),
                    const SizedBox(width: 16),
                    Expanded(child: _buildDropdown(label: 'Gender', items: const ['Men','Women'],)),
                  ]),

                  const SizedBox(height:16),
                  // sizes
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Size:', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height:8),
                  Wrap(
                    spacing: 8,
                    children: sizeOptions.map((s) {
                      return ChoiceChip(
                        label: Text(s),
                        selected: false,
                        onSelected: (_) {},
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height:16),
                  // colors
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Colors:', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height:8),
                  Wrap(
                    spacing: 8,
                    children: colorOptions.map((c) {
                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: c,
                            shape: BoxShape.circle,
                            border: Border.all(color: _kBorder),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height:16),
                  _buildTextField(
                    label: 'Description',
                    hint: 'Short description about the product',
                    maxLines: 4,
                  ),

                  const SizedBox(height:16),
                  Row(children: [
                    Expanded(child: _buildTextField(label: 'Tag Number', hint: '#*******')),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTextField(label: 'Stock', hint: 'Quantity', keyboard: TextInputType.number)),
                  ]),
                ],
              ),
            ),
          ),

          const SizedBox(height:32),

          // — Price Details
          Card(  color: AppColors.background,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                Expanded(child: _buildTextField(label: 'Price', hint: '0.00', keyboard: TextInputType.number)),
                const SizedBox(width: 16),
                Expanded(child: _buildTextField(label: 'Discount', hint: '0.00', keyboard: TextInputType.number)),
                const SizedBox(width: 16),
                Expanded(child: _buildTextField(label: 'Tax', hint: '0.00', keyboard: TextInputType.number)),
              ]),
            ),
          ),

          const SizedBox(height:32),

          // — buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  context.read<ShellBloc>()
  .add(const ShellSectionChanged(ShellSection.addProduct));
                 //  Get.find<DashboardController>().changeSection(1);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kPrimary,foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal:24, vertical:12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Create Product'),
              ),
              const SizedBox(width:16),
              OutlinedButton(
                onPressed: () {
                     context.read<ShellBloc>().add(
                            const ShellSectionChanged(
                                ShellSection.products),
                          );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal:24, vertical:12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    String? hint,
    TextInputType keyboard = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height:4),
        TextFormField(
          keyboardType: keyboard,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal:12, vertical:12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required List<String> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height:4),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal:12, vertical:12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          items: items.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
          onChanged: (_) {},
        ),
      ],
    );
  }
}