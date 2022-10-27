/// {{app_name}} API Client-Side Library
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

export 'src/client/{{project_name.snakeCase()}}_api_client.dart'
    show
        {{project_name.pascalCase()}}ApiClient,
        {{project_name.pascalCase()}}ApiMalformedResponse,
        {{project_name.pascalCase()}}ApiRequestFailure,
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
