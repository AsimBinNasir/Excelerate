import 'package:excelerate/models/courseModel.dart';
import 'package:flutter/material.dart';

class CourseDetailsPage extends StatefulWidget {
  final Course course;
  const CourseDetailsPage({super.key, required this.course});

  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final course = widget.course;

    return Scaffold(
      backgroundColor: const Color(0xfff9fafb),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header with image and backbutton
              Stack(
                children: [
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: course.category == 'Web Development'
                          ? Colors.blue
                          : course.category == 'Mobile Development'
                          ? Colors.orange
                          : course.category == 'Design'
                          ? Colors.green
                          : Colors.red,
                    ),
                    child: Center(
                      child: Text(course.icon, style: TextStyle(fontSize: 70)),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back_sharp, color: Colors.white),
                    ),
                  ),
                ],
              ),

              // Course info
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        course.category,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      course.title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Instructor detail
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey.shade300,
                          radius: 18,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Alex Johnson',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            /* 
                            Text(course.instructor ?? 'Unknown instructor', style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),)
                            */
                            Text(
                              'Instructor',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            /* 
                            Text(course.role ?? 'Instructor', style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),)
                            */
                          ],
                        ),
                        const SizedBox(height: 12),

                        Text(
                          '⭐️ ${course.rating} (${course.reviews} reviews)',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 13,
                          ),
                        ),

                        Row(
                          children: [
                            Text(
                              '👥 ${course.numStudents} students',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '⏰ ${course.totalTime} hours',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        Text(
                          '📱 Mobile & Desktop',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),

                    // Tabs
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

                    // Tab content
                    SizedBox(
                      height: 500,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _lessonsTab(course),
                          _aboutTab(course),
                          _reviewsTab(course),
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

  // Lessons Tab
  Widget _lessonsTab(Course course) {
    return ListView.builder(
      itemCount: course.lessonsList.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final lesson = course.lessonsList[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: Colors.white,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson['title'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          lesson['duration'],
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _statusChip(lesson['status']),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // About tab
  Widget _aboutTab(Course course) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(course.description),
    );
  }

  // Review tab
  Widget _reviewsTab(Course course) {
    return Center(
      child: Text(
        'Reviews coming soon...',
        style: TextStyle(color: Colors.grey.shade600),
      ),
    );
  }

  // Status chip
  Widget _statusChip(String status) {
    Color color;
    IconData icon;

    switch (status) {
      case 'Completed':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'In Progress':
        color = Colors.orange;
        icon = Icons.play_circle;
        break;
      default:
        color = Colors.grey;
        icon = Icons.lock;
    }

    return Row(
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 4),
        Text(
          status,
          style: TextStyle(
            fontSize: 14,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
