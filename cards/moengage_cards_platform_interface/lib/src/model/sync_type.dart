/// Card Sync Types
enum SyncType {
  /// Sync when user Opens the App
  appOpen,

  /// Sync when user lands on Inbox Screen
  inboxOpen,

  /// Sync when user performs pull to refresh action
  pullToRefresh,

  /// Sync type when SDK sync the cards immediately.
  /// Currently applicable for SDK fetching cards immediately when login is performed.
  immediate
}
