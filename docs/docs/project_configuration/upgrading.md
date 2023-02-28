---
sidebar_position: 9
description: Learn how to upgrade your project to incorporate improvements in the toolkit.
---

# Upgrading your project

If you have generated a project using an older version of the Flutter News Template, you can upgrade your project to take advantage of any fixes and improvements.

:::caution
It's recommended that you use a version control tool like `git` and that you have committed all changes before trying to upgrade. Please make sure you have a backup of your project before proceeding so that you can revert the changes if you encounter any issues during the upgrade process.
:::

## Upgrade the template

In order to upgrade an existing project, you must first upgrade to the latest available version of the [`flutter_news_template`](https://brickhub.dev/bricks/flutter_news_template).

:::info
You can check the local version of the `flutter_news_template` by running `mason list --global`

```
mason list --global
/Users/me/.mason-cache/global
└── flutter_news_template 1.0.0 -> registry.brickhub.dev
```

:::

If you have an outdated version installed, upgrade by running `mason upgrade --global`

:::note
Running `mason upgrade --global` will also upgrade other globally installed templates. If you wish to avoid this you can re-install just the `flutter_news_template` via:

```sh
# Uninstall the current version of the flutter_news_template
mason remove -g flutter_news_template

# Install the latest available version of the flutter_news_template
mason add -g flutter_news_template
```

:::

## Regenerate the project

Once you have upgraded to a newer version of the `flutter_news_template`, you can update an existing project by re-running the `mason make` command:

```sh
mason make flutter_news_template
```

It's important to provide the same values as you originally did when mason prompts for things like the application name, bundle identifier, code owners, and flavors.

:::tip
It may be helpful to maintain a configuration file which contains the configuration used to generate the project:

```json
{
  "app_name": "Daily Globe",
  "reverse_domain": "com.globe.daily",
  "code_owners": "@user1 @user2",
  "flavors": ["development", "integration", "staging", "production"]
}
```

This way you can pass the same configuration to mason every time:

```sh
mason make flutter_news_template -c ./path/to/config.json
```

:::

At this point, mason will generate any new files which didn't exist in previous versions of the template. A conflict can occur when mason attempts to generate a file which already exists and the contents of the existing file differ from the contents of the generated file. By default, mason will prompt you for each file conflict and ask you how you would like to resolve the conflict. Refer to the [mason documentation](https://docs.brickhub.dev/mason-make#file-conflict-resolution-%EF%B8%8F) for more information about file conflict resolution and specifying a conflict resolution strategy.

Once you have resolved any conflicts, your project has been successfully upgraded 🎉.
