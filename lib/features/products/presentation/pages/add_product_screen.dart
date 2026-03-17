import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flay_admin_panel/core/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../media/domain/entities/media_entity.dart';
import '../../../media/presentation/bloc/media_bloc.dart';
import '../../../media/presentation/widgets/media_picker_dialog.dart';
import '../../../shell/presentation/bloc/shell_bloc.dart';
import '../../../shell/presentation/bloc/shell_event.dart';
import '../../../shell/presentation/bloc/shell_state.dart';
import '../../domain/entities/product_entity.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';

class AddProductContentScreen extends StatefulWidget {
  final ProductEntity? product;
  const AddProductContentScreen({super.key, this.product});

  @override
  State<AddProductContentScreen> createState() =>
      _AddProductContentScreenState();
}

class _AddProductContentScreenState extends State<AddProductContentScreen> {
  final _formKey = GlobalKey<FormState>();

  static const _kPrimary = Color(0xFFFF6C30);
  static const _kBorder = Color(0xFFE0E0E0);
  late final TextEditingController _title;
  // late final TextEditingController _category;
  // late final TextEditingController _brand;
  late final TextEditingController _weight;
  late final TextEditingController _desc;
  late final TextEditingController _tagNumber;
  late final TextEditingController _stock;
  late final TextEditingController _price;
  late final TextEditingController _discount;
  late final TextEditingController _tax;
  String? _selectedCategoryId;
  String? _selectedCategoryName;
  String _gender = '';
  final List<String> _selectedSizes = [];
  final List<String> _selectedColors = [];
  MediaEntity? _selectedImage;
  String? _selectedBrandId;
  String? _selectedBrandName;
  bool get isEdit => widget.product != null;
  @override
  void initState() {
    super.initState();
    final p = widget.product;

    _title = TextEditingController(text: p?.title ?? '');
    //  _category = TextEditingController(text: p?.categoryId ?? '');
    // _brand = TextEditingController(text: p?.brand ?? '');
    _weight = TextEditingController(text: p?.weight ?? '');
    _desc = TextEditingController(text: p?.description ?? '');
    _tagNumber = TextEditingController(text: p?.tagNumber ?? '');
    _stock = TextEditingController(text: p?.stock.toString() ?? '');
    _price = TextEditingController(text: p?.price.toString() ?? '');
    _discount = TextEditingController(text: p?.discount.toString() ?? '');
    _tax = TextEditingController(text: p?.tax.toString() ?? '');
    _selectedCategoryId = widget.product?.categoryId;
    _selectedCategoryName = widget.product?.categoryName;
    _selectedBrandId = p?.brandId;
    _selectedBrandName = p?.brandName;

    _gender = p?.gender ?? '';
    if (p != null) {
      _selectedSizes.addAll(p.sizes);
      _selectedColors.addAll(p.colors);
    }
  }

