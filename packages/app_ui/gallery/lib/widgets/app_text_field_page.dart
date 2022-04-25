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
  var _opacity = 0.0;
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(controller.text);
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
          prefix: const Padding(
            padding: EdgeInsets.only(
              left: AppSpacing.sm,
              right: AppSpacing.sm,
            ),
            child: Icon(
              Icons.email_outlined,
              color: AppColors.mediumEmphasis,
              size: 24,
            ),
          ),
          onChanged: (email) {
            setState(() {
              if (email.isNotEmpty) {
                _opacity = 1.0;
              } else {
                _opacity = 0.0;
              }
            });
          },
          suffix: Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: Opacity(
              opacity: _opacity,
              child: GestureDetector(
                onTap: () {
                  controller.text = '';
                  setState(() {
                    _opacity = 0.0;
                  });
                },
                child: Assets.icons.closeCircle.svg(),
              ),
            ),
          ),
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
