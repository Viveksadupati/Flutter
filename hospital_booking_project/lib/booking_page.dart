import 'package:flutter/material.dart';
import 'main.dart' show Appointment, Doctor;

const bookingBlue = Color(0xFF1677E8);

class BookingPage extends StatefulWidget {
  final Doctor doctor;
  const BookingPage({super.key, required this.doctor});
  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  String selectedTime = '10:00 AM';
  final timeSlots = const ['09:00 AM', '10:00 AM', '11:00 AM', '12:00 PM', '02:00 PM', '03:00 PM', '04:00 PM'];

  @override
  void dispose() { _nameController.dispose(); _phoneController.dispose(); super.dispose(); }

  Future<void> chooseDate() async {
    final date = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 180)));
    if (date != null && mounted) setState(() => selectedDate = date);
  }

  void confirmBooking() {
    if (!_formKey.currentState!.validate()) return;
    final appointment = Appointment(doctor: widget.doctor, date: selectedDate, time: selectedTime, patientName: _nameController.text.trim(), phone: _phoneController.text.trim());
    showDialog<void>(context: context, builder: (dialogContext) => AlertDialog(
      icon: const Icon(Icons.check_circle, color: Colors.green, size: 55),
      title: const Text('Booking Successful!'),
      content: Text('Patient: ${appointment.patientName}\nDoctor: ${appointment.doctor.name}\nDate: ${appointment.date.day}/${appointment.date.month}/${appointment.date.year}\nTime: ${appointment.time}\n\nDemo only: no real hospital appointment has been created.'),
      actions: [FilledButton(onPressed: () { Navigator.pop(dialogContext); Navigator.pop(context, appointment); }, child: const Text('Done'))],
    ));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Book Appointment'), backgroundColor: Colors.white),
    body: SafeArea(child: LayoutBuilder(builder: (context, constraints) {
      final tablet = constraints.maxWidth >= 700;
      return Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 900), child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: tablet
        ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: doctorDetails()), const SizedBox(width: 24), Expanded(child: bookingForm())])
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [doctorDetails(), const SizedBox(height: 24), bookingForm()]))));
    })),
  );

  Widget doctorDetails() => Container(width: double.infinity, padding: const EdgeInsets.all(22), decoration: BoxDecoration(color: const Color(0xFFE5F1FF), borderRadius: BorderRadius.circular(22)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    CircleAvatar(radius: 36, backgroundColor: Colors.white, child: Icon(widget.doctor.icon, size: 38, color: bookingBlue)), const SizedBox(height: 18),
    Text(widget.doctor.name, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold)), const SizedBox(height: 6), Text(widget.doctor.specialty, style: const TextStyle(color: bookingBlue, fontSize: 16)), const SizedBox(height: 14),
    Row(children: [const Icon(Icons.star, color: Colors.orange), const SizedBox(width: 5), Text('${widget.doctor.rating} rating')]), const SizedBox(height: 10),
    Row(children: [const Icon(Icons.work_outline, color: bookingBlue), const SizedBox(width: 8), Text('${widget.doctor.experience} years experience')]), const Divider(height: 32),
    const ListTile(contentPadding: EdgeInsets.zero, leading: Icon(Icons.local_hospital, color: bookingBlue), title: Text('MediCare Hospital'), subtitle: Text('Hospital appointment desk')),
  ]));

  Widget bookingForm() => Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Text('Patient Details', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)), const SizedBox(height: 16),
    TextFormField(controller: _nameController, textCapitalization: TextCapitalization.words, decoration: const InputDecoration(labelText: 'Patient full name', prefixIcon: Icon(Icons.person_outline), border: OutlineInputBorder()), validator: (v) => v == null || v.trim().isEmpty ? 'Please enter the patient name' : null),
    const SizedBox(height: 16),
    TextFormField(controller: _phoneController, keyboardType: TextInputType.phone, maxLength: 10, decoration: const InputDecoration(labelText: '10-digit mobile number', prefixIcon: Icon(Icons.phone_outlined), border: OutlineInputBorder(), counterText: ''), validator: (v) => v == null || !RegExp(r'^[0-9]{10}$').hasMatch(v.trim()) ? 'Enter a valid 10-digit mobile number' : null),
    const SizedBox(height: 24), const Text('Appointment Date', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 12),
    SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: chooseDate, icon: const Icon(Icons.calendar_month), label: Padding(padding: const EdgeInsets.all(12), child: Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}')))),
    const SizedBox(height: 24), const Text('Available Time Slots', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 12),
    Wrap(spacing: 10, runSpacing: 10, children: timeSlots.map((time) => ChoiceChip(label: Text(time), selected: selectedTime == time, selectedColor: const Color(0xFFD7E9FF), onSelected: (_) => setState(() => selectedTime = time))).toList()),
    const SizedBox(height: 28), SizedBox(width: double.infinity, height: 54, child: FilledButton.icon(onPressed: confirmBooking, icon: const Icon(Icons.check_circle_outline), label: const Text('Confirm Booking', style: TextStyle(fontSize: 16)))),
    const SizedBox(height: 14), const Center(child: Text('Please arrive 10 minutes before your appointment.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.blueGrey))),
  ]));
}
