"""
Main API entrypoint.
"""

import requests
from fastapi import FastAPI, Request

FASTAPI_APP = FastAPI()

URL_BASE = "https://kauppa.kierratyskeskus.fi/backend/api/v1/products?inStock=1&page={}&cross_categories[]=18305&cross_categories[]=18304&categories[]=183&excludeContent=1&sections[]=6&lang=fi&active_section=6"


@FASTAPI_APP.get("/kierratyskeskus")
async def kierratyskeskus(request: Request):
    """
    Scrape kierratyskeskus.
    """
    # Get first page
    first_page = requests.get(url=URL_BASE.format("1"))
    first_page_json = first_page.json()

    # Determine last page from first page json response
    last_page = first_page_json["last_page"]

    # Collect into single list of json events
    data_results = []
    data_results.extend(first_page_json["data"])

    # Iterate from second page to last
    for page_idx in range(2, last_page + 1):
        try:
            page_json = requests.get(url=URL_BASE.format(str(page_idx))).json()
            data_results.extend(page_json["data"])
        except ValueError:
            pass

    # Return all page jsons
    return data_results
