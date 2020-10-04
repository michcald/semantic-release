# Semantic Release

This image defines a standard to implement automated semantic releases.

It's a wrapper for [Semantic Release](https://github.com/semantic-release/semantic-release).

## Conventional Commits

The semantic release process is complying with [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).

Here's a very quick manual:

- `fix: msg` will bump up the patch number (`v1.0.X`)
- `feat: msg` will bump up the minor number (`v1.X.0`)
- `feat!: msg` or `fix!: msg` will bump up the major number (`vX.0.0`) 

## Special Branches

When you push or merge PRs into one of these branches, the semantic release will kick in and produce a new release tag.

| Branch | Tag |
|-|-|
| master | `vX.X.X` |
| develop | `vX.X.X-develop.X` |

## Docker image output

Although this Docker image will create a new release tag, you may need to know what was the version just created if
you are running this in a CI pipeline. For example, you may need it to tag a new Docker image to be then pushed in ECR.

If a new release version is created, a new file `.RELEASE_VERSION` will be created in the root of the project which
contain the newly created tag (including the initial `v`).

Look at the Github action example below to see how to use it.

## Github Action Usage

```yaml
name: Release
on:
  push:
    branches:
      - master
      - develop
      # add here any other special branch you want to use
  pull_request:
jobs:
  release:
    name:  Release
    runs-on: ubuntu-latest
    timeout-minutes: 10
    env:
      GITHUB_TOKEN: ${{ secrets.MY_GITHUB_TOKEN }}
      RELEASE_VERSION: ~
    steps:
      - name: Checkout Repo
        uses: actions/checkout@v2
      - name: Semantic Release
        run: |
          docker run --rm -e GITHUB_TOKEN=${GITHUB_TOKEN} -v "${PWD}":/app michcald/semantic-release
          if test -f .RELEASE_VERSION; then
            release_version="$(cat .RELEASE_VERSION)"
            echo "::set-env name=RELEASE_VERSION::$release_version"
          fi
      - name: Version
        run: echo $RELEASE_VERSION
```

