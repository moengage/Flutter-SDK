import Foundation

enum MoEngageFlutterPersonalizeConstants {
    static let pluginChannelName = "com.moengage/personalize"

    enum MethodNames {
        static let fetchExperiencesMeta   = "fetchExperiencesMeta"
        static let fetchExperiences       = "fetchExperiences"
        static let experiencesShown  = "experiencesShown"
        static let experienceClicked = "experienceClicked"
        static let offeringsShown    = "offeringsShown"
        static let offeringClicked   = "offeringClicked"
    }
}
