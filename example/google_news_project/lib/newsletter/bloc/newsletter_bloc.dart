import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:news_repository/news_repository.dart';

part 'newsletter_event.dart';
part 'newsletter_state.dart';

class NewsletterBloc extends Bloc<NewsletterEvent, NewsletterState> {
  NewsletterBloc({
    required this.newsRepository,
  }) : super(const NewsletterState()) {
    on<NewsletterSubscribed>(_onNewsletterSubscribed);
    on<EmailChanged>(_onEmailChanged);
  }

  final NewsRepository newsRepository;

  Future<void> _onNewsletterSubscribed(
    NewsletterSubscribed event,
    Emitter<NewsletterState> emit,
  ) async {
    if (state.email.value.isEmpty) return;
    emit(state.copyWith(status: NewsletterStatus.loading));
    try {
      await newsRepository.subscribeToNewsletter(email: state.email.value);
      emit(state.copyWith(status: NewsletterStatus.success));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: NewsletterStatus.failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onEmailChanged(
    EmailChanged event,
    Emitter<NewsletterState> emit,
  ) async {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([email]),
      ),
    );
  }
}
