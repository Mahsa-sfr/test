# Tests for python-example.func

from python_example import inc_num


def test_inc_number():
    assert inc_num(1) == 2
