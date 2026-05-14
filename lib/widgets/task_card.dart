import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onToggleComplete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onToggleComplete,
  });

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
      !task.isCompleted && task.dueDate.isBefore(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final priorityColor = _priorityColor(task.priority);
    final overdue = _isOverdue;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: overdue
              ? Border.all(color: const Color(0xFFFF5C5C), width: 1.5)
              : null,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7B6CF6).withOpacity(0.07),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7B6CF6).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _categoryIcon(task.category),
                      color: const Color(0xFF7B6CF6),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: task.isCompleted
                            ? Colors.grey
                            : const Color(0xFF1A1A2E),
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onToggleComplete,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: task.isCompleted
                            ? const Color(0xFF7B6CF6)
                            : Colors.transparent,
                        border: Border.all(
                          color: task.isCompleted
                              ? const Color(0xFF7B6CF6)
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: task.isCompleted
                          ? const Icon(Icons.check,
                              color: Colors.white, size: 14)
                          : null,
                    ),
                  ),
                ],
              ),
              if (task.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  task.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    height: 1.4,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  // Status chip
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: task.isCompleted
                          ? const Color(0xFF26C281).withOpacity(0.12)
                          : overdue
                              ? const Color(0xFFFF5C5C).withOpacity(0.12)
                              : const Color(0xFF7B6CF6).withOpacity(0.10),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: task.isCompleted
                                ? const Color(0xFF26C281)
                                : overdue
                                    ? const Color(0xFFFF5C5C)
                                    : const Color(0xFF7B6CF6),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          task.isCompleted
                              ? 'Done'
                              : overdue
                                  ? 'Overdue'
                                  : 'Ongoing',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: task.isCompleted
                                ? const Color(0xFF26C281)
                                : overdue
                                    ? const Color(0xFFFF5C5C)
                                    : const Color(0xFF7B6CF6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Priority chip
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: priorityColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.flag_rounded,
                            size: 11, color: priorityColor),
                        const SizedBox(width: 4),
                        Text(
                          task.priority,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: priorityColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Due date
                  Icon(Icons.calendar_today_rounded,
                      size: 12, color: Colors.grey.shade400),
                  const SizedBox(width: 4),
                  Text(
                    '${task.dueDate.day} ${_monthName(task.dueDate.month)}',
                    style: TextStyle(
                      fontSize: 11,
                      color: overdue
                          ? const Color(0xFFFF5C5C)
                          : Colors.grey.shade400,
                      fontWeight:
                          overdue ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}