import os
import sys
import time
import traceback
from termcolor import colored
import requests
import tarfile

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
                    print('\n')
                    break
            except Exception:
                i += 1
                print(colored("fail downloading, retry in 1 seconds", "red"))
                time.sleep(1)

        try:
            downloadTo("https://update.code.visualstudio.com/latest/linux-x64/stable", "vscode.tar.gz")
            file = tarfile.open("vscode.tar.gz")
            file.extractall("./")
            file.close()
            os.mkdir("./folder1")
        except FileExistsError:
            print("folder1 already existing")
        f = open("folder1/file.md", "w")
        f.write("#Hello world\nThis is a new line!")
        f.close()
        os.system("git -v")
