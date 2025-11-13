import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:open_filex/open_filex.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class AlertsPage extends StatefulWidget {
  const AlertsPage({Key? key}) : super(key: key);

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  final supabase = Supabase.instance.client;
  List<dynamic> alerts = [];
  bool loading = true;

  final String bucket = "alerts-files";

  @override
  void initState() {
    super.initState();
    fetchAlerts();
  }

  Future<void> fetchAlerts() async {
    final data = await supabase
        .from('alerts')
        .select()
        .order('created_at', ascending: false);

    setState(() {
      alerts = data;
      loading = false;
    });
  }

  Future<String> getSignedUrl(String filePath) async {
    return await supabase.storage
        .from(bucket)
        .createSignedUrl(filePath, 3600);
  }

  Future<void> downloadAndOpen(String filePath) async {
    try {
      final signedUrl = await getSignedUrl(filePath);
      final fileBytes = await http.readBytes(Uri.parse(signedUrl));

      final dir = await getApplicationDocumentsDirectory();
      final fileName = filePath.split('/').last;
      final file = File("${dir.path}/$fileName");

      await file.writeAsBytes(fileBytes);
      await OpenFilex.open(file.path);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Download failed: $e")),
      );
    }
  }

  Color getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'alert': return Colors.redAccent;
      case 'circular': return Colors.amber;
      case 'event': return Colors.green;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerts & Circulars'),
        backgroundColor: const Color(0xFF7C183D),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF7C183D)))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                final alert = alerts[index];
                final filePath = alert['file_url'];
                final createdAt = alert['created_at'] != null
                    ? DateFormat('MMM d, yyyy • hh:mm a').format(
                        DateTime.parse(alert['created_at']).toLocal(),
                      )
                    : '';

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(alert['title'] ?? "Untitled",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF7C183D),
                            )),
                        const SizedBox(height: 6),
                        Text(alert['description'] ?? "",
                            style: const TextStyle(fontSize: 15)),
                        const SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: getTypeColor(alert['type'] ?? '')
                                    .withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                alert['type'] ?? '',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: getTypeColor(alert['type'] ?? ''),
                                ),
                              ),
                            ),
                            Text(createdAt,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                          ],
                        ),

                        const SizedBox(height: 12),

                        if (filePath != null && filePath.isNotEmpty)
                          TextButton.icon(
                            onPressed: () => downloadAndOpen(filePath),
                            icon: const Icon(Icons.download),
                            label: const Text("Download Attachment"),
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF7C183D),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
