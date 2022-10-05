"""Hello CLI"""
from argparse import ArgumentParser

from libhello import hello


def main() -> None:
    """CLI entry point."""
    parser = ArgumentParser()
    parser.add_argument("name")
    arguments = parser.parse_args()
    print(hello(arguments.name))


if __name__ == "__main__":
    main()
