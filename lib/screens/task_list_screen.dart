import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_card.dart';
import './tas_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<Task> _tasks = [
    Task(
      title: 'Website Design',
      description:
          'Create wireframes and high-fidelity mockups for the client project.',
      category: 'Work',
      priority: 'High',
      dueDate: DateTime.now().add(const Duration(days: 3)),
    ),
    Task(
      title: 'Study Flutter Navigation',
      description:
          'Research Navigator.push, named routes and passing arguments between screens.',
      category: 'School',
      priority: 'High',
      dueDate: DateTime.now().add(const Duration(days: 1)),
    ),
    Task(
      title: 'Morning Jog',
      description: 'Run 5km before 7am every weekday this week.',
      category: 'Health',
      priority: 'Medium',
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Task(
      title: 'Read Clean Code',
      description: 'Finish chapters 5 to 8 of the Clean Code book.',
      category: 'Personal',
      priority: 'Low',
      dueDate: DateTime.now().add(const Duration(days: 7)),
    ),
  ];

  String _filter = 'All';
  String _searchQuery = '';
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _sortBy = 'Due Date';

  // Form controllers
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedCategory = 'School';
  String _selectedPriority = 'Medium';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));

  List<Task> get _filteredTasks {
    List<Task> tasks = List.from(_tasks);

    if (_filter == 'Pending') {
      tasks = tasks.where((t) => !t.isCompleted).toList();
    } else if (_filter == 'Completed') {
      tasks = tasks.where((t) => t.isCompleted).toList();
    }

    if (_searchQuery.isNotEmpty) {
      tasks = tasks
          .where(
            (t) => t.title.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    if (_sortBy == 'Due Date') {
      tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    } else if (_sortBy == 'Priority') {
      const order = {'High': 0, 'Medium': 1, 'Low': 2};
      tasks.sort(
        (a, b) => (order[a.priority] ?? 2).compareTo(order[b.priority] ?? 2),
      );
    }

    return tasks;
  }

  int get _completedCount => _tasks.where((t) => t.isCompleted).length;
  int get _pendingCount => _tasks.where((t) => !t.isCompleted).length;
  double get _progress => _tasks.isEmpty ? 0 : _completedCount / _tasks.length;

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'Sort Tasks',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Due Date', 'Priority'].map((option) {
            return RadioListTile<String>(
              value: option,
              groupValue: _sortBy,
              activeColor: const Color(0xFF7B6CF6),
              title: Text(option),
              onChanged: (val) {
                setState(() => _sortBy = val!);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _clearAllConfirm() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'Clear All Tasks',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: const Text(
          'Are you sure you want to delete all tasks? This cannot be undone.',
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
              setState(() => _tasks.clear());
              Navigator.pop(context);
            },
            child: const Text(
              'Delete All',
              style: TextStyle(color: Color(0xFFFF5C5C)),
            ),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    _titleController.clear();
    _descController.clear();
    _selectedCategory = 'School';
    _selectedPriority = 'Medium';
    _selectedDate = DateTime.now().add(const Duration(days: 1));
  }

  void _showAddTaskSheet({Task? existingTask, int? index}) {
    if (existingTask != null) {
      _titleController.text = existingTask.title;
      _descController.text = existingTask.description;
      _selectedCategory = existingTask.category;
      _selectedPriority = existingTask.priority;
      _selectedDate = existingTask.dueDate;
    } else {
      _resetForm();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  existingTask != null ? 'Edit Task' : 'New Task',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  controller: _titleController,
                  label: 'Task Title',
                  hint: 'Enter task title...',
                  icon: Icons.title_rounded,
                ),
                const SizedBox(height: 14),
                _buildInputField(
                  controller: _descController,
                  label: 'Description',
                  hint: 'Describe your task...',
                  icon: Icons.notes_rounded,
                  maxLines: 3,
                ),
                const SizedBox(height: 14),
                // Category dropdown
                _buildDropdownField<String>(
                  label: 'Category',
                  icon: Icons.category_rounded,
                  value: _selectedCategory,
                  items: ['School', 'Work', 'Health', 'Personal'],
                  onChanged: (val) =>
                      setSheetState(() => _selectedCategory = val!),
                ),
                const SizedBox(height: 14),
                // Priority dropdown
                _buildDropdownField<String>(
                  label: 'Priority',
                  icon: Icons.flag_rounded,
                  value: _selectedPriority,
                  items: ['Low', 'Medium', 'High'],
                  onChanged: (val) =>
                      setSheetState(() => _selectedPriority = val!),
                ),
                const SizedBox(height: 14),
                // Date picker
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 365),
                      ),
                      lastDate: DateTime.now().add(
                        const Duration(days: 365 * 2),
                      ),
                      builder: (context, child) => Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Color(0xFF7B6CF6),
                          ),
                        ),
                        child: child!,
                      ),
                    );
                    if (picked != null) {
                      setSheetState(() => _selectedDate = picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F7FF),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE8E4FF)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_rounded,
                          color: Color(0xFF7B6CF6),
                          size: 18,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Due Date',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${_selectedDate.day} ${_monthName(_selectedDate.month)} ${_selectedDate.year}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF1A1A2E),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.grey,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_titleController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter a task title'),
                          ),
                        );
                        return;
                      }
                      if (_descController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter a description'),
                          ),
                        );
                        return;
                      }
                      setState(() {
                        if (existingTask != null && index != null) {
                          _tasks[index].title = _titleController.text.trim();
                          _tasks[index].description = _descController.text
                              .trim();
                          _tasks[index].category = _selectedCategory;
                          _tasks[index].priority = _selectedPriority;
                          _tasks[index].dueDate = _selectedDate;
                        } else {
                          _tasks.add(
                            Task(
                              title: _titleController.text.trim(),
                              description: _descController.text.trim(),
                              category: _selectedCategory,
                              priority: _selectedPriority,
                              dueDate: _selectedDate,
                            ),
                          );
                        }
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7B6CF6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      existingTask != null ? 'Save Changes' : 'Add Task',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF7B6CF6), size: 18),
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
        filled: true,
        fillColor: const Color(0xFFF8F7FF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE8E4FF)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE8E4FF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF7B6CF6), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    required IconData icon,
    required T value,
    required List<T> items,
    required void Function(T?) onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      onChanged: onChanged,
      items: items
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: Text(
                item.toString(),
                style: const TextStyle(fontSize: 14),
              ),
            ),
          )
          .toList(),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF7B6CF6), size: 18),
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
        filled: true,
        fillColor: const Color(0xFFF8F7FF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE8E4FF)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE8E4FF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF7B6CF6), width: 1.5),
        ),
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

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredTasks;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 20,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: (val) => setState(() => _searchQuery = val),
                style: const TextStyle(color: Color(0xFF1A1A2E)),
                decoration: InputDecoration(
                  hintText: 'Search tasks...',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  border: InputBorder.none,
                ),
              )
            : const Text(
                'My Tasks',
                style: TextStyle(
                  color: Color(0xFF1A1A2E),
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close_rounded : Icons.search_rounded,
              color: const Color(0xFF7B6CF6),
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchQuery = '';
                  _searchController.clear();
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.sort_rounded, color: Color(0xFF7B6CF6)),
            onPressed: _showSortDialog,
          ),
          IconButton(
            icon: const Icon(
              Icons.delete_sweep_rounded,
              color: Color(0xFF7B6CF6),
            ),
            onPressed: _clearAllConfirm,
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7B6CF6), Color(0xFF9D8FF8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _statItem('Total', _tasks.length.toString()),
                      _statDivider(),
                      _statItem('Done', _completedCount.toString()),
                      _statDivider(),
                      _statItem('Pending', _pendingCount.toString()),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: _progress,
                      backgroundColor: Colors.white.withOpacity(0.25),
                      color: Colors.white,
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${(_progress * 100).toStringAsFixed(0)}% complete',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Filter chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: ['All', 'Pending', 'Completed'].map((f) {
                final active = _filter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _filter = f),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: active ? const Color(0xFF7B6CF6) : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: active
                            ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFF7B6CF6,
                                  ).withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        f,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: active ? Colors.white : Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          // Task list
          Expanded(
            child: filtered.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final task = filtered[index];
                      final realIndex = _tasks.indexOf(task);
                      return Dismissible(
                        key: ValueKey(task.hashCode),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF5C5C),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(
                            Icons.delete_rounded,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (_) =>
                            setState(() => _tasks.removeAt(realIndex)),
                        child: TaskCard(
                          task: task,
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TaskDetailScreen(
                                  task: task,
                                  onDelete: () => setState(
                                    () => _tasks.removeAt(realIndex),
                                  ),
                                  onEdit: () => _showAddTaskSheet(
                                    existingTask: task,
                                    index: realIndex,
                                  ),
                                ),
                              ),
                            );
                            if (result == true) setState(() {});
                          },
                          onToggleComplete: () => setState(
                            () => task.isCompleted = !task.isCompleted,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskSheet(),
        backgroundColor: const Color(0xFF7B6CF6),
        elevation: 4,
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _statDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.white.withOpacity(0.3),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF7B6CF6).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.task_alt_rounded,
              color: Color(0xFF7B6CF6),
              size: 36,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No tasks here',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add your first task',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
