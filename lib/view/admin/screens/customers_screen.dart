import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:mini_project_bank_sampah/common/utils.dart';
import 'package:mini_project_bank_sampah/model/short_profile.dart';
import 'package:mini_project_bank_sampah/service/admin_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Nasabah"),
      ),
      body: FutureBuilder<List<ShortProfile>>(
        future: AdminService().getShortProfiles(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              final users = snapshot.data;
              return ListView.builder(
                itemCount: users!.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  final name = user.name ?? 'No Name';
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: name.genColor,
                        child: Text(name[0].toUpperCase()),
                      ),
                      title: Text(name.capitalize),
                      // subtitle: Text(user.id),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          '/admin/customers/detail',
                          arguments: user.id,
                        );
                      },
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
