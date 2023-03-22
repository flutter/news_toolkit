import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ColorsPage extends StatelessWidget {
  const ColorsPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const ColorsPage());
  }

  @override
  Widget build(BuildContext context) {
    const colorItems = [
      _ColorItem(name: 'Secondary', color: AppColors.secondary),
      _ColorItem(name: 'Black', color: AppColors.black),
      _ColorItem(name: 'Black Light', color: AppColors.lightBlack),
      _ColorItem(
        name: 'Medium Emphasis',
        color: AppColors.mediumEmphasisSurface,
      ),
      _ColorItem(name: 'White', color: AppColors.white),
      _ColorItem(name: 'Modal Background', color: AppColors.modalBackground),
      _ColorItem(name: 'Transparent', color: AppColors.transparent),
      _ColorItem(name: 'Blue', color: AppColors.blue),
      _ColorItem(name: 'Sky Blue', color: AppColors.skyBlue),
      _ColorItem(name: 'Ocean Blue', color: AppColors.oceanBlue),
      _ColorItem(name: 'Light Blue', color: AppColors.lightBlue),
      _ColorItem(name: 'Blue Dress', color: AppColors.blueDress),
      _ColorItem(name: 'Crystal Blue', color: AppColors.crystalBlue),
      _ColorItem(name: 'Yellow', color: AppColors.yellow),
      _ColorItem(name: 'Red', color: AppColors.red),
      _ColorItem(name: 'Red Wine', color: AppColors.redWine),
      _ColorItem(name: 'Grey', color: AppColors.grey),
      _ColorItem(name: 'Liver', color: AppColors.liver),
      _ColorItem(name: 'Surface 2', color: AppColors.surface2),
      _ColorItem(name: 'Input Enabled', color: AppColors.inputEnabled),
      _ColorItem(name: 'Input Hover', color: AppColors.inputHover),
      _ColorItem(name: 'Input Focused', color: AppColors.inputFocused),
      _ColorItem(name: 'Pastel Grey', color: AppColors.pastelGrey),
      _ColorItem(name: 'Bright Grey', color: AppColors.brightGrey),
      _ColorItem(name: 'Pale Sky', color: AppColors.paleSky),
      _ColorItem(name: 'Green', color: AppColors.green),
      _ColorItem(name: 'Rangoon Green', color: AppColors.rangoonGreen),
      _ColorItem(name: 'Teal', color: AppColors.teal),
      _ColorItem(name: 'Dark Aqua', color: AppColors.darkAqua),
      _ColorItem(name: 'Eerie Black', color: AppColors.eerieBlack),
      _ColorItem(name: 'Gainsboro', color: AppColors.gainsboro),
      _ColorItem(name: 'Orange', color: AppColors.orange),
      _ColorItem(name: 'Outline Light', color: AppColors.outlineLight),
      _ColorItem(name: 'Outline On Dark', color: AppColors.outlineOnDark),
      _ColorItem(
        name: 'Medium Emphasis Primary',
        color: AppColors.mediumEmphasisPrimary,
      ),
      _ColorItem(
        name: 'High Emphasis Primary',
        color: AppColors.highEmphasisPrimary,
      ),
      _ColorItem(
        name: 'Medium High Emphasis Primary',
        color: AppColors.mediumHighEmphasisPrimary,
      ),
      _ColorItem(
        name: 'Medium High Emphasis Surface',
        color: AppColors.mediumHighEmphasisSurface,
      ),
      _ColorItem(
        name: 'High Emphasis Surface',
        color: AppColors.highEmphasisSurface,
      ),
      _ColorItem(
        name: 'Disabled Foreground',
        color: AppColors.disabledForeground,
      ),
      _ColorItem(
        name: 'Disabled Button',
        color: AppColors.disabledButton,
      ),
      _ColorItem(
        name: 'Disabled Surface',
        color: AppColors.disabledSurface,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Colors')),
      body: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: colorItems.length,
        itemBuilder: (_, index) => colorItems[index],
      ),
    );
  }
}

class _ColorItem extends StatelessWidget {
  const _ColorItem({required this.name, required this.color});

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(name),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: color is MaterialColor
                  ? _MaterialColorView(color: color as MaterialColor)
                  : _ColorSquare(color: color),
            ),
          ),
        ],
      ),
    );
  }
}

class _MaterialColorView extends StatelessWidget {
  const _MaterialColorView({required this.color});

  static const List<int> shades = [
    50,
    100,
    200,
    300,
    400,
    500,
    600,
    700,
    800,
    900,
  ];

  final MaterialColor color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: shades.map((shade) {
        return _ColorSquare(color: color[shade]!);
      }).toList(),
    );
  }
}

class _ColorSquare extends StatelessWidget {
  const _ColorSquare({required this.color});

  final Color color;

  TextStyle get textStyle {
    return TextStyle(
      color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
    );
  }

  String get hexCode {
    if (color.value.toRadixString(16).length <= 2) {
      return '--';
    } else {
      return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Stack(
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: DecoratedBox(
              decoration: BoxDecoration(color: color, border: Border.all()),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(child: Text(hexCode, style: textStyle)),
          ),
        ],
      ),
    );
  }
}
