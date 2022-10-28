---
sidebar_position: 1
description: Learn how to configure your repository on GitHub.
---

# GitHub Setup

- Create repository within the ‘Github Organization’ to enable:
  - The following recommended branch protection rules:
    - Require a pull request before merging (require approvals, dismiss stale pull request approvals when new commits are pushed, require review from Code Owners).
    - Require status checks to pass before merging (require branches to be up to date before merging).
    - Require linear history.
  - [Slack Integration](https://github.com/integrations/slack/blob/master/README.md) (recommended)
  - [Auto-deletion](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-the-automatic-deletion-of-branches) and [auto-merge](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-auto-merge-for-pull-requests-in-your-repository) for branches
  - Draft PRs
- Grant Admin access to at least one developer to enable secrets creation.
