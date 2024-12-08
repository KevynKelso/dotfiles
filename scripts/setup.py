from setuptools import find_packages, setup

setup(
    name="scripts",
    version="0.1.0",
    packages=find_packages(),
    author="Kevyn Kelso",
    install_requires=[
        "sqlitedict",
        "pyyaml",
    ],
)
