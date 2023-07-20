#!/usr/bin/env python3

"""Write links to notebooks on the HTML file"""

import os
import sys

from bs4 import BeautifulSoup, Tag


def write_link(html_file: str, section_id: str) -> None:
    """Entrypoint of the script"""
    notebook_dict = {}

    with os.scandir("notebooks/") as notebooks:
        for notebook in notebooks:
            if notebook.name[-5:] == ".html":
                notebook_dict[notebook.name] = (
                    notebook.name[:-5].title().replace("_", " ")
                )

    with open(html_file, "r", encoding="utf-8") as handle:
        soup = BeautifulSoup(handle, "html.parser")

    for span in soup.find("nav").find_all("span"):
        if span.text == section_id:
            for sibling in span.next_siblings:
                if isinstance(sibling, Tag):
                    sibling.clear()
                    for file_name, title in notebook_dict.items():
                        new_li_tag = soup.new_tag("li")
                        new_a_tag = soup.new_tag("a", href=f"notebooks/{file_name}")

                        new_a_tag.string = title

                        new_li_tag.append(new_a_tag)
                        sibling.append(new_li_tag)

    with open(html_file, "w", encoding="utf-8") as file:
        file.write(str(soup))


if __name__ == "__main__":
    if len(sys.argv) == 3:
        write_link(sys.argv[1], sys.argv[2])
    else:
        print('USAGE: ./write_links.py [HTML File] "[Span Text]"')
        sys.exit(1)
