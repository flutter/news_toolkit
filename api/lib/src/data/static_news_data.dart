part of 'in_memory_news_data_source.dart';

/// The static news feed content.
final technologyItems = <NewsItem>[
  NewsItem(
    post: PostLargeBlock(
      id: '499305f6-5096-4051-afda-824dcfc7df23',
      category: PostCategory.technology,
      author: 'Sean Hollister',
      publishedAt: DateTime(2022, 3, 9),
      imageUrl:
          'https://cdn.vox-cdn.com/thumbor/OTpmptgr7XcTVAJ27UBvIxl0vrg=/0x146:2040x1214/fit-in/1200x630/cdn.vox-cdn.com/uploads/chorus_asset/file/22049166/shollister_201117_4303_0003.0.jpg',
      title: 'Nvidia and AMD GPUs are returning to shelves '
          'and prices are finally falling',
    ),
    content: const [
      SectionHeaderBlock(
        title: 'Nvidia and AMD GPUs are returning to shelves '
            'and prices are finally falling',
      ),
    ],
  )
];

/// Sports news items.
final sportsItems = <NewsItem>[
  NewsItem(
    post: PostMediumBlock(
      id: '82c49bf1-946d-4920-a801-302291f367b5',
      category: PostCategory.sports,
      author: 'Tom Dierberger',
      publishedAt: DateTime(2022, 3, 10),
      imageUrl:
          'https://www.nbcsports.com/sites/rsnunited/files/styles/metatags_opengraph/public/article/hero/pat-bev-ja-morant-USA.jpg',
      title: 'Patrick Beverley throws shade at Warriors '
          'for Ja Morant struggles - NBC Sports',
      description:
          'Patrick Beverley is no longer participating in the NBA playoffs, '
          'but he sure has a lot to say. In Game 2 between the Warriors and '
          'Memphis Grizzlies on Tuesday night, Ja Morant torched the Dubs '
          'for 47 points...',
    ),
    content: const [
      SectionHeaderBlock(
        title: 'Patrick Beverley throws shade at Warriors '
            'for Ja Morant struggles',
      ),
    ],
  ),
];

/// Health news items.
final healthItems = <NewsItem>[
  NewsItem(
    post: PostSmallBlock(
      id: 'b1fc2ffc-eb02-42ce-af65-79702172a987',
      category: PostCategory.health,
      author: 'Northwestern University',
      publishedAt: DateTime(2022, 3, 11),
      imageUrl: 'https://scitechdaily.com/images/Ear-Hearing-Concept.jpg',
      title: 'Restoring Hearing: New Tool To Create Ear Hair Cells '
          'Lost Due to Aging or Noise',
      description: '‘We have overcome a major hurdle’ to restore hearing, '
          'investigators say. Gene discovery allows the production of inner '
          'or outer ear hair cells, death of outer hair cells due to aging '
          'or noise cause most hearing loss...',
    ),
    content: const [
      SectionHeaderBlock(
        title: 'Restoring Hearing: New Tool To Create Ear Hair Cells '
            'Lost Due to Aging or Noise',
      ),
    ],
  ),
];

