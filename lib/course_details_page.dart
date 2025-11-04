// lib/course_details_page.dart
import 'package:flutter/material.dart';
import 'package:excelerate/models/course_model.dart';

class CourseDetailsPage extends StatefulWidget {
  final Course course;
  final List<Course> allCourses;

  const CourseDetailsPage({super.key, required this.course, required this.allCourses});

  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Course course;

  @override
  void initState() {
    super.initState();
    course = widget.course;
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool _isStarted() => course.lessonsList.any((l) => l['status'] != 'Locked');

  bool _isCompleted() => course.lessonsList.isNotEmpty && course.lessonsList.every((l) => l['status'] == 'Completed');

  double _progressValue() {
    final total = course.lessonsList.length;
    if (total == 0) return 0.0;
    final completed = course.lessonsList.where((l) => l['status'] == 'Completed').length;
    return completed / total;
  }

  void _startCourse() {
    setState(() {
      if (course.lessonsList.isNotEmpty && course.lessonsList.every((l) => l['status'] == 'Locked')) {
        course.lessonsList[0]['status'] = 'In Progress';
      }
    });
  }

  void _toggleSaveCourse() {
    setState(() {
      course.isSaved = !course.isSaved;
    });
  }

  void _completeLesson(int index) {
    if (course.lessonsList[index]['status'] == 'Locked') return;

    setState(() {
      course.lessonsList[index]['status'] = 'Completed';

      // Unlock next lesson
      if (index + 1 < course.lessonsList.length &&
          course.lessonsList[index + 1]['status'] == 'Locked') {
        Future.delayed(const Duration(milliseconds: 120), () {
          setState(() {
            course.lessonsList[index + 1]['status'] = 'In Progress';
          });
        });
      }

     
    });
  }

  // void _unlockNextCourse() {
  //   final idx = widget.allCourses.indexWhere((c) => c.id == course.id);
  //   if (idx != -1 && idx + 1 < widget.allCourses.length) {
  //     final next = widget.allCourses[idx + 1];
  //     if (next.lessonsList.isNotEmpty && next.lessonsList[0]['status'] == 'Locked') {
  //       Future.delayed(const Duration(milliseconds: 200), () {
  //         setState(() {
  //           next.lessonsList[0]['status'] = 'In Progress';
  //         });
  //       });
  //     }
  //   }
  // }

  Widget _buildHeader() {
    Color color = course.category == 'Web Development'
        ? Colors.blue
        : course.category == 'Mobile Development'
            ? Colors.orange
            : course.category == 'Design'
                ? Colors.green
                : Colors.red;

    return Stack(
      children: [
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(color: color),
          child: Center(child: Text(course.icon, style: const TextStyle(fontSize: 70))),
        ),
        Positioned(
          top: 16,
          left: 16,
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_sharp, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
          child: Text(course.category, style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
        ),
        const SizedBox(height: 8),
        Text(course.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(
          children: [
            CircleAvatar(backgroundColor: Colors.grey.shade300, radius: 18),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
              Text('Alex Johnson', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              Text('Instructor', style: TextStyle(fontSize: 13, color: Colors.grey)),
            ])
          ],
        ),
      ],
    );
  }

  Widget _buildStartOrSaveSection() {
    final notStarted = course.lessonsList.every((l) => l['status'] == 'Locked');
    final started = _isStarted();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        notStarted
            ? SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _startCourse,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent, foregroundColor: Colors.white,),
                  child: const Text('Start Course'),
                ),
              )
            : Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _toggleSaveCourse,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent, foregroundColor: Colors.white,),
                      child: Text(course.isSaved ? 'Unsave' : 'Save Course'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (started)
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        key: ValueKey('prog-${course.id}-${course.lessonsList.hashCode}'),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('${(_progressValue() * 100).round()}%'),
                      ),
                    ),
                ],
              ),
        const SizedBox(height: 12),
        // Metadata below buttons
        Wrap(
          spacing: 10,
          runSpacing: 4,
          children: [
            Text('⭐️ ${course.rating} (${course.reviews} reviews)', style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
            Text('👥 ${course.numStudents} students', style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
            Text('⏰ ${course.totalTime} hours', style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
            Text('📱 Mobile & Desktop', style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
            if (course.isSaved) Text('Saved', style: TextStyle(color: Colors.pinkAccent, fontSize: 13)),
            if (_isStarted()) Text(_isCompleted() ? 'Completed' : 'In Progress', style: TextStyle(color: Colors.orange, fontSize: 13)),
          ],
        ),
      ],
    );
  }

  Widget _lessonsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: course.lessonsList.length,
      itemBuilder: (context, index) {
        final lesson = course.lessonsList[index];
        final status = lesson['status'] as String;
        final locked = status == 'Locked';
        final inProgress = status == 'In Progress';
        final completed = status == 'Completed';

        Color bg = Colors.grey.shade100;
        if (completed) bg = Colors.green.shade50;
        if (inProgress) bg = Colors.orange.shade50;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              CircleAvatar(radius: 14, backgroundColor: Colors.white, child: Text('${index + 1}', style: const TextStyle(fontWeight: FontWeight.w600))),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lesson['title'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(
                      locked
                          ? 'Locked'
                          : completed
                              ? 'Completed'
                              : inProgress
                                  ? 'In Progress'
                                  : '',
                      style: TextStyle(
                        color: locked ? Colors.grey.shade600 : completed ? Colors.green : Colors.orange,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              if (!locked)
                ElevatedButton(
                  onPressed: completed ? null : () => _completeLesson(index),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                  child: const Text('Done'),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _aboutTab() => Padding(padding: const EdgeInsets.all(16), child: Text(course.description));

  Widget _reviewsTab() => Center(child: Text('Reviews coming soon...', style: TextStyle(color: Colors.grey.shade600)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff9fafb),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCourseInfo(),
                    const SizedBox(height: 12),
                    _buildStartOrSaveSection(),
                    const SizedBox(height: 12),
                    TabBar(
                      controller: _tabController,
                      labelColor: Colors.pinkAccent,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.pinkAccent,
                      tabs: const [
                        Tab(text: 'Lessons'),
                        Tab(text: 'About'),
                        Tab(text: 'Reviews'),
                      ],
                    ),
                    SizedBox(
                      height: 500,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _lessonsTab(),
                          _aboutTab(),
                          _reviewsTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
