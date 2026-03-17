import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../media/domain/entities/media_entity.dart';
import '../../../media/presentation/bloc/media_bloc.dart';
import '../../../media/presentation/widgets/media_picker_dialog.dart';
import '../../../shell/presentation/bloc/shell_bloc.dart';
import '../../../shell/presentation/bloc/shell_event.dart';
import '../../../shell/presentation/bloc/shell_state.dart';
import '../../domain/entities/category_entity.dart';
import '../bloc/category_bloc.dart';
import '../bloc/category_event.dart';
import '../bloc/category_state.dart';
import 'category_screen.dart';

class AddCategoryScreen extends StatefulWidget {
  final CategoryTableItem? category;
  const AddCategoryScreen({super.key, this.category});
  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _tagIdController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String? _createdBy;
  MediaEntity? _selectedImage;
  bool get isEdit => widget.category != null;
  @override
  void dispose() {
    _titleController.dispose();
    _brandController.dispose();
    _tagIdController.dispose();
    _descController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final c = widget.category;

    if (c != null) {
      _titleController.text = c.title;
      _stockController.text = c.stock.toString();
      _tagIdController.text = c.tagId;
      _brandController.text = c.brand;
      _descController.text = c.description;
      _createdBy = c.createdBy;

      if (c.imageUrl.isNotEmpty) {
        _selectedImage = MediaEntity(
          id: '',
          url: c.imageUrl,
          folder: 'categories',
          filename: '',
          uploadedBy: c.createdBy,
          fullPath: '',
        );
      }
    }
  }

