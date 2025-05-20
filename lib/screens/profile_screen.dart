import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController billingNameController;
  late TextEditingController billingAddressController;

  final int loyaltyPoints = 350;
  final String currentTier = "Silver";
  final String nextTier = "Gold";
  final int pointsToNextTier = 150;

  // Notification toggles state
  bool pushNotificationsEnabled = true;
  bool emailNotificationsEnabled = true;
  bool smsNotificationsEnabled = true;

  // Dark mode toggle state
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    nameController = TextEditingController();
    emailController = TextEditingController();
    billingNameController = TextEditingController();
    billingAddressController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authState = ref.read(authProvider);
    nameController.text = authState.userFullName ?? '';
    emailController.text = authState.userEmail ?? '';
    billingNameController.text = authState.userFullName ?? '';
    billingAddressController.text = authState.userAddress ?? '';
  }

  @override
  void dispose() {
    _tabController.dispose();
    nameController.dispose();
    emailController.dispose();
    billingNameController.dispose();
    billingAddressController.dispose();
    super.dispose();
  }

  void _handleLogout() async {
    await ref.read(authProvider.notifier).logout();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You have been logged out")),
      );
    }
  }

  void _handleSaveProfile() async {
    final newName = nameController.text.trim();
    if (newName.isEmpty) {
      Fluttertoast.showToast(msg: "Name cannot be empty");
      return;
    }
    await ref.read(authProvider.notifier).updateProfile(newName);
    Fluttertoast.showToast(msg: "Profile updated successfully");
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    final String fullName = authState.userFullName ?? 'No Name';
    final String email = authState.userEmail ?? 'No Email';
    final String location = authState.userLocation ?? 'Unknown Location';

    String initials = '';
    if (fullName.isNotEmpty) {
      var names = fullName.split(' ');
      initials = names.length > 1
          ? '${names[0][0]}${names[1][0]}'.toUpperCase()
          : fullName.substring(0, 1).toUpperCase();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: authState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  child: Text(
                    initials,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(fullName,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.email, size: 16),
                          const SizedBox(width: 6),
                          Expanded(child: Text(email)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_pin, size: 16),
                          const SizedBox(width: 6),
                          Expanded(child: Text(location)),
                          IconButton(
                            icon: const Icon(Icons.refresh, size: 18),
                            tooltip: 'Update Location',
                            onPressed: () async {
                              await ref
                                  .read(authProvider.notifier)
                                  .updateLocation();
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          TabBar(
            controller: _tabController,
            labelColor: Colors.blue,
            tabs: const [
              Tab(text: "Account"),
              Tab(text: "Settings"),
              Tab(text: "Payment"),
            ],
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAccountTab(),
                _buildSettingsTab(),
                _buildPaymentTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Personal Information",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Full Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: emailController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _handleSaveProfile,
                    child: const Text("Save Changes"),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SwitchListTile(
          title: const Text("Push Notifications"),
          subtitle: const Text("Receive order updates and promotions"),
          value: pushNotificationsEnabled,
          onChanged: (val) {
            setState(() {
              pushNotificationsEnabled = val;
            });
            Fluttertoast.showToast(
                msg: val ? "Push Notifications Enabled" : "Push Notifications Disabled");
          },
        ),
        SwitchListTile(
          title: const Text("Email Notifications"),
          subtitle: const Text("Receive order confirmations and receipts"),
          value: emailNotificationsEnabled,
          onChanged: (val) {
            setState(() {
              emailNotificationsEnabled = val;
            });
            Fluttertoast.showToast(
                msg: val ? "Email Notifications Enabled" : "Email Notifications Disabled");
          },
        ),
        SwitchListTile(
          title: const Text("SMS Notifications"),
          subtitle: const Text("Receive delivery updates via text"),
          value: smsNotificationsEnabled,
          onChanged: (val) {
            setState(() {
              smsNotificationsEnabled = val;
            });
            Fluttertoast.showToast(
                msg: val ? "SMS Notifications Enabled" : "SMS Notifications Disabled");
          },
        ),
        const Divider(),
        SwitchListTile(
          title: const Text("Dark Mode"),
          subtitle: const Text("Switch between light and dark themes"),
          value: isDarkMode,
          onChanged: (val) {
            setState(() {
              isDarkMode = val;
            });
            Fluttertoast.showToast(msg: val ? "Dark Mode Enabled" : "Dark Mode Disabled");
            // TODO: Actually implement dark mode switching in app theme
          },
        ),
        ListTile(
          title: const Text("Language"),
          subtitle: const Text("Select your preferred language"),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Implement language selection dialog or page
            Fluttertoast.showToast(msg: "Language selection tapped");
          },
        ),
      ],
    );
  }

  Widget _buildPaymentTab() {
    // Placeholder for payment tab content
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Loyalty Points: $loyaltyPoints",
                style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Current Tier: $currentTier",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text("Points to Next Tier ($nextTier): $pointsToNextTier",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement payment methods or loyalty program features
                Fluttertoast.showToast(msg: "Payment tab action tapped");
              },
              child: const Text("Manage Payment Methods"),
            ),
          ],
        ),
      ),
    );
  }
}
