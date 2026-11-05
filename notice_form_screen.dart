import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/notice.dart';
import '../services/notice_store.dart';
import '../widgets/formatters.dart';

class NoticeFormScreen extends StatefulWidget {
  const NoticeFormScreen({super.key});

  @override
  State<NoticeFormScreen> createState() => _NoticeFormScreenState();
}

class _NoticeFormScreenState extends State<NoticeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _postedByController = TextEditingController();
  final _bodyController = TextEditingController();

  String? _department;
  DateTime _date = DateTime.now();
  bool _saving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _postedByController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  String? _validateTitle(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Enter a title';
    if (text.length < 3) return 'Title must be at least 3 characters';
    return null;
  }

  String? _validateDepartment(String? value) =>
      value == null ? 'Choose a department' : null;

  String? _validatePostedBy(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Enter who is posting this notice';
    if (text.length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  String? _validateBody(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Enter the notice details';
    if (text.length < 10) return 'Details must be at least 10 characters';
    if (text.length > 500) return 'Details must be 500 characters or fewer';
    return null;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1, now.month, now.day),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  Future<void> _save() async {
    if (_saving) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    final store = context.read<NoticeStore>();
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await store.add(
        title: _titleController.text.trim(),
        department: _department!,
        body: _bodyController.text.trim(),
        postedBy: _postedByController.text.trim(),
        date: _date,
      );
      navigator.pop();
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      messenger.showSnackBar(
        const SnackBar(content: Text('Could not post. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post notice')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  maxLength: 80,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: _validateTitle,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _department,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Department'),
                  items: [
                    for (final name in Departments.names)
                      DropdownMenuItem(value: name, child: Text(name)),
                  ],
                  onChanged: (v) => setState(() => _department = v),
                  validator: _validateDepartment,
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _pickDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Notice date',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(formatDate(_date)),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _postedByController,
                  maxLength: 40,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Posted by'),
                  validator: _validatePostedBy,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _bodyController,
                  maxLength: 500,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    labelText: 'Details',
                    alignLabelWithHint: true,
                  ),
                  validator: _validateBody,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Publish'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
