import os
import sys
import time
from termcolor import colored
import traceback
import requests

def prompt(text, max_try=10):
    """
    prompt user for yes or no
    support lower, higher case answers as well as their hybrid lower-higher case

    @type text: string
    @param text: the prompt printed to the terminal

    @type max_try: int
    @param max_try: max number of times the user can try answering the prompt
    """
    i = 0
    answer = False
    while i < max_try:
        answer = input(colored(text, "yellow"))
        if answer.lower() in ["yes", "y"]:
            answer = True
            break
        elif answer.lower() in ["no", "n"]:
            answer = False
            break
        print(colored("unexpected input, retry", "red"))
        i += 1
    if i == max_try:
        print(colored("max number of try reached, default answer selected: ", "red"),
              "yes" if answer == True else "no")
    return answer 
   
def downloadTo(url, filename, max_try=5):
    """
    download a file locate at the url, save it under the filename

    @type url: string
    @param url: url

    @type filename: string
    @param filename: relative or absolute path

    @type max_try: int
    @param max_try: max number of times the function will try downloading the file
    """
    i = 0
    print(colored('downloading "{}" from "{}"'.format(filename, url), "green"))
    while i < max_try:
        with open(filename, "wb") as file:
            try: #sometimes throw a certificate error, thus try multiple times
                response = requests.get(url, stream=True)
                total_length = response.headers.get('content-length')
                if total_length is None:
                    file.write(response.content)
                else:
                    dl = 0
                    total_length = int(total_length)
                    for data in response.iter_content(chunk_size=4096):
                        dl += len(data)
                        file.write(data)
                        done = int(50 * dl / total_length)
                        sys.stdout.write("\r[%s%s]" % ('=' * done, ' ' * (50-done)) )    
                        sys.stdout.flush()
                    break
            except Exception:
                i += 1
                print(colored("fail downloading, retry in 1 seconds", "red"))
                time.sleep(1)

if __name__ == "__main__":
    print(colored("*****************************************************", "red"))
    print(colored("** Welcome to Visual Studio Code EPuck 2 installer **", "red"))
    print(colored("*****************************************************\n", "red"))
    answer = prompt("Do you wish to continue with the installation: ")

    if answer:
        try:
            downloadTo("https://update.code.visualstudio.com/latest/linux-x64/stable", "vscode.tar.gz")
            os.mkdir("./folder1")
        except FileExistsError:
            print("folder1 already existing")
        f = open("folder1/file.md", "w")
        f.write("#Hello world\nThis is a new line!")
        f.close()
        os.system("git -v")


