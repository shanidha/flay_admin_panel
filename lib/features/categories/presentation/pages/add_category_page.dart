import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shell/presentation/bloc/shell_bloc.dart';
import '../../../shell/presentation/bloc/shell_event.dart';
import '../../../shell/presentation/bloc/shell_state.dart';
import '../bloc/category_bloc.dart';
import '../bloc/category_event.dart';
import '../bloc/category_state.dart';


class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({super.key});
  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _stock = TextEditingController();
  final _tagId = TextEditingController();
  final _desc = TextEditingController();
  String? _createdBy;

  @override
  void dispose() { _title.dispose(); _stock.dispose(); _tagId.dispose(); _desc.dispose(); super.dispose(); }

  void _submit() {
    if (!_form.currentState!.validate()) return;
    context.read<AddCategoryBloc>().add(AddCategorySubmitted(
      title: _title.text.trim(),
      createdBy: _createdBy!,
      stock: int.tryParse(_stock.text.trim()) ?? 0,
      tagId: _tagId.text.trim(),
      description: _desc.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddCategoryBloc, AddCategoryState>(
      listener: (context, state) {
        if (state.success) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Category added')));
          _form.currentState!.reset();
          _title.clear(); _stock.clear(); _tagId.clear(); _desc.clear(); _createdBy = null;
          setState(() {});
            context.read<ShellBloc>().add(
          const ShellSectionChanged(ShellSection.categories),
        );
        }
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error!)));
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
                  Expanded(child: _tf('Category Title', _title)),
                  const SizedBox(width: 16),
                  Expanded(child: _dd('Created By', _createdBy, ['Admin', 'Seller'], (v){ setState(()=> _createdBy=v); })),
                ]),
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(child: _tf('Tag ID/Number', _stock, keyboard: TextInputType.number)),
                  const SizedBox(width: 16),
                  Expanded(child: _tf('Brand', _tagId)),
                ]),
                const SizedBox(height: 16),
                _tf('Description', _desc, maxLines: 4),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: state.loading ? null : _submit,
                      child: state.loading ? const CircularProgressIndicator() : const Text('Save Changes'),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _tf(String label, TextEditingController c, {TextInputType keyboard = TextInputType.text, int maxLines = 1}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 6),
      TextFormField(
        controller: c, keyboardType: keyboard, maxLines: maxLines,
        validator: (v) => (v==null || v.isEmpty) ? 'Required' : null,
        decoration: const InputDecoration(border: OutlineInputBorder()),
      ),
    ]);
  }

  Widget _dd(String label, String? value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 6),
      DropdownButtonFormField<String>(
        value: value,
        items: items.map((e)=>DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
        validator: (v)=> v==null ? 'Please select' : null,
        decoration: const InputDecoration(border: OutlineInputBorder()),
      ),
    ]);
  }
}