import os

from dotenv import load_dotenv

load_dotenv()


def print_hello():
    print("Hello world, my name is alexandre!")
    
    


def print_password():
    print("Password:", os.getenv("PASSWORD"))


def inc_num(i: int) -> int:
    return i + 1
