import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _institutionName = "";
  int? _startingYear;
  int? _endYear;
  String _description = "";
  bool _isOngoing = false;

  // Controllers to display picked dates in TextFormFields
  final TextEditingController _endYearController = TextEditingController();

  @override
  void dispose() {
    _endYearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Add Education Form',
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
              // === Institution Name ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLength: 255,
                  decoration: InputDecoration(
                    hintText: "e.g. Universitas Indonesia",
                    labelText: "Institution Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _institutionName = value ?? "";
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Enter an institution name.";
                    }
                    if (value.length > 255) {
                      return "Institution name cannot exceed 255 characters.";
                    }
                    return null;
                  },
                ),
              ),
              
              // === Starting year ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  decoration: InputDecoration(
                    hintText: "e.g. 2022",
                    labelText: "Starting Year",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _startingYear = int.tryParse(value ?? "");
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Enter a starting year.";
                    }
                    final year = int.tryParse(value.trim());
                    if (year == null || year < 2010 || year > 2100) {
                      return "Enter a valid year between 2010 and 2100.";
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
                      _endYear = null;
                      _endYearController.clear();
                    }
                  });
                },
              ),

              // === End year ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _endYearController,
                  enabled: !_isOngoing,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  decoration: InputDecoration(
                    hintText: "e.g. 2026 (optional)",
                    labelText: "End Year",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _endYear = int.tryParse(value ?? "");
                    });
                  },
                  validator: (String? value) {
                    if (!_isOngoing && value != null && value.trim().isNotEmpty) {
                      final year = int.tryParse(value.trim());
                      if (year == null || year < 2010 || year > 2100) {
                        return "Enter a valid year between 2010 and 2100.";
                      }
                      if (_startingYear != null && year < _startingYear!) {
                        return "End year can't be before the starting year.";
                      }
                    }
                    return null;
                  },
                ),
              ),

              // === Description ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 4,
                  maxLength: 400,
                  decoration: InputDecoration(
                    hintText: "Description (max 400 chars)",
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
                    if (value.length > 400) {
                      return "Description cannot exceed 400 characters.";
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
                              title: const Text('Education added successfully!'),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Institution: $_institutionName'),
                                    Text('Starting Year: $_startingYear'),
                                    Text('End Year: ${_endYear ?? '-'}'),
                                    Text('Description: $_description'),
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
                                      _institutionName = "";
                                      _startingYear = null;
                                      _endYear = null;
                                      _description = "";
                                      _isOngoing = false;
                                      _endYearController.clear();
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