  @override
  void dispose() {
    _title.dispose();
    // _category.dispose();
    // _brand.dispose();
    _weight.dispose();
    _desc.dispose();
    _tagNumber.dispose();
    _stock.dispose();
    _price.dispose();
    _discount.dispose();
    _tax.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final MediaEntity? media = await showDialog<MediaEntity>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<MediaBloc>(),
        child: const MediaPickerDialog(
          folder: 'products',
          uploadedBy: 'admin_user_id',
        ),
      ),
    );

    if (media != null) {
      setState(() {
        _selectedImage = media;
      });
    }
  }

  void _toggleSize(String size) {
    setState(() {
      if (_selectedSizes.contains(size)) {
        _selectedSizes.remove(size);
      } else {
        _selectedSizes.add(size);
      }
    });
  }

  void _toggleColor(String color) {
    setState(() {
      if (_selectedColors.contains(color)) {
        _selectedColors.remove(color);
      } else {
        _selectedColors.add(color);
      }
    });
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Product Category',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('categories')
              .orderBy('title')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox(
                height: 48,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              );
            }

            final docs = snapshot.data!.docs;

            return DropdownButtonFormField<String>(
              value: docs.any((e) => e.id == _selectedCategoryId)
                  ? _selectedCategoryId
                  : null,
              items: docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final title = (data['title'] ?? data['name'] ?? '') as String;

                return DropdownMenuItem<String>(
                  value: doc.id,
                  child: Text(title),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) return;

                final selectedDoc = docs.firstWhere((e) => e.id == value);
                final data = selectedDoc.data() as Map<String, dynamic>;
                final title = (data['title'] ?? data['name'] ?? '') as String;

                setState(() {
                  _selectedCategoryId = value;
                  _selectedCategoryName = title;

                  // clear brand when category changes
                  _selectedBrandId = null;
                  _selectedBrandName = null;
                });
              },
              validator: (value) => value == null || value.isEmpty
                  ? 'Please select a category'
                  : null,
              decoration: InputDecoration(
                hintText: 'Choose a category',
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBrandDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Brand',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        if (_selectedCategoryId == null || _selectedCategoryId!.isEmpty)
          TextFormField(
            enabled: false,
            decoration: InputDecoration(
              hintText: 'Select category first',
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          )
        else
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('brands')
                .where('categoryIds', arrayContains: _selectedCategoryId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox(
                  height: 48,
                  child:
                      Center(child: CircularProgressIndicator(strokeWidth: 2)),
                );
              }

              final docs = snapshot.data!.docs;

              return DropdownButtonFormField<String>(
                value: docs.any((e) => e.id == _selectedBrandId)
                    ? _selectedBrandId
                    : null,
                items: docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final brandName = (data['name'] ?? '') as String;

                  return DropdownMenuItem<String>(
                    value: doc.id,
                    child: Text(brandName),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null) return;

                  final selectedDoc = docs.firstWhere((e) => e.id == value);
                  final data = selectedDoc.data() as Map<String, dynamic>;
                  final brandName = (data['name'] ?? '') as String;

                  setState(() {
                    _selectedBrandId = value;
                    _selectedBrandName = brandName;
                  });
                },
                validator: (value) => value == null || value.isEmpty
                    ? 'Please select a brand'
                    : null,
                decoration: InputDecoration(
                  hintText: docs.isEmpty ? 'No brands found' : 'Choose a brand',
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final old = widget.product;

    final product = ProductEntity(
      id: old?.id ?? '',
      title: _title.text.trim(),
      createdBy: old?.createdBy ?? 'Admin',
      categoryId: _selectedCategoryId ?? '',
      categoryName: _selectedCategoryName ?? '',
      // brand: _brand.text.trim(),
      brandId: _selectedBrandId ?? '',
      brandName: _selectedBrandName ?? '',
      weight: _weight.text.trim(),
      gender: _gender,
      sizes: List<String>.from(_selectedSizes),
      colors: List<String>.from(_selectedColors),
      description: _desc.text.trim(),
      tagNumber: _tagNumber.text.trim(),
      stock: int.tryParse(_stock.text.trim()) ?? 0,
      price: double.tryParse(_price.text.trim()) ?? 0,
      discount: double.tryParse(_discount.text.trim()) ?? 0,
      tax: double.tryParse(_tax.text.trim()) ?? 0,
      imageUrl: _selectedImage?.url ?? old?.imageUrl ?? '',
      imagePath: _selectedImage?.fullPath ?? old?.imagePath ?? '',
      imageMediaId: _selectedImage?.id ?? old?.imageMediaId ?? '',
      createdAt: old?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (isEdit) {
      context.read<ProductBloc>().add(UpdateProductSubmitted(product));
    } else {
      context.read<ProductBloc>().add(AddProductSubmitted(product));
    }

    // context.read<ShellBloc>().add(
    //       const ShellSectionChanged(ShellSection.products),
    //     );
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      context.read<ShellBloc>().add(
            const ShellSectionChanged(ShellSection.products),
          );
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isEdit ? 'Product updated' : 'Product created'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sizeOptions = ['XS', 'S', 'M', 'L', 'XL', '2XL', '3XL'];
    // final colorOptions = [
    //   _kPrimary,
    //   Colors.black,
    //   Colors.blue,
    //   Colors.red,
    //   const Color.fromARGB(255, 144, 138, 84),
    //   Colors.grey,
    //   Colors.green,
    //   Colors.purple,
    //   Colors.orangeAccent,
    // ];
    final colorOptions = [
      'orange',
      'black',
      'blue',
      'red',
      'yellow',
      'grey',
      'green',
      'purple',
      'orangeAccent',
    ];
    final previewUrl = _selectedImage?.url ?? widget.product?.imageUrl ?? '';
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // title
            Text(isEdit ? 'Edit Product' : 'Create Product',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),

            // — Upload photo
            Card(
              color: AppColors.background,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 1,
              child: Container(
                height: 220,
                padding: const EdgeInsets.all(16),
                child: InkWell(
                  onTap: _pickImage,
                  child: DottedBorder(
                    color: _kBorder,
                    dashPattern: const [6, 4],
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(8),
                    child: Center(
                      child: _selectedImage != null || previewUrl.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    _selectedImage?.url ?? previewUrl,
                                    width: 140,
                                    height: 90,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(
                                        Icons.broken_image,
                                        size: 50),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(isEdit
                                    ? 'Image selected'
                                    : 'Product image selected'),
                                const SizedBox(height: 8),
                                OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedImage = null;
                                    });
                                  },
                                  child: const Text('Remove'),
                                ),
                              ],
                            )
                          : RichText(
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
                                    text:
                                        '1600×1200 (4:3) recommended · PNG, JPG files allowed',
                                    style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // — Product Information card
            Card(
              color: AppColors.background,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(
                          child: _buildTextField(
                        label: 'Product Name',
                        hint: 'Item Name',
                        controller: _title,
                      )),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildCategoryDropdown(),
                      ),
                      // Expanded(child: _buildTextField(label: 'Product Categories', hint: 'Choose a category',controller: _category,)),
                    ]),

                    const SizedBox(height: 16),
                    Row(children: [
                      Expanded(
                        child: _buildBrandDropdown(),
                      ),
                      // Expanded(child: _buildTextField(label: 'Brand', hint: 'Brand Name', controller: _brand,)),
                      const SizedBox(width: 16),
                      Expanded(
                          child: _buildTextField(
                        label: 'Weight',
                        hint: 'In g & kg',
                        controller: _weight,
                      )),
                      const SizedBox(width: 16),
                      Expanded(
                          child: _buildDropdown(
                        label: 'Gender',
                        value: _gender.isEmpty ? null : _gender,
                        onChanged: (v) {
                          setState(() => _gender = v ?? '');
                        },
                        items: const ['Men', 'Women'],
                      )),
                    ]),

                    const SizedBox(height: 16),
                    // sizes
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Size:',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: sizeOptions.map((s) {
                        return ChoiceChip(
                          label: Text(s),
                          selected: _selectedSizes.contains(s),
                          onSelected: (_) => _toggleSize(s),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 16),
                    // colors
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Colors:',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: colorOptions.map((c) {
                        return FilterChip(
                          label: Text(c),
                          selected: _selectedColors.contains(c),
                          onSelected: (_) => _toggleColor(c),
                        );
                      }).toList(),
                    ),
                    // Wrap(
                    //   spacing: 8,
                    //   children: colorOptions.map((c) {
                    //     return GestureDetector(
                    //       onTap: () {},
                    //       child: Container(
                    //         width: 28,
                    //         height: 28,
                    //         decoration: BoxDecoration(
                    //           color: c,
                    //           shape: BoxShape.circle,
                    //           border: Border.all(color: _kBorder),
                    //         ),
                    //       ),
                    //     );
                    //   }).toList(),
                    // ),

                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Description',
                      controller: _desc,
                      hint: 'Short description about the product',
                      maxLines: 4,
                    ),

                    const SizedBox(height: 16),
                    Row(children: [
                      Expanded(
                          child: _buildTextField(
                        label: 'Tag Number',
                        hint: '#*******',
                        controller: _tagNumber,
                      )),
                      const SizedBox(width: 16),
                      Expanded(
                          child: _buildTextField(
                              label: 'Stock',
                              hint: 'Quantity',
                              keyboard: TextInputType.number,
                              controller: _stock)),
                    ]),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // — Price Details
            Card(
              color: AppColors.background,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(children: [
                  Expanded(
                      child: _buildTextField(
                          label: 'Price',
                          controller: _price,
                          hint: '0.00',
                          keyboard: TextInputType.number)),
                  const SizedBox(width: 16),
                  Expanded(
                      child: _buildTextField(
                          controller: _discount,
                          hint: '0.00',
                          label: 'Discount',
                          keyboard: TextInputType.number)),
                  const SizedBox(width: 16),
                  Expanded(
                      child: _buildTextField(
                          controller: _tax,
                          hint: '0.00',
                          label: 'Tax',
                          keyboard: TextInputType.number)),
                ]),
              ),
            ),

            const SizedBox(height: 32),

            // — buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _submit,

                  //         {
                  //           context.read<ShellBloc>()
                  // .add(const ShellSectionChanged(ShellSection.addProduct));
                  //          //  Get.find<DashboardController>().changeSection(1);
                  //         },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kPrimary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(isEdit ? 'Update Product' : 'Create Product'),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: () {
                    context.read<ShellBloc>().add(
                          const ShellSectionChanged(ShellSection.products),
                        );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
    TextInputType keyboard = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: keyboard,
          maxLines: maxLines,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
          decoration: InputDecoration(
            hintText: hint,
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          items: items
              .map((v) => DropdownMenuItem(value: v, child: Text(v)))
              .toList(),
          onChanged: (_) {},
        ),
      ],
    );
  }
}

