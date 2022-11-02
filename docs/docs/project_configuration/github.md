---
sidebar_position: 1
description: Learn how to configure your repository on GitHub.
---

# GitHub Setup

Below are the recommended configuration settings for your repository on GitHub. Note that you're welcome to use other development hosting services, if desired.

## Create Repository

If you do not already have an account, please follow GitHub's [getting started guide](https://docs.github.com/en/get-started/onboarding/getting-started-with-your-github-account) to generate and configure your account. Follow [these steps](https://docs.github.com/en/get-started/quickstart/create-a-repo) to create your repository.

## Branch Protection Rules

You can protect important branches by setting branch protection rules, which define whether collaborators can delete or force push to a branch and set requirements for any pushes to a branch, such as passing status checks or linear commit history. It's recommended to enable the following branch protection rules for your project:

- Require a pull request before merging (require approvals, dismiss stale pull request approvals when new commits are pushed, require review from code owners).
- Require status checks to pass before merging (require branched to be up to date before merging).
- Require linear history.

For more information on branch protection rules, follow [this link](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/about-protected-branches) to learn more.

## Slack Integration

The GitHub integration for Slack gives you and your teams full visibility into your GitHub projects right in Slack channels, where you can generate ideas, triage issues and collaborate with other teams to move projects forward. To configure this for your repository, follow the instuctions [here](https://github.com/integrations/slack/blob/master/README.md) (recommended).

## Configuring PR Merges

Whenever you propose a change in Git, you create a new branch. [Branch management](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-branches-in-your-repository) is an important part of the Git workflow. After some time, your list of branches may grow, so it's a good idea to delete merged or stale branches.

To streamline this management, you can automatically delete head branches after pull requests are merged in your repository. For details on how to set this up, vist [this link](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-the-automatic-deletion-of-branches).

In addition, you can allow or disallow auto-merge for pull requests in your repository. Follow the steps [here ](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-auto-merge-for-pull-requests-in-your-repository) to set this up for your project.

## Draft PRs

You can choose to mark a pull request that is ready for review or a [draft pull request](https://github.blog/2019-02-14-introducing-draft-pull-requests/) when you generate a pull request for your news project. Draft pull requests cannot be merged and code owners are not automatically requested to review draft pull requests. However, you can collaborate with other team members in GitHub when leveraging this feature. It is recommended to leverage draft pull requests for your project, but this is not a requirement.

:::note

If any of the above features are not available to you, it's possible your account needs to be upgraded. Please see [GitHubs Products](https://docs.github.com/en/get-started/learning-about-github/githubs-products) for an overview of your options.

:::
