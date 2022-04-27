import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:gallery/helpers/helper.dart';

class AppTextFieldPage extends StatefulWidget {
  const AppTextFieldPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const AppTextFieldPage());
  }

  @override
  State<AppTextFieldPage> createState() => _AppTextFieldPageState();
}

class _AppTextFieldPageState extends State<AppTextFieldPage> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TextField',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: AppEmailField(
          controller: controller,
          hintText: 'Your email address',
          errorText: _errorText,
          onChanged: (email) {},
          suffixOpacity: 1,
          onSuffixPressed: () {},
        ),
      ),
    );
  }

  String? get _errorText {
    final text = controller.value.text;
    if (text.isEmpty) {
      return null;
    }
    if (text.isNotEmpty && !text.isValidEmail()) {
      return 'Invalid email';
    }
    // return null if the text is valid
    return null;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
