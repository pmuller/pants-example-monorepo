"""libhello implementation."""
from colorama import Fore, Style


def hello(name: str) -> str:
    """Say hello to `name`."""
    return f"Hello {Fore.GREEN}{name}{Style.RESET_ALL}"
