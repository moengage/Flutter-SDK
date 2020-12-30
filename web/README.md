# MoEngage Flutter Web Plugin

Flutter Web Plugin for MoEngage Platform

## SDK Installation

To add the MoEngage Flutter SDK to your application, edit your application's `pubspec.yaml` file and add the below dependency to it:

![Download](https://img.shields.io/pub/v/moengage_flutter_web.svg)

```yaml
dependencies:
 moengage_flutter_web: $latestSdkVersion
```
replace `$latestSdkVersion` with the latest SDK version.

 Run `flutter packages get` to install the SDK.

## SDK Initialization

Get the APP ID from the [dashboard](https://app.moengage.com/v3/#/settings/app/general) and replace "XXXXXXXXXXX" in the code below.

Add this initialization script in your `web/index.html` file:
```javascript
<script type="text/javascript">
  (function(i,s,o,g,r,a,m,n){i.moengage_object=r;t={};q=function(f){return function(){(i.moengage_q=i.moengage_q||[]).push({f:f,a:arguments})}};f=['track_event','add_user_attribute','add_first_name','add_last_name','add_email','add_mobile','add_user_name','add_gender','add_birthday','destroy_session','add_unique_user_id','moe_events','call_web_push','track','location_type_attribute'],h={onsite:["getData","registerCallback"]};for(k in f){t[f[k]]=q(f[k])}for(k in h)for(l in h[k]){null==t[k]&&(t[k]={}),t[k][h[k][l]]=q(k+"."+h[k][l])}a=s.createElement(o);m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m);i.moe=i.moe||function(){n=arguments[0];return t};a.onload=function(){if(n){i[r]=moe(n)}}})(window,document,'script','https://cdn.moengage.com/webpush/moe_webSdk.min.latest.js','Moengage')

  
  Moengage = moe({
    app_id:"XXXXXXXXXXX", // replace "XXXXXXXXXXX" with the APP ID you get from the dashboard
    debug_logs: 0
  });
</script>
```

Refer to the [Documentation](https://docs.moengage.com/docs/flutter-sdk-integration) for complete integration guide. 