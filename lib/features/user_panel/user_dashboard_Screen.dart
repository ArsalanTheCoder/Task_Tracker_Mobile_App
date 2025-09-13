import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:task_tracker_mobile_app/features/user_panel/task_submission_form_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'CurrentUserHistorySubmission.dart';
import 'package:fl_chart/fl_chart.dart';


class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({super.key});

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  Future<String> fetchUserName() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance.collection('users_decision').doc(uid).get();
    return doc.data()?['Name'] ?? 'User';
  }

  @override
  Widget build(BuildContext context) {
    final String uid = FirebaseAuth.instance.currentUser!.uid;

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
            'User Dashboard',
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
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome section
            FutureBuilder<String>(
              future: fetchUserName(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text(
                    "Hi,\nWelcome back!",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  );
                } else if (snapshot.hasError) {
                  return Text(
                    "Hi there,\nWelcome!",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  );
                }

                final name = snapshot.data!;
                return Text(
                    "Hi 👋 $name,\nWelcome back!",

                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                );
              },
            ),

            SizedBox(height: 20),

            // Daily Task Submission Card
            Stack(
              children: [
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient:
                      LinearGradient(colors: [Colors.deepPurple, Colors.purple]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Daily Task Submission",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text("Submit your daily task and track your productivity.",
                            style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  bottom: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => TaskSubmissionForm()),
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.add, color: Colors.deepPurple),
                    ),
                  ),
                ),
              ],
            ),
             SizedBox(height: 30),

            ProgressGraphs(userId: uid),

            SizedBox(height: 30),

            // Recent Tasks
            Text("Recent Submissions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('user_tasks')
                  .where('uid', isEqualTo: uid)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text("No recent submissions found.");
                }

                final tasks = snapshot.data!.docs.take(3).toList();
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final item = tasks[index].data() as Map<String, dynamic>;
                    final DateTime timestamp =
                    (item['timestamp'] as Timestamp).toDate();
                    final formattedDate =
                        "${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')} • ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}";
                   final  title =
                        item['name'] ?? item['taskSummary'] ?? "No task title";

                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepPurple.shade100,
                          child: Icon(Icons.task_alt, color: Colors.deepPurple),
                        ),
                        title: Text(title,
                            style:
                            TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                        subtitle: Text(formattedDate,
                            style: TextStyle(color: Colors.grey.shade600)),
                        trailing: Chip(
                          label: Text("Submitted",
                              style: TextStyle(color: Colors.white)),
                          backgroundColor: Colors.green,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AllUserSubmissionsScreen()),
                  );
                },
                icon: Icon(Icons.history),
                label: Text("View All Submissions"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// 🟢 Flutter code for displaying 3 real-time graphs based on Firestore data

class ProgressGraphs extends StatefulWidget {
  final String userId;
  const ProgressGraphs({super.key, required this.userId});

  @override
  State<ProgressGraphs> createState() => _ProgressGraphsState();
}

class _ProgressGraphsState extends State<ProgressGraphs> {
  int currentGraphIndex = 0;

  final List<String> graphTitles = [
    'Number of Tasks vs Date',
    'Time Spent per Task vs Date',
    'Task Duration Types'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "📊 ${graphTitles[currentGraphIndex]}",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12),
        Container(
          height: 250,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('user_tasks') // your real collection
                .where('uid', isEqualTo: widget.userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              final data = snapshot.data!.docs;

              if (data.isEmpty)
                return Center(child: Text("No task data available"));

              if (currentGraphIndex == 0) {
                return  _buildTimeSpentPerTask(data);
              } else if (currentGraphIndex == 1) {
                return  _buildTasksPerDateChart(data);
              } else {
                return _buildTimeCategoryComparison(data);
              }
            },
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              setState(() {
                currentGraphIndex = (currentGraphIndex + 1) % 3;
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Next Graph"),
                Icon(Icons.arrow_forward_ios, size: 16)
              ],
            ),
          ),
        )
      ],
    );
  }

  /// Graph 1: Tasks per date
  Widget _buildTasksPerDateChart(List<QueryDocumentSnapshot> data) {
    Map<String, int> taskCount = {};

    for (var doc in data) {
      final dateStr = doc['date']; // Use Firestore's date field directly
      if (dateStr != null && dateStr is String) {
        taskCount[dateStr] = (taskCount[dateStr] ?? 0) + 1;
      }
    }

    final sortedEntries = taskCount.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return BarChart(
      BarChartData(
        barGroups: sortedEntries.asMap().entries.map((entry) {
          final index = entry.key;
          final date = entry.value.key;
          final count = entry.value.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: count.toDouble(),
                color: Colors.indigo,
                width: 16,
                borderRadius: BorderRadius.circular(6),
              )
            ],
          );
        }).toList(),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                final i = value.toInt();
                if (i >= 0 && i < sortedEntries.length) {
                  return Text(
                    DateFormat('MMM d').format(DateTime.parse(sortedEntries[i].key)),
                    style: TextStyle(fontSize: 10),
                  );
                }
                return SizedBox.shrink();
              },
              interval: 1,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 28),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  /// Graph 2: Time spent per task vs date (using "hours" field)
  Widget _buildTimeSpentPerTask(List<QueryDocumentSnapshot> data) {
    final validData = data
        .where((doc) => doc.data().toString().contains('hours'))
        .toList()
      ..sort((a, b) => a['date'].compareTo(b['date']));

    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int i = value.toInt();
                if (i >= 0 && i < validData.length) {
                  try {
                    final dateStr = validData[i]['date']; // assuming format: yyyy-MM-dd
                    final parsedDate = DateFormat('yyyy-MM-dd').parse(dateStr);
                    final formatted = DateFormat('d MMM').format(parsedDate); // e.g. 24 Jul
                    return Text(formatted, style: const TextStyle(fontSize: 10));
                  } catch (e) {
                    return const Text('');
                  }
                }
                return const Text('');
              },
              interval: 1,
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(validData.length, (i) {
              final hours = double.tryParse(validData[i]['hours'].toString()) ?? 0;
              return FlSpot(i.toDouble(), hours);
            }),
            isCurved: true,
            color: Colors.green,
            belowBarData: BarAreaData(
              show: true,
              color: Colors.green.withOpacity(0.3),
            ),
          )
        ],
      ),
    );
  }


  /// Graph 3: Task Time Categories
  Widget _buildTimeCategoryComparison(List<QueryDocumentSnapshot> data) {
    int short = 0,
        medium = 0,
        long = 0;

    for (var doc in data) {
      final raw = doc['hours']; // ✅ fixed field name
      double time = double.tryParse(raw.toString()) ?? 0;

      if (time < 2) {
        short++;
      } else if (time < 6) {
        medium++;
      } else {
        long++;
      }
    }

    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: short.toDouble(),
            title: 'Short (<1h)',
            color: Colors.teal,
            radius: 50,
          ),
          PieChartSectionData(
            value: medium.toDouble(),
            title: 'Medium (2-6h)',
            color: Colors.orange,
            radius: 50,
          ),
          PieChartSectionData(
            value: long.toDouble(),
            title: 'Long (>6h)',
            color: Colors.purple,
            radius: 50,
          ),
        ],
      ),
    );
  }
}
