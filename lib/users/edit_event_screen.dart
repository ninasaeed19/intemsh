import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intemssh2/models/event.dart';
import 'package:intemssh2/utils/constants.dart';
import 'package:intl/intl.dart';

class EditEventScreen extends StatefulWidget {
  final Event event;

  const EditEventScreen({super.key, required this.event});

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  late final TextEditingController _locationController;
  late final TextEditingController _maxAttendeesController;

  late DateTime _selectedDate;
  late String _selectedCategory;
  late bool _isApproved;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.title);
    _descController = TextEditingController(text: widget.event.description);
    _locationController = TextEditingController(text: widget.event.location);
    _maxAttendeesController = TextEditingController(text: widget.event.maxAttendees.toString());
    _selectedDate = widget.event.dateTime;
    _selectedCategory = widget.event.category;
    _isApproved = widget.event.isApproved;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _locationController.dispose();
    _maxAttendeesController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    // Use the copyWith method from our updated Event model
    final updatedEvent = widget.event.copyWith(
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      location: _locationController.text.trim(),
      dateTime: _selectedDate,
      maxAttendees: int.tryParse(_maxAttendeesController.text.trim()) ?? widget.event.maxAttendees,
      category: _selectedCategory,
      isApproved: _isApproved,
    );

    try {
      // Update the document in Firestore using its ID
      await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.event.id)
          .update(updatedEvent.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Event updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, updatedEvent); // Pass the updated event back
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update event: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // You can copy the _selectDate method from CreateEventScreen or re-implement it
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020), // Allow past dates for editing
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Event'),
        backgroundColor: AppColors.primaryPink,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _saveChanges,
            tooltip: 'Save Changes',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Event Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Event Title'),
                validator: (value) => value?.trim().isEmpty ?? true ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Description', alignLabelWithHint: true),
                validator: (value) => value?.trim().isEmpty ?? true ? 'Please enter a description' : null,
              ),
              const SizedBox(height: 16),
              // ... Other fields like category, location, date ...
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: ['General', 'Workshop', 'Lecture', 'Social', 'Sports']
                    .map((category) => DropdownMenuItem(value: category, child: Text(category)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedCategory = value!),
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (value) => value?.trim().isEmpty ?? true ? 'Please enter a location' : null,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Date & Time'),
                  child: Text(DateFormat('MMM dd, yyyy  •  hh:mm a').format(_selectedDate)),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _maxAttendeesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Max Attendees'),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Please enter max attendees';
                  if (int.tryParse(value!) == null) return 'Please enter a valid number';
                  return null;
                },
              ),
              const Divider(height: 40),
              const Text('Admin Controls', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SwitchListTile(
                title: const Text('Event Approved'),
                value: _isApproved,
                onChanged: (value) {
                  setState(() {
                    _isApproved = value;
                  });
                },
                activeColor: AppColors.primaryPink,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