class CategoryDropdownItem {
  final String id;
  final String title;

  const CategoryDropdownItem({
    required this.id,
    required this.title,
  });
}
// Widget _buildCategoryDropdown() {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       const Text(
//         'Product Categories',
//         style: TextStyle(fontWeight: FontWeight.w600),
//       ),
//       const SizedBox(height: 4),
//       StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('categories')
//             .orderBy('title')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const SizedBox(
//               height: 48,
//               child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
//             );
//           }

//           final docs = snapshot.data!.docs;

//           final items = docs.map((doc) {
//             final data = doc.data() as Map<String, dynamic>;
//             return DropdownMenuItem<String>(
//               value: doc.id,
//               child: Text((data['title'] ?? '') as String),
//               onTap: () {
//                 _selectedCategoryName = (data['title'] ?? '') as String;
//               },
//             );
//           }).toList();

//           return DropdownButtonFormField<String>(
//             value: docs.any((e) => e.id == _selectedCategoryId)
//                 ? _selectedCategoryId
//                 : null,
//             items: items,
//             onChanged: (value) {
//               setState(() {
//                 _selectedCategoryId = value;
//                 final selectedDoc = docs.firstWhere(
//                   (e) => e.id == value,
//                 );
//                 final data = selectedDoc.data() as Map<String, dynamic>;
//                 _selectedCategoryName = (data['title'] ?? '') as String;
//               });
//             },
//             validator: (value) =>
//                 value == null || value.isEmpty ? 'Please select a category' : null,
//             decoration: InputDecoration(
//               hintText: 'Choose a category',
//               isDense: true,
//               contentPadding:
//                   const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//           );
//         },
//       ),
//     ],
//   );
// }



