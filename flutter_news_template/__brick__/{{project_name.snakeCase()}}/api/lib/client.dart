/// {{app_name}} API Client-Side Library
library client;

export 'package:news_blocks/news_blocks.dart'
    show
        BlockAction,
        BlockActionType,
        DividerHorizontalBlock,
        ImageBlock,
        NewsBlock,
        NewsBlocksConverter,
        PostCategory,
        PostGridGroupBlock,
        PostGridTileBlock,
        PostLargeBlock,
        PostMediumBlock,
        PostSmallBlock,
        SectionHeaderBlock,
        SpacerBlock,
        Spacing,
        TextCaptionBlock,
        TextCaptionColor,
        TextHeadlineBlock,
        TextLeadParagraphBlock,
        TextParagraphBlock,
        TrendingStoryBlock,
        VideoBlock;

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
