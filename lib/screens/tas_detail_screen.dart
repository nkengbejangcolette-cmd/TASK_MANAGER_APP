import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late Task _task;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
  }

  Color _priorityColor(String priority) {
    switch (priority) {
      case 'High':
        return const Color(0xFFFF5C5C);
      case 'Medium':
        return const Color(0xFFFF9F43);
      default:
        return const Color(0xFF26C281);
    }
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'School':
        return Icons.school_rounded;
      case 'Health':
        return Icons.favorite_rounded;
      case 'Work':
        return Icons.work_rounded;
      case 'Personal':
        return Icons.person_rounded;
      default:
        return Icons.label_rounded;
    }
  }

  bool get _isOverdue =>
      !_task.isCompleted && _task.dueDate.isBefore(DateTime.now());

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'Delete Task',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to delete "${_task.title}"? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF7B6CF6)),
            ),
          ),
          TextButton(
            onPressed: () {
              widget.onDelete();
              Navigator.pop(context); // close dialog
              Navigator.pop(context, true); // go back to list
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Color(0xFFFF5C5C)),
            ),
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  String _dayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final priorityColor = _priorityColor(_task.priority);
    final overdue = _isOverdue;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      body: CustomScrollView(
        slivers: [
          // Hero AppBar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: const Color(0xFF7B6CF6),
            leading: GestureDetector(
              onTap: () => Navigator.pop(context, true),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  widget.onEdit();
                  Navigator.pop(context, true);
                },
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Edit',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
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
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _categoryIcon(_task.category),
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _task.category,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _task.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Body content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status row
                  Row(
                    children: [
                      _infoChip(
                        label: _task.isCompleted
                            ? 'Completed'
                            : overdue
                            ? 'Overdue'
                            : 'In Progress',
                        color: _task.isCompleted
                            ? const Color(0xFF26C281)
                            : overdue
                            ? const Color(0xFFFF5C5C)
                            : const Color(0xFF7B6CF6),
                        icon: _task.isCompleted
                            ? Icons.check_circle_rounded
                            : overdue
                            ? Icons.warning_rounded
                            : Icons.radio_button_unchecked_rounded,
                      ),
                      const SizedBox(width: 10),
                      _infoChip(
                        label: _task.priority,
                        color: priorityColor,
                        icon: Icons.flag_rounded,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Description card
                  _sectionCard(
                    title: 'Description',
                    icon: Icons.notes_rounded,
                    child: Text(
                      _task.description.isEmpty
                          ? 'No description provided.'
                          : _task.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: _task.description.isEmpty
                            ? Colors.grey.shade400
                            : const Color(0xFF444466),
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Due date card
                  _sectionCard(
                    title: 'Due Date',
                    icon: Icons.calendar_today_rounded,
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: overdue
                                ? const Color(0xFFFF5C5C).withOpacity(0.1)
                                : const Color(0xFF7B6CF6).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _task.dueDate.day.toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: overdue
                                      ? const Color(0xFFFF5C5C)
                                      : const Color(0xFF7B6CF6),
                                ),
                              ),
                              Text(
                                _monthName(_task.dueDate.month),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: overdue
                                      ? const Color(0xFFFF5C5C)
                                      : const Color(0xFF7B6CF6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_dayName(_task.dueDate.weekday)}, ${_task.dueDate.day} ${_monthName(_task.dueDate.month)} ${_task.dueDate.year}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A1A2E),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              overdue
                                  ? 'This task is overdue!'
                                  : _task.isCompleted
                                  ? 'Completed on time'
                                  : 'Coming up soon',
                              style: TextStyle(
                                fontSize: 12,
                                color: overdue
                                    ? const Color(0xFFFF5C5C)
                                    : Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Toggle complete button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() => _task.isCompleted = !_task.isCompleted);
                      },
                      icon: Icon(
                        _task.isCompleted
                            ? Icons.undo_rounded
                            : Icons.check_circle_rounded,
                        size: 20,
                      ),
                      label: Text(
                        _task.isCompleted
                            ? 'Mark as Incomplete'
                            : 'Mark as Complete',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _task.isCompleted
                            ? Colors.grey.shade200
                            : const Color(0xFF7B6CF6),
                        foregroundColor: _task.isCompleted
                            ? Colors.grey.shade600
                            : Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Delete button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _confirmDelete,
                      icon: const Icon(Icons.delete_rounded, size: 20),
                      label: const Text(
                        'Delete Task',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFFF5C5C),
                        side: const BorderSide(
                          color: Color(0xFFFF5C5C),
                          width: 1.5,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
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

  Widget _infoChip({
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
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
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF7B6CF6),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
