import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flay_admin_panel/core/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shell/presentation/bloc/shell_bloc.dart';
import '../../../shell/presentation/bloc/shell_event.dart';
import '../../../shell/presentation/bloc/shell_state.dart';
import '../../data/repositories/brand_repository_impl.dart';
import '../../domain/usecases/create_brand.dart';
import '../bloc/brand_bloc.dart';
import '../bloc/brand_event.dart';
import '../bloc/brand_state.dart';

class AddBrandPage extends StatefulWidget {
  const AddBrandPage({super.key});

  @override
  State<AddBrandPage> createState() => _AddBrandPageState();
}

class _AddBrandPageState extends State<AddBrandPage> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _desc = TextEditingController();

  List<String> _selectedCategoryIds = const [];

  @override
  void dispose() {
    _name.dispose();
    _desc.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_form.currentState!.validate()) return;
    context.read<AddBrandBloc>().add(
          AddBrandSubmitted(
            name: _name.text.trim(),
            categoryIds: _selectedCategoryIds,
            logoUrl: null,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddBrandBloc>(
      create: (_) => AddBrandBloc(
        CreateBrandUseCase(
          BrandRepositoryImpl(FirebaseFirestore.instance),
        ),
      ),
      // ↓ Now provide the child
      child: BlocConsumer<AddBrandBloc, AddBrandState>(
        listener: (context, state) {
          if (state.success) {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Brand created')));
            _form.currentState!.reset();
            _name.clear();
            _desc.clear();
            _selectedCategoryIds = const [];
            setState(() {});
            context
                .read<ShellBloc>()
                .add(const ShellSectionChanged(ShellSection.brands));
          }
          if (state.error != null) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error!)));
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(child: _tf('Brand Name', _name)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _CategoryMultiSelect(
                        value: _selectedCategoryIds,
                        onChanged: (ids) =>
                            setState(() => _selectedCategoryIds = ids),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  _tf('Description (optional)', _desc,
                      maxLines: 3, requiredField: false),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          height: 44,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                foregroundColor: AppColors.background,
                                backgroundColor: AppColors.primary),
                            onPressed: state.loading ? null : _submit,
                            child: state.loading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                : const Text('Save Brand'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton(
                        onPressed: () {
                          context.read<ShellBloc>().add(
                                const ShellSectionChanged(ShellSection.brands),
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
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _tf(String label, TextEditingController c,
      {int maxLines = 1, bool requiredField = true}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 6),
      TextFormField(
        controller: c,
        maxLines: maxLines,
        validator: requiredField
            ? (v) => (v == null || v.isEmpty) ? 'Required' : null
            : null,
        decoration: const InputDecoration(border: OutlineInputBorder()),
      ),
    ]);
  }
}

/// simple multi-select for categories (checks Firestore 'categories' collection)
class _CategoryMultiSelect extends StatefulWidget {
  final List<String> value;
  final ValueChanged<List<String>> onChanged;
  const _CategoryMultiSelect({
    required this.value,
    required this.onChanged,
  });

  @override
  State<_CategoryMultiSelect> createState() => _CategoryMultiSelectState();
}

class _CategoryMultiSelectState extends State<_CategoryMultiSelect> {
  late final Future<List<Map<String, String>>> _cats;

  @override
  void initState() {
    super.initState();
    _cats = FirebaseFirestore.instance
        .collection('categories')
        .orderBy('title')
        .get()
        .then((q) => q.docs.map((d) {
              final m = d.data();
              return {
                'id': d.id,
                'title': (m['title'] ?? '') as String,
              };
            }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, String>>>(
      future: _cats,
      builder: (_, snap) {
        final items = snap.data ?? const [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Categories',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final it in items)
                  FilterChip(
                    label: Text(it['title']!),
                    selected: widget.value.contains(it['id']),
                    onSelected: (on) {
                      final next = [...widget.value];
                      on ? next.add(it['id']!) : next.remove(it['id']!);
                      widget.onChanged(next);
                    },
                  ),
              ],
            ),
            if (snap.connectionState == ConnectionState.waiting)
              const LinearProgressIndicator(),
          ],
        );
      },
    );
  }
}
