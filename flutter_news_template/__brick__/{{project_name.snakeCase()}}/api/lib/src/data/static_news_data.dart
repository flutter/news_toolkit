part of 'in_memory_news_data_source.dart';

/// List of available subscriptions.
const subscriptions = <Subscription>[
  Subscription(
    id: 'dd339fda-33e9-49d0-9eb5-0ccb77eb760f',
    name: SubscriptionPlan.premium,
    cost: SubscriptionCost(
      annual: 16200,
      monthly: 1499,
    ),
    benefits: [
      'Ut rhoncus dui vel imperdiet ullamcorper.',
      'Proin pellentesque erat et metus fringilla tincidunt.',
      'Nunc scelerisque nulla quis urna auctor.',
    ],
  ),
  Subscription(
    id: '375af719-c9e0-44c4-be05-4527df45a13d',
    name: SubscriptionPlan.plus,
    cost: SubscriptionCost(
      annual: 10800,
      monthly: 999,
    ),
    benefits: ['Nunc scelerisque nulla quis urna auctor.'],
  ),
  Subscription(
    id: '34809bc1-28e5-4967-b029-2432638b0dc7',
    name: SubscriptionPlan.basic,
    cost: SubscriptionCost(
      annual: 5400,
      monthly: 499,
    ),
    benefits: ['Nunc scelerisque nulla quis urna auctor.'],
  ),
];

/// List of popular search topics.
const popularTopics = [
  'Ukraine',
  'Supreme Court',
  'China',
  'Inflation',
  'Oil Prices',
  'Plane Crash',
];

/// List of relevant search topics.
const relevantTopics = [
  'South China Sea',
  'US-China Relations',
  'China at the Olymptics',
];

/// List of popular search articles.
final popularArticles = <NewsItem>[
  NewsItem(
    post: PostSmallBlock(
      id: '5c47495a-608b-4e8b-a7f0-642a02594888',
      category: PostCategory.technology,
      author: 'CNN',
      publishedAt: DateTime(2022, 3, 17),
      imageUrl:
          'https://cdn.cnn.com/cnnnext/dam/assets/220518135103-03-boeing-starliner-pre-launch-0518-super-tease.jpg',
      title: 'Boeing makes third attempt to launch its '
          'Starliner capsule to the ISS',
      description: 'Boeing will try yet again Thursday to send the capsule it '
          'designed to ferry astronauts to and from the International '
          'Space Station on a successful, uncrewed test mission. '
          'After two prior attempts to complete such a mission failed, '
          "Boeing's goal is to prove th…",
    ),
    content: [
      ArticleIntroductionBlock(
        category: PostCategory.technology,
        author: 'Sean Hollister',
        publishedAt: DateTime(2022, 3, 17),
        title: 'Boeing makes third attempt to launch its '
            'Starliner capsule to the ISS',
        imageUrl:
            'https://cdn.cnn.com/cnnnext/dam/assets/220518135103-03-boeing-starliner-pre-launch-0518-super-tease.jpg',
      ),
    ],
    contentPreview: [],
    url: Uri.parse(
      'https://nbc-2.com/news/2022/05/19/boeing-makes-third-attempt-to-launch-its-starliner-capsule-to-the-iss',
    ),
  ),
];

/// List of relevant search articles.
final relevantArticles = <NewsItem>[
  NewsItem(
    post: PostSmallBlock(
      id: '781b6a65-0357-45c7-8789-3ee890e43e0e',
      category: PostCategory.health,
      author: 'CNN',
      publishedAt: DateTime(2022, 5, 20),
      imageUrl:
          'https://cdn.cnn.com/cnnnext/dam/assets/220519121645-01-monkeypox-explainer-super-tease.jpg',
      title: 'What is monkeypox and its signs and symptoms?',
      description: 'Where did monkeypox come from, what are the signs and '
          "symptoms and how worried should you be? Here's what we know.",
    ),
    content: [
      ArticleIntroductionBlock(
        category: PostCategory.health,
        author: 'Sandee LaMotte',
        publishedAt: DateTime(2022, 5, 20),
        title: 'What is monkeypox and its signs and symptoms?',
        imageUrl:
            'https://cdn.cnn.com/cnnnext/dam/assets/220519121645-01-monkeypox-explainer-super-tease.jpg',
      ),
    ],
    contentPreview: [],
    url: Uri.parse(
      'https://www.cnn.com/2022/05/24/health/what-is-monkeypox-virus-explainer-update-wellness',
    ),
  ),
];

/// Technology news items.
final technologyItems = <NewsItem>[
  ...technologyLargeItems,
  ...technologyMediumItems,
  ...technologySmallItems,
];

