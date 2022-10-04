# pylint: disable=missing-module-docstring,missing-function-docstring
from libhello import hello


def test_hello():
    assert hello("world") == "Hello \x1b[32mworld\x1b[0m"
