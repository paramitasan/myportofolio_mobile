import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _title = "";
  String _description = "";
  String _category = "full-time"; // default
  String _thumbnail = "";
  DateTime? _startedAt;
  DateTime? _endedAt;
  bool _isOngoing = false;

  // Controllers to display picked dates in TextFormFields
  final TextEditingController _startedAtController = TextEditingController();
  final TextEditingController _endedAtController = TextEditingController();

  final Map<String, String> _categories = {
    'internship': 'Internship',
    'research': 'Research',
    'volunteer': 'Volunteer',
    'part-time': 'Part-Time',
    'full-time': 'Full-Time',
    'freelance': 'Freelance',
  };

  @override
  void dispose() {
    _startedAtController.dispose();
    _endedAtController.dispose();
    super.dispose();
  }

  // Date picker helper for started_at and ended_at
  Future<void> _pickDate({required bool isStart}) async {
    final initialDate = isStart
        ? (_startedAt ?? DateTime.now())
        : (_endedAt ?? _startedAt ?? DateTime.now());

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        final formatted =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
        if (isStart) {
          _startedAt = picked;
          _startedAtController.text = formatted;
        } else {
          _endedAt = picked;
          _endedAtController.text = formatted;
        }
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Add Experience Form',
          ),
        ),
        backgroundColor: Colors.blueGrey.shade700,
        foregroundColor: Colors.white,
      ),
      
      drawer: const LeftDrawer(),

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Title ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLength: 255,
                  decoration: InputDecoration(
                    hintText: "Experience Title",
                    labelText: "Title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _title = value ?? "";
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Enter a title.";
                    }
                    if (value.length > 255) {
                      return "Title cannot exceed 255 characters.";
                    }
                    return null;
                  },
                ),
              ),

              // === Description ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 3,
                  maxLength: 100,
                  decoration: InputDecoration(
                    hintText: "Brief description (max 100 chars)",
                    labelText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _description = value ?? "";
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Enter a description.";
                    }
                    if (value.length > 100) {
                      return "Description cannot exceed 100 characters.";
                    }
                    return null;
                  },
                ),
              ),

              // === Category ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Category",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  value: _category,
                  items: _categories.entries
                      .map((entry) => DropdownMenuItem<String>(
                            value: entry.key,
                            child: Text(entry.value),
                          ))
                      .toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _category = newValue;
                      });
                    }
                  },
                ),
              ),

              // === Thumbnail URL ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    hintText: "https://example.com/image.png (optional)",
                    labelText: "Thumbnail URL",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _thumbnail = value ?? "";
                    });
                  },
                  validator: (String? value) {
                    if (value != null && value.trim().isNotEmpty) {
                      final uri = Uri.tryParse(value.trim());
                      if (uri == null ||
                          uri.host.isEmpty ||
                          (uri.scheme != 'http' && uri.scheme != 'https')) {
                        return "Enter a valid URL (http/https).";
                      }
                    }
                    return null;
                  },
                ),
              ),

              // === Started at ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _startedAtController,
                  readOnly: true,
                  onTap: () => _pickDate(isStart: true),
                  decoration: InputDecoration(
                    hintText: "Select start date",
                    labelText: "Started At",
                    suffixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  validator: (String? value) {
                    if (_startedAt == null) {
                      return "Select a start date.";
                    }
                    return null;
                  },
                ),
              ),

              // === Ongoing toggle ===
              CheckboxListTile(
                title: const Text("Currently ongoing"),
                value: _isOngoing,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) {
                  setState(() {
                    _isOngoing = value ?? false;
                    if (_isOngoing) {
                      _endedAt = null;
                      _endedAtController.clear();
                    }
                  });
                },
              ),

              // === Ended at ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _endedAtController,
                  readOnly: true,
                  enabled: !_isOngoing,
                  onTap: _isOngoing ? null : () => _pickDate(isStart: false),
                  decoration: InputDecoration(
                    hintText: "Select end date (optional)",
                    labelText: "Ended At",
                    suffixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  validator: (String? value) {
                    if (!_isOngoing &&
                        _startedAt != null &&
                        _endedAt != null &&
                        _endedAt!.isBefore(_startedAt!)) {
                      return "End date can't be before the start date.";
                    }
                    return null;
                  },
                ),
              ),

              // === Save Button ===
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                        WidgetStateProperty.all(Colors.blueGrey.shade700,),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Experience added successfully!'),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Experience: $_title'),
                                    Text('Description: $_description'),
                                    Text('Category: $_category'),
                                    Text('Thumbnail: ${_thumbnail.isEmpty ? '-' : _thumbnail}'),
                                    // Format DateTime to YYYY-MM-DD without time
                                    Text('Started at: ${_startedAt?.toString().split(' ')[0]}'),
                                    // Format DateTime to YYYY-MM-DD without time
                                    Text('Ended at: ${_endedAt?.toString().split(' ')[0] ?? '-'}'),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _formKey.currentState!.reset();
                                    setState(() {
                                      _title = "";
                                      _description = "";
                                      _category = "full-time";
                                      _thumbnail = "";
                                      _startedAt = null;
                                      _endedAt = null;
                                      _isOngoing = false;
                                      _startedAtController.clear();
                                      _endedAtController.clear();
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
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

