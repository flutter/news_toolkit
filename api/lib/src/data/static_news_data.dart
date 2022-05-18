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
      action: const NavigateToArticleAction(
        articleId: '499305f6-5096-4051-afda-824dcfc7df23',
      ),
    ),
    content: [
      ArticleIntroductionBlock(
        category: PostCategory.technology,
        author: 'Sean Hollister',
        publishedAt: DateTime(2022, 3, 9),
        title: 'Nvidia and AMD GPUs are returning to shelves '
            'and prices are finally falling',
        imageUrl:
            'https://cdn.vox-cdn.com/thumbor/OTpmptgr7XcTVAJ27UBvIxl0vrg=/0x146:2040x1214/fit-in/1200x630/cdn.vox-cdn.com/uploads/chorus_asset/file/22049166/shollister_201117_4303_0003.0.jpg',
      ),
      const TextLeadParagraphBlock(
        text:
            'Scientists at the University of Copenhagen research institute have'
            ' developed an Artificial Intelligence (AI) algorithm that can help'
            ' communicate with animals in the future. Currently, AI algorithms '
            'are being used on pigs to decode their emotions and researchers '
            'claim that they have achieved 60% of success in translating '
            'positive & negative emotions hidden in pig grunts.',
      ),
      const SpacerBlock(spacing: Spacing.large),
      const TextParagraphBlock(
        text:
            'Cybersecurity Insiders has learned that an algorithm induced with '
            '7,414 recordings of pig calls from over 411 pigs was analyzed and '
            'will be used further to improve the mental health of swine.',
      ),
      const SpacerBlock(spacing: Spacing.large),
      const VideoBlock(
        videoUrl:
            'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      ),
      const SpacerBlock(spacing: Spacing.large),
      const TextParagraphBlock(
        text: 'Apparently, the breakthrough can also pave the way to a new '
            'world where humans could communicate with animals and that can '
            'lead to an ecosystem where every living being receives equal '
            'respect in this supernatural power-driven world.',
      ),
      const SpacerBlock(spacing: Spacing.large),
      const ImageBlock(
        imageUrl:
            'https://cdn.vox-cdn.com/thumbor/OTpmptgr7XcTVAJ27UBvIxl0vrg=/0x146:2040x1214/fit-in/1200x630/cdn.vox-cdn.com/uploads/chorus_asset/file/22049166/shollister_201117_4303_0003.0.jpg',
      ),
    ],
    relatedArticles: [
      PostSmallBlock(
        id: '2224b86e-60d6-461a-a5d8-e8e71589669f',
        category: PostCategory.technology,
        author: 'The Drive',
        publishedAt: DateTime(2022, 3, 17),
        imageUrl:
            'https://www.thedrive.com/uploads/2022/05/17/asdrf.jpg?auto=webp',
        title: 'Leaked Pic Hints Ford F-150 Raptor R '
            'Will Get the Mustang GT500 V8',
        description:
            'A build sheet leaked to Instagram indicates that the upcoming '
            "F-150 Raptor R will likely get the GT500's "
            'supercharged V8 engine.',
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
      action: const NavigateToArticleAction(
        articleId: '82c49bf1-946d-4920-a801-302291f367b5',
      ),
    ),
    content: const [
      SectionHeaderBlock(
        title: 'Patrick Beverley throws shade at Warriors '
            'for Ja Morant struggles',
      ),
    ],
    relatedArticles: [
      PostSmallBlock(
        id: 'b77f8854-7483-4353-ac91-5a8a10e576b0',
        category: PostCategory.sports,
        author: 'Bleacher Report',
        publishedAt: DateTime(2022, 3, 17),
        imageUrl:
            'https://img.bleacherreport.net/img/images/photos/003/921/731/fb79b6bfb3d129622735c307266f225c_crop_exact.jpg?w=1200&h=1200&q=75',
        title: '1 Trade Every Lottery Team Must Consider '
            'If It Wins No. 1 Draft Pick',
        description:
            'The 2022  NBA draft  lottery is Tuesday, and it could change '
            'everything for whichever team lands the first overall pick. '
            'In most cases, the squad that secures that top '
            'selection should keep it...',
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
      action: const NavigateToArticleAction(
        articleId: 'b1fc2ffc-eb02-42ce-af65-79702172a987',
      ),
    ),
    content: const [
      SectionHeaderBlock(
        title: 'Restoring Hearing: New Tool To Create Ear Hair Cells '
            'Lost Due to Aging or Noise',
      ),
    ],
    relatedArticles: [
      PostSmallBlock(
        id: '7a5661d7-32a3-4b05-9fe2-7bc5ff8ea904',
        category: PostCategory.health,
        author: 'New York Times',
        publishedAt: DateTime(2022, 3, 17),
        imageUrl:
            'https://static01.nyt.com/images/2022/05/17/science/00kidney1/00kidney1-facebookJumbo.jpg',
        title: 'Targeting the Uneven Burden of Kidney Disease '
            'on Black Americans',
        description:
            'New treatments aim for a gene variant causing the illness in '
            'people of sub-Saharan African descent. '
            'Some experts worry that focus will neglect other factors.',
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
      action: const NavigateToArticleAction(
        articleId: '384a15ff-a50e-46d5-96a7-8864facdcc48',
      ),
    ),
    content: const [
      SectionHeaderBlock(
        title: 'SpaceX successfully returns four astronauts from the '
            'International Space Station',
      ),
    ],
    relatedArticles: [
      PostSmallBlock(
        id: 'bfd5aa62-4c50-40c6-9aef-5511535c7b68',
        category: PostCategory.science,
        author: 'SciTechDaily',
        publishedAt: DateTime(2022, 3, 17),
        imageUrl:
            'https://scitechdaily.com/images/Sample-of-Hypatia-Stone-From-Outside-Solar-System.jpg',
        title: 'Extraterrestrial Stone Could Be First Evidence '
            'on Earth of Supernova Ia Explosion',
        description:
            'New chemistry ‘forensics’ indicates that the stone named Hypatia '
            'from the Egyptian desert could be the first physical evidence '
            'found on Earth of a supernova type Ia explosion. '
            'These rare supernovas are some of the most energetic '
            'events in the universe.',
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
      action: const NavigateToArticleAction(
        articleId: '13e448bb-cd26-4ae0-b138-4a67067f7a93',
      ),
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
      action: const NavigateToArticleAction(
        articleId: '842e3193-86d2-4069-a7e6-f769faa6f970',
      ),
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
      action: const NavigateToArticleAction(
        articleId: '1f79da6f-64cb-430a-b7b2-2318d23b719f',
      ),
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
  const SpacerBlock(spacing: Spacing.small),
  const SectionHeaderBlock(title: 'Breaking News'),
  technologyItems.first.post,
  const DividerHorizontalBlock(),
  const SectionHeaderBlock(
    title: 'Technology',
    action: NavigateToFeedCategoryAction(
      category: Category.technology,
    ),
  ),
  technologyItems.first.post,
  const DividerHorizontalBlock(),
  const SectionHeaderBlock(
    title: 'Sports',
    action: NavigateToFeedCategoryAction(
      category: Category.sports,
    ),
  ),
  sportsItems.first.post,
  const DividerHorizontalBlock(),
  const SectionHeaderBlock(
    title: 'Health',
    action: NavigateToFeedCategoryAction(
      category: Category.health,
    ),
  ),
  healthItems.first.post,
];

/// Technology feed blocks.
final technologyFeedBlocks = <NewsBlock>[
  const SpacerBlock(spacing: Spacing.small),
  const SectionHeaderBlock(title: 'Technology'),
  technologyItems.first.post,
  const SpacerBlock(spacing: Spacing.medium),
  const NewsletterBlock(),
  const SpacerBlock(spacing: Spacing.medium),
];

/// Sports feed blocks.
final sportsFeedBlocks = <NewsBlock>[
  const SpacerBlock(spacing: Spacing.small),
  const SectionHeaderBlock(title: 'Sports'),
  sportsItems.first.post,
];

/// Health feed blocks.
final healthFeedBlocks = <NewsBlock>[
  const SpacerBlock(spacing: Spacing.small),
  const SectionHeaderBlock(title: 'Health'),
  healthItems.first.post,
];

/// Science feed blocks.
final scienceFeedBlocks = <NewsBlock>[
  const SpacerBlock(spacing: Spacing.small),
  const SectionHeaderBlock(title: 'Science'),
  PostGridGroupBlock(
    category: PostCategory.science,
    tiles: [...scienceItems.map((e) => e.post).cast<PostGridTileBlock>()],
  ),
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
