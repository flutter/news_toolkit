/// Google News Template API Client-Side Library
library client;

export 'package:news_blocks/news_blocks.dart'
    show
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
        TextHeadlineBlock,
        TextLeadParagraphBlock,
        TextParagraphBlock,
        VideoBlock;

export 'src/api/v1/articles/get_article/models/models.dart'
    show ArticleResponse;
export 'src/api/v1/categories/get_categories/models/models.dart'
    show CategoriesResponse;
export 'src/api/v1/feed/get_feed/models/models.dart' show FeedResponse;
export 'src/client/google_news_template_api_client.dart'
    show
        GoogleNewsTemplateApiClient,
        GoogleNewsTemplateApiMalformedResponse,
        GoogleNewsTemplateApiRequestFailure;
export 'src/data/models/models.dart' show Category, Feed;
