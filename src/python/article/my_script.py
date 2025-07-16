
import requests

def run():
    response = requests.get("https://2eb86668f7ab407989787c97ec6b24ba.api.mockbin.io/")

    my_dict = response.json()

    for key, value in my_dict.items():
        print(f"{key}: {value}") # print message: Hello World

    return my_dict
