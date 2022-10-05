#!/bin/bash -eu

# Cleanup $TMP_DIR on termination
trap 'rm -rf $TMP_DIR' EXIT

# Create a temporary directory
TMP_DIR=$(mktemp -d)
EXPORTS=$TMP_DIR/exports
VENV_PATHS=$TMP_DIR/venv-paths

# Export all virtualenvs
echo "Exporting virtualenvs..."
./pants export :: >"$EXPORTS"

# Get resolved Python version
echo "Generating .env file..."
FULL_PYTHON_VERSION=$(awk '
/^Wrote virtualenv for the resolve '\''python-default'\'' / {
    print gensub(/^([0-9\.]+)\)/, "\\1", "g", $9)
}
' <"$EXPORTS")
MINOR_PYTHON_VERSION=$(echo "$FULL_PYTHON_VERSION" | cut -d. -f1-2)

# Generate list of virtualenv paths
awk '
/^Wrote virtualenv for the resolve '\''python-default'\'' / {
    print $11 "/'"$FULL_PYTHON_VERSION"'"
}
/^Wrote virtualenv for the tool / {
    print $8 "/" gensub(/'\''([a-z0-9]+)'\''/, "\\1", "g", $6)
}
' <"$EXPORTS" >"$VENV_PATHS"

# Generate $PATH
awk '
{ path = path (path ? ":" : "") $0 "/bin" }
END { print "PATH=" path ":$PATH" }
' <"$VENV_PATHS" >.env

# Generate $PYTHONPATH
ROOTS=$(./pants roots | tr '\n' :)
awk '
BEGIN {
    suffix = "/lib/python'"$MINOR_PYTHON_VERSION"'/site-packages"
}
{
    pythonpath = pythonpath (pythonpath ? ":" : "") $0 suffix
}
END {
    print "PYTHONPATH='"$ROOTS"'" pythonpath ":$PYTHONPATH"
}
' <"$VENV_PATHS" >>.env

# Generate VSCode config
mkdir -p .vscode
VSCODE_SETTINGS_PATH=.vscode/settings.json
echo "Generating $VSCODE_SETTINGS_PATH file..."
DEFAULT_INTERPRETER_PATH=$(head -1 "$VENV_PATHS")/bin/python
[ -f $VSCODE_SETTINGS_PATH ] || echo '{}' >$VSCODE_SETTINGS_PATH
jq -r --arg defaultInterpreterPath "$DEFAULT_INTERPRETER_PATH" '
    ."python.defaultInterpreterPath" = $defaultInterpreterPath |
    ."python.formatting.provider" = "black" |
    ."python.linting.flake8Enabled" = true |
    ."python.linting.pylintEnabled" = true |
    ."python.linting.mypyEnabled" = true |
    ."[python]"."editor.formatOnSave" = true |
    ."[python]"."editor.codeActionsOnSave"."source.organizeImports" = true
' $VSCODE_SETTINGS_PATH | sponge $VSCODE_SETTINGS_PATH
