import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/apiexperiment_controller.dart';

class ApiexperimentView extends GetView<ApiexperimentController> {
  const ApiexperimentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Eksperimen API')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: controller.fetchWithHttp,
                child: const Text('Fetch via HTTP'),
              ),
              ElevatedButton(
                onPressed: controller.fetchWithDio,
                child: const Text('Fetch via Dio'),
              ),
              const SizedBox(height: 12),
              Obx(() => Text(controller.result.value, textAlign: TextAlign.center)),
              const Divider(height: 32),
              ElevatedButton(
                onPressed: controller.testAsyncHandling,
                child: const Text('Uji Async-Await'),
              ),
              ElevatedButton(
                onPressed: controller.testCallbackHandling,
                child: const Text('Uji Callback Chaining'),
              ),
              const SizedBox(height: 12),
              Obx(() => Text(controller.recommendation.value, textAlign: TextAlign.center)),
            ],
          ),
        ),
      ),
    );
  }
}
