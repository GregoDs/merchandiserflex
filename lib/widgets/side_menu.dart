import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flexmerchandiser/routes.dart';
import 'package:flexmerchandiser/utils/cache/shared_preferences_helper.dart';
import 'package:flexmerchandiser/features/auth/repo/auth_repo.dart'; // <-- Add this import


class SideMenu extends StatefulWidget {
  final String? name;
  final String? phone;
  final VoidCallback onLogout;
  final VoidCallback onDeleteAccount;
  final VoidCallback? onClose; 

  const SideMenu({
    super.key,
    this.name,
    this.phone,
    required this.onLogout,
    required this.onDeleteAccount,
    this.onClose,
  });

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final AuthRepo _authRepo = AuthRepo(); 
  int selectedItem = -1;

  final List<_SideMenuItem> menuItems = [
    _SideMenuItem(
      title: 'Leads',
      icon: Icons.leaderboard,
      subItems: ['Add Lead'],
    ),
    _SideMenuItem(
      title: 'Calls',
      icon: Icons.call,
      subItems: ['All Calls', 'Log Call'],
    ),
    _SideMenuItem(
      title: 'Customer Retention',
      icon: Icons.people,
      subItems: ['Retention List', 'Add Retention'],
    ),
    _SideMenuItem(
      title: 'Leaderboard',
      icon: Icons.emoji_events,
      subItems: ['View Rankings'],
    ),
  ];




  Future<void> _deleteAccount() async {
    try {
      final response = await _authRepo.deleteAccount();
      await SharedPreferencesHelper.logout();
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.onboarding,
          (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Account"),
        content: const Text(
            "Are you sure you want to delete your account? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAccount();
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.75;
    final height = MediaQuery.of(context).size.height;

    return Material(
      color: const Color(0xFF17203A),
      child: SafeArea(
        child: Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(
            color: Color(0xFF17203A),
            borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(5, 0),
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Logo
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Image.asset(
                  'assets/icon/flexhomelogo.png',
                  height: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              // Profile Info
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.transparent,
                      child: Icon(Icons.person, color: Colors.white, size: 32),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.name ?? 'Promoter',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              fontFamily: 'montserrat',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.phone ?? 'Profile',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14,
                              fontFamily: 'montserrat',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Menu Items
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: menuItems.length,
                  itemBuilder: (context, i) {
                    final item = menuItems[i];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: selectedItem == i
                            ? Colors.white.withOpacity(0.1)
                            : Colors.transparent,
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          key: Key(i.toString()),
                          onExpansionChanged: (value) {
                            setState(() => selectedItem = value ? i : -1);
                          },
                          iconColor: Colors.white,
                          collapsedIconColor: Colors.white.withOpacity(0.7),
                          leading: Icon(item.icon, color: Colors.white),
                          title: Text(
                            item.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'montserrat',
                            ),
                          ),
                          children: item.subItems
                              .map(
                                (sub) => ListTile(
                                  onTap: () {
                                    if (item.title == 'Leads' && sub == 'Add Lead') {
                                      Navigator.of(context).pop(); // Close the drawer
                                      Navigator.pushNamed(context, Routes.addLeads);
                                    }
                                    // TODO: Add navigation for other subitems as needed
                                  },
                                  leading: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  title: Text(
                                    sub,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 14,
                                      fontFamily: 'montserrat',
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Logout Button
              Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
               child: ListTile(
                onTap: () async {
                  await SharedPreferencesHelper.logout();
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, Routes.login);
                  }
                },
                leading: Icon(
                  CupertinoIcons.power,
                  color: Colors.white,
                  size: 24.0,
                ),
                title: Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontFamily: 'montserrat',
                    fontWeight: FontWeight.w500,
                  ),
                ),
               ),
              ),
              // Delete Account Button
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  onTap: _confirmDeleteAccount,
                  leading: const Icon(Icons.delete_forever, color: Colors.redAccent),
                  title: const Text(
                    "Delete Account",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 15,
                      fontFamily: 'montserrat',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SideMenuItem {
  final String title;
  final IconData icon;
  final List<String> subItems;
  _SideMenuItem({required this.title, required this.icon, required this.subItems});
}