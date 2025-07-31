//
// Coder                    : Rethabile Eric Siase
// Purpose                  : Integrated fiebase storage for managing(adding, removing and updating) modules
//

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter/models/app_user.dart';
import 'package:firebase_flutter/models/modules.dart';
import 'package:firebase_flutter/routes/app_router.dart';
import 'package:firebase_flutter/views/modules_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class MainPage extends StatelessWidget {
  final String email;
  const MainPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Home')),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, RouteManager.loginPage);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddModuleDialog(context),
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: FutureBuilder<AppUser?>(
          future: authService.getUserData(authService.currentUser!.uid),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (!userSnapshot.hasData) {
              return const Text('User not found');
            }

            final user = userSnapshot.data!;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text('Welcome, ${user.name}'),
                      const SizedBox(height: 10),
                      Text('Email: $email'),
                    ],
                  ),
                ),
                const Divider(),
                const Text('Your Modules', style: TextStyle(fontSize: 18)),
                Expanded(child: _buildModulesList(context)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildModulesList(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder<List<Module>>(
      stream: authService.getModules(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final modules = snapshot.data ?? [];

        if (modules.isEmpty) {
          return const Center(child: Text('No modules added yet'));
        }

        return ListView.builder(
          itemCount: modules.length,
          itemBuilder: (context, index) {
            final module = modules[index];
            return ListTile(
              title: Text(module.name),
              subtitle: Text(module.code),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit,color:Colors.green),
                    onPressed: () => _showEditModuleDialog(context, module),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete,color:Colors.red),
                    onPressed: () => _deleteModule(context, module.id),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAddModuleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add New Module'),
            content: SizedBox(
              height: 160,
              width: 100,
              child: ModuleForm(
                onSubmit: (name, code) {
                  Provider.of<AuthService>(
                    context,
                    listen: false,
                  ).addModule(name, code);
                },
              ),
            ),
          ),
    );
  }

  void _showEditModuleDialog(BuildContext context, Module module) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Module'),
            content: SizedBox(
              height: 160,
              width: 100,
              child: ModuleForm(
                moduleId: module.id,
                initialName: module.name,
                initialCode: module.code,
                onSubmit: (name, code) {
                  Provider.of<AuthService>(
                    context,
                    listen: false,
                  ).updateModule(module.id, name, code);
                },
              ),
            ),
          ),
    );
  }

  Future<void> _deleteModule(BuildContext context, String moduleId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text('Are you sure you want to delete this module?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      await Provider.of<AuthService>(
        context,
        listen: false,
      ).deleteModule(moduleId);
    }
  }
}
