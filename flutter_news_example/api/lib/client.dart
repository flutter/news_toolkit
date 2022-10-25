/// Flutter News Toolkit API Client-Side Library
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
        VideoBlock,
        TrendingStoryBlock;

export 'src/client/flutter_news_template_api_client.dart'
    show
        GoogleNewsTemplateApiClient,
        GoogleNewsTemplateApiMalformedResponse,
        GoogleNewsTemplateApiRequestFailure,
        TokenProvider;
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
