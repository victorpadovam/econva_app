import 'package:econva_app/presentation/pages/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Econva'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value != null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(controller.errorMessage.value!),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: controller.loadUsers,
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadUsers,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.users.length,
            itemBuilder: (context, index) {
              final user = controller.users[index];

              return Card(
                child: ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  leading: CircleAvatar(
                    child: Text(user.id.toString()),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
