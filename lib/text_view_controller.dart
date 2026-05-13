import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';



class HyperlinkController extends TextEditingController {
  final BuildContext context;
  HyperlinkController(this.context);

  // Regex patterns for URL, Phone, and Date (YYYY-MM-DD)
  static final RegExp _urlRegex = RegExp(r'https?://[^\s]+', caseSensitive: false);
  static final RegExp _phoneRegex = RegExp(r'\+?\d{7,15}');
  static final RegExp _dateRegex = RegExp(r'\d{4}-\d{2}-\d{2}');

  // Combined Regex for the splitMapJoin
  static final RegExp _combinedRegex = RegExp(
    '(${_urlRegex.pattern})|(${_phoneRegex.pattern})|(${_dateRegex.pattern})',
    caseSensitive: false,
  );

  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    final List<TextSpan> children = [];

    text.splitMapJoin(
      _combinedRegex,
      onMatch: (Match match) {
        final String matchText = match[0]!;

        children.add(TextSpan(
          text: matchText,
          style: style?.copyWith(
            color: Colors.blue,
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.bold,
          ),
          // Attach the specific action based on the match type
          recognizer: TapGestureRecognizer()..onTap = () => _handleTap(matchText),
        ));
        return matchText;
      },
      onNonMatch: (String nonMatch) {
        children.add(TextSpan(text: nonMatch, style: style));
        return nonMatch;
      },
    );

    return TextSpan(children: children, style: style);
  }

  void _handleTap(String value) async {
    // 1. Check if it's a URL
    if (_urlRegex.hasMatch(value)) {
      final Uri url = Uri.parse(value);
      if (await canLaunchUrl(url)) await launchUrl(url);
    }
    // 2. Check if it's a Phone Number
    else if (_phoneRegex.hasMatch(value)) {
      final Uri tel = Uri.parse('tel:$value');
      if (await canLaunchUrl(tel)) await launchUrl(tel);
    }
    // 3. Check if it's a Date
    else if (_dateRegex.hasMatch(value)) {
      DateTime? initialDate = DateTime.tryParse(value);
      showDatePicker(
        context: context,
        initialDate: initialDate ?? DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );
    }
  }
}

class TextViewDemo extends StatelessWidget {
  const TextViewDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Description View',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const DescriptionPage(),
    );
  }
}

class DescriptionPage extends StatefulWidget {
  const DescriptionPage({super.key});

  @override
  State<DescriptionPage> createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  late HyperlinkController _descriptionController;


  // Controller to manage and retrieve the text value
  // final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    // Initialize with context to allow showing DatePicker
    _descriptionController = HyperlinkController(context);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      // Access the final description via _descriptionController.text
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Description Saved: ${_descriptionController.text}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Description Input'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Implementation of the Description "TextView"
              TextFormField(
                controller: _descriptionController,
                keyboardType: TextInputType.multiline,
                minLines: 5,           // Initial height of the box
                maxLines: 10,          // Expands until 10 lines, then scrolls
                maxLength: 500,
                buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,// Shows character counter at the bottom
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Type your description here...',
                  alignLabelWithHint: true, // Labels stay at top for multiline
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2.0,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Description cannot be empty';
                  }
                  if (value.length < 10) {
                    return 'Please provide more detail (min 10 chars)';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _handleSubmit,
                  icon: const Icon(Icons.check),
                  label: const Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
