import 'package:flutter/material.dart';
import 'booking_page.dart';

void main() => runApp(const HospitalApp());

const primary = Color(0xFF1677E8);
const background = Color(0xFFF5F8FD);

class HospitalApp extends StatelessWidget {
  const HospitalApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MediCare Hospital',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: primary),
          scaffoldBackgroundColor: background,
          appBarTheme: const AppBarTheme(
            backgroundColor: background,
            surfaceTintColor: Colors.transparent,
          ),
        ),
        home: const HospitalHome(),
      );
}

class Doctor {
  final String name, specialty, qualification;
  final double rating;
  final int experience;
  final IconData icon;
  final Color color;

  const Doctor({
    required this.name,
    required this.specialty,
    required this.qualification,
    required this.rating,
    required this.experience,
    required this.icon,
    required this.color,
  });
}

const doctors = <Doctor>[
  Doctor(name: 'Dr. R. Sharma', specialty: 'General Physician', qualification: 'MBBS, MD', rating: 4.8, experience: 8, icon: Icons.medical_services, color: Color(0xFFDDEBFF)),
  Doctor(name: 'Dr. Neha Verma', specialty: 'Dermatology', qualification: 'MBBS, DVD', rating: 4.7, experience: 7, icon: Icons.face_3, color: Color(0xFFFFE4ED)),
  Doctor(name: 'Dr. K. Reddy', specialty: 'Cardiology', qualification: 'MBBS, DM', rating: 4.9, experience: 10, icon: Icons.favorite, color: Color(0xFFFFE8E8)),
  Doctor(name: 'Dr. Priya Singh', specialty: 'Pediatrics', qualification: 'MBBS, MD', rating: 4.6, experience: 6, icon: Icons.child_care, color: Color(0xFFE0F7EF)),
  Doctor(name: 'Dr. Arjun Rao', specialty: 'Orthopedics', qualification: 'MBBS, MS', rating: 4.8, experience: 9, icon: Icons.accessibility_new, color: Color(0xFFFFF0D8)),
  Doctor(name: 'Dr. Meera Das', specialty: 'Neurology', qualification: 'MBBS, DM', rating: 4.9, experience: 11, icon: Icons.psychology, color: Color(0xFFEAE5FF)),
];

const specialties = <String>[
  'All', 'General Physician', 'Cardiology', 'Dermatology',
  'Pediatrics', 'Orthopedics', 'Neurology',
];

class Appointment {
  final Doctor doctor;
  final DateTime date;
  final String time, patientName, phone;
  Appointment({required this.doctor, required this.date, required this.time, required this.patientName, required this.phone});
}

class HospitalHome extends StatefulWidget {
  const HospitalHome({super.key});
  @override
  State<HospitalHome> createState() => _HospitalHomeState();
}

class _HospitalHomeState extends State<HospitalHome> {
  int page = 0;
  String selectedSpecialty = 'All', search = '';
  final List<Appointment> appointments = [];

  List<Doctor> get filteredDoctors => doctors.where((doctor) {
        final specialtyMatch = selectedSpecialty == 'All' || doctor.specialty == selectedSpecialty;
        final q = search.toLowerCase();
        return specialtyMatch && (doctor.name.toLowerCase().contains(q) || doctor.specialty.toLowerCase().contains(q));
      }).toList();

