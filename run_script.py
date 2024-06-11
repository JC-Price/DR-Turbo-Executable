"""
Takes info from main_gui.py and passes it along to convert_script
"""

import subprocess
import sys


def storeInfo(dir_text, main_text, env_text):
    # first check we have all the info we need
    if dir_text is None or main_text is None or env_text is None:
        return "missing_data"
    
    try:
        p = subprocess.Popen(["convert_script.psi", dir_text, main_text, env_text], stdout=sys.stdout)
        p.communicate()
    except Exception as e:
        print(e)
        return "failed"
