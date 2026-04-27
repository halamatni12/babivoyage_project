import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:babibeauty_app/features/auth/data/services/notification_service.dart';
import '../../data/booking/booking_service.dart';

class BookingScreen extends StatefulWidget {
  final String serviceName;

  const BookingScreen({super.key, required this.serviceName});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final service = BookingService();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  List bookings = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    bookings = await service.get();
    setState(() {});
  }

  void pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );
    if (date != null) setState(() => selectedDate = date);
  }

  void pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) setState(() => selectedTime = time);
  }

  DateTime getFullDateTime() {
    return DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );
  }

  void addBooking() async {
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        selectedDate == null ||
        selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill all fields ⚠️")),
      );
      return;
    }

    final bookingDateTime = getFullDateTime();

    final reminderTime = DateTime.now().add(const Duration(seconds: 5));

    await NotificationService.schedule(
      "Reminder 💖",
      "You have ${widget.serviceName} soon!",
      reminderTime,
    );

    await service.add({
      "service": widget.serviceName,
      "name": nameController.text,
      "phone": phoneController.text,
      "date": selectedDate!.toString().split(' ')[0],
      "time": selectedTime!.format(context),
    });

    nameController.clear();
    phoneController.clear();
    selectedDate = null;
    selectedTime = null;

    load();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Booked Successfully 🎉")),
    );
  }

  void deleteBooking(int index) async {
    await service.delete(index);
    load();
  }

  void editBooking(int index) async {
    final b = bookings[index];

    nameController.text = b["name"];
    phoneController.text = b["phone"];

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Booking"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController),
            TextField(controller: phoneController),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await service.delete(index);

              await service.add({
                ...b,
                "name": nameController.text,
                "phone": phoneController.text,
              });

              Navigator.pop(context);
              load();
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.serviceName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          Text(
            "Book ${widget.serviceName}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "Your Name"),
          ),

          TextField(
            controller: phoneController,
            decoration: const InputDecoration(labelText: "Phone"),
          ),

          const SizedBox(height: 10),

          ElevatedButton(
            onPressed: pickDate,
            child: Text(
              selectedDate == null
                  ? "Select Date"
                  : selectedDate!.toString().split(' ')[0],
            ),
          ),

          ElevatedButton(
            onPressed: pickTime,
            child: Text(
              selectedTime == null
                  ? "Select Time"
                  : selectedTime!.format(context),
            ),
          ),

          const SizedBox(height: 15),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
            ),
            onPressed: addBooking,
            child: const Text("Confirm Booking"),
          ),

          const SizedBox(height: 15),

          ElevatedButton(
            onPressed: () {
              NotificationService.show(
                "TEST 🔥",
                "This should appear immediately",
              );
            },
            child: const Text("Test Notification"),
          ),

          const SizedBox(height: 25),

          const Text(
            "Your Bookings",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          ...bookings.asMap().entries.map((entry) {
            final i = entry.key;
            final b = entry.value;

            return Card(
              child: ListTile(
                title: Text(b["service"]),
                subtitle: Text(
                    "${b["date"]} - ${b["time"]}\n${b["name"]} (${b["phone"]})"),

                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => editBooking(i),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => deleteBooking(i),
                    ),
                  ],
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}