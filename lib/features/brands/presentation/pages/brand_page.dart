import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flay_admin_panel/core/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shell/presentation/bloc/shell_bloc.dart';
import '../../../shell/presentation/bloc/shell_event.dart';
import '../../../shell/presentation/bloc/shell_state.dart';
import '../../data/models/brand_model.dart';
import 'add_brand_page.dart';

class BrandPage extends StatefulWidget {
  const BrandPage({super.key});
  @override
  State<BrandPage> createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage> {
  int currentPage = 1;
  final int totalPages = 3;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('brands')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Center(child: Text('Error: ${snapshot.error}'));
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());

        final brands =
            snapshot.data!.docs.map((d) => BrandModel.fromDoc(d)).toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Expanded(
                  child: Text('All Brands',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600))),
              ElevatedButton(
                onPressed: () {
                  // If you use ShellBloc to swap body:
                  context
                      .read<ShellBloc>()
                      .add(const ShellSectionChanged(ShellSection.addBrands));
                  // Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddBrandPage()));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white),
                child: const Text('Create New Brand'),
              ),
            ]),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: DataTable(
                  columnSpacing: 16,
                  headingRowHeight: 48,
                  columns: const [
                    DataColumn(label: Text('Logo')),
                    DataColumn(label: Text('Brand')),
                    DataColumn(label: Text('Number of Categories')),
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Action')),
                  ],
                  rows: brands
                      .map((b) => DataRow(cells: [
                            DataCell(
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.grey.shade200,
                                backgroundImage:
                                    (b.logoUrl != null && b.logoUrl!.isNotEmpty)
                                        ? NetworkImage(b.logoUrl!)
                                        : null,
                                child: (b.logoUrl == null || b.logoUrl!.isEmpty)
                                    ? const Icon(Icons.image,
                                        color: Colors.grey)
                                    : null,
                              ),
                            ),
                            DataCell(Text(b.name)),
                            DataCell(Text(b.categoryIds.length.toString())),
                            DataCell(Text(b.createdAt
                                .toLocal()
                                .toString()
                                .substring(0, 16))),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                        Icons.remove_red_eye_outlined),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: Text(b.name),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if ((b.logoUrl ?? '').isNotEmpty)
                                                Center(
                                                  child: CircleAvatar(
                                                    radius: 40,
                                                    backgroundImage:
                                                        NetworkImage(
                                                            b.logoUrl!),
                                                  ),
                                                ),
                                              const SizedBox(height: 12),
                                              Text('Brand: ${b.name}'),
                                              Text(
                                                  'Categories: ${b.categoryIds.length}'),
                                              Text(
                                                  'Created At: ${b.createdAt.toLocal()}'),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: AppColors.primary),
                                    onPressed: () async {
                                      final result =
                                          await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              AddBrandPage(brand: b),
                                        ),
                                      );

                                      if (result == true && mounted) {
                                        setState(() {});
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline,
                                        color: Colors.redAccent),
                                    onPressed: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: const Text('Delete Brand'),
                                          content: Text('Delete "${b.name}"?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, false),
                                              child: const Text('Cancel'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, true),
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (confirm == true) {
                                        await FirebaseFirestore.instance
                                            .collection('brands')
                                            .doc(b.id)
                                            .delete();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ]))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // dummy pagination UI (not wired to Firestore)
            Align(
              alignment: Alignment.centerRight,
              child: Wrap(spacing: 8, children: [
                TextButton(
                    onPressed: currentPage > 1
                        ? () => setState(() => currentPage--)
                        : null,
                    child: const Text('Prev')),
                for (var i = 1; i <= totalPages; i++)
                  InkWell(
                    onTap: () => setState(() => currentPage = i),
                    child: Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color:
                            currentPage == i ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text('$i',
                          style: TextStyle(
                              color: currentPage == i
                                  ? Colors.white
                                  : Colors.black)),
                    ),
                  ),
                TextButton(
                    onPressed: currentPage < totalPages
                        ? () => setState(() => currentPage++)
                        : null,
                    child: const Text('Next')),
              ]),
            ),
          ]),
        );
      },
    );
  }
}