//Image
  //     Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child:  Text( isEdit ? 'Edit Product Image' : 'Add Product Image',
                      //                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: AppColors.kHintStyle)),
                      //     ),
                      //      const SizedBox(height: 8),
                      //                   Divider(color: AppColors.lineColor,),
                      //                    const SizedBox(height: 8),
                         
                      //          if (previewUrl.isNotEmpty)
                      //       Container(
                      //         height: 120,
                      //           width: double.infinity,
                      //            decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(12),
                      // border: Border.all(color: Colors.grey.shade300),
                      //                   ),
                      //         child: ClipRRect(
                      //           borderRadius: BorderRadius.circular(12),
                      //           child: Image.network(
                      //             previewUrl,
                      //             width: double.infinity,
                      //             fit: BoxFit.cover,
                      //             errorBuilder: (_, __, ___) =>
                      //                 const Center(child: Icon(Icons.broken_image)),
                      //           ),
                      //         ),
                      //       )
                      //     else
                      //       Container(
                      //                   height: 120,
                      //                   width: double.infinity,
                      //                   alignment: Alignment.center,
                      //                   decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(12),
                      // border: Border.all(color: Colors.grey.shade300),
                      //                   ),
                      //                   child: const Text('No product image selected'),
                      //             ),
                                        
                      //           const SizedBox(height: 16),
                              // SizedBox(
                              //   height: 20,
                              //   width: 20,
                              //   child: Image.asset(AppImages.browse,width: 20,height: 20,)),
                             