/// Technology large news items.
final technologyLargeItems = <NewsItem>[
  NewsItem(
    post: PostLargeBlock(
      id: '499305f6-5096-4051-afda-824dcfc7df23',
      category: PostCategory.technology,
      author: 'Sean Hollister',
      publishedAt: DateTime(2022, 4, 19),
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
        publishedAt: DateTime(2022, 4, 19),
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
      const SlideshowIntroductionBlock(
        title: 'High end GPUs',
        coverImageUrl:
            'https://cdn.vox-cdn.com/thumbor/nC20D1S_iVCFb-sPRnEiFPLeg-s=/0x0:3181x2391/1820x1213/filters:focal(1337x942:1845x1450):format(webp)/cdn.vox-cdn.com/uploads/chorus_image/image/70682614/955510a1_40de_495a_ad94_09d04e6105d7.0.jpg',
        action: NavigateToSlideshowAction(
          articleId: '499305f6-5096-4051-afda-824dcfc7df23',
          slideshow: SlideshowBlock(
            title: 'High end GPUs',
            slides: [
              SlideBlock(
                caption: 'Nvidia RTX 4090',
                description:
                    'Fusce ornare quis odio eget fringilla. Curabitur gravida '
                    'velit urna, semper imperdiet metus fermentum congue. '
                    'Vestibulum ut diam ut risus porta mattis. Proin fringilla '
                    'arcu lorem, sit amet porttitor ante iaculis sit amet.',
                photoCredit: 'Nvidia',
                imageUrl:
                    'https://cdn.vox-cdn.com/thumbor/-2TdzHiFfbfz8K1Z0D5V7fv7-3A=/0x0:1200x554/1820x1213/filters:focal(430x196:622x388):format(webp)/cdn.vox-cdn.com/uploads/chorus_image/image/70876010/nvidia_3090_generic.0.jpg',
              ),
              SlideBlock(
                caption: 'AMD Ryzen 7000',
                description:
                    'Fusce ornare quis odio eget fringilla. Curabitur gravida '
                    'velit urna, semper imperdiet metus fermentum congue. '
                    'Vestibulum ut diam ut risus porta mattis. Proin fringilla '
                    'arcu lorem, sit amet porttitor ante iaculis sit amet.',
                photoCredit: 'AMD',
                imageUrl:
                    'https://cdn.vox-cdn.com/thumbor/tb-1DMHN6elrf_2in0qFUeARDoY=/0x0:1510x1130/1820x1213/filters:focal(635x445:875x685):format(webp)/cdn.vox-cdn.com/uploads/chorus_image/image/70899444/2022_05_22_15_38_37_Dly6cgt0xY.0.jpg',
              ),
              SlideBlock(
                caption: 'Asus GeForce RTX 3070 Noctua',
                description:
                    'Fusce ornare quis odio eget fringilla. Curabitur gravida '
                    'velit urna, semper imperdiet metus fermentum congue. '
                    'Vestibulum ut diam ut risus porta mattis. Proin fringilla '
                    'arcu lorem, sit amet porttitor ante iaculis sit amet.',
                photoCredit: 'Asus',
                imageUrl:
                    'https://cdn.vox-cdn.com/thumbor/oU-H_vwU66ldMk3M69k3eY3Td1U=/34x189:1238x869/1820x1213/filters:focal(295x343:615x663):format(webp)/cdn.vox-cdn.com/uploads/chorus_image/image/70879959/kv.0.jpg',
              ),
            ],
          ),
        ),
      ),
      const SpacerBlock(spacing: Spacing.large),
      const BannerAdBlock(size: BannerAdSize.large),
      const SpacerBlock(spacing: Spacing.large),
      const TextHeadlineBlock(text: 'Now, comes the big surprise!'),
      const SpacerBlock(spacing: Spacing.medium),
      const TextParagraphBlock(
        text: 'In the next few months, a machine language will be developed in '
            'such a way that farmers indulged in pig farming will communicate '
            'with their swine, cutting down unnecessary chaos between animals '
            'and humans in large farms and slaughterhouses.',
      ),
      const SpacerBlock(spacing: Spacing.large),
      const ImageBlock(
        imageUrl:
            'https://cdn.vox-cdn.com/thumbor/OTpmptgr7XcTVAJ27UBvIxl0vrg=/0x146:2040x1214/fit-in/1200x630/cdn.vox-cdn.com/uploads/chorus_asset/file/22049166/shollister_201117_4303_0003.0.jpg',
      ),
      const SpacerBlock(spacing: Spacing.medium),
      const TextCaptionBlock(
        text: 'Caption. Et has minim elitr intellegat. Mea aeterno eleifend '
            'antiopam ad, nam no suscipit quaerendum. '
            'At nam minimum ponderum.',
        color: TextCaptionColor.normal,
      ),
      const TextCaptionBlock(
        text: 'Credit: Phineas Photographer',
        color: TextCaptionColor.light,
      ),
      const SpacerBlock(spacing: Spacing.large),
      const NewsletterBlock(),
      const DividerHorizontalBlock(),
      TrendingStoryBlock(
        content: PostSmallBlock(
          id: '5c47497a-608b-4e9b-a7f0-642a02594900',
          category: PostCategory.technology,
          author: 'Fall Guys',
          publishedAt: DateTime(2022, 3, 9),
          imageUrl:
              'https://cdn2.unrealengine.com/preregevent-3840x2160-03-pp-3840x2160-74911d8b9813.jpg',
          title: 'Fall Guys: Ultimate Knockout'
              ' free for ALL',
          description: 'Welcome to Fall Guys: Free for All! You are invited to '
              'dive and dodge your way to victory in the pantheon of clumsy. '
              'Rookie or pro? Solo or partied up? '
              'Fall Guys delivers ever-evolving, '
              'high-concentrated hilarity and fun!',
        ),
      ),
      const DividerHorizontalBlock(),
    ],
    contentPreview: [
      ArticleIntroductionBlock(
        category: PostCategory.technology,
        author: 'Sean Hollister',
        publishedAt: DateTime(2022, 4, 19),
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
    url: Uri.parse(
      'https://www.theverge.com/2022/4/19/23031309/nvidia-amd-gpu-price-in-stock-retail-ebay',
    ),
  ),
  NewsItem(
    post: PostLargeBlock(
      id: '7dd29642-2bbd-40ea-80af-99e4381bbabb',
      category: PostCategory.technology,
      author: 'Jasmine Hicks',
      publishedAt: DateTime(2022, 6, 2),
      imageUrl:
          'https://cdn.vox-cdn.com/thumbor/TanD-HFR6zb_ZfUEMwGMRWkdl5E=/0x0:1920x1080/1820x1213/filters:focal(807x387:1113x693):format(webp)/cdn.vox-cdn.com/uploads/chorus_image/image/70937578/676eeda0_4ebe_4742_857e_9934a172200d.0.png',
      title: 'Meta adds new Calls tab to its Messenger app for iOS and Android',
      action: const NavigateToArticleAction(
        articleId: '7dd29642-2bbd-40ea-80af-99e4381bbabb',
      ),
      isPremium: true,
    ),
    content: [
      ArticleIntroductionBlock(
        category: PostCategory.technology,
        author: 'Jasmine Hicks',
        publishedAt: DateTime(2022, 6, 2),
        title:
            'Meta adds new Calls tab to its Messenger app for iOS and Android',
        imageUrl:
            'https://cdn.vox-cdn.com/thumbor/TanD-HFR6zb_ZfUEMwGMRWkdl5E=/0x0:1920x1080/1820x1213/filters:focal(807x387:1113x693):format(webp)/cdn.vox-cdn.com/uploads/chorus_image/image/70937578/676eeda0_4ebe_4742_857e_9934a172200d.0.png',
        isPremium: true,
      ),
    ],
    contentPreview: [
      ArticleIntroductionBlock(
        category: PostCategory.technology,
        author: 'Jasmine Hicks',
        publishedAt: DateTime(2022, 6, 2),
        title:
            'Meta adds new Calls tab to its Messenger app for iOS and Android',
        imageUrl:
            'https://cdn.vox-cdn.com/thumbor/TanD-HFR6zb_ZfUEMwGMRWkdl5E=/0x0:1920x1080/1820x1213/filters:focal(807x387:1113x693):format(webp)/cdn.vox-cdn.com/uploads/chorus_image/image/70937578/676eeda0_4ebe_4742_857e_9934a172200d.0.png',
      ),
    ],
    url: Uri.parse(
      'https://www.theverge.com/2022/6/2/23151755/meta-messenger-call-tab-ios-android-rollout',
    ),
  ),
];

/// Technology medium news items.
final technologyMediumItems = <NewsItem>[
  NewsItem(
    post: PostMediumBlock(
      id: 'd62a154f-b69a-4e8c-87ee-a1bdfcec3cfa',
      category: PostCategory.technology,
      author: 'Victoria Song',
      publishedAt: DateTime(2022, 6, 2),
      imageUrl:
          'https://cdn.vox-cdn.com/thumbor/vztwGP7fw5SuqtFUfNC3WpXOS4U=/0x38:1920x1043/fit-in/1200x630/cdn.vox-cdn.com/uploads/chorus_asset/file/23449170/Google_Pixel_Watch_1.png',
      title: "It's okay if the Pixel Watch only manages a day of battery life",
      description: 'A new report claims that Google’s forthcoming Pixel Watch '
          'will “only” get 24 hours of battery life. While that’s nowhere '
          'close to fitness trackers, it’s actually pretty standard for a '
          'full-featured flagship smartwatch.',
      action: const NavigateToArticleAction(
        articleId: 'd62a154f-b69a-4e8c-87ee-a1bdfcec3cfa',
      ),
    ),
    content: [
      ArticleIntroductionBlock(
        category: PostCategory.technology,
        author: 'Victoria Song',
        publishedAt: DateTime(2022, 6, 2),
        title:
            "It's okay if the Pixel Watch only manages a day of battery life",
        imageUrl:
            'https://cdn.vox-cdn.com/thumbor/vztwGP7fw5SuqtFUfNC3WpXOS4U=/0x38:1920x1043/fit-in/1200x630/cdn.vox-cdn.com/uploads/chorus_asset/file/23449170/Google_Pixel_Watch_1.png',
      ),
    ],
    contentPreview: [
      ArticleIntroductionBlock(
        category: PostCategory.technology,
        author: 'Victoria Song',
        publishedAt: DateTime(2022, 6, 2),
        title:
            "It's okay if the Pixel Watch only manages a day of battery life",
        imageUrl:
            'https://cdn.vox-cdn.com/thumbor/vztwGP7fw5SuqtFUfNC3WpXOS4U=/0x38:1920x1043/fit-in/1200x630/cdn.vox-cdn.com/uploads/chorus_asset/file/23449170/Google_Pixel_Watch_1.png',
      ),
    ],
    url: Uri.parse(
      'https://www.theverge.com/2022/6/2/23151748/pixel-watch-battery-wear-os-3-google-apple-samsung',
    ),
  ),
];

/// Technology small news items.
final technologySmallItems = <NewsItem>[
  NewsItem(
    post: PostSmallBlock(
      id: '36f4a017-d099-4fce-8727-1d9ca6a0398c',
      category: PostCategory.technology,
      author: 'Tom Phillips',
      publishedAt: DateTime(2022, 6, 2),
      imageUrl:
          'https://assets.reedpopcdn.com/stray_XlfRQmc.jpg/BROK/thumbnail/1600x900/format/jpg/quality/80/stray_XlfRQmc.jpg',
      title: 'Stray launches next month, included in pricier PlayStation '
          'Plus tiers on day one',
      description: "Stray, everyone's favourite upcoming cyberpunk cat game, "
          'launches for PC, PlayStation 4 and PS5 on 19th July.',
      action: const NavigateToArticleAction(
        articleId: '36f4a017-d099-4fce-8727-1d9ca6a0398c',
      ),
    ),
    content: [
      ArticleIntroductionBlock(
        category: PostCategory.technology,
        author: 'Tom Phillips',
        publishedAt: DateTime(2022, 6, 2),
        imageUrl:
            'https://assets.reedpopcdn.com/stray_XlfRQmc.jpg/BROK/thumbnail/1600x900/format/jpg/quality/80/stray_XlfRQmc.jpg',
        title: 'Stray launches next month, included in pricier PlayStation '
            'Plus tiers on day one',
      ),
    ],
    contentPreview: [
      ArticleIntroductionBlock(
        category: PostCategory.technology,
        author: 'Tom Phillips',
        publishedAt: DateTime(2022, 6, 2),
        imageUrl:
            'https://assets.reedpopcdn.com/stray_XlfRQmc.jpg/BROK/thumbnail/1600x900/format/jpg/quality/80/stray_XlfRQmc.jpg',
        title: 'Stray launches next month, included in pricier PlayStation '
            'Plus tiers on day one',
      ),
    ],
    url: Uri.parse(
      'https://www.eurogamer.net/stray-launches-next-month-included-in-pricier-playstation-plus-tiers-on-day-one',
    ),
  ),
  NewsItem(
    post: PostSmallBlock(
      id: 'f903c34b-e4a7-4db1-8945-94f9fb7c7284',
      category: PostCategory.technology,
      author: 'Mike Andronico',
      publishedAt: DateTime(2022, 6, 2),
      title: 'Walmart has a big PS5 restock today — '
          'here’s how to have the best shot',
      description: 'Walmart will have the PS5 in stock today exclusively for '
          "Walmart+ members. Here's how to have the best shot at scoring this "
          'still-elusive console.',
      action: const NavigateToArticleAction(
        articleId: 'f903c34b-e4a7-4db1-8945-94f9fb7c7284',
      ),
      isPremium: true,
    ),
    content: [
      ArticleIntroductionBlock(
        category: PostCategory.technology,
        author: 'Victoria Song',
        publishedAt: DateTime(2022, 6, 2),
        title: 'Walmart has a big PS5 restock today — '
            'here’s how to have the best shot',
        isPremium: true,
      ),
    ],
    contentPreview: [
      ArticleIntroductionBlock(
        category: PostCategory.technology,
        author: 'Victoria Song',
        publishedAt: DateTime(2022, 6, 2),
        title: 'Walmart has a big PS5 restock today — '
            'here’s how to have the best shot',
      ),
    ],
    url: Uri.parse(
      'https://us.cnn.com/2022/06/02/cnn-underscored/deals/ps5-restock-walmart-june-2',
    ),
  ),
];

/// Sports news items.
final sportsItems = <NewsItem>[
  ...sportsLargeItems,
  ...sportsMediumItems,
  ...sportsSmallItems,
];

/// Sports large news items.
final sportsLargeItems = <NewsItem>[
  NewsItem(
    post: PostLargeBlock(
      id: 'e24e8c44-fcba-4312-92bc-4da4c83e1f4b',
      category: PostCategory.sports,
      author: 'Peter Brody',
      publishedAt: DateTime(2022, 6, 3),
      imageUrl:
          'https://cdn.vox-cdn.com/thumbor/a3ES9_uJ0NKxcWTH3xrtM0FulHE=/0x0:3482x1823/fit-in/1200x630/cdn.vox-cdn.com/uploads/chorus_asset/file/23605079/usa_today_18419260.jpg',
      title: 'Yankees win, 2-1, as Jameson Taillon carries '
          'perfect game into eighth',
      description:
          'Taillon took us tantalizingly close to history, and Rizzo saved the '
          'day with a come-from-behind hit.',
      action: const NavigateToArticleAction(
        articleId: 'e24e8c44-fcba-4312-92bc-4da4c83e1f4b',
      ),
    ),
    content: [
      ArticleIntroductionBlock(
        category: PostCategory.sports,
        author: 'Peter Brody',
        publishedAt: DateTime(2022, 6, 3),
        imageUrl:
            'https://cdn.vox-cdn.com/thumbor/a3ES9_uJ0NKxcWTH3xrtM0FulHE=/0x0:3482x1823/fit-in/1200x630/cdn.vox-cdn.com/uploads/chorus_asset/file/23605079/usa_today_18419260.jpg',
        title: 'Yankees win, 2-1, as Jameson Taillon carries '
            'perfect game into eighth',
      ),
    ],
    contentPreview: [
      ArticleIntroductionBlock(
        category: PostCategory.sports,
        author: 'Peter Brody',
        publishedAt: DateTime(2022, 6, 3),
        imageUrl:
            'https://cdn.vox-cdn.com/thumbor/a3ES9_uJ0NKxcWTH3xrtM0FulHE=/0x0:3482x1823/fit-in/1200x630/cdn.vox-cdn.com/uploads/chorus_asset/file/23605079/usa_today_18419260.jpg',
        title: 'Yankees win, 2-1, as Jameson Taillon carries '
            'perfect game into eighth',
      ),
    ],
    url: Uri.parse(
      'https://www.pinstripealley.com/2022/6/2/23150750/yankees-game-score-recap-angels-sweep-jameson-taillon-perfect-game-bid-anthony-rizzo-doubleheader',
    ),
  ),
];

/// Sports medium news items.
final sportsMediumItems = <NewsItem>[
  NewsItem(
    post: PostMediumBlock(
      id: '82c49bf1-946d-4920-a801-302291f367b5',
      category: PostCategory.sports,
      author: 'Tom Dierberger',
      publishedAt: DateTime(2022, 5, 5),
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
    content: [
      ArticleIntroductionBlock(
        category: PostCategory.sports,
        author: 'Tom Dierberger',
        publishedAt: DateTime(2022, 5, 22),
        imageUrl:
            'https://www.nbcsports.com/sites/rsnunited/files/styles/metatags_opengraph/public/article/hero/pat-bev-ja-morant-USA.jpg',
        title: 'Patrick Beverley throws shade at Warriors '
            'for Ja Morant struggles - NBC Sports',
      ),
    ],
    contentPreview: [
      ArticleIntroductionBlock(
        category: PostCategory.sports,
        author: 'Tom Dierberger',
        publishedAt: DateTime(2022, 5, 22),
        imageUrl:
            'https://www.nbcsports.com/sites/rsnunited/files/styles/metatags_opengraph/public/article/hero/pat-bev-ja-morant-USA.jpg',
        title: 'Patrick Beverley throws shade at Warriors '
            'for Ja Morant struggles - NBC Sports',
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
    url: Uri.parse(
      'https://www.nbcsports.com/bayarea/warriors/patrick-beverley-throws-shade-warriors-ja-morant-struggles',
    ),
  ),
];

/// Sports small news items.
final sportsSmallItems = <NewsItem>[
  NewsItem(
    post: PostSmallBlock(
      id: 'b1e70b22-b7a3-4b07-808d-3735fe7131af',
      category: PostCategory.sports,
      author: 'Jasmyn Wimbish',
      publishedAt: DateTime(2022, 6, 3),
      imageUrl:
          'https://sportshub.cbsistatic.com/i/r/2022/06/03/ff016f39-ad02-4dd9-8237-f1c7d3b1b5a6/thumbnail/1200x675/ed10f396f5f3cdf4b6b912e44fdf2597/untitled-design-2022-06-02t212223-267.png',
      title: 'NBA commissioner Adam Silver talks about league expansion, '
          'potential All-NBA changes ahead of Finals',
      description: 'Silver touched on a number of topics during his '
          'annual press conference.',
      action: const NavigateToArticleAction(
        articleId: 'b1e70b22-b7a3-4b07-808d-3735fe7131af',
      ),
    ),
    content: [
      ArticleIntroductionBlock(
        category: PostCategory.sports,
        author: 'Jasmyn Wimbish',
        publishedAt: DateTime(2022, 6, 3),
        imageUrl:
            'https://sportshub.cbsistatic.com/i/r/2022/06/03/ff016f39-ad02-4dd9-8237-f1c7d3b1b5a6/thumbnail/1200x675/ed10f396f5f3cdf4b6b912e44fdf2597/untitled-design-2022-06-02t212223-267.png',
        title: 'NBA commissioner Adam Silver talks about league expansion, '
            'potential All-NBA changes ahead of Finals',
      ),
    ],
    contentPreview: [
      ArticleIntroductionBlock(
        category: PostCategory.sports,
        author: 'Jasmyn Wimbish',
        publishedAt: DateTime(2022, 6, 3),
        imageUrl:
            'https://sportshub.cbsistatic.com/i/r/2022/06/03/ff016f39-ad02-4dd9-8237-f1c7d3b1b5a6/thumbnail/1200x675/ed10f396f5f3cdf4b6b912e44fdf2597/untitled-design-2022-06-02t212223-267.png',
        title: 'NBA commissioner Adam Silver talks about league expansion, '
            'potential All-NBA changes ahead of Finals',
      ),
    ],
    url: Uri.parse(
      'https://www.cbssports.com/nba/news/nba-commissioner-adam-silver-talks-about-league-expansion-potential-all-nba-changes-ahead-of-finals/',
    ),
  ),
  NewsItem(
    post: PostSmallBlock(
      id: '7f03f6bf-011f-49cf-88b8-08c79a21745c',
      category: PostCategory.sports,
      author: 'Adam Rowe',
      publishedAt: DateTime(2022, 6, 3),
      title: 'Five-Star International Recruit Tyrese Proctor will reclassify '
          'up to 2022 and enroll at Duke this summer',
      description: 'Duke will be getting one of their top Class of 2023 '
          'recruits, Tyrese Proctor, a year earlier than originally expected',
      action: const NavigateToArticleAction(
        articleId: '7f03f6bf-011f-49cf-88b8-08c79a21745c',
      ),
    ),
    content: [
      ArticleIntroductionBlock(
        category: PostCategory.sports,
        author: 'Adam Rowe',
        publishedAt: DateTime(2022, 6, 3),
        title: 'Five-Star International Recruit Tyrese Proctor will reclassify '
            'up to 2022 and enroll at Duke this summer',
      ),
    ],
    contentPreview: [
      ArticleIntroductionBlock(
        category: PostCategory.sports,
        author: 'Adam Rowe',
        publishedAt: DateTime(2022, 6, 3),
        title: 'Five-Star International Recruit Tyrese Proctor will reclassify '
            'up to 2022 and enroll at Duke this summer',
      ),
    ],
    url: Uri.parse(
      'https://247sports.com/college/duke/Article/tyrese-proctor-reclassfication-2022-188267682/',
    ),
  ),
];

/// Health news items.
final healthItems = <NewsItem>[
  ...healthLargeItems,
  ...healthMediumItems,
  ...healthSmallItems,
];

/// Health large news items.
final healthLargeItems = <NewsItem>[
  NewsItem(
    post: PostLargeBlock(
      id: 'f237463b-f4d8-4b23-a468-d448a446b03b',
      category: PostCategory.health,
      author: 'Neuroscience News',
      publishedAt: DateTime(2022, 6, 2),
      imageUrl:
          'https://neurosciencenews.com/files/2022/06/asd-genetics-neurosicnes-public.jpg',
      title: 'Broad Spectrum of Autism Depends on Spectrum of Genetic Factors',
      description: 'Genetic factors influence the severity of symptoms in '
          'children on the autism spectrum, and different genetic factors were '
          'associated with different symptoms of ASD.',
      action: const NavigateToArticleAction(
        articleId: 'f237463b-f4d8-4b23-a468-d448a446b03b',
      ),
    ),
    content: [
      ArticleIntroductionBlock(
        category: PostCategory.health,
        author: 'Neuroscience News',
        publishedAt: DateTime(2022, 6, 2),
        imageUrl:
            'https://neurosciencenews.com/files/2022/06/asd-genetics-neurosicnes-public.jpg',
        title:
            'Broad Spectrum of Autism Depends on Spectrum of Genetic Factors',
      ),
    ],
    contentPreview: [
      ArticleIntroductionBlock(
        category: PostCategory.health,
        author: 'Neuroscience News',
        publishedAt: DateTime(2022, 6, 2),
        imageUrl:
            'https://neurosciencenews.com/files/2022/06/asd-genetics-neurosicnes-public.jpg',
        title:
            'Broad Spectrum of Autism Depends on Spectrum of Genetic Factors',
      ),
    ],
    url: Uri.parse(
      'https://neurosciencenews.com/asd-genetics-symptoms-20731/',
    ),
  ),
];

/// Health medium news items.
final healthMediumItems = <NewsItem>[
  NewsItem(
    post: PostMediumBlock(
      id: '057d4de4-a7c5-4dc3-b231-33052bcea53d',
      category: PostCategory.health,
      author: 'Neuroscience News',
      publishedAt: DateTime(2022, 6, 2),
      imageUrl:
          'https://neurosciencenews.com/files/2022/06/amd-eye-supplements-neurosinces-public.jpg',
      title: 'Study Confirms Benefit of Supplements for Slowing Age-Related '
          'Macular Degeneration',
      description: 'The AREDS2 dietary supplement that substitutes '
          'antioxidants lutein and zeaxanthin for beta-carotene reduces the '
          'risk of age-related macular degeneration progression, a new study '
          'reveals.',
      action: const NavigateToArticleAction(
        articleId: '057d4de4-a7c5-4dc3-b231-33052bcea53d',
      ),
    ),
    content: [
      ArticleIntroductionBlock(
        category: PostCategory.health,
        author: 'Neuroscience News',
        publishedAt: DateTime(2022, 6, 2),
        imageUrl:
            'https://neurosciencenews.com/files/2022/06/amd-eye-supplements-neurosinces-public.jpg',
        title: 'Study Confirms Benefit of Supplements for Slowing Age-Related '
            'Macular Degeneration',
      ),
    ],
    contentPreview: [
      ArticleIntroductionBlock(
        category: PostCategory.health,
        author: 'Neuroscience News',
        publishedAt: DateTime(2022, 6, 2),
        imageUrl:
            'https://neurosciencenews.com/files/2022/06/amd-eye-supplements-neurosinces-public.jpg',
        title: 'Study Confirms Benefit of Supplements for Slowing Age-Related '
            'Macular Degeneration',
      ),
    ],
    url: Uri.parse(
      'https://neurosciencenews.com/asd-genetics-symptoms-20731/',
    ),
  ),
];

/// Health small news items.
final healthSmallItems = <NewsItem>[
  NewsItem(
    post: PostSmallBlock(
      id: 'b1fc2ffc-eb02-42ce-af65-79702172a987',
      category: PostCategory.health,
      author: 'Northwestern University',
      publishedAt: DateTime(2022, 5, 4),
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
    content: [
      ArticleIntroductionBlock(
        category: PostCategory.health,
        author: 'Northwestern University',
        publishedAt: DateTime(2022, 5, 4),
        imageUrl: 'https://scitechdaily.com/images/Ear-Hearing-Concept.jpg',
        title: 'Restoring Hearing: New Tool To Create Ear Hair Cells '
            'Lost Due to Aging or Noise',
      ),
    ],
    contentPreview: [
      ArticleIntroductionBlock(
        category: PostCategory.health,
        author: 'Northwestern University',
        publishedAt: DateTime(2022, 5, 4),
        imageUrl: 'https://scitechdaily.com/images/Ear-Hearing-Concept.jpg',
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
    url: Uri.parse(
      'https://scitechdaily.com/restoring-hearing-new-tool-to-create-ear-hair-cells-lost-due-to-aging-or-noise',
    ),
  ),
  NewsItem(
    post: PostSmallBlock(
      id: '67c36008-42f3-4ed3-9bcc-2c96acaa27d3',
      category: PostCategory.health,
      author: 'Gabby Landsverk',
      publishedAt: DateTime(2022, 6, 2),
      title: 'Keto and Mediterranean diets both help manage blood sugar, '
          'but keto may have more side effects, according to research',
      description: 'A high-fat ketogenic diet and a high-fiber Mediterranean '
          'diet may be equally effective for balancing blood sugar levels, '
          'according to a study published May 31 in the American Journal of '
          'Clinical Nutrition.',
      action: const NavigateToArticleAction(
        articleId: '67c36008-42f3-4ed3-9bcc-2c96acaa27d3',
      ),
    ),
    content: [
      ArticleIntroductionBlock(
        category: PostCategory.health,
        author: 'Gabby Landsverk',
        publishedAt: DateTime(2022, 6, 2),
        title: 'Keto and Mediterranean diets both help manage blood sugar, '
            'but keto may have more side effects, according to research',
      ),
    ],
    contentPreview: [
      ArticleIntroductionBlock(
        category: PostCategory.health,
        author: 'Gabby Landsverk',
        publishedAt: DateTime(2022, 6, 2),
        title: 'Keto and Mediterranean diets both help manage blood sugar, '
            'but keto may have more side effects, according to research',
      ),
    ],
    url: Uri.parse(
      'https://www.msn.com/en-us/health/nutrition/keto-and-mediterranean-diets-both-help-manage-blood-sugar-but-keto-may-have-more-side-effects-according-to-research/ar-AAY0S3q?li=BBnba9O',
    ),
  ),
];

/// Science news items.
final scienceItems = <NewsItem>[
  ...scienceLargeItems,
  ...scienceMediumItems,
  ...scienceSmallItems,
  ...scienceVideoItems,
];

/// Science large news items.
final scienceLargeItems = <NewsItem>[
  NewsItem(
    post: PostLargeBlock(
      id: 'f6e66eb4-add9-4181-bf1e-ce09c629287d',
      category: PostCategory.science,
      author: 'Megan Marples and Ashley Strickland',
      publishedAt: DateTime(2022, 6, 2),
      imageUrl:
          'https://neurosciencenews.com/files/2022/06/asd-genetics-neurosicnes-public.jpg',
      title: 'A rare, 5-planet alignment will take over the sky this month',
      description: 'Mercury, Venus, Mars, Jupiter and Saturn will align in the '
          'month of June, with the waning crescent moon making a special '
          'appearance on June 24.',
      action: const NavigateToArticleAction(
        articleId: 'f6e66eb4-add9-4181-bf1e-ce09c629287d',
      ),
    ),
    content: [
      ArticleIntroductionBlock(
        category: PostCategory.science,
        author: 'Megan Marples and Ashley Strickland',
        publishedAt: DateTime(2022, 6, 2),
        imageUrl:
            'https://neurosciencenews.com/files/2022/06/asd-genetics-neurosicnes-public.jpg',
        title: 'A rare, 5-planet alignment will take over the sky this month',
      ),
    ],
    contentPreview: [
      ArticleIntroductionBlock(
        category: PostCategory.science,
        author: 'Megan Marples and Ashley Strickland',
        publishedAt: DateTime(2022, 6, 2),
        imageUrl:
            'https://neurosciencenews.com/files/2022/06/asd-genetics-neurosicnes-public.jpg',
        title: 'A rare, 5-planet alignment will take over the sky this month',
      ),
    ],
    url: Uri.parse(
      'https://edition.cnn.com/2022/06/02/world/five-planet-alignment-june-scn/index.html',
    ),
  ),
];

/// Science medium news items.
final scienceMediumItems = <NewsItem>[
  NewsItem(
    post: PostMediumBlock(
      id: '506271f9-394e-48e4-a6d8-9d438f561532',
      category: PostCategory.science,
      author: 'Jeff Foust',
      publishedAt: DateTime(2022, 6, 2),
      imageUrl:
          'https://spacenews.com/wp-content/uploads/2021/11/crew2-depature.jpg',
      title: 'NASA to buy five additional Crew Dragon flights',
      description: 'NASA is planning to purchase five more Crew Dragon '
          'missions from SpaceX, a move the agency says is needed to ensure '
          'long-term access to the station.',
      action: const NavigateToArticleAction(
        articleId: '506271f9-394e-48e4-a6d8-9d438f561532',
      ),
    ),
    content: [
      ArticleIntroductionBlock(
        category: PostCategory.science,
        author: 'Jeff Foust',
        publishedAt: DateTime(2022, 6, 2),
        imageUrl:
            'https://spacenews.com/wp-content/uploads/2021/11/crew2-depature.jpg',
        title: 'NASA to buy five additional Crew Dragon flights',
      ),
    ],
    contentPreview: [
      ArticleIntroductionBlock(
        category: PostCategory.science,
        author: 'Jeff Foust',
        publishedAt: DateTime(2022, 6, 2),
        imageUrl:
            'https://spacenews.com/wp-content/uploads/2021/11/crew2-depature.jpg',
        title: 'NASA to buy five additional Crew Dragon flights',
      ),
    ],
    url: Uri.parse(
      'https://spacenews.com/?p=128336&#038;preview=true&#038;preview_id=128336',
    ),
  ),
];

/// Science small news items.
final scienceSmallItems = <NewsItem>[
  NewsItem(
    post: PostSmallBlock(
      id: '1273746e-900d-45d9-a4f3-acbb462de797',
      category: PostCategory.science,
      author: 'Tomasz Nowakowski',
      publishedAt: DateTime(2022, 6, 2),
      imageUrl:
          'https://scx2.b-cdn.net/gfx/news/2022/super-earth-exoplanet.jpg',
      title: 'Super-Earth exoplanet orbiting nearby star discovered',
      description: 'An international team of astronomers reports the discovery '
          'of a new super-Earth exoplanet orbiting a nearby M-dwarf star '
          'known as Ross 508.',
      action: const NavigateToArticleAction(
        articleId: '1273746e-900d-45d9-a4f3-acbb462de797',
      ),
    ),
    content: [
      ArticleIntroductionBlock(
        category: PostCategory.science,
        author: 'Tomasz Nowakowski',
        publishedAt: DateTime(2022, 6, 2),
        imageUrl:
            'https://scx2.b-cdn.net/gfx/news/2022/super-earth-exoplanet.jpg',
        title: 'Super-Earth exoplanet orbiting nearby star discovered',
      ),
    ],
    contentPreview: [
      ArticleIntroductionBlock(
        category: PostCategory.science,
        author: 'Tomasz Nowakowski',
        publishedAt: DateTime(2022, 6, 2),
        imageUrl:
            'https://scx2.b-cdn.net/gfx/news/2022/super-earth-exoplanet.jpg',
        title: 'Super-Earth exoplanet orbiting nearby star discovered',
      ),
    ],
    url: Uri.parse(
      'https://phys.org/news/2022-06-super-earth-exoplanet-orbiting-nearby-star.html',
    ),
  ),
  NewsItem(
    post: PostSmallBlock(
      id: '52c74e71-36b3-45aa-bc06-f50b1d2631fa',
      category: PostCategory.science,
      author: 'Phil Plait',
      publishedAt: DateTime(2022, 6, 2),
      title: 'Are supermassive black holes killing their host galaxies?',
      description: 'Why are young galaxies in the distant Universe dying? '
          'Their supermassive black holes may be killing them.',
      action: const NavigateToArticleAction(
        articleId: '52c74e71-36b3-45aa-bc06-f50b1d2631fa',
      ),
    ),
    content: [
      ArticleIntroductionBlock(
        category: PostCategory.science,
        author: 'Phil Plait',
        publishedAt: DateTime(2022, 6, 2),
        title: 'Are supermassive black holes killing their host galaxies?',
      ),
    ],
    contentPreview: [
      ArticleIntroductionBlock(
        category: PostCategory.science,
        author: 'Phil Plait',
        publishedAt: DateTime(2022, 6, 2),
        title: 'Are supermassive black holes killing their host galaxies?',
      ),
    ],
    url: Uri.parse(
      'https://www.syfy.com/syfy-wire/bad-astronomy-astronomers-link-supermassive-black-holes-reduced-star-birth',
    ),
  ),
];

/// Science video news items.
final scienceVideoItems = <NewsItem>[
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
      action: const NavigateToVideoArticleAction(
        articleId: '384a15ff-a50e-46d5-96a7-8864facdcc48',
      ),
    ),
    content: const [
      VideoIntroductionBlock(
        category: PostCategory.science,
        title: 'SpaceX successfully returns four astronauts from the '
            'International Space Station',
        videoUrl:
            'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      ),
    ],
    contentPreview: const [
      VideoIntroductionBlock(
        category: PostCategory.science,
        title: 'SpaceX successfully returns four astronauts from the '
            'International Space Station',
        videoUrl:
            'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
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
    url: Uri.parse(
      'https://www.theverge.com/2022/5/6/23055274/spacex-crew-3-return-iss-nasa-crew-dragon',
    ),
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
      action: const NavigateToVideoArticleAction(
        articleId: '13e448bb-cd26-4ae0-b138-4a67067f7a93',
      ),
    ),
    content: const [
      VideoIntroductionBlock(
        category: PostCategory.science,
        title: 'A surging glow in a distant galaxy could change '
            'the way we look at black holes',
        videoUrl:
            'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      ),
    ],
    contentPreview: const [
      VideoIntroductionBlock(
        category: PostCategory.science,
        title: 'A surging glow in a distant galaxy could change '
            'the way we look at black holes',
        videoUrl:
            'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      ),
    ],
    url: Uri.parse(
      'https://phys.org/news/2022-05-surging-distant-galaxy-black-holes.html',
    ),
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
      action: const NavigateToVideoArticleAction(
        articleId: '842e3193-86d2-4069-a7e6-f769faa6f970',
      ),
    ),
    content: const [
      VideoIntroductionBlock(
        category: PostCategory.science,
        title:
            'The Quest for an Ideal Quantum Bit: New Qubit Breakthrough Could '
            'Revolutionize Quantum Computing',
        videoUrl:
            'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      ),
    ],
    contentPreview: const [
      VideoIntroductionBlock(
        category: PostCategory.science,
        title:
            'The Quest for an Ideal Quantum Bit: New Qubit Breakthrough Could '
            'Revolutionize Quantum Computing',
        videoUrl:
            'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      ),
    ],
    url: Uri.parse(
      'https://scitechdaily.com/the-quest-for-an-ideal-quantum-bit-new-qubit-breakthrough-could-revolutionize-quantum-computing',
    ),
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
      action: const NavigateToVideoArticleAction(
        articleId: '1f79da6f-64cb-430a-b7b2-2318d23b719f',
      ),
    ),
    content: const [
      VideoIntroductionBlock(
        category: PostCategory.science,
        title: 'Hear What a Black Hole Sounds Like – New NASA Black Hole '
            'Sonifications With a Remix',
        videoUrl:
            'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      ),
    ],
    contentPreview: const [
      VideoIntroductionBlock(
        category: PostCategory.science,
        title: 'Hear What a Black Hole Sounds Like – New NASA Black Hole '
            'Sonifications With a Remix',
        videoUrl:
            'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      ),
    ],
    url: Uri.parse(
      'https://www.cbsnews.com/news/black-hole-audio-perseus-galaxy-cluster',
    ),
  ),
];

/// Top news feed blocks.
final topNewsFeedBlocks = <NewsBlock>[
  const SpacerBlock(spacing: Spacing.small),
  const SectionHeaderBlock(title: 'Breaking News'),
  technologyLargeItems.first.post,
  const BannerAdBlock(size: BannerAdSize.normal),
  const SpacerBlock(spacing: Spacing.small),
  const SectionHeaderBlock(
    title: 'Technology',
    action: NavigateToFeedCategoryAction(
      category: Category.technology,
    ),
  ),
  technologyLargeItems.last.post,
  const BannerAdBlock(size: BannerAdSize.large),
  const SpacerBlock(spacing: Spacing.small),
  const SectionHeaderBlock(
    title: 'Science Videos',
    action: NavigateToFeedCategoryAction(
      category: Category.science,
    ),
  ),
  PostGridGroupBlock(
    category: PostCategory.science,
    tiles: [...scienceVideoItems.map((e) => e.post).cast<PostGridTileBlock>()],
  ),
  const SpacerBlock(spacing: Spacing.large),
  const DividerHorizontalBlock(),
  const SectionHeaderBlock(
    title: 'Sports',
    action: NavigateToFeedCategoryAction(
      category: Category.sports,
    ),
  ),
  sportsMediumItems.first.post,
  const SpacerBlock(spacing: Spacing.medium),
  const BannerAdBlock(size: BannerAdSize.extraLarge),
  const SpacerBlock(spacing: Spacing.small),
  const SectionHeaderBlock(
    title: 'Health',
    action: NavigateToFeedCategoryAction(
      category: Category.health,
    ),
  ),
  healthSmallItems.first.post,
  const SpacerBlock(spacing: Spacing.small),
  const NewsletterBlock(),
  const SpacerBlock(spacing: Spacing.small),
  healthSmallItems.last.post,
  const SpacerBlock(spacing: Spacing.medium),
];

/// Technology feed blocks.
final technologyFeedBlocks = <NewsBlock>[
  const SpacerBlock(spacing: Spacing.small),
  const SectionHeaderBlock(title: 'Technology'),
  ...technologyLargeItems.map((item) => item.post),
  const BannerAdBlock(size: BannerAdSize.large),
  const SpacerBlock(spacing: Spacing.small),
  const SectionHeaderBlock(title: 'Popular in Tech'),
  ...technologyMediumItems.map((item) => item.post),
  const SpacerBlock(spacing: Spacing.small),
  const BannerAdBlock(size: BannerAdSize.normal),
  const SpacerBlock(spacing: Spacing.small),
  technologySmallItems.first.post,
  const SpacerBlock(spacing: Spacing.small),
  const NewsletterBlock(),
  technologySmallItems.last.post,
  const SpacerBlock(spacing: Spacing.small),
  const SpacerBlock(spacing: Spacing.medium),
];

/// Sports feed blocks.
final sportsFeedBlocks = <NewsBlock>[
  const SpacerBlock(spacing: Spacing.small),
  const SectionHeaderBlock(title: 'Sports'),
  ...sportsLargeItems.map((item) => item.post),
  const BannerAdBlock(size: BannerAdSize.large),
  const SpacerBlock(spacing: Spacing.small),
  const SectionHeaderBlock(title: 'Popular in Sports'),
  ...sportsMediumItems.map((item) => item.post),
  const SpacerBlock(spacing: Spacing.small),
  const BannerAdBlock(size: BannerAdSize.normal),
  const SpacerBlock(spacing: Spacing.small),
  sportsSmallItems.first.post,
  const SpacerBlock(spacing: Spacing.small),
  const NewsletterBlock(),
  sportsSmallItems.last.post,
  const SpacerBlock(spacing: Spacing.small),
  const SpacerBlock(spacing: Spacing.medium),
];

/// Health feed blocks.
final healthFeedBlocks = <NewsBlock>[
  const SpacerBlock(spacing: Spacing.small),
  const SectionHeaderBlock(title: 'Health'),
  ...healthLargeItems.map((item) => item.post),
  const BannerAdBlock(size: BannerAdSize.large),
  const SpacerBlock(spacing: Spacing.small),
  const SectionHeaderBlock(title: 'Popular in Health'),
  ...healthMediumItems.map((item) => item.post),
  const SpacerBlock(spacing: Spacing.small),
  const BannerAdBlock(size: BannerAdSize.normal),
  const SpacerBlock(spacing: Spacing.small),
  healthSmallItems.first.post,
  const SpacerBlock(spacing: Spacing.small),
  const NewsletterBlock(),
  healthSmallItems.last.post,
  const SpacerBlock(spacing: Spacing.small),
  const SpacerBlock(spacing: Spacing.medium),
];

/// Science feed blocks.
final scienceFeedBlocks = <NewsBlock>[
  const SpacerBlock(spacing: Spacing.small),
  const SectionHeaderBlock(title: 'Science'),
  ...scienceLargeItems.map((item) => item.post),
  const BannerAdBlock(size: BannerAdSize.large),
  const SpacerBlock(spacing: Spacing.small),
  const SectionHeaderBlock(title: 'Popular in Science'),
  ...scienceMediumItems.map((item) => item.post),
  const SpacerBlock(spacing: Spacing.small),
  const BannerAdBlock(size: BannerAdSize.normal),
  const SpacerBlock(spacing: Spacing.small),
  scienceSmallItems.first.post,
  const SpacerBlock(spacing: Spacing.small),
  const NewsletterBlock(),
  scienceSmallItems.last.post,
  const SpacerBlock(spacing: Spacing.small),
  const BannerAdBlock(size: BannerAdSize.normal),
  const SpacerBlock(spacing: Spacing.small),
  const SectionHeaderBlock(title: 'Science Videos'),
  PostGridGroupBlock(
    category: PostCategory.science,
    tiles: [...scienceVideoItems.map((e) => e.post).cast<PostGridTileBlock>()],
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
  Article toArticle({required String title, required Uri url}) {
    return Article(
      title: title,
      blocks: this,
      totalBlocks: length,
      url: url,
    );
  }
}
