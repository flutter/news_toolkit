/// Google News Template API Server-Side Library
library api;

export 'src/data/in_memory_news_data_source.dart' show InMemoryNewsDataSource;
export 'src/data/models/models.dart'
    show
        Article,
        Category,
        Feed,
        RelatedArticles,
        Subscription,
        SubscriptionCost,
        SubscriptionPlan,
        User;
export 'src/data/news_data_source.dart' show NewsDataSource;
export 'src/middleware/middleware.dart'
    show RequestUser, newsDataSourceProvider, userProvider;
export 'src/models/models.dart'
    show
        ArticleResponse,
        CategoriesResponse,
        CurrentUserResponse,
        FeedResponse,
        PopularSearchResponse,
        RelatedArticlesResponse,
        RelevantSearchResponse,
        SubscriptionsResponse;
