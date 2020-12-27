#!/usr/bin/env python3

"""Symlink scripts in this directory

Symlink scripts in the current directory to /usr/local/bin (macOS). Use the
same name of the script to create the symlink if missing.
"""

__author__ = "tkolleh"
__license__ = "MIT"

import sys, os, subprocess, shutil, logging, argparse
import pprint as pp
from pprint import pprint
from pathlib import Path

from typing import List, Set, Dict, Tuple, Optional


def files_in_dir_of_type(type: str, dir: Path = Path.cwd()) -> Tuple[Path, ...]:
    rtn_lst = []
    for p in dir.iterdir():
        if p.suffix == ".sh":
            rtn_lst.append(p)

    logging.debug(rtn_lst)
    return tuple(rtn_lst)


def create_symlink(target_path: Path, link_path: Path = Path("/usr/local/bin")) -> Path:
    link_path = link_path.joinpath(target_path.stem)

    if link_path.exists():
        logging.debug(f"Symlink found at path '{link_path}'")
        return link_path
    if not target_path.exists():
        logging.error("Can not find target path at {}".format(target_path))
        raise FileNotFoundError("Unable to find target path")

    link_path.symlink_to(target_path)
    link_path = link_path.resolve()
    return link_path


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-v", "--verbose", help="Increase output verbosity", action="store_true"
    )
    args = parser.parse_args()
    if args.verbose:
        logging.basicConfig(level=logging.DEBUG)
        logging.debug("Verbose logging enabled")
    else:
        logging.basicConfig(level=logging.INFO)

    paths: Tuple[Path, ...] = files_in_dir_of_type(".sh")
    linked_paths: List[Tuple] = []
    error_paths: List[Path] = []
    for p in paths:
        try:
            link_path = create_symlink(p)
            linked_paths.append((link_path, p))
        except FileNotFoundError as f:
            logging.error(f"File not found at path '{p}'")
            error_paths.append(p)
        except:
            logging.error(f"Unexpected error:\n {sys.exc_info()[0]}")
            raise

    logging.info(f"Linked the following paths:\n {pp.pformat(linked_paths)}")

    if error_paths or logging.getLogger("root").isEnabledFor(logging.DEBUG):
        logging.info(f"Error linking the following paths:\n {pp.pformat(error_paths)}")
