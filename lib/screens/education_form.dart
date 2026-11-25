import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

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
  bool _isSubmitting = false;

  // Controllers to display picked dates in TextFormFields
  final TextEditingController _endYearController = TextEditingController();

  @override
  void dispose() {
    _endYearController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final allowed = await ensureLoggedIn(context);
    if (!allowed || !mounted) return;

    final token = context.read<AuthState>().token;
    if (token == null) return;

    final newEducation = Education(
      institutionName: _institutionName.trim(),
      startingYear: _startingYear!,
      endYear: _isOngoing ? null : _endYear,
      description: _description.trim(),
    );

    setState(() {
      _isSubmitting = true;
    });

    try {
      await context.read<ApiClient>().createEducation(
            newEducation,
            token: token,
          );
      if (!mounted) return;

      await showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Education added successfully!'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Institution: $_institutionName'),
                  Text('Starting Year: $_startingYear'),
                  Text('End Year: ${_isOngoing ? 'Present' : (_endYear ?? '-')}'),
                  Text('Description: $_description'),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );

      if (!mounted) return;
      _formKey.currentState!.reset();
      setState(() {
        _institutionName = "";
        _startingYear = null;
        _endYear = null;
        _description = "";
        _isOngoing = false;
        _endYearController.clear();
      });
    } on ApiException catch (e) {
      if (!mounted) return;

      if (e.statusCode == 401) {
        await context.read<AuthState>().logout();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Session expired. Please log in again.'),
          ),
        );
        await ensureLoggedIn(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save education (Status: ${e.statusCode})'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Add Education Record',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueGrey.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
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
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
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
