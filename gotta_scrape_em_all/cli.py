#!/usr/bin/env python3
"""
Command-line entrypoint.
"""
import subprocess
import sys
import os
from pathlib import Path


def main():
    args = [] if len(sys.argv) == 1 else sys.argv[1:]
    # uvicorn.run("gotta_scrape_em_all.main:FASTAPI_APP", port=5000, log_level="info")
    os.chdir(Path(__file__).parent.parent)
    subprocess.check_call(["uvicorn", "gotta_scrape_em_all.main:FASTAPI_APP"] + args)


if __name__ == "__main__":
    main()
