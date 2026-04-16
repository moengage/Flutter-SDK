import 'package:moengage_personalize_platform_interface/moengage_personalize_platform_interface.dart';

final experienceCampaignMeta1 = ExperienceCampaignMeta(
  experienceKey: 'welcome_banner',
  experienceName: 'Welcome Banner',
  status: ExperienceStatus.active,
);

final experienceCampaignMeta2 = ExperienceCampaignMeta(
  experienceKey: 'home_hero',
  experienceName: 'Home Hero',
  status: ExperienceStatus.paused,
);

final experienceCampaignsMetadata = ExperienceCampaignsMetadata(
  source: DataSource.cache,
  experiences: [experienceCampaignMeta1, experienceCampaignMeta2],
);

final experienceCampaign = ExperienceCampaign(
  experienceKey: 'welcome_banner',
  payload: {'title': 'Welcome', 'body': 'Hello World'},
  experienceContext: {'campaignId': 'c123', 'locale': 'en'},
  source: DataSource.network,
);

final experienceCampaignFailure = ExperienceCampaignFailure(
  reason: 'USER_NOT_IN_SEGMENT',
  experienceKeys: ['home_hero'],
  message: 'User does not match segment criteria',
);

final experienceCampaignFailureWithoutMessage = ExperienceCampaignFailure(
  reason: 'IN_VALID_EXPERIENCE_KEY',
  experienceKeys: ['bad_key'],
);

final experienceCampaignsResult = ExperienceCampaignsResult(
  experiences: [experienceCampaign],
  failures: [experienceCampaignFailure],
);

final experienceCampaignsResultEmpty = ExperienceCampaignsResult(
  experiences: [],
  failures: [],
);
