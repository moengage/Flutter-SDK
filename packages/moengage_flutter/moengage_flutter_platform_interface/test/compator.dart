import 'package:collection/collection.dart';
import 'package:moengage_flutter_platform_interface/moengage_flutter_platform_interface.dart';

class Comparator {
  bool isPushTokenDataEqual(PushTokenData? data1, PushTokenData? data2) {
    return data1?.platform == data2?.platform &&
        data1?.pushService == data2?.pushService &&
        data1?.token == data1?.token;
  }

  bool isPushCampaignDataEqual(
      PushCampaignData? data1, PushCampaignData? data2) {
    return data1?.platform == data2?.platform &&
        isAccountMetaEqual(data1?.accountMeta, data2?.accountMeta) &&
        isPushDataEqual(data1?.data, data2?.data);
  }

  bool isAccountMetaEqual(AccountMeta? data1, AccountMeta? data2) {
    return data1?.appId == data2?.appId;
  }

  bool isPushDataEqual(PushCampaign? data1, PushCampaign? data2) {
    return data1?.isDefaultAction == data2?.isDefaultAction &&
        data1?.selfHandledPushRedirection ==
            data2?.selfHandledPushRedirection &&
        const DeepCollectionEquality().equals(data1?.payload, data2?.payload) &&
        const DeepCollectionEquality()
            .equals(data2?.clickedAction, data1?.clickedAction);
  }

  bool isSelfHandledDataEqual(
      SelfHandledCampaignData? data1, SelfHandledCampaignData? data2) {
    return isAccountMetaEqual(data1?.accountMeta, data2?.accountMeta) &&
        data1?.platform == data2?.platform &&
        isSelfHandledCampaignEqual(data1?.campaign, data2?.campaign) &&
        isCampaignDataEqual(data1?.campaignData, data2?.campaignData);
  }

  bool isSelfHandledCampaignEqual(
      SelfHandledCampaign? data1, SelfHandledCampaign? data2) {
    return data1?.payload == data2?.payload &&
        data1?.dismissInterval == data2?.dismissInterval &&
        isDisplayRuleEqual(data1?.displayRules, data2?.displayRules);
  }

  bool isCampaignDataEqual(CampaignData? data1, CampaignData? data2) {
    return data1?.campaignId == data2?.campaignId &&
        data1?.campaignName == data2?.campaignName &&
        isCampaignContextEqual(data1?.context, data2?.context);
  }

  bool isCampaignContextEqual(CampaignContext? data1, CampaignContext? data2) {
    return data1?.formattedCampaignId == data2?.formattedCampaignId &&
        const DeepCollectionEquality()
            .equals(data1?.attributes, data1?.attributes);
  }

  bool isInAppDataEqual(InAppData? data1, InAppData? data2) {
    return isAccountMetaEqual(data1?.accountMeta, data2?.accountMeta) &&
        data1?.platform == data2?.platform &&
        isCampaignDataEqual(data1?.campaignData, data2?.campaignData);
  }

  bool isClickDataEqual(ClickData? data1, ClickData? data2) {
    return isAccountMetaEqual(data1?.accountMeta, data2?.accountMeta) &&
        data1?.platform == data2?.platform &&
        isCampaignDataEqual(data1?.campaignData, data2?.campaignData) &&
        isCampaignActionEqual(data1?.action, data2?.action);
  }

  bool isCampaignActionEqual(Action? action1, Action? action2) {
    return action1?.actionType == action2?.actionType;
  }

  bool isSelfHandledCampaignsDataEqual(
      SelfHandledCampaignsData? data1, SelfHandledCampaignsData? data2) {
    return isAccountMetaEqual(data1?.accountMeta, data2?.accountMeta) &&
        data1?.campaigns.length == data2?.campaigns.length &&
        IterableZip([
          data1?.campaigns ?? <SelfHandledCampaignData>[],
          data2?.campaigns ?? <SelfHandledCampaignData>[]
        ]).every((pair) {
          return isSelfHandledDataEqual(pair[0], pair[1]);
        });
  }

  bool isDisplayRuleEqual(Rules? data1, Rules? data2) {
    return data1?.screenName == data2?.screenName &&
        const DeepCollectionEquality().equals(data1?.context, data2?.context) &&
        const DeepCollectionEquality().equals(data1?.screenNames, data2?.screenNames);
  }
}
