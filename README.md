# Pipeline Owners Buildkite Plugin 

A Buildkite plugin that's designed to introduce the concept of "owners". A `PIPELINEOWNERS` file path can be provided via `owners_file`, or the plugin will default to using `.buildkite/PIPELINEOWNERS`.

The contents of a `PIPELINEOWNERS` file would look similar to this:

```
org-name/example-pipeline #team-cool cool_team@org-name.com
org-name/example-pipeline-2 @anothercooluser #team-not-cool
```

The above shows how a monorepo `PIPELINEOWNERS` file may look, where the "owners" of the pipelines are set using a Slack handle (`@`), a Slack channel (`#`), an email addess or a combination of multiple of these.

You can then set a `method` of alert in the plugin which will select the necessary owner identifier from the `PIPELINEOWNERS`.

### How it works

The plugin injects a top-level `nofity` block in to the running pipeline, so that once the build has run to completion (passed, failed, blocked) the notification will trigger and deliver the status to the chosen target.

## Options

These are all the options available to configure this plugin's behaviour.

### Required

#### `method` (string)

This is the method of delivering the build notification, this can be one of `slack_channel`, `slack_handle` or `email`.

A `slack_channel` is the `#` identifier of the channel, such as `#general`. A `slack_handle` is the username or handle of a team/group, such as `@cool_user` or `@great_team`. These are delivered via direct message (DM).

`email` will send the notification to the email addess listed in the `PIPELINEOWNERS` file

### Optional

#### `owners_file` (string)

This allows you to override the default location of the `PIPELINEOWNERS` file, which is `.buildkite/PIPELINEOWNERS`.

## Examples

It is recommended that the plugin be used in the upload step of the pipeline, this ensures that no additional steps must pass in order for the plugin to insert the `notify` block.

```yaml
steps:
  - label: ":pipeline: Upload pipeline"
    command: buildkite-agent pipeline upload
    plugins:
        pipeline-owners-buildkite-plugin#v1.0.0:
            method: slack_channel
```

To override the default location of the `PIPELINEOWNERS` file, set an `owners_file` attribute.

```yaml
steps:
  - label: ":pipeline: Upload pipeline"
    command: buildkite-agent pipeline upload
    plugins:
        pipeline-owners-buildkite-plugin#v1.0.0:
            owners_file: configs/buildkite/PIPELINEOWNERS
            method: slack_channel
```

## ⚒ Developing

You can use the [bk cli](https://github.com/buildkite/cli) to run the [pipeline](.buildkite/pipeline.yml) locally:

```bash
bk local run
```

## 👩‍💻 Contributing

Your policy on how to contribute to the plugin!

## 📜 License

The package is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
