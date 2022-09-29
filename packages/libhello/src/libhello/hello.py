from colorama import Style, Fore


def hello(name):
    return f'Hello {Fore.GREEN}{name}{Style.RESET_ALL}'