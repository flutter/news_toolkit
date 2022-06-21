import 'package:analytics_repository/analytics_repository.dart';
import 'package:flutter_test/flutter_test.dart';

// NTGEvent is exported and can be implemented.
class FakeNTGEvent extends Fake implements NTGEvent {}

void main() {
  group('NTGEvent', () {
    test('can be implemented', () {
      expect(FakeNTGEvent.new, returnsNormally);
    });

    group('NewsletterEvent', () {
      group('signUp', () {
        test('has correct values', () {
          final event = NewsletterEvent.signUp();
          expect(event.name, equals('newsletter-signup'));
          expect(event.properties!['eventCategory'], equals('NTG newsletter'));
          expect(event.properties!['eventAction'], equals('newsletter signup'));
          expect(event.properties!['eventLabel'], equals('success'));
          expect(event.properties!['nonInteraction'], isFalse);
        });
      });

      group('impression', () {
        test(
            'has correct values '
            'when articleTitle is empty', () {
          final event = NewsletterEvent.impression();
          expect(event.name, equals('newsletter-impression'));
          expect(event.properties!['eventCategory'], equals('NTG newsletter'));
          expect(
            event.properties!['eventAction'],
            equals('newsletter modal impression 3'),
          );
          expect(event.properties!['eventLabel'], equals(''));
          expect(event.properties!['nonInteraction'], isFalse);
        });

        test(
            'has correct values '
            'when articleTitle is not empty', () {
          const articleTitle = 'articleTitle';
          final event = NewsletterEvent.impression(articleTitle: articleTitle);
          expect(event.name, equals('newsletter-impression'));
          expect(event.properties!['eventCategory'], equals('NTG newsletter'));
          expect(
            event.properties!['eventAction'],
            equals('newsletter modal impression 3'),
          );
          expect(event.properties!['eventLabel'], equals(articleTitle));
          expect(event.properties!['nonInteraction'], isFalse);
        });
      });
    });

    group('LoginEvent', () {
      test('has correct values', () {
        final event = LoginEvent();
        expect(event.name, equals('login'));
        expect(event.properties!['eventCategory'], equals('NTG account'));
        expect(event.properties!['eventAction'], equals('login'));
        expect(event.properties!['eventLabel'], equals('success'));
        expect(event.properties!['nonInteraction'], isFalse);
      });
    });

    group('RegistrationEvent', () {
      test('has correct values', () {
        final event = RegistrationEvent();
        expect(event.name, equals('registration'));
        expect(event.properties!['eventCategory'], equals('NTG account'));
        expect(event.properties!['eventAction'], equals('registration'));
        expect(event.properties!['eventLabel'], equals('success'));
        expect(event.properties!['nonInteraction'], isFalse);
      });
    });

    group('ArticleMilestoneEvent', () {
      test('has correct values', () {
        const milestonePercentage = 25;
        const articleTitle = 'articleTitle';
        final event = ArticleMilestoneEvent(
          milestonePercentage: milestonePercentage,
          articleTitle: articleTitle,
        );
        expect(event.name, equals('article-milestone'));
        expect(
          event.properties!['eventCategory'],
          equals('NTG article milestone'),
        );
        expect(
          event.properties!['eventAction'],
          equals('$milestonePercentage%'),
        );
        expect(event.properties!['eventLabel'], equals(articleTitle));
        expect(event.properties!['eventValue'], equals(milestonePercentage));
        expect(event.properties!['nonInteraction'], isTrue);
        expect(event.properties!['hitType'], equals('event'));
      });
    });

    group('ArticleCommentEvent', () {
      test('has correct values', () {
        const articleTitle = 'articleTitle';
        final event = ArticleCommentEvent(articleTitle: articleTitle);
        expect(event.name, equals('comment'));
        expect(event.properties!['eventCategory'], equals('NTG user'));
        expect(event.properties!['eventAction'], equals('comment added'));
        expect(event.properties!['eventLabel'], equals(articleTitle));
        expect(event.properties!['nonInteraction'], isFalse);
      });
    });

    group('SocialShareEvent', () {
      test('has correct values', () {
        final event = SocialShareEvent();
        expect(event.name, equals('social-share'));
        expect(event.properties!['eventCategory'], equals('NTG social'));
        expect(event.properties!['eventAction'], equals('social share'));
        expect(event.properties!['eventLabel'], equals('OS share menu'));
        expect(event.properties!['nonInteraction'], isFalse);
      });
    });

    group('PushNotificationSubscriptionEvent', () {
      test('has correct values', () {
        final event = PushNotificationSubscriptionEvent();
        expect(event.name, equals('push-notification-click'));
        expect(
          event.properties!['eventCategory'],
          equals('NTG push notification'),
        );
        expect(event.properties!['eventAction'], equals('click'));
        expect(event.properties!['nonInteraction'], isFalse);
      });
    });

    group('PaywallPromptEvent', () {
      group('impression', () {
        test('has correct values', () {
          const impression = PaywallPromptImpression.subscription;
          const articleTitle = 'articleTitle';
          final event = PaywallPromptEvent.impression(
            impression: impression,
            articleTitle: articleTitle,
          );
          expect(event.name, equals('paywall-impression'));
          expect(event.properties!['eventCategory'], equals('NTG paywall'));
          expect(
            event.properties!['eventAction'],
            equals('paywall modal impression $impression'),
          );
          expect(event.properties!['eventLabel'], equals(articleTitle));
          expect(event.properties!['nonInteraction'], isTrue);
        });
      });

      group('click', () {
        test('has correct values', () {
          const articleTitle = 'articleTitle';
          final event = PaywallPromptEvent.click(
            articleTitle: articleTitle,
          );
          expect(event.name, equals('paywall-click'));
          expect(event.properties!['eventCategory'], equals('NTG paywall'));
          expect(event.properties!['eventAction'], equals('click'));
          expect(event.properties!['eventLabel'], equals(articleTitle));
          expect(event.properties!['nonInteraction'], isFalse);
        });
      });
    });

    group('PaywallPromptImpression', () {
      test('rewarded toString returns 1', () {
        expect(PaywallPromptImpression.rewarded.toString(), equals('1'));
      });

      test('subscription toString returns 2', () {
        expect(PaywallPromptImpression.subscription.toString(), equals('2'));
      });
    });

    group('UserSubscriptionConversionEvent', () {
      test('has correct values', () {
        final event = UserSubscriptionConversionEvent();
        expect(event.name, equals('subscription-submit'));
        expect(event.properties!['eventCategory'], equals('NTG subscription'));
        expect(event.properties!['eventAction'], equals('submit'));
        expect(event.properties!['eventLabel'], equals('success'));
        expect(event.properties!['nonInteraction'], isFalse);
      });
    });
  });
}
