/// Google News Template API Client-Side Library
library client;

export 'package:news_blocks/news_blocks.dart'
    show
        NewsBlock,
        BlockAction,
        BlockActionType,
        SectionHeaderBlock,
        DividerHorizontalBlock,
        SpacerBlock,
        Spacing,
        PostLargeBlock,
        PostMediumBlock,
        PostSmallBlock,
        PostGridGroupBlock,
        PostGridTileBlock,
        PostCategory,
        NewsBlocksConverter,
        TextCaptionBlock,
        TextCaptionColor,
        TextHeadlineBlock,
        TextLeadParagraphBlock,
        TextParagraphBlock,
        ImageBlock,
        VideoBlock;

export 'src/api/v1/articles/get_article/models/models.dart'
    show ArticleResponse;
export 'src/api/v1/articles/get_related_articles/models/models.dart'
    show RelatedArticlesResponse;
export 'src/api/v1/categories/get_categories/models/models.dart'
    show CategoriesResponse;
export 'src/api/v1/feed/get_feed/models/models.dart' show FeedResponse;
export 'src/api/v1/search/popular_search/models/models.dart'
    show PopularSearchResponse;
export 'src/api/v1/search/relevant_search/models/models.dart'
    show RelevantSearchResponse;
export 'src/api/v1/subscriptions/get_subscriptions/models/models.dart'
    show SubscriptionsResponse;
export 'src/client/google_news_template_api_client.dart'
    show
        GoogleNewsTemplateApiClient,
        GoogleNewsTemplateApiMalformedResponse,
        GoogleNewsTemplateApiRequestFailure,
        TokenProvider;
export 'src/data/models/models.dart'
    show Category, Feed, Subscription, SubscriptionCost, SubscriptionPlan;
