// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'pwrvm_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _service = PwrvmService(); // change baseUrl inside service if needed
  Map<String, dynamic>? _status;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await _service.getStatus();
      // Defensive parsing with defaults so we never pass null to Text()
      _status = {
        'paperDetected': (data['paperDetected'] as bool?) ?? false,
        'temperature': (data['temperature'] as num?)?.toDouble() ?? 0.0,
        'timeLeft': (data['timeLeft'] as num?)?.toInt() ?? 0,
        'cycle': (data['cycle'] as String?) ?? 'idle',
      };
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final paperDetected = (_status?['paperDetected'] as bool?) ?? false;
    final temperature = (_status?['temperature'] as double?) ?? 0.0;
    final timeLeft = (_status?['timeLeft'] as int?) ?? 0;
    final cycle = (_status?['cycle'] as String?) ?? 'idle';

    return Scaffold(
      appBar: AppBar(title: const Text('PRVM Home')),
      body: RefreshIndicator(
        onRefresh: _loadStatus,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (_loading)
              const Center(child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              )),
            if (!_loading && _error != null)
              Card(
                child: ListTile(
                  title: const Text('Error'),
                  subtitle: Text(_error ?? ''), // never null
                ),
              ),
            Card(
              child: ListTile(
                title: const Text('Paper Status'),
                subtitle: Text(
                  paperDetected ? '✅ Paper detected' : '❌ Insert paper',
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                title: const Text('Boiler Temperature'),
                subtitle: Text('${temperature.toStringAsFixed(1)} °C'), // String, not null
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                title: const Text('Time Remaining'),
                subtitle: Text('$timeLeft seconds left'), // String, not null
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                title: const Text('Cycle'),
                subtitle: Text(cycle), // String, not null
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await _service.startCycle();
                      _loadStatus();
                    },
                    child: const Text('Start Cycle'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      await _service.stopCycle();
                      _loadStatus();
                    },
                    child: const Text('Stop Cycle'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
