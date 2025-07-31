//
// Coder                    : Rethabile Eric Siase
// Purpose                  : Integrated fiebase storage for managing(adding, removing and updating) modules  
//

import 'package:flutter/material.dart';

class ModuleForm extends StatefulWidget {
  final String? moduleId;
  final String? initialName;
  final String? initialCode;
  final Function(String name, String code) onSubmit;

  const ModuleForm({
    super.key,
    this.moduleId,
    this.initialName,
    this.initialCode,
    required this.onSubmit,
  });

  @override
  State<ModuleForm> createState() => _ModuleFormState();
}

class _ModuleFormState extends State<ModuleForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialName != null) _nameController.text = widget.initialName!;
    if (widget.initialCode != null) _codeController.text = widget.initialCode!;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Module Name'),
            validator: (value) => value!.isEmpty ? 'Required' : null,
          ),
          TextFormField(
            controller: _codeController,
            decoration: const InputDecoration(labelText: 'Module Code'),
            validator: (value) => value!.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                widget.onSubmit(
                  _nameController.text.trim(),
                  _codeController.text.trim(),
                );
                Navigator.pop(context);
              }
            },
            child: Text(widget.moduleId == null ? 'Add Module' : 'Update Module'),
          ),
        ],
      ),
    );
  }
}