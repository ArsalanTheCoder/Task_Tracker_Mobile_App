import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AllEmployeeTasksScreen extends StatefulWidget {
  const AllEmployeeTasksScreen({super.key});

  @override
  State<AllEmployeeTasksScreen> createState() => _AllEmployeeTasksScreenState();
}

class _AllEmployeeTasksScreenState extends State<AllEmployeeTasksScreen> {
  String? _selectedDepartment;
  DateTime? _selectedDate;
  List<String> _departments = [];

  @override
  void initState() {
    super.initState();
    _initializeFilters();
  }

  Future<void> _initializeFilters() async {
    final snapshot = await FirebaseFirestore.instance.collection('user_tasks').get();
    final departments = snapshot.docs.map((e) => e['department'] as String).toSet().toList();
    setState(() {
      _departments = departments;
    });
  }

  Query _buildQuery() {
    Query query = FirebaseFirestore.instance.collection('user_tasks').orderBy('timestamp', descending: true);
    return query;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6A1B9A), Color(0xFFD81B60)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
          ),
          title: const Text(
            'All Employee Tasks',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Colors.white
            ),
          ),
          leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios, color: Colors.white)),
          centerTitle: true,
          elevation: 6,
          backgroundColor: Colors.transparent,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Filter by Department',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedDepartment,
                    isExpanded: true,
                    items: [null, ..._departments].map((dept) {
                      return DropdownMenuItem(
                        value: dept,
                        child: Text(dept ?? 'All'),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedDepartment = val),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Filter by Date',
                      border: OutlineInputBorder(),
                      hintText: _selectedDate != null
                          ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                          : 'All',
                      suffixIcon: _selectedDate != null
                          ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _selectedDate = null),
                      )
                          : const Icon(Icons.calendar_today),
                    ),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() => _selectedDate = picked);
                      }
                    },
                  ),
                ),

              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _buildQuery().snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                List<QueryDocumentSnapshot> docs = snapshot.data?.docs ?? [];

                // Client-side filtering
                if (_selectedDepartment != null && _selectedDepartment!.isNotEmpty) {
                  docs = docs.where((d) => d['department'] == _selectedDepartment).toList();
                }
                if (_selectedDate != null) {
                  final selectedDateStr = DateFormat('yyyy-MM-dd').format(_selectedDate!);
                  docs = docs.where((d) => d['date'] == selectedDateStr).toList();
                }

                if (docs.isEmpty) {
                  return const Center(child: Text('No tasks found.'));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepPurple.shade100,
                          child: const Icon(Icons.person, color: Colors.deepPurple),
                        ),
                        title: Text(
                          data['name'] ?? 'Unknown',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Text(
                          '${data['date'] ?? ''} • ${data['taskSummary'] ?? ''}',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        trailing: Chip(
                          label: Text(
                            data['taskStatus'] ?? '',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                          backgroundColor: _statusColor(data['taskStatus']),
                        ),
                        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        children: [
                          _detailRow(Icons.work, 'Department', data['department']),
                          _detailRow(Icons.flag, 'Challenge', data['challenge']),
                          _detailRow(Icons.comment, 'Comments', data['comments']),
                          _detailRow(Icons.access_time, 'Hours', data['hours']),
                          _detailRow(Icons.star, 'Rating', data['rating']?.toString()),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String? status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'In Progress':
        return Colors.orange;
      case 'Uncompleted':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _detailRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.deepPurple),
          const SizedBox(width: 8),
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value ?? '-', style: TextStyle(color: Colors.grey.shade800)),
          ),
        ],
      ),
    );
  }
}
