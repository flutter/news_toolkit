/// Google News Template API Server-Side Library
library api;

export 'src/api/api.dart' show ApiController;
export 'src/api/v1/articles/get_article/models/models.dart'
    show ArticleResponse;
export 'src/api/v1/categories/get_categories/models/models.dart'
    show CategoriesResponse;
export 'src/api/v1/feed/get_feed/models/models.dart' show FeedResponse;
export 'src/data/in_memory_news_data_source.dart' show InMemoryNewsDataSource;
export 'src/data/models/models.dart'
    show Article, Category, Feed, RelatedArticles;
export 'src/data/news_data_source.dart' show NewsDataSource;
export 'src/di.dart' show GetRequest, PipelineInjection;
