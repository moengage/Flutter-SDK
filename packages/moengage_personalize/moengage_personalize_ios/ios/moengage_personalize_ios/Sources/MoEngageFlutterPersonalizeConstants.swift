import Foundation

enum MoEngageFlutterPersonalizeConstants {
    static let pluginChannelName = "com.moengage/personalize"

    enum MethodNames {
        static let fetchExperiencesMeta   = "fetchExperiencesMeta"
        static let fetchExperiences       = "fetchExperiences"
        static let trackExperienceShown   = "trackExperienceShown"
        static let trackExperienceClicked = "trackExperienceClicked"
        static let trackOfferingShown     = "trackOfferingShown"
        static let trackOfferingClicked   = "trackOfferingClicked"
    }
}
