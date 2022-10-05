# Example Python monorepo using Pants

This is a sample Python monorepo I use to learn how to use Pants.

## Generate IDE configuration

Must be ran every time a new package is added.

```shell
$ ./scripts/setup-pants-ide-env.sh
Exporting virtualenvs...
Generating .env file...
Generating .vscode/settings.json file...
```

Configuration validated with VSCode.

TODO: Check if it also works in vim with [dotenv.vim](https://github.com/tpope/vim-dotenv).

## Update requirements lock file

Must be ran every time a dependency is added/modified/removed.

```shell
$ ./pants generate-lockfiles
18:32:51.53 [INFO] Initializing scheduler...
18:32:51.71 [INFO] Scheduler initialized.
18:32:52.87 [INFO] Completed: Generate lockfile for python-default
18:32:52.87 [INFO] Wrote lockfile for the resolve `python-default` to 3rdparty/python/default.lock
```

## Run all tests

```shell
./pants test ::
```

## Run linters

```shell
./pants lint ::
```

## Run type checker

```shell
./pants check ::
```