  Future<void> _pickImage() async {
    final MediaEntity? media = await showDialog<MediaEntity>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<MediaBloc>(),
        child: const MediaPickerDialog(
          folder: 'categories',
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

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_createdBy == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select Created By')),
      );
      return;
    }

    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload/select an image')),
      );
      return;
    }

    final category = CategoryEntity(
      id: isEdit ? widget.category!.id : '',
      title: _titleController.text.trim(),
      createdBy: _createdBy!,
      stock: int.tryParse(_stockController.text.trim()) ?? 0,
      tagId: _tagIdController.text.trim(),
      brand: _brandController.text.trim(),
      description: _descController.text.trim(),
      imageUrl: _selectedImage!.url,
      imagePath: _selectedImage!.fullPath ?? '',
      imageMediaId: _selectedImage!.id,
      createdAt: isEdit ? null : DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // if (isEdit) {
    //   context.read<EditCategoryBloc>().add(EditCategorySubmitted(category));
    // } else {
    //   context.read<AddCategoryBloc>().add(AddCategorySubmitted(category));
    // }
    if (isEdit) {
      context.read<EditCategoryBloc>().add(
            EditCategorySubmitted(category),
          );
    } else {
      context.read<AddCategoryBloc>().add(
            AddCategorySubmitted(category),
          );
    }
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _titleController.clear();
    _stockController.clear();
    _tagIdController.clear();
    _descController.clear();
    _brandController.clear();
    setState(() {
      _createdBy = null;
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AddCategoryBloc, AddCategoryState>(
          listener: (context, state) {
            if (state.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Category added successfully')),
              );
              _clearForm();

              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                context.read<ShellBloc>().add(
                      const ShellSectionChanged(ShellSection.categories),
                    );
              }
            }

            if (state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error!)),
              );
            }
          },
        ),
        BlocListener<EditCategoryBloc, EditCategoryState>(
          listener: (context, state) {
            if (state.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Category updated successfully')),
              );
              _clearForm();
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                context.read<ShellBloc>().add(
                      const ShellSectionChanged(ShellSection.categories),
                    );
              }
            }

            if (state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error!)),
              );
            }
          },
        ),
      ],
      //builder: (context, state) {
      child: Builder(
        builder: (context) {
          final addLoading = context.watch<AddCategoryBloc>().state.loading;
          final editLoading = context.watch<EditCategoryBloc>().state.loading;
          final isLoading = addLoading || editLoading;
          return Row(
            children: [
              Expanded(
                child: Scaffold(
                  backgroundColor: const Color(0xFFF7F5F5),
                  body: SafeArea(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24, horizontal: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            isEdit ? 'Edit Category' : 'Create Category',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Thumbnail upload area
                          Card(
                            color: AppColors.background,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 1,
                            child: Container(
                              height: 180,
                              padding: const EdgeInsets.all(16),
                              child: InkWell(
                                onTap: _pickImage,
                                child: DottedBorder(
                                  color: Colors.grey.shade400,
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(8),
                                  dashPattern: const [6, 4],
                                  child: Center(
                                    child: _selectedImage != null
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.network(
                                                  _selectedImage!.url,
                                                  width: 120,
                                                  height: 80,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, __, ___) =>
                                                      const Icon(
                                                    Icons.broken_image,
                                                    size: 50,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              const Text('Image selected'),
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
                                        : Text(
                                            'Drop your images here or click to browse\n\nRecommended: PNG, JPG up to 2MB',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.grey.shade600),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // General Information form
                          Card(
                            color: AppColors.background,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildTextField(
                                            label: 'Category Title',
                                            controller: _titleController,
                                            hint: 'Enter Title',
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: _buildDropdownField(
                                            label: 'Created By',
                                            value: _createdBy,
                                            items: const [
                                              'Admin',
                                              'Seller',
                                            ],
                                            onChanged: (v) =>
                                                setState(() => _createdBy = v),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildTextField(
                                            label: 'TagID',
                                            controller: _tagIdController,
                                            hint: 'Tag Number',
                                            keyboard: TextInputType.number,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: _buildTextField(
                                            label: 'Brand',
                                            controller: _brandController,
                                            hint: '#Nike',
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    _buildTextField(
                                      label: 'Description',
                                      controller: _descController,
                                      hint: 'Type description',
                                      maxLines: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Save & Cancel buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: isLoading ? null : _submit,
                                //  () async {
                                //   if (_formKey.currentState!.validate()) {
                                //     final newCategories = {
                                //       'title': _titleController.text.trim(),
                                //       'createdBy': _createdBy,
                                //       'stock':
                                //           int.parse(_stockController.text.trim()),
                                //       'tagId': _tagIdController.text.trim(),
                                //       'description': _descController.text.trim(),
                                //       'createdAt': FieldValue.serverTimestamp(),
                                //     };
                                //     await FirebaseFirestore.instance
                                //         .collection('categories')
                                //         .add(newCategories);

                                //     context.read<ShellBloc>().add(
                                //         const ShellSectionChanged(
                                //             ShellSection.categories));
                                //   }
                                // },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: const Color(0xFFFF6C30),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                child: Text(
                                  isLoading
                                      ? 'Please wait...'
                                      : isEdit
                                          ? 'Update Category'
                                          : 'Save Changes',
                                ),
                                // child: const Text('Save Changes'),
                              ),
                              const SizedBox(width: 16),
                              OutlinedButton(
                                onPressed: () {
                                  if (Navigator.of(context).canPop()) {
                                    Navigator.of(context).pop();
                                  } else {
                                    context.read<ShellBloc>().add(
                                          const ShellSectionChanged(
                                              ShellSection.categories),
                                        );
                                  }
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
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
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
      Text(label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      const SizedBox(height: 4),
      TextFormField(
        controller: controller,
        keyboardType: keyboard,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
      ),
    ],
  );
}

Widget _buildDropdownField({
  required String label,
  required String? value,
  required List<String> items,
  required ValueChanged<String?> onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
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
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
        validator: (v) => v == null ? 'Please select' : null,
      ),
    ],
  );
}

//submit form
//  void _submit() {
//     if (!_formKey.currentState!.validate()) return;

//     if (_createdBy == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select Created By')),
//       );
//       return;
//     }

//     if (_selectedImage == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please upload/select an image')),
//       );
//       return;
//     }

//     context.read<AddCategoryBloc>().add(
//           AddCategorySubmitted(
//             title: _titleController.text.trim(),
//             createdBy: _createdBy!,
//             brand: _brandController.text.trim(),
//             stock: int.tryParse(_stockController.text.trim()) ?? 0,
//             tagId: _tagIdController.text.trim(),
//             description: _descController.text.trim(),
//             imageUrl: _selectedImage!.url,
//             imagePath: _selectedImage!.fullPath ?? '',
//             imageMediaId: _selectedImage!.id,
//           ),
//         );
//   }
//Future<void> _submit() async {
//   if (!_formKey.currentState!.validate()) return;

//   if (_createdBy == null) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Please select Created By')),
//     );
//     return;
//   }

//   if (_selectedImage == null) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Please upload/select an image')),
//     );
//     return;
//   }

//   final data = {
//     'title': _titleController.text.trim(),
//     'createdBy': _createdBy!,
//     'brand': _brandController.text.trim(),
//     'stock': int.tryParse(_stockController.text.trim()) ?? 0,
//     'tagId': _tagIdController.text.trim(),
//     'description': _descController.text.trim(),
//     'imageUrl': _selectedImage!.url,
//     'imagePath': _selectedImage!.fullPath ?? '',
//     'imageMediaId': _selectedImage!.id,
//     'updatedAt': FieldValue.serverTimestamp(),
//   };

//   try {
//     if (isEdit) {
//       await FirebaseFirestore.instance
//           .collection('categories')
//           .doc(widget.category!.id)
//           .update(data);

//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Category updated successfully')),
//       );
//     } else {
//       await FirebaseFirestore.instance.collection('categories').add({
//         ...data,
//         'createdAt': FieldValue.serverTimestamp(),
//       });

//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Category added successfully')),
//       );
//     }

//     _clearForm();

//     if (!mounted) return;
//     context.read<ShellBloc>().add(
//           const ShellSectionChanged(ShellSection.categories),
//         );
//   } catch (e) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(e.toString())),
//     );
//   }
// }