  Future<void> openBookingPage(Doctor doctor) async {
    final appointment = await Navigator.push<Appointment>(
      context,
      MaterialPageRoute(builder: (_) => BookingPage(doctor: doctor)),
    );
    if (appointment != null && mounted) {
      setState(() {
        appointments.add(appointment);
        page = 1;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment booked with ${doctor.name}!'), backgroundColor: Colors.green.shade700),
      );
    }
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, constraints) {
        final tablet = constraints.maxWidth >= 800;
        return Scaffold(
          body: SafeArea(
            child: Row(children: [
              if (tablet) NavigationRailPanel(selected: page, onSelect: (v) => setState(() => page = v)),
              Expanded(child: Column(children: [
                _header(tablet),
                Expanded(child: page == 0 ? _homeContent(tablet, constraints.maxWidth) : page == 1 ? _appointmentsContent() : _profileContent()),
              ])),
            ]),
          ),
          bottomNavigationBar: tablet ? null : NavigationBar(
            selectedIndex: page,
            onDestinationSelected: (v) => setState(() => page = v),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.calendar_month_outlined), label: 'Appointments'),
              NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
            ],
          ),
        );
      });

  Widget _header(bool tablet) => Padding(
        padding: EdgeInsets.fromLTRB(tablet ? 32 : 20, 20, 20, 12),
        child: Row(children: [
          Container(padding: const EdgeInsets.all(11), decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.local_hospital, color: Colors.white, size: 28)),
          const SizedBox(width: 12),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('MediCare', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: primary)),
            Text('Hospital Appointment Booking', style: TextStyle(fontSize: 12, color: Colors.blueGrey)),
          ])),
          IconButton(onPressed: () => setState(() => page = 1), icon: const Icon(Icons.notifications_none)),
          const CircleAvatar(backgroundColor: Color(0xFFDDEBFF), child: Icon(Icons.person, color: primary)),
        ]),
      );

  Widget _homeContent(bool tablet, double width) {
    final columns = width >= 1100 ? 3 : width >= 600 ? 2 : 1;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(tablet ? 32 : 20, 8, tablet ? 32 : 20, 28),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: double.infinity, padding: const EdgeInsets.all(24), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFD9EEFF), Color(0xFFEFF7FF)]), borderRadius: BorderRadius.circular(24)), child: Row(children: [
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Your Health,\nOur Priority', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF123D83))),
            SizedBox(height: 10), Text('Find trusted doctors and book your visit easily.'),
            SizedBox(height: 14), Row(children: [Icon(Icons.verified_user, color: primary, size: 18), SizedBox(width: 6), Text('Care you can trust', style: TextStyle(fontWeight: FontWeight.w600))]),
          ])),
          if (tablet) const Icon(Icons.medical_services, color: primary, size: 82),
        ])),
        const SizedBox(height: 22),
        TextField(onChanged: (v) => setState(() => search = v), decoration: const InputDecoration(hintText: 'Search doctors or specialties...', prefixIcon: Icon(Icons.search))),
        const SizedBox(height: 26),
        const SectionTitle(title: 'Medical Specialties'),
        const SizedBox(height: 12),
        Wrap(spacing: 10, runSpacing: 10, children: specialties.map((s) => ChoiceChip(label: Text(s), selected: selectedSpecialty == s, selectedColor: const Color(0xFFD9EAFF), onSelected: (_) => setState(() => selectedSpecialty = s))).toList()),
        const SizedBox(height: 28),
        SectionTitle(title: 'Available Doctors', trailing: Text('${filteredDoctors.length} doctors')),
        const SizedBox(height: 12),
        if (filteredDoctors.isEmpty) const Padding(padding: EdgeInsets.all(24), child: Center(child: Text('No doctors found. Try another search.')))
        else GridView.builder(
          shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: filteredDoctors.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columns, crossAxisSpacing: 14, mainAxisSpacing: 14, mainAxisExtent: 235),
          itemBuilder: (context, index) { final doctor = filteredDoctors[index]; return DoctorCard(doctor: doctor, onBook: () => openBookingPage(doctor)); },
        ),
        const SizedBox(height: 28),
        const SectionTitle(title: 'Your Next Visit'),
        const SizedBox(height: 12),
        if (appointments.isEmpty) const EmptyCard(icon: Icons.calendar_month, message: 'No upcoming appointments. Book a doctor today.')
        else AppointmentCard(appointment: appointments.last),
      ]),
    );
  }

  Widget _appointmentsContent() => ListView(padding: const EdgeInsets.all(24), children: [
        const Text('My Appointments', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        const SizedBox(height: 18),
        if (appointments.isEmpty) const EmptyCard(icon: Icons.event_available, message: 'You have no appointments yet.')
        else ...appointments.reversed.map((a) => Padding(padding: const EdgeInsets.only(bottom: 14), child: AppointmentCard(appointment: a))),
        const SizedBox(height: 12),
        FilledButton.icon(onPressed: () => setState(() => page = 0), icon: const Icon(Icons.add), label: const Text('Book Another Appointment')),
      ]);

  Widget _profileContent() => ListView(padding: const EdgeInsets.all(24), children: const [
        CircleAvatar(radius: 42, backgroundColor: Color(0xFFDDEBFF), child: Icon(Icons.person, color: primary, size: 44)),
        SizedBox(height: 16), Center(child: Text('Welcome, Patient!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
        SizedBox(height: 24), ListTile(leading: Icon(Icons.person_outline), title: Text('Patient Profile'), subtitle: Text('Manage your personal details')),
        ListTile(leading: Icon(Icons.security_outlined), title: Text('Privacy & Security')),
        ListTile(leading: Icon(Icons.help_outline), title: Text('Help & Support')),
        ListTile(leading: Icon(Icons.info_outline), title: Text('About MediCare')),
      ]);
}

class NavigationRailPanel extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onSelect;
  const NavigationRailPanel({super.key, required this.selected, required this.onSelect});
  @override
  Widget build(BuildContext context) => Container(width: 220, color: Colors.white, padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12), child: Column(children: [
        const SizedBox(height: 12), const Icon(Icons.local_hospital, color: primary, size: 44),
        const Text('MediCare', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primary)), const SizedBox(height: 36),
        _item(Icons.home_outlined, 'Home', 0), _item(Icons.calendar_month_outlined, 'Appointments', 1), _item(Icons.person_outline, 'Profile', 2), const Spacer(),
        const Text('Your health matters.', style: TextStyle(color: Colors.blueGrey, fontSize: 12)),
      ]));
  Widget _item(IconData icon, String label, int index) { final active = selected == index; return Padding(padding: const EdgeInsets.only(bottom: 8), child: ListTile(selected: active, selectedTileColor: const Color(0xFFE6F1FF), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), leading: Icon(icon, color: active ? primary : Colors.blueGrey), title: Text(label, style: TextStyle(color: active ? primary : Colors.black87, fontWeight: active ? FontWeight.bold : FontWeight.normal)), onTap: () => onSelect(index))); }
}

