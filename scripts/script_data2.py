#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Store persistant data to be used by scripts."""
# Ideas:
# configure database backend for a real database to have script data across machines
# encrypted keys/values

import os
import sys
from os.path import isdir, isfile, join

import yaml

from sqlitedict import SqliteDict


class ScriptData2:
    script_storage = "~/.local/state/scripts"

    def __init__(self, name: str, config_file="config.yaml"):
        if "win" in sys.platform:
            raise NotImplementedError("ScriptData2 is not supported on windows.")

        if isfile(config_file):
            with open(config_file, "r") as f:
                config = yaml.safe_load(f)
            self.script_storage = config.get("script_storage", self.script_storage)

        if not isdir(self.script_storage):
            os.makedirs(self.script_storage)
        self.database_file = join(self.script_storage, f"{name}.sqlite")

        try:
            self.db = SqliteDict(self.database_file, outer_stack=False)
        except Exception as e:
            print(f"Error opening database: {e}")
            raise

    def __del__(self) -> None:
        try:
            self.db.commit()
            self.db.close()
        except Exception as e:
            print(f"Error closing database: {e}")
            raise


def main():
    sd = ScriptData2("test")
    print(sd.script_storage)


if __name__ == "__main__":
    main()
