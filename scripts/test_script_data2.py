# -*- coding: utf-8 -*-
import os
import tempfile
from os.path import join

import pytest

from scripts.script_data2 import ScriptData2


@pytest.fixture(autouse=True)
def cleanup():
    """
    Deletes the test SQLite database file if it exists.
    """
    db_file = join(ScriptData2.script_storage, "test.sqlite")
    if os.path.exists(db_file):
        os.remove(db_file)


def test_script_data_00():
    """
    Test the database_file path is correct.
    """
    sd = ScriptData2("test")
    assert sd.database_file == join(ScriptData2.script_storage, "test.sqlite")


def test_script_data_01():
    """
    Test the persistance of a key.
    """
    sd = ScriptData2("test")
    sd.db["test_01"] = True
    del sd
    sd = ScriptData2("test")
    assert sd.db.get("test_01") == True


def test_database_creation():
    """
    Test the database file is created.
    """
    with tempfile.TemporaryDirectory() as tmpdir:
        ScriptData2.script_storage = tmpdir
        sd = ScriptData2("test")
        assert os.path.exists(sd.database_file)


def test_data_persistence():
    """
    Test the keys persist even after obj is deleted.
    """
    with tempfile.TemporaryDirectory() as tmpdir:
        ScriptData2.script_storage = tmpdir
        sd = ScriptData2("test")
        sd.db["test_key"] = "test_value"
        del sd

        sd2 = ScriptData2("test")
        assert sd2.db["test_key"] == "test_value"


def test_config_file_loading():
    """
    Test loading custom config.
    """
    # Create a temporary config file
    with tempfile.NamedTemporaryFile("w", delete=False) as f:
        f.write('script_storage: "/tmp/custom_storage"')

    # Test if the custom storage path is used
    with tempfile.TemporaryDirectory() as tmpdir:
        ScriptData2.script_storage = tmpdir
        sd = ScriptData2("test", config_file=f.name)
        assert sd.database_file.startswith("/tmp/custom_storage")

    os.remove(f.name)
