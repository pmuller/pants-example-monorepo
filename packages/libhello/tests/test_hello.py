from libhello import hello


def test_hello():
    assert hello('world') == 'Hello world'