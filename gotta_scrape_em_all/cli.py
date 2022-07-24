#!/usr/bin/env python3
"""
Command-line entrypoint.
"""

import typer
import uvicorn

APP = typer.Typer()


@APP.command()
def cli():
    """
    Run API with uvicorn.
    """
    uvicorn.run("gotta_scrape_em_all.main:FASTAPI_APP", port=5000, log_level="info")


if __name__ == "__main__":
    APP()
