import os
from distutils.core import setup, Extension


def setupModule(moduleName: str, libraries: list[str], **kwargs):
    libraries.extend([os.environ['BOOST_PYTHON_LIB_NAME'], os.environ['PYTHON_LIB_NAME']])

    allCpp = []
    projectDir = os.path.dirname(__file__)
    for root, _, files in os.walk(projectDir):
        for file in files:
            if file.endswith(".cpp"):
                allCpp.append(os.path.join(root, file))

    myModule = Extension(moduleName,
                        include_dirs=[projectDir, os.environ["BOOST_DIR"]],
                        library_dirs=[os.environ['BOOST_PYTHON_LIB_DIR']],
                        libraries=libraries,
                        extra_compile_args = ["-DBOOST_PYTHON_STATIC_LIB"],
                        sources=allCpp
                        )

    setup(name=moduleName,
          version=kwargs.get("version", '1.0'),
          description=kwargs.get("description", ""),
          ext_modules=[myModule]
          )

setupModule("bptest", [])
