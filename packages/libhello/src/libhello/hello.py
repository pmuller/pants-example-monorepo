"""libhello implementation."""
from colorama import Style, Fore


def hello(name: str) -> str:
    """Say hello to `name`."""
    return f"Hello {Fore.GREEN}{name}{Style.RESET_ALL}"
