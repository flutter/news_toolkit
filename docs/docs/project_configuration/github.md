---
sidebar_position: 1
description: Learn how to configure your repository on GitHub.
---

# GitHub setup

Below are the recommended configuration settings for your repository on GitHub. Note that you're welcome to use other development hosting services, if desired.

## Create repository

If you don't already have an account, please follow GitHub's [getting started guide](https://docs.github.com/en/get-started/onboarding/getting-started-with-your-github-account) to generate and configure your account. Check out the instructions to [create a repo](https://docs.github.com/en/get-started/quickstart/create-a-repo).

## Branch protection rules

You can protect important branches by setting _branch protection rules_, which define whether collaborators can delete or force push to a branch, and set requirements for pushing to a branch, such as passing status checks or requiring a linear commit history. We recommend that you enable the following branch protection rules for your project:

- Require a pull request before merging (require approvals, dismiss stale pull request approvals when new commits are pushed, require review from code owners).
- Require status checks to pass before merging (require branches to be up to date before merging).
- Require linear history.

To learn more, check out [branch protection rules](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/about-protected-branches).

## Slack integration

The GitHub integration for Slack gives you and your team full visibility into your GitHub projects right in Slack channels, where you can generate ideas, triage issues, and collaborate with other teams to move projects forward. To configure this for your repository, check out [GitHub and Slack integration](https://github.com/integrations/slack/blob/master/README.md) (recommended).

## Configuring PR merges

Whenever you propose a change in Git, you create a new branch. [Branch management](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-branches-in-your-repository) is an important part of the Git workflow. After some time, your list of branches will grow, so it's a good idea to delete merged or stale branches.

To streamline branch management, you can automatically delete head branches after pull requests are merged in your repository. To set this up, check out [how to automatically delete branches](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-the-automatic-deletion-of-branches).

In addition, you can allow or disallow auto-merge for pull requests in your repository. To set this up for your project, check out [managing automerge for PRs](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-auto-merge-for-pull-requests-in-your-repository).

## Draft PRs

You can set it up so that a new pull request can be optionally created as a draft PR or a standard PR. To learn how to set this up, check out [introducing draft pull requests](https://github.blog/2019-02-14-introducing-draft-pull-requests/). Draft pull requests can't be merged and code owners aren't automatically notified to review them. However, you can collaborate with other team members in GitHub when using this feature. We recommended using draft pull requests for your project, but this isn't a requirement.

:::note

If any of the above features aren't available to you, your account might need to be upgraded. For an overview of your options, check out [GitHub's products](https://docs.github.com/en/get-started/learning-about-github/githubs-products).

:::
