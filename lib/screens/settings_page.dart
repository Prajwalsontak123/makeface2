import 'package:flutter/material.dart';

import '../screens//settings//blockedaccounts_page.dart';
import '../screens//settings//feedback_page.dart';
import '../screens/settings/aboutus_page.dart'; // Import the AboutUsPage
import '../screens/settings/account_center_page.dart';
import '../screens/settings/addaccount_page.dart';
import '../screens/settings/archives_page.dart';
import '../screens/settings/closefriends_page.dart';
import '../screens/settings/downloads_page.dart';
import '../screens/settings/edit_profile_page.dart';
import '../screens/settings/followandinvite_page.dart';
import '../screens/settings/helpcenter_page.dart';
import '../screens/settings/hidestory_page.dart';
import '../screens/settings/logoutofallaccounts_page.dart';
import '../screens/settings/notifications_page.dart';
import '../screens/settings/privacy_page.dart'; // Import the PrivacyPage
import '../screens/settings/privacypolicy_page.dart'; // Import the PrivacyPolicyPage
import '../screens/settings/saved_posts_page.dart';
import '../screens/settings/security_page.dart';
import '../screens/settings/termsofservice_page.dart'; // Import the TermsOfServicePage
import '../screens/settings/timespent_page.dart';
import '../screens/settings/youractivity_page.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Account'),
          _buildSettingsTile(Icons.account_circle, 'Account Center', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AccountCenterPage()),
            );
            // Placeholder for action when Account Center is tapped
            print('Account Center tapped');
          }),
          _buildSettingsTile(Icons.account_circle, 'Edit Profile', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditProfilePage()),
            );
            // Placeholder for action when Edit Profile is tapped
            print('Edit Profile tapped');
          }),
          _buildSettingsTile(Icons.notifications, 'Notifications', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationsPage()),
            );
            // Placeholder for action when Notifications is tapped
            print('Notifications tapped');
          }),
          _buildSettingsTile(Icons.bookmark, 'Saved Posts', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SavedPostsPage()),
            );
            // Placeholder for action when Saved Posts is tapped
            print('Saved Posts tapped');
          }),
          _buildSettingsTile(Icons.lock, 'Privacy', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PrivacyPage()),
            );
            // Placeholder for action when Privacy is tapped
            print('Privacy tapped');
          }),
          _buildSettingsTile(Icons.security, 'Security', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecurityPage()),
            );
            // Placeholder for action when Security is tapped
            print('Security tapped');
          }),
          _buildSettingsTile(Icons.person_add, 'Follow and Invite Friends ',
              () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FollowAndInvitePage()),
            );
            // Placeholder for action when Friends is tapped
            print('Friends tapped');
          }),
          _buildSettingsTile(Icons.history, 'Your Activity', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => YourActivityPage()),
            );
            // Placeholder for action when Your Activity is tapped
            print('Your Activity tapped');
          }),
          _buildSettingsTile(Icons.watch_later, 'Time Spent ', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TimeSpentPage()),
            );
            // Placeholder for action when Your Activity is tapped
            print('Time Spent  tapped');
          }),
          _buildSettingsTile(Icons.star_rounded, 'Close Friends ', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CloseFriendsPage()),
            );
            // Placeholder for action when Your Activity is tapped
            print('Close Friends tapped');
          }),
          _buildSettingsTile(Icons.block, 'Blocked accounts ', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BlockedAccountsPage()),
            );
            // Placeholder for action when Your Activity is tapped
            print('Blocked Accounts tapped');
          }),
          _buildSettingsTile(Icons.cloud_off, 'Hide Story ', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HideStoryPage()),
            );
            // Placeholder for action when Your Activity is tapped
            print('Blocked Accounts tapped');
          }),

          _buildSectionHeader('About'),
          _buildSettingsTile(Icons.info, 'About Us', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AboutUsPage()),
            );
            // Placeholder for action when About Us is tapped
            print('About Us tapped');
          }),
          _buildSettingsTile(Icons.privacy_tip, 'Terms of Service', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TermsOfServicePage()),
            );
            // Placeholder for action when Terms of Service is tapped
            print('Terms of Service tapped');
          }),
          _buildSettingsTile(Icons.privacy_tip_outlined, 'Privacy Policy', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
            );
            // Placeholder for action when Privacy Policy is tapped
            print('Privacy Policy tapped');
          }),
          _buildSectionHeader('Archives and Downloads'),
          _buildSettingsTile(Icons.archive, 'Archives ', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ArchivesPage()),
            );
            // Placeholder for action when Archives is tapped
            print('Archives tapped');
          }),
          _buildSettingsTile(Icons.file_download, 'Downloads', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DownloadsPage()),
            );
            print('Downloads tapped');
          }),

          _buildSectionHeader('Support'),
          _buildSettingsTile(Icons.help, 'Help Center', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HelpCenterPage()),
            ); // Placeholder for action when Help Center is tapped
            print('Help Center tapped');
          }),
          _buildSettingsTile(Icons.feedback, 'Feedback', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FeedbackPage()),
            );
            // Placeholder for action when Feedback is tapped
            print('Feedback tapped');
          }),

          _buildSectionHeader('Login'),

          _buildSettingsTile(Icons.login, 'Add account ', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddAccountPage()),
            );
            // Placeholder for action when Help Center is tapped
            print('Add account  tapped');
          }),
          _buildSettingsTile(Icons.logout, 'LogOut', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LogoutPage()),
            );
            // Placeholder for action when Feedback is tapped
            print('Logout  tapped');
          }),
          _buildSettingsTile(Icons.logout, 'LogOut  of all accounts', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LogoutOfAllAccountsPage()),
            );
            // Placeholder for action when Feedback is tapped
            print('Logout of all accounts   tapped');
          }),
          // Add more setting options here with icons
          SizedBox(height: 20.0), // Add some spacing at the bottom
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      color: Colors.grey[200],
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, VoidCallback? onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}

class LogoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logout'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Add logic here to handle logout
            // For demonstration, navigate back to the settings page
            Navigator.pop(context);
          },
          child: Text('Logout'),
        ),
      ),
    );
  }
}