/// Science news items.
final scienceItems = <NewsItem>[
  NewsItem(
    post: PostGridTileBlock(
      id: '384a15ff-a50e-46d5-96a7-8864facdcc48',
      category: PostCategory.science,
      author: 'Loren Grush',
      publishedAt: DateTime(2022, 5, 6),
      imageUrl:
          'https://cdn.vox-cdn.com/thumbor/eqkJgsUMn-iJOrN98c4gduFGDT8=/0x74:1050x624/fit-in/1200x630/cdn.vox-cdn.com/uploads/chorus_asset/file/23441881/Screen_Shot_2022_05_06_at_1.13.12_AM.png',
      title:
          'SpaceX successfully returns four astronauts from the International '
          'Space Station',
    ),
    content: const [
      SectionHeaderBlock(
        title: 'SpaceX successfully returns four astronauts from the '
            'International Space Station',
      ),
    ],
  ),
  NewsItem(
    post: PostGridTileBlock(
      id: '13e448bb-cd26-4ae0-b138-4a67067f7a93',
      category: PostCategory.science,
      author: 'Daniel Strain',
      publishedAt: DateTime(2022, 5, 6),
      imageUrl:
          'https://scx2.b-cdn.net/gfx/news/2022/a-surging-glow-in-a-di.jpg',
      title:
          'A surging glow in a distant galaxy could change the way we look at '
          'black holes',
    ),
    content: const [
      SectionHeaderBlock(
        title: 'A surging glow in a distant galaxy could change '
            'the way we look at black holes',
      ),
    ],
  ),
  NewsItem(
    post: PostGridTileBlock(
      id: '842e3193-86d2-4069-a7e6-f769faa6f970',
      category: PostCategory.science,
      author: 'SciTechDaily',
      publishedAt: DateTime(2022, 5, 5),
      imageUrl:
          'https://scitechdaily.com/images/Qubit-Platform-Single-Electron-on-Solid-Neon.jpg',
      title: 'The Quest for an Ideal Quantum Bit: New Qubit Breakthrough Could '
          'Revolutionize Quantum Computing',
    ),
    content: const [
      SectionHeaderBlock(
        title:
            'The Quest for an Ideal Quantum Bit: New Qubit Breakthrough Could '
            'Revolutionize Quantum Computing',
      ),
    ],
  ),
  NewsItem(
    post: PostGridTileBlock(
      id: '1f79da6f-64cb-430a-b7b2-2318d23b719f',
      category: PostCategory.science,
      author: 'SciTechDaily',
      publishedAt: DateTime(2022, 5, 4),
      imageUrl: 'https://scitechdaily.com/images/Black-Hole-Sonification.gif',
      title: 'Hear What a Black Hole Sounds Like – New NASA Black Hole '
          'Sonifications With a Remix',
    ),
    content: const [
      SectionHeaderBlock(
        title: 'Hear What a Black Hole Sounds Like – New NASA Black Hole '
            'Sonifications With a Remix',
      ),
    ],
  )
];

/// Top news feed blocks.
final topNewsFeedBlocks = <NewsBlock>[
  const SectionHeaderBlock(title: 'Breaking News'),
  const DividerHorizontalBlock(),
  const SpacerBlock(spacing: Spacing.medium),
  technologyItems.first.post,
  const SpacerBlock(spacing: Spacing.medium),
  sportsItems.first.post,
  const SpacerBlock(spacing: Spacing.small),
  healthItems.first.post,
  const SpacerBlock(spacing: Spacing.extraSmall),
];

/// Technology feed blocks.
final technologyFeedBlocks = <NewsBlock>[
  const SectionHeaderBlock(title: 'Technology'),
  const DividerHorizontalBlock(),
  technologyItems.first.post,
  const SpacerBlock(spacing: Spacing.medium),
  const NewsletterBlock(),
  const SpacerBlock(spacing: Spacing.medium),
];

/// Sports feed blocks.
final sportsFeedBlocks = <NewsBlock>[
  const SectionHeaderBlock(title: 'Sports'),
  const DividerHorizontalBlock(),
  sportsItems.first.post,
  const SpacerBlock(spacing: Spacing.medium),
];

/// Health feed blocks.
final healthFeedBlocks = <NewsBlock>[
  const SectionHeaderBlock(title: 'Health'),
  const DividerHorizontalBlock(),
  healthItems.first.post,
  const SpacerBlock(spacing: Spacing.medium),
];

/// Science feed blocks.
final scienceFeedBlocks = <NewsBlock>[
  const SectionHeaderBlock(title: 'Science'),
  const DividerHorizontalBlock(),
  PostGridGroupBlock(
    category: PostCategory.science,
    tiles: [...scienceItems.map((e) => e.post).cast<PostGridTileBlock>()],
  ),
  const SpacerBlock(spacing: Spacing.medium),
];

List<NewsItem> get _newsItems {
  return [
    ...technologyItems,
    ...sportsItems,
    ...healthItems,
    ...scienceItems,
  ];
}

final _newsFeedData = <Category, Feed>{
  Category.top: topNewsFeedBlocks.toFeed(),
  Category.technology: technologyFeedBlocks.toFeed(),
  Category.sports: sportsFeedBlocks.toFeed(),
  Category.health: healthFeedBlocks.toFeed(),
  Category.science: scienceFeedBlocks.toFeed(),
};

extension on List<NewsBlock> {
  Feed toFeed() => Feed(blocks: this, totalBlocks: length);
  Article toArticle() => Article(blocks: this, totalBlocks: length);
}
