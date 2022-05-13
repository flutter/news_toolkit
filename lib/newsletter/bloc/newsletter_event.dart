part of 'newsletter_bloc.dart';

abstract class NewsletterEvent extends Equatable {
  const NewsletterEvent();
}

class NewsletterSubscribed extends NewsletterEvent with AnalyticsEventMixin {
  @override
  AnalyticsEvent get event => const AnalyticsEvent('NewsletterSubscribed');
}

class EmailChanged extends NewsletterEvent {
  const EmailChanged({required this.email});

  final String email;

  @override
  List<Object?> get props => [email];
}
