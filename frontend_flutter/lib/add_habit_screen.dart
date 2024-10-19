import 'package:flutter/material.dart';
import 'custom_button.dart';
import 'api_service.dart';


class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({Key? key}) : super(key: key);

  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  // Add state variables and controllers here
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _frequency = 'Daily';
  TimeOfDay _reminderTime = TimeOfDay.now();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.pink.shade300, Colors.orange.shade300],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context),
                const SizedBox(height: 30),
                _buildHabitForm(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        Text(
          'Add New Habit',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 48),
      ],
    );
  }

  Widget _buildHabitForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Habit Name', _nameController),
            const SizedBox(height: 15),
            _buildTextField('Description', _descriptionController),
            const SizedBox(height: 15),
            Text(
              'Frequency',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 10),
            _buildFrequencyButtons(),
            const SizedBox(height: 15),
            Text(
              'Reminder Time',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 10),
            _buildTimePicker(context),
            const SizedBox(height: 30),
            CustomButton(
              text: 'Add Habit',
              onPressed: _addHabit,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildFrequencyButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: ['Daily', 'Weekly', 'Monthly'].map((freq) => 
        _buildFrequencyButton(freq)
      ).toList(),
    );
  }

  Widget _buildFrequencyButton(String text) {
    return ElevatedButton(
      onPressed: () => setState(() => _frequency = text),
      child: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: _frequency == text ? Colors.orange : Colors.white,
        foregroundColor: _frequency == text ? Colors.white : Colors.orange,
      ),
    );
  }

  Widget _buildTimePicker(BuildContext context) {
    return InkWell(
      onTap: () async {
        TimeOfDay? selectedTime = await showTimePicker(
          context: context,
          initialTime: _reminderTime,
        );
        if (selectedTime != null) {
          setState(() => _reminderTime = selectedTime);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _reminderTime.format(context),
              style: TextStyle(color: Colors.white),
            ),
            Icon(Icons.access_time, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Future<void> _addHabit() async {
    if (_formKey.currentState!.validate()) {
      try {
        final habitData = {
          'habit_name': _nameController.text,
          'description': _descriptionController.text,
          'frequency': _frequency,
          'reminder_time': '${_reminderTime.hour}:${_reminderTime.minute}',
        };
        
        await ApiService.createHabit(habitData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Habit added successfully!')),
        );
        Navigator.pop(context);
      } catch (e) {
        print('Error adding habit: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add habit. Please try again.')),
        );
      }
    }
  }
}
