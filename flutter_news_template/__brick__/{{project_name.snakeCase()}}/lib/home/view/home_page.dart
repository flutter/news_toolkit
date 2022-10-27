import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{project_name.snakeCase()}}/categories/categories.dart';
import 'package:{{project_name.snakeCase()}}/feed/feed.dart';
import 'package:{{project_name.snakeCase()}}/home/home.dart';
import 'package:news_repository/news_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Page page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CategoriesBloc(
            newsRepository: context.read<NewsRepository>(),
          )..add(const CategoriesRequested()),
        ),
        BlocProvider(
          create: (context) => FeedBloc(
            newsRepository: context.read<NewsRepository>(),
          ),
        ),
        BlocProvider(create: (_) => HomeCubit())
      ],
      child: const HomeView(),
    );
  }
}
