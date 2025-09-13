import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:task_tracker_mobile_app/features/admin_panel/All_Employee_Task_Screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late Future<List<_DepartmentTaskData>> departmentTasks;
  late Future<List<_DepartmentRatingData>> departmentRatings;
  late Future<List<_FlaggedIssueData>> flaggedIssues;
  late Future<int> totalTasks;

  @override
  void initState() {
    super.initState();
    departmentTasks = fetchTasksByDepartment();
    departmentRatings = fetchAverageRatingByDepartment();
    flaggedIssues = fetchFlaggedIssues();
    totalTasks = fetchTotalTaskCount();
  }

  Future<int> fetchTotalTaskCount() async {
    final snapshot = await _firestore.collection('user_tasks').get();
    return snapshot.docs.length;
  }

  Future<List<_DepartmentTaskData>> fetchTasksByDepartment() async {
    final snapshot = await _firestore.collection('user_tasks').get();
    final Map<String, int> departmentCounts = {};

    for (var doc in snapshot.docs) {
      final department = doc['department'] as String;
      departmentCounts[department] = (departmentCounts[department] ?? 0) + 1;
    }

    return departmentCounts.entries
        .map((e) => _DepartmentTaskData(e.key, e.value))
        .toList();
  }

  Future<List<_DepartmentRatingData>> fetchAverageRatingByDepartment() async {
    final snapshot = await _firestore.collection('user_tasks').get();
    final Map<String, List<double>> ratingMap = {};

    for (var doc in snapshot.docs) {
      final department = doc['department'] as String;
      final ratingValue = doc['rating'];
      final rating = ratingValue is int
          ? ratingValue.toDouble()
          : (ratingValue is double
          ? ratingValue
          : double.tryParse(ratingValue.toString()) ?? 0.0);
      ratingMap.putIfAbsent(department, () => []).add(rating);
    }

    return ratingMap.entries.map((entry) {
      final avg = entry.value.reduce((a, b) => a + b) / entry.value.length;
      return _DepartmentRatingData(entry.key, double.parse(avg.toStringAsFixed(1)));
    }).toList();
  }

  Future<List<_FlaggedIssueData>> fetchFlaggedIssues() async {
    final snapshot = await _firestore.collection('user_tasks').get();
    final Map<String, int> flaggedMap = {};

    for (var doc in snapshot.docs) {
      final name = doc['name'] as String;
      final status = doc['taskStatus'] as String;

      if (status.toLowerCase() != 'completed') {
        flaggedMap[name] = (flaggedMap[name] ?? 0) + 1;
      }
    }

    final sorted = flaggedMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.map((e) => _FlaggedIssueData(e.key, e.value)).toList();
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
            'Admin Dashboard',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Colors.white
            ),
          ),
          centerTitle: true,
          elevation: 6,
          backgroundColor: Colors.transparent,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FutureBuilder<int>(
              future: totalTasks,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Text(
                  '📦 Total Tasks: ${snapshot.data}',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4A148C)),
                );
              },
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<_DepartmentTaskData>>(
              future: departmentTasks,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                return _buildCard(
                  title: '📊 Tasks by Department',
                  chart: SfCircularChart(
                    legend: const Legend(isVisible: true),
                    series: <PieSeries<_DepartmentTaskData, String>>[
                      PieSeries<_DepartmentTaskData, String>(
                        dataSource: snapshot.data!,
                        xValueMapper: (data, _) => data.department,
                        yValueMapper: (data, _) => data.tasks,
                        // Default labels inside slices
                        dataLabelSettings: const DataLabelSettings(isVisible: true),
                      )
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
            FutureBuilder<List<_DepartmentRatingData>>(
              future: departmentRatings,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                return _buildCard(
                  title: '⭐ Avg Rating by Dept',
                  chart: SfCartesianChart(
                    primaryXAxis: CategoryAxis(
                      labelRotation: 45,
                      interval: 1,
                      labelStyle: const TextStyle(fontSize: 12),
                    ),
                    primaryYAxis: NumericAxis(
                      minimum: 0,
                      maximum: 5,
                      interval: 1,
                      labelFormat: '{value}',
                    ),
                    series: <ColumnSeries<_DepartmentRatingData, String>>[
                      ColumnSeries<_DepartmentRatingData, String>(
                        dataSource: snapshot.data!,
                        xValueMapper: (data, _) => data.department,
                        yValueMapper: (data, _) => data.rating,
                        dataLabelSettings: const DataLabelSettings(isVisible: true),
                      )
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<_FlaggedIssueData>>(
              future: flaggedIssues,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                return _buildCard(
                  title: '🚩 Top Flagged Users',
                  chart: SfCartesianChart(
                    primaryXAxis: CategoryAxis(
                      labelRotation: 45,
                      interval: 1,
                      labelStyle: const TextStyle(fontSize: 12),
                    ),
                    series: <BarSeries<_FlaggedIssueData, String>>[
                      BarSeries<_FlaggedIssueData, String>(
                        dataSource: snapshot.data!,
                        xValueMapper: (data, _) => data.name,
                        yValueMapper: (data, _) => data.issues,
                        dataLabelSettings: const DataLabelSettings(isVisible: true),
                      )
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AllEmployeeTasksScreen(),
                  ),
                );
              },
              child: Container(
                height: 60,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6A1B9A), Color(0xFFD81B60)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.list, color: Colors.white),
                    SizedBox(width: 12),
                    Text(
                      'View All Tasks',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required Widget chart}) {
    return Card(
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A148C),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(height: 250, child: chart),
          ],
        ),
      ),
    );
  }
}

class _DepartmentTaskData {
  final String department;
  final int tasks;
  _DepartmentTaskData(this.department, this.tasks);
}

class _DepartmentRatingData {
  final String department;
  final double rating;
  _DepartmentRatingData(this.department, this.rating);
}

class _FlaggedIssueData {
  final String name;
  final int issues;
  _FlaggedIssueData(this.name, this.issues);
}
