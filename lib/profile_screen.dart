// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color primaryColor = Color.fromARGB(255, 6, 62, 42);
  static const Color secondaryColor = Color(0xFF8BD8BC);
  static const Color backgroundColor = Color(0xFFCAE6D3);
  static const Gradient cardGradient = LinearGradient(
    colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  final SupabaseClient supabase = Supabase.instance.client;
  String? email;
  String? name;
  bool isLoading = true; // To track the loading state
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      try {
        final response = await supabase
            .from('users') // Ensure 'users' table exists and has the 'name' field
            .select('name')
            .eq('id', user.id)
            .single();

        if (response != null) {
          setState(() {
            email = user.email;
            name = response['name'];
            _nameController.text = name ?? '';
            isLoading = false;
          });
        } else {
          // Handle case if the profile does not exist
          setState(() {
            isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        // Log error to debug
        print("Error fetching user profile: $e");
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      try {
        await supabase.from('users').update({'name': _nameController.text}).eq('id', user.id);
        setState(() {
          name = _nameController.text;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      } catch (e) {
        // Handle any errors that might occur during update
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error updating profile!')),
        );
      }
    }
  }

  Future<void> _logout() async {
    final user = supabase.auth.currentUser;
    
    if (user != null) {
      print("User is logged in, logging out...");
      await supabase.auth.signOut();
      Navigator.pushReplacementNamed(context, '/login'); // Navigate to login screen
    } else {
      print("No user is currently logged in, force navigating to login...");
      // If no user is logged in, navigate directly to login screen
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildProfileCard(),
                const SizedBox(height: 20),
                _buildSectionTitle('Account Settings'),
                const SizedBox(height: 12),
                _buildSettingsList(),
                const SizedBox(height: 20),
                _buildSectionTitle('Support'),
                const SizedBox(height: 12),
                _buildSupportOptions(),
                const SizedBox(height: 20),
                _buildLogoutButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Profile',
          style: TextStyle(
            color: primaryColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        CircleAvatar(
          backgroundColor: primaryColor,
          child: IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Add navigation to settings if required
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator()); // Show loading spinner while fetching data
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: cardGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 50, color: primaryColor),
          ),
          const SizedBox(height: 12),
          Text(
            name ?? 'No name found',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            email ?? 'No email found',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () => _showEditProfileDialog(),
            icon: const Icon(Icons.edit, color: primaryColor),
            label: const Text(
              'Edit Profile',
              style: TextStyle(color: primaryColor),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: primaryColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSettingsList() {
    return Column(
      children: [
        _buildSettingsItem('Change Password', Icons.lock_outline, onTap: () {}),
        _buildSettingsItem('Privacy Settings', Icons.privacy_tip_outlined, onTap: () {}),
        _buildSettingsItem('Notification Preferences', Icons.notifications_outlined, onTap: () {}),
      ],
    );
  }

  Widget _buildSettingsItem(String title, IconData icon, {VoidCallback? onTap}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: primaryColor),
        title: Text(
          title,
          style: const TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSupportOptions() {
    return Column(
      children: [
        _buildSettingsItem('Help Center', Icons.help_outline, onTap: () {}),
        _buildSettingsItem('Contact Support', Icons.phone_in_talk_outlined, onTap: () {}),
        _buildSettingsItem('Terms & Conditions', Icons.article_outlined, onTap: () {}),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return ElevatedButton.icon(
      onPressed: _logout,
      icon: const Icon(Icons.logout, color: Colors.white),
      label: const Text('Logout', style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _updateProfile();
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
