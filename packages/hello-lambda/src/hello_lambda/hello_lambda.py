"""Hello lambda function"""
from typing import TypedDict

from aws_lambda_typing.context import Context
from libhello import hello


class HelloEvent(TypedDict):
    """An event sent to the Hello lambda function."""

    name: str


def lambda_handler(event: HelloEvent, _context: Context) -> str:
    """Lambda function handler"""
    # This type ignore annotation shouldn't be necessary as hello()
    # returns str. This error only occurs when checking typing through VSCode,
    # not when checking with "./pants check".
    return hello(event["name"])  # type: ignore[no-any-return]
