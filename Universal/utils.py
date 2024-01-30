import os
import sys
import time
import requests
import tarfile
import shutil
import logging

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

    if os.path.isfile(filename):
        logging.info(f"{filename} already exists, not redownloading, delete manualy if file corrupted")
        return
    else:    
        logging.info('downloading "{}" from "{}"'.format(filename, url))
        for attempt in range(max_try):
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
                    logging.error("fail downloading, retry in 1 seconds")
                    time.sleep(1)

def os_cli(command):
    logging.info("executing " + command)
    return_code = os.system(command)
    if return_code == 126:
        logging.error("Command not executable (or permission denied): " + command)
    elif return_code == 127:
        logging.error("Command not found: " + command)
    elif return_code == 130:
        logging.error("Command interrupted by user: " + command)
    elif return_code != 0:
        logging.error("Command failed to execute for unknown reason: " + command)

def os_copy(src, dest):
    if os.path.isdir(dest):
        logging.warning("deleting already existing destination : " + dest)
        shutil.rmtree(dest)
    if not os.path.isdir(src):
        logging.error("invalid source folder to copy: " + src)
    else:
        logging.info("copying " + src + " to " + dest)
        shutil.copytree(src, dest)
    if not os.path.isdir(dest):
        logging.error("failed to copy folder to " + dest)
    else:
        logging.info("copied " + dest)