class SectionTitle extends StatelessWidget {
  final String title; final Widget? trailing;
  const SectionTitle({super.key, required this.title, this.trailing});
  @override
  Widget build(BuildContext context) => Row(children: [Expanded(child: Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold))), if (trailing != null) trailing!]);
}

class DoctorCard extends StatelessWidget {
  final Doctor doctor; final VoidCallback onBook;
  const DoctorCard({super.key, required this.doctor, required this.onBook});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFEDF1F7))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [CircleAvatar(radius: 27, backgroundColor: doctor.color, child: Icon(doctor.icon, color: primary, size: 28)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(doctor.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)), const SizedBox(height: 4), Text(doctor.specialty, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.blueGrey, fontSize: 12))]))]),
        const SizedBox(height: 14), Text(doctor.qualification, style: const TextStyle(color: Colors.blueGrey)), const SizedBox(height: 6),
        Row(children: [const Icon(Icons.star, color: Colors.amber, size: 19), const SizedBox(width: 4), Text('${doctor.rating}'), const SizedBox(width: 12), const Icon(Icons.work_outline, color: Colors.blueGrey, size: 16), const SizedBox(width: 4), Expanded(child: Text('${doctor.experience} years experience', style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis))]),
        const Spacer(), SizedBox(width: double.infinity, child: FilledButton(onPressed: onBook, child: const Text('Book Appointment'))),
      ]));
}

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  const AppointmentCard({super.key, required this.appointment});
  @override
  Widget build(BuildContext context) { final doctor = appointment.doctor; return Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFEDF1F7))), child: Row(children: [
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFE6F1FF), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.calendar_month, color: primary, size: 28)), const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(doctor.name, style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text(doctor.specialty), const SizedBox(height: 6), Text('${appointment.date.day}/${appointment.date.month}/${appointment.date.year} • ${appointment.time}', style: const TextStyle(color: Colors.blueGrey, fontSize: 12)), const SizedBox(height: 6), Text('Patient: ${appointment.patientName}', style: const TextStyle(fontSize: 12)), const Text('MediCare Hospital', style: TextStyle(color: primary, fontSize: 12))])), const Icon(Icons.check_circle, color: Colors.green),
      ])); }
}

class EmptyCard extends StatelessWidget {
  final IconData icon; final String message;
  const EmptyCard({super.key, required this.icon, required this.message});
  @override
  Widget build(BuildContext context) => Container(width: double.infinity, padding: const EdgeInsets.all(28), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Column(children: [Icon(icon, color: primary, size: 42), const SizedBox(height: 12), Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.blueGrey))]));
}
