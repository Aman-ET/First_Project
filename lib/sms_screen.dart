import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';

class SmsInboxScreen extends StatefulWidget {
  const SmsInboxScreen({super.key});

  @override
  State<SmsInboxScreen> createState() => _SmsInboxScreenState();
}

class _SmsInboxScreenState extends State<SmsInboxScreen> {
  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _messages = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _getPermissionAndLoadSms();
  }

  Future<void> _getPermissionAndLoadSms() async {
    // Check permission status
    PermissionStatus status = await Permission.sms.status;

    if (!status.isGranted) {
      status = await Permission.sms.request();
    }

    if (status.isGranted) {
      final messages = await _query.querySms(
        kinds: [SmsQueryKind.inbox, SmsQueryKind.sent],
        count: 30,
      );

      setState(() {
        _messages = messages;
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      home: Scaffold(
        appBar: AppBar(
          title: const Text("SMS Inbox"),
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _getPermissionAndLoadSms,
            )
          ],
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _messages.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.sms_failed, size: 50, color: Colors.grey),
              const SizedBox(height: 10),
              const Text("No messages found in emulator"),
              TextButton(
                onPressed: _getPermissionAndLoadSms,
                child: const Text("Refresh App"),
              )
            ],
          ),
        )
            : ListView.builder(
          itemCount: _messages.length,
          itemBuilder: (context, index) {
            final msg = _messages[index];
            return ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(msg.sender ?? "Unknown"),
              subtitle: Text(msg.body ?? ""),
              trailing: Text(
                msg.date != null ? _formatDate(msg.date!) : "",
                style: const TextStyle(fontSize: 10),
              ),
            );
          },
        ),
      ),
    );
  }
}
