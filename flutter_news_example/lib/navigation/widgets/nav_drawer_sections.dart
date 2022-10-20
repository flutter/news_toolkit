import 'package:app_ui/app_ui.dart' show AppColors, AppSpacing;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_example/categories/categories.dart';
import 'package:flutter_news_example/home/home.dart';
import 'package:flutter_news_example/l10n/l10n.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

class NavDrawerSections extends StatelessWidget {
  const NavDrawerSections({super.key});

  @override
  Widget build(BuildContext context) {
    final categories =
        context.select((CategoriesBloc bloc) => bloc.state.categories) ?? [];

    final selectedCategory =
        context.select((CategoriesBloc bloc) => bloc.state.selectedCategory);

    return Column(
      children: [
        const NavDrawerSectionsTitle(),
        ...[
          for (final category in categories)
            NavDrawerSectionItem(
              key: ValueKey(category),
              title: toBeginningOfSentenceCase(category.name) ?? '',
              selected: category == selectedCategory,
              onTap: () {
                Scaffold.of(context).closeDrawer();
                context.read<HomeCubit>().setTab(0);
                context
                    .read<CategoriesBloc>()
                    .add(CategorySelected(category: category));
              },
            )
        ],
      ],
    );
  }
}

@visibleForTesting
class NavDrawerSectionsTitle extends StatelessWidget {
  const NavDrawerSectionsTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg + AppSpacing.xxs,
        ),
        child: Text(
          context.l10n.navigationDrawerSectionsTitle,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.primaryContainer,
              ),
        ),
      ),
    );
  }
}

@visibleForTesting
class NavDrawerSectionItem extends StatelessWidget {
  const NavDrawerSectionItem({
    super.key,
    required this.title,
    this.onTap,
    this.leading,
    this.selected = false,
  });

  static const _borderRadius = 100.0;

  final String title;
  final Widget? leading;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: leading,
      visualDensity: const VisualDensity(
        vertical: VisualDensity.minimumDensity,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: selected ? AppSpacing.xlg : AppSpacing.lg,
        vertical: AppSpacing.lg + AppSpacing.xxs,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(_borderRadius),
        ),
      ),
      horizontalTitleGap: AppSpacing.md,
      minLeadingWidth: AppSpacing.xlg,
      selectedTileColor: AppColors.white.withOpacity(0.08),
      selected: selected,
      onTap: onTap,
      title: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: selected
                  ? AppColors.highEmphasisPrimary
                  : AppColors.mediumEmphasisPrimary,
            ),
      ),
    );
  }
}
