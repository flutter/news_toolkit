---
sidebar_position: 5
description: Learn how to configure your own newsletter.
---

# Creating a newsletter

The current [implementation](https://github.com/flutter/news_toolkit/blob/main/flutter_news_example/api/routes/api/v1/newsletter/subscription.dart) of a newsletter email subscription always returns true and the response is handled in the app as a success state. Be aware that the current implementation of this feature doesn't store the subscriber state for a user.

```dart
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  return Response(statusCode: HttpStatus.created);
}
```

To fully use the newsletter subscription feature, please add your API handling logic or an already existing email service, such as [mailchimp.](https://mailchimp.com/)
