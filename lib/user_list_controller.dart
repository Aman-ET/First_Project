

import 'package:flutter/material.dart';
import 'package:essential_demo/grid_detail_view.dart';
import 'package:essential_demo/login_view.dart';
import 'package:essential_demo/database_connection.dart';
import 'package:essential_demo/user_details.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';


/*
class Product {
  const Product({required this.name, required this.price, required this.inStock});

  final String name;
  final double price;
  final bool inStock;
}

*/

class UserListView extends StatefulWidget {
  const UserListView({super.key});
  @override
  State<UserListView> createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {

  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // initialization();
    // fetchApiResponse();
  }

  Future<List<UserDetails>> fetchApiResponse() async {
    final url = Uri.parse('https://fake-json-api.mock.beeceptor.com/users');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Successfully hit the API
        List<dynamic> body = jsonDecode(response.body);
        print(body);


        // print('Response Data: $data');
        List<UserDetails> users = body.map((dynamic item) =>
            UserDetails.fromJson(item)).toList();
        return users;
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Failed to load users');
    }
  }

  // Function to show update dialog

  void _showUpdateDialog(Map<String, dynamic> user) {
    // Store the old name before the user starts typing a new one
    String oldName = user['name'];
    _nameController.text = oldName;

    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text("Update User"),
            content: TextField(controller: _nameController),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel")),
              ElevatedButton(
                onPressed: () async {
                  Map<String, dynamic> updatedRow = {
                    'name': _nameController.text, // New name from TextField
                    'age': user['age'],
                  };

                  // Call the new function using the old name as the filter
                  await DatabaseHelper.instance.updateUserByName(
                      oldName, updatedRow);

                  if (context.mounted) {
                    setState(() {}); // Refresh the list
                    Navigator.pop(context);
                  }
                },
                child: const Text("Update"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Directory"),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      // 2. FutureBuilder handles the "Loading", "Error", and "Success" states
      body: FutureBuilder<List<UserDetails>>(
        future: fetchApiResponse(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No users found"));
          }

          final users = snapshot.data!;

          // 3. ListView.builder creates a scrollable list of custom cards
          return ListView.builder(
            itemCount: users.length,
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemBuilder: (context, index) {
              final user = users[index]; // Define 'user' here for this specific row

              // 4. THE CUSTOM VIEW (CARD)
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section: Avatar & Top Info
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: user.photo,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Container(color: Colors.grey[200]),
                              errorWidget: (context, url, error) =>
                              const Icon(Icons.person, size: 40),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user.name,
                                    style: const TextStyle(fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                Text("@${user.username}",
                                    style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 13)),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(user.company,
                                      style: TextStyle(
                                          color: Colors.blue.shade800,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(),
                      ),

                      // Details Grid Section using the helper method
                      _buildDetailRow(
                          Icons.email_outlined, user.email, "Email"),
                      _buildDetailRow(Icons.phone_android, user.phone, "Phone"),
                      _buildDetailRow(Icons.location_on_outlined,
                          "${user.address}, ${user.state}", "Address"),
                      _buildDetailRow(
                          Icons.public, "${user.country}, ${user.zip}",
                          "Region"),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // 5. HELPER METHOD: Creates the small info rows inside the card
  Widget _buildDetailRow(IconData icon, String value, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.blueGrey[400]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 10,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold)),
                Text(value, style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w400)),
              ],
            ),
          ),
        ],
      ),
    );
  }

/*
  // Inside your State class
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User List')),
      body: FutureBuilder<List<UserDetails>>(
        future: fetchApiResponse(), // Your API function
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          // Success: Display the ListView
          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(users[index].name),
                subtitle: Text("ID: ${users[index].id}"),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(users[index].photo),
                  backgroundColor: Colors.transparent,
                ),
              );
            },
          );
        },
      ),
    );
  }
*/

/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All Users")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        // 1. Call your existing function here
        // future: DatabaseHelper.instance.queryAllUsers(),
        future: DatabaseHelper.instance.getUsersSorted(),
        builder: (context, snapshot) {
          // 2. Handle the "Loading" state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // 3. Handle Errors
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          // 4. Handle Empty Data
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No users found in database."));
          }

          // 5. Display the List
          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];



              return ListTile(
                title: Text(user['name'] ?? 'Unknown User'),
                subtitle: Text("Age: ${user['age']}"),

                // ADD THIS ONTAP LOGIC HERE
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        title: const Text("Delete User"),
                        content: Text("Are you sure you want to delete ${user['name']}?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: const Text("CANCEL"),
                          ),
                          TextButton(
                            onPressed: () async {
                              // 1. Database call
                              await DatabaseHelper.instance.deleteUserByName(user['name']);

                              // 2. THE FIX: Check context.mounted after the 'async gap'
                              if (!context.mounted) return;

                              // 3. Refresh and close
                              setState(() {}); // Triggers the FutureBuilder to reload
                              Navigator.pop(dialogContext); // Closes the dialog

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("${user['name']} deleted")),
                              );
                            },
                            child: const Text("DELETE", style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      );
                    },
                  );
                },
              );


/*
              return Dismissible(
                key: Key(user['name']), // Required: unique key
                direction: DismissDirection.endToStart, // Swipe right-to-left
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.black), // Show trash icon
                ),
                onDismissed: (direction) async {
                  // Perform the delete
                  await DatabaseHelper.instance.deleteUserByName(user['name']);
                  if (context.mounted) {
                    setState(() {}); // Refresh list
                  }
                },
                // THIS WAS LIKELY MISSING:
                child: ListTile(
                  leading: CircleAvatar(child: Text((index + 1).toString())),
                  title: Text(user['name'] ?? 'Unknown User'),
                  subtitle: Text("Age: ${user['age']}"),
                  // trailing: IconButton(
                  //    icon: const Icon(Icons.edit, color: Colors.blue),
                  //    onPressed: () => _showUpdateDialog(user),
                  // ),
                ),
              ); */



            },
          );
        },
      ),
    );
  }
}

*/


}


