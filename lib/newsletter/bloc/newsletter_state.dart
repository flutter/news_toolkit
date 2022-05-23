part of 'newsletter_bloc.dart';

enum NewsletterStatus {
  initial,
  loading,
  success,
  failure,
}

class NewsletterState extends Equatable {
  const NewsletterState({
    this.status = NewsletterStatus.initial,
    this.isValid = false,
    this.email = const Email.pure(),
  });

  final NewsletterStatus status;
  final bool isValid;
  final Email email;

  @override
  List<Object> get props => [status, email, isValid];

  NewsletterState copyWith({
    NewsletterStatus? status,
    Email? email,
    bool? isValid,
  }) =>
      NewsletterState(
        status: status ?? this.status,
        email: email ?? this.email,
        isValid: isValid ?? this.isValid,
      );
}
