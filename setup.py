from setuptools import (
    setup,
    find_packages,
)


setup(
    name="tex_to_md",
    version="0.0.1",
    packages=find_packages(),
    install_requires=[
        "undebt",
    ],
)
