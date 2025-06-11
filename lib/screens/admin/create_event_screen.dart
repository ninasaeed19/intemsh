import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../models/event.dart';
import '../../controllers/event_controller.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final EventController _eventController = Get.find<EventController>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _maxAttendeesController = TextEditingController();

  DateTime? _selectedDateTime;
  String? _selectedCategory;
  bool _isLoading = false;

  late bool _isEditMode;
  Event? _existingEvent;

  final List<String> _categories = ['Technology', 'Arts & Culture', 'Sports', 'Networking', 'Gaming', 'Music', 'General'];

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      _isEditMode = true;
      _existingEvent = Get.arguments as Event;
      _titleController.text = _existingEvent!.title;
      _descriptionController.text = _existingEvent!.description;
      _locationController.text = _existingEvent!.location;
      _imageUrlController.text = _existingEvent!.imageUrl;
      _maxAttendeesController.text = _existingEvent!.maxAttendees.toString();
      _selectedDateTime = _existingEvent!.dateTime;
      _selectedCategory = _existingEvent!.category;
    } else {
      _isEditMode = false;
      _existingEvent = null;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _imageUrlController.dispose();
    _maxAttendeesController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDateTime == null) {
        Get.snackbar('Error', 'Please select a date and time.');
        return;
      }

      setState(() { _isLoading = true; });

      final eventData = Event(
        id: _isEditMode ? _existingEvent!.id : '',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        location: _locationController.text.trim(),
        category: _selectedCategory!,
        imageUrl: _imageUrlController.text.trim(),
        dateTime: _selectedDateTime!,
        maxAttendees: int.parse(_maxAttendeesController.text.trim()),
        organizerId: _isEditMode ? _existingEvent!.organizerId : '',
        attendees: _isEditMode ? _existingEvent!.attendees : [],
        isApproved: _isEditMode ? _existingEvent!.isApproved : false,
      );

      final success = await _eventController.saveEvent(eventData, _isEditMode);

      // **THE FIX**: Check if the widget is still mounted before doing anything.
      if (mounted) {
        setState(() { _isLoading = false; });
        // If the save was successful, navigate back.
        if (success) {
          Get.back();
        }
      }
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context, initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now(), lastDate: DateTime(2030),
    );
    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context, initialTime: TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
    );
    if (pickedTime == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        pickedDate.year, pickedDate.month, pickedDate.day,
        pickedTime.hour, pickedTime.minute,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Event' : 'Create New Event'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(controller: _titleController, decoration: const InputDecoration(labelText: 'Event Title'), validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Description'), maxLines: 4, validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _locationController, decoration: const InputDecoration(labelText: 'Location'), validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: _categories.map((category) => DropdownMenuItem(value: category, child: Text(category))).toList(),
                onChanged: (value) => setState(() => _selectedCategory = value),
                validator: (value) => value == null ? 'Please select a category' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _maxAttendeesController,
                decoration: const InputDecoration(labelText: 'Maximum Attendees'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter max attendees';
                  if (int.tryParse(value) == null || int.parse(value) <= 0) return 'Please enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(controller: _imageUrlController, decoration: const InputDecoration(labelText: 'Image URL'), keyboardType: TextInputType.url, validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 24),
              ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Colors.grey.shade400)),
                title: Text(_selectedDateTime == null ? 'Select Date & Time' : DateFormat('EEE, MMM d, y @ hh:mm a').format(_selectedDateTime!)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDateTime(context),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: Text(_isEditMode ? 'Update Event' : 'Create Event', style: const TextStyle(fontSize: 18)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
