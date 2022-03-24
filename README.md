## Overview
A Drone plugin that runs the Datree CLI.  
Use this plugin to easily scan your k8s manifest files, Helm charts and Kustomizations for misconfigurations as part of your CI.

## Setup
Get started in 2 simple steps:  

* Obtain your Datree account token by following the instructions described [here](https://hub.datree.io/account-token).
* Configure your token by passing it directly to the 'token' setting, or by setting it as a secret variable in your drone dashboard (see examples below).

## Usage

The following settings determine the plugin's behavior:  
| Setting | Required | Description |
| --- | ----------- | --- |
| **token** | Yes | your Datree CLI token. |
| **path** | Yes | A path to the file/s you wish to run your Datree test against. This can be a single file or a [Glob pattern](https://www.digitalocean.com/community/tools/glob) signifying a directory. |
| **cliArguments** | No | The desired [Datree CLI arguments](https://hub.datree.io/cli-arguments) for the policy check. In the above example, schema version 1.20.0 will be used.  |
| **isHelmChart** | No | Specify whether the given path is a Helm chart. If this option is unused, the path will be considered as a regular yaml file. |
| **helmArguments** | No | The Helm arguments to be used, if the path is a Helm chart. |
| **isKustomization** | No | Specify whether the given path is a directory containing a "kustomization.yaml" file. If this option is unused, the path will be considered as a regular yaml file. |
| **kustomizeArguments** | No | The Kustomize arguments to be used, if the path is a Kustomization directory |  

*For more information and examples of using this plugin with Helm/Kustomize, see below*

## Examples
Here is an example pipeline that runs a Datree policy check on a file in the repository, on every push/pull request. This example uses a drone secret variable for the CLI token (can be configured via the drone dashboard):
```yaml
kind: pipeline
type: docker
name: default

platform:
  os: linux
  arch: arm64

steps:
- name: datree-policy-check  
  image: datree/drone-datree
  settings:
    token:
      from_secret: datree_token
    path: "someDirectory/someFile.yaml"

  when:
    event:
    - push
    - pull_request
```

### Using Helm
This plugin enables performing policy checks on Helm charts, by utilizing the [Datree Helm plugin](https://github.com/datreeio/helm-datree).
To test a Helm chart, simply set "isHelmChart" to 'true', and add any Helm arguments you wish to use to the "helmArguments" setting, like so:
```yaml
kind: pipeline
type: docker
name: default

steps:
- name: datree-policy-check  
  image: datree/drone-datree
  settings:
    token:
      from_secret: datree_token
    path: "my/chart/directory"
    isHelmChart: true
    helmArguments: "--values values.yaml"
```

### Using Kustomize
This plugin utilizes the Datree CLI's built-in Kustomize support. To use the plugin to test a kustomization, set "isKustomization" to 'true', and add any Kustomize arguments you wish to use to the "kustomizeArguments" setting, like so:
```yaml
kind: pipeline
type: docker
name: default

steps:
- name: datree-policy-check  
  image: datree/drone-datree
  settings:
    token:
      from_secret: datree_token
    path: "my/kustomization/directory"
    isKustomization: true
    kustomizeArguments:
```
