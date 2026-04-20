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
  reason: ExperienceFailureReason.userNotInSegment,
  experienceKeys: ['home_hero'],
);

final experienceCampaignFailureInvalidKey = ExperienceCampaignFailure(
  reason: ExperienceFailureReason.invalidExperienceKey,
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
