# Release Process

- Create a new branch from `development` for any new feature or bugfix
- While working on feature update the changelog in the format of
    - Release Header Placeholder = `# Release Date`
    - Release Date Placeholder = `## Release Version`
    - [Release Type (major / minor / patch)] TicketNumber: <Content>
- After QA, merge the feature/bugfix branch into `development`
- Trigger the release workflow from `development`