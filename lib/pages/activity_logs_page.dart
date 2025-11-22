// pages/activity_logs_page.dart
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import '../services/db_helper.dart'; // Make sure this path is correct!

class ActivityLogsPage extends StatefulWidget {
  const ActivityLogsPage({super.key});

  @override
  State<ActivityLogsPage> createState() => _ActivityLogsPageState();
}

class _ActivityLogsPageState extends State<ActivityLogsPage> {
  List<Map<String, dynamic>> _logs = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

Future<void> _loadLogs() async {
  setState(() {
    _isLoading = true;
    _error = null;
  });

  try {
    final results = await DBHelper.instance.query('''
      SELECT al.*, u.username 
      FROM activity_logs al
      LEFT JOIN users u ON al.user_id = u.id
      ORDER BY al.created_at DESC
      LIMIT 500
    ''');

    final logs = results.map((row) {
      final f = row.fields;

      // SAFELY CONVERT BLOB → STRING
      dynamic desc = f['description'];
      String description = '';
      if (desc is Blob) {
        description = String.fromCharCodes(desc.toBytes());
      } else if (desc is String) {
        description = desc;
      } else if (desc != null) {
        description = desc.toString();
      }

      final timestamp = f['created_at'] as DateTime;

      return {
        'id': f['id'],
        'fullname': f['fullname']?.toString() ?? 'Unknown',
        'role': f['role']?.toString() ?? 'Unknown',
        'action': f['action']?.toString() ?? 'Unknown',
        'description': description,
        'username': f['username']?.toString() ?? '-',
        'timestamp': timestamp,
      };
    }).toList();

    if (mounted) {
      setState(() {
        _logs = logs;
        _isLoading = false;
      });
    }
  } catch (e, stack) {
    debugPrint('Load logs error: $e\n$stack');
    if (mounted) {
      setState(() {
        _error = 'Failed to load logs: $e';
        _isLoading = false;
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Icon(Icons.cloud_off, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Failed to load activity logs', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text(_error!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadLogs,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Activity Logs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
          _buildSummaryCards(),
          const SizedBox(height: 24),
          _buildDataTable(),
          const SizedBox(height: 24),
          _buildLastSync(),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    final total = _logs.length;
    final logins = _logs.where((l) => l['action'] == 'Login').length;
    final registers = _logs.where((l) => l['action'] == 'Register').length;
    final households = _logs.where((l) => l['action'].toString().contains('Household')).length;

    return Row(
      
      children: [
        _statCard('Total Logs', total.toString(), Icons.history),
        SizedBox(width: 10,),
        _statCard('Logins', logins.toString(), Icons.login),
        SizedBox(width: 10,),
        _statCard('Registrations', registers.toString(), Icons.person_add),
        SizedBox(width: 10,),
        _statCard('Households Added', households.toString(), Icons.home),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon) {
    return Expanded(
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 32, color: const Color(0xFF031273)),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataTable() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Recent Activities', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('${_logs.length} entries', style: TextStyle(color: Colors.grey[600])),
              ],
            ),
            const SizedBox(height: 12),
            _logs.isEmpty
                ? const Center(child: Text('No logs yet', style: TextStyle(color: Colors.grey)))
                : LayoutBuilder(
                    builder: (context, constraints) => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: constraints.maxWidth),
                        child: DataTable(
                          headingRowColor: MaterialStateProperty.all(const Color(0xFF031273)),
                          headingTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          columns: const [
                            DataColumn(label: Text('No.')),
                            DataColumn(label: Text('User')),
                            DataColumn(label: Text('Role')),
                            DataColumn(label: Text('Action')),
                            DataColumn(label: Text('Details')),
                            DataColumn(label: Text('Time')),
                          ],
                          rows: _logs.asMap().entries.map((e) {
                            final i = e.key + 1;
                            final log = e.value;
                            return DataRow(
                              cells: [
                                DataCell(Text('$i', style: const TextStyle(fontWeight: FontWeight.bold))),
                                DataCell(
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 14,
                                        child: Text(log['fullname'].toString().substring(0, 1).toUpperCase()),
                                      ),
                                      const SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(log['fullname'], style: const TextStyle(fontWeight: FontWeight.w600)),
                                          Text('@${log['username']}', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Chip(
                                    label: Text(log['role'], style: const TextStyle(fontSize: 11, color: Colors.white)),
                                    backgroundColor: log['role'] == 'Captain' ? Colors.deepPurple : Colors.blue,
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: _getActionColor(log['action']).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      log['action'],
                                      style: TextStyle(color: _getActionColor(log['action']), fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 220,
                                    child: Text(
                                      log['description'],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                ),
                                DataCell(Text(_formatDate(log['timestamp']), style: const TextStyle(fontSize: 12, color: Colors.grey))),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Color _getActionColor(String action) {
    return switch (action) {
      'Login' => Colors.green,
      'Register' => Colors.blue,
      'Logout' => Colors.orange,
      'Add Household' => Colors.purple,
      'Add User' => Colors.indigo,
      'Update Census Data' => Colors.teal,
      'Add Census Data' => Colors.cyan,
      _ => Colors.grey,
    };
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final logDay = DateTime(date.year, date.month, date.day);

    if (logDay == today) return 'Today ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    if (logDay == yesterday) return 'Yesterday ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
           '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildLastSync() {
    return Center(
      child: Text(
        'Last updated: ${DateTime.now().toString().substring(0, 19)}',
        style: const TextStyle(color: Colors.grey, fontSize: 14),
      ),
    );
  }
}