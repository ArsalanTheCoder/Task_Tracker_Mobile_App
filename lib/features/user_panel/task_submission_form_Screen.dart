import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class TaskSubmissionForm extends StatefulWidget {
  const TaskSubmissionForm({super.key});

  @override
  State<TaskSubmissionForm> createState() => _TaskSubmissionFormState();
}

class _TaskSubmissionFormState extends State<TaskSubmissionForm> {
  String? selectedDepartment;
  String? selectedHours;
  String? selectedCompletionStatus;

  final List<String> departmentItems = [
    'Mobile Development', 'SEO', 'Frontend', 'Backend', 'Web Development','HR'
  ];
  final List<String> hourItems = List.generate(12, (i) => '${i + 1}');
  final List<String> taskCompletionItems = [
    'Completed', 'In Progress', 'Uncompleted','Overdue'
  ];

  final userNameController = TextEditingController();
  final taskCompletedController = TextEditingController();
  final challengesController = TextEditingController();
  final commentsController = TextEditingController();

  String currentDate = '';
  int rating = 0;

  @override
  void initState() {
    super.initState();
    currentDate = DateFormat('dd MMMM yyyy').format(DateTime.now());
  }

  void clearFields() {
    userNameController.clear();
    taskCompletedController.clear();
    challengesController.clear();
    commentsController.clear();
    setState(() {
      selectedDepartment = null;
      selectedHours = null;
      selectedCompletionStatus = null;
      rating = 0;
    });
  }

  void showSuccessDialogBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF8E24AA), Color(0xFFD81B60)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.transparent,
                    child: Icon(
                      Icons.check_rounded,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Success!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8E24AA),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Your task has been submitted successfully.",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 48),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8E24AA), Color(0xFFD81B60)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8E24AA).withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Text(
                      "Go Back",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> addUserData() async {
    final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    if (uid == null) return;

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    try {
      // final existing = await firestore
      //     .collection('user_tasks')
      //     .where('uid', isEqualTo: uid)
      //     .where('date', isEqualTo: today)
      //     .get();
      //
      // if (existing.docs.isNotEmpty) {
      //   Flushbar(
      //     title: "Already Submitted",
      //     message: "You've already submitted your task today.",
      //     duration: const Duration(seconds: 3),
      //     backgroundColor: Colors.orange,
      //     icon: const Icon(Icons.info, color: Colors.white),
      //     flushbarPosition: FlushbarPosition.TOP,
      //     borderRadius: BorderRadius.circular(12),
      //     margin: const EdgeInsets.all(12),
      //   ).show(navigatorKey.currentContext!);
      //   return;
      // }

      await firestore.collection('user_tasks').add({
        "uid": uid,
        "date": today,
        "timestamp": FieldValue.serverTimestamp(),
        "name": userNameController.text.trim(),
        "department": selectedDepartment,
        "taskSummary": taskCompletedController.text.trim(),
        "challenge": challengesController.text.trim(),
        "hours": selectedHours,
        "taskStatus": selectedCompletionStatus,
        "comments": commentsController.text.trim(),
        "rating": rating
      });
    } catch (e) {
        Flushbar(
          title: "Opps",
          message: "Data Failed to save $e",
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.orange,
          icon: const Icon(Icons.info, color: Colors.white),
          flushbarPosition: FlushbarPosition.TOP,
          borderRadius: BorderRadius.circular(12),
          margin: const EdgeInsets.all(12),
        ).show(navigatorKey.currentContext!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
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
            'Daily Task Submission',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCard(
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.deepPurple),
                  const SizedBox(width: 12),
                  const Text('Today\'s Date:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.deepPurple)),
                  const Spacer(),
                  Text(currentDate, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            _buildCard(child: customDropDownButton(label: 'Select Department', items: departmentItems, selectedValue: selectedDepartment ?? '', onChanged: (val) => setState(() => selectedDepartment = val))),
            _buildCard(child: customTextField('Name', userNameController)),
            _buildCard(child: customTextField("Today's task summary", taskCompletedController)),
            _buildCard(child: customTextField('Challenges Faced (Optional)', challengesController)),
            Row(
              children: [
                Expanded(child: _buildCard(child: customDropDownButton(label: 'Select Hours', items: hourItems, selectedValue: selectedHours ?? '', onChanged: (val) => setState(() => selectedHours = val)))),
                const SizedBox(width: 8),
                Expanded(child: _buildCard(child: customDropDownButton(label: 'Select Progress', items: taskCompletionItems, selectedValue: selectedCompletionStatus ?? '', onChanged: (val) => setState(() => selectedCompletionStatus = val)))),
              ],
            ),
            const SizedBox(height: 8),
            _buildCard(
              child: TextField(
                controller: commentsController,
                maxLines: 5,
                decoration: InputDecoration(
                    hintText: 'Write your comments...'
                ),
              ),
            ),
            _buildCard(
              child: Row(
                children: [
                  const Text('Rate Yourself:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 12),
                  Row(
                    children: List.generate(
                      5,
                          (i) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1),
                        child: InkWell(
                          onTap: () => setState(() => rating = i + 1),
                          child: Icon(i < rating ? Icons.star : Icons.star_border, color: Colors.amber),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () async {
                final name = userNameController.text.trim();
                final task = taskCompletedController.text.trim();

                if (name.isEmpty || task.isEmpty || selectedDepartment == null || selectedHours == null || selectedCompletionStatus == null) {
                  Flushbar(
                    title: "Hi, there!",
                    message: 'Please fill all required fields.',
                    duration: const Duration(seconds: 3),
                    backgroundColor: Colors.redAccent,
                    icon: const Icon(Icons.error_outline, color: Colors.white),
                    flushbarPosition: FlushbarPosition.TOP,
                    borderRadius: BorderRadius.circular(12),
                    margin: const EdgeInsets.all(12),
                  ).show(context);
                  return;
                }

                await addUserData();
                showSuccessDialogBox(context);
                clearFields();
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8E24AA), Color(0xFFD81B60)],
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
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.send, color: Colors.white),
                    SizedBox(width: 12),
                    Text('Submit Task', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(padding: const EdgeInsets.all(12), child: child),
    );
  }
}

Widget customTextField(String label, TextEditingController controller) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}

Widget customDropDownButton({
  required String label,
  required List<String> items,
  required String selectedValue,
  required Function(String?) onChanged,
}) {
  return DropdownButtonFormField<String>(
    value: selectedValue.isEmpty ? null : selectedValue,
    isExpanded: true,
    decoration: InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
    ),
    onChanged: onChanged,
    items: items.map((String item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList(),
  );
}
