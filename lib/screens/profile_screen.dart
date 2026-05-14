import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      body: CustomScrollView(
        slivers: [
          // Hero header
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFF7B6CF6),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF7B6CF6), Color(0xFF9D8FF8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      // Avatar with initials
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            // TODO: Replace with your own initials
                            'ARS',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF7B6CF6),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Full name - TODO: Replace with your own name
                      const Text(
                        'ATABONGFAC RODELLE STEPHANIE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Student ID - TODO: Replace with your real ID
                      const Text(
                        'Student ID: LMUI250707',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Programme card
                  _infoCard(
                    icon: Icons.school_rounded,
                    title: 'Programme / Department',
                    // TODO: Replace with your real programme
                    value:
                        'BSc Software Engineering\nFaculty of Engineering and Technology',
                  ),
                  const SizedBox(height: 14),

                  // Bio card
                  _sectionCard(
                    title: 'About Me',
                    icon: Icons.person_rounded,
                    child: const Text(
                      // TODO: Replace with your own bio (2-3 sentences)
                      'I am a passionate software engineering student with a strong interest in mobile development and human-computer interaction. '
                      'I enjoy building elegant, user-friendly applications that solve real-world problems. '
                      'In my spare time, I contribute to open-source projects and explore new technologies.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF444466),
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Goals card
                  _sectionCard(
                    title: 'Semester Goals',
                    icon: Icons.flag_rounded,
                    child: Column(
                      children: [
                        // TODO: Replace with your own semester goals
                        _goalItem(
                          number: '01',
                          goal:
                              'Complete all Flutter exercises and achieve a minimum grade of 70%',
                        ),
                        const SizedBox(height: 12),
                        _goalItem(
                          number: '02',
                          goal:
                              'Build and publish a personal mobile app on the Play Store before the year ends',
                        ),
                        const SizedBox(height: 12),
                        _goalItem(
                          number: '03',
                          goal:
                              'Improve my problem-solving skills by solving at least 1 coding challenges per week',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Quick stats
                  _sectionCard(
                    title: 'Quick Stats',
                    icon: Icons.bar_chart_rounded,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _quickStat('Level', '400'),
                        _verticalDivider(),
                        _quickStat('Year', '4th'),
                        _verticalDivider(),
                        _quickStat('Semester', '2nd'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7B6CF6).withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF7B6CF6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF7B6CF6), size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF7B6CF6),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1A1A2E),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7B6CF6).withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF7B6CF6), size: 16),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF7B6CF6),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _goalItem({required String number, required String goal}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF7B6CF6), Color(0xFF9D8FF8)],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            goal,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF444466),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _quickStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF7B6CF6),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget _verticalDivider() {
    return Container(height: 35, width: 1, color: Colors.grey.shade200);
  }
}
