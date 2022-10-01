# Example Python monorepo using Pants

This is a sample Python monorepo I use to learn how to use Pants.

## Update .env

Must be ran every time a new root is added.

```shell
echo PYTHONPATH=$(./pants roots | tr '\n' :)\$PYTHONPATH > .env
```

## Build virtualenvs

```shell
$ ./pants export ::
Wrote virtualenv for the resolve 'python-default' (using Python 3.9.14) to dist/export/python/virtualenvs/python-default
Wrote virtualenv for the tool 'pytest' to dist/export/python/virtualenvs/tools
Wrote virtualenv for the tool 'black' to dist/export/python/virtualenvs/tools
Wrote virtualenv for the tool 'docformatter' to dist/export/python/virtualenvs/tools
Wrote virtualenv for the tool 'flake8' to dist/export/python/virtualenvs/tools
Wrote virtualenv for the tool 'isort' to dist/export/python/virtualenvs/tools
Wrote virtualenv for the tool 'pylint' to dist/export/python/virtualenvs/tools
Wrote virtualenv for the tool 'mypy' to dist/export/python/virtualenvs/tools
```

## Configure VSCode to use the python-default virtualenv

```shell
mkdir -p .vscode
VSCODE_SETTINGS_PATH=.vscode/settings.json
DEFAULT_INTERPRETER_PATH=$(echo ./dist/export/python/virtualenvs/python-default/*/bin/python | head -1)
[ -f $VSCODE_SETTINGS_PATH ] || echo '{}' > $VSCODE_SETTINGS_PATH
jq --arg pythonInterpreterPath $DEFAULT_INTERPRETER_PATH '
    ."python.defaultInterpreterPath" = "'$DEFAULT_VENV_PATH'" |
    ."python.formatting.provider" = "black" |
    ."python.formatting.blackPath" = "./dist/export/python/virtualenvs/tools/black/bin/black" |
    ."python.sortImpots.path" = "./dist/export/python/virtualenvs/tools/isort/bin/isort" |
    ."python.linting.flake8Enabled" = true |
    ."python.linting.flake8Path" = "./dist/export/python/virtualenvs/tools/flake8/bin/flake8" |
    ."python.linting.flake8Enabled" = true |
    ."python.linting.pylintPath" = "./dist/export/python/virtualenvs/tools/pylint/bin/pylint" |
    ."python.linting.pylintEnabled" = true |
    ."python.linting.mypyPath" = "./dist/export/python/virtualenvs/tools/mypy/bin/mypy" |
    ."python.linting.mypyEnabled" = true
' $VSCODE_SETTINGS_PATH | sponge $VSCODE_SETTINGS_PATH
```

## Update requirements lock file

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
