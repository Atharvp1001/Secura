import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';

class StartScanScreen extends StatefulWidget {
  const StartScanScreen({Key? key}) : super(key: key);

  @override
  _StartScanScreenState createState() => _StartScanScreenState();
}

class _StartScanScreenState extends State<StartScanScreen> {
  late Future<List<Application>> _installedAppsFuture;

  @override
  void initState() {
    super.initState();
    _installedAppsFuture = _fetchInstalledApps(); // Correct type assignment
  }

  Future<List<Application>> _fetchInstalledApps() async {
    // Fetch all installed apps on the device
    return await DeviceApps.getInstalledApplications(
      includeSystemApps: true, // Include system apps if needed
      includeAppIcons: true,  // Include app icons
    );
  }

  void _scanApp(Application app) {
    // Simulate scanning logic
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Scanning ${app.appName}'),
        content: const Text('Scanning for vulnerabilities...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Scan'),
        backgroundColor: const Color(0xFF06303E), // Primary color
      ),
      body: FutureBuilder<List<Application>>(
        future: _installedAppsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No apps found.'),
            );
          }

          final installedApps = snapshot.data!;
          return ListView.builder(
            itemCount: installedApps.length,
            itemBuilder: (context, index) {
              final app = installedApps[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: app is ApplicationWithIcon
                      ? CircleAvatar(
                          backgroundImage: MemoryImage(app.icon),
                        )
                      : const CircleAvatar(
                          child: Icon(Icons.android),
                        ),
                  title: Text(app.appName),
                  subtitle: Text('Package: ${app.packageName}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.security, color: Colors.green),
                    onPressed: () => _scanApp(app),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}