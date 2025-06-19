# Project template

A quick C++ startup template that helps you bootstrap your ideas if you want to build it using CMake, to retrieve its dependencies using VCPKG, and need FMT, SPDLOG, GLM, Dear ImGui and SDL3 to implement it.

## How to use - Windows

The usual way to use it is:
1. Choose your application's name and compose a short id from it: lowercase only, no space or blank, no special char (excepted `-`). We'll call it `my-application` from now on but you'll replace it your own application short id.
1. Copy all files from this project template folder to `my-application` folder.
1. Press <kbd>WIN</kbd>+<kbd>R</kbd> and enter `cmd` in the popup
1. Type the following command followed by <kbd>ENTER</kbd>:
```
mkdir my-application & cd my-application
```
1. Run the following command:
```
bootstrap.cmd
```

Voilà, you're done.

## How to use - Linux

*NOT IMPLEMENTED YET*

The usual way to use it is:
1. Choose your application's name
1. Transform the name into a short id: lowercase only, no space or blank, no special char (excepted `-`)
1. Open your preferred terminal application
1. Type the following command followed by <kbd>ENTER</kbd>, but replacing `my-application` with your application's short id:
```
mkdir my-application ; cd my-application
```
1. Copy all files from this project template folder to `my-application` folder.
1. Adapt the application dependency list:
    1. Explore the list of available ports in vcpkg using https://vcpkg.link/
    1. Open `my-application\bootstrap-dependencies.txt`
    1. Add / remove port names, then save
1. Run the following command:
```
.\bootstrap.sh
```

## Finalization

1. Adapt the application dependency list:
    1. Explore the list of available ports in vcpkg using https://vcpkg.link/
    1. Call `vcpkg add port [PORT]` with the need port name
    1. Call `vcpkg search [KEYWORD]` to search for `[KEYWORD]` in the list of available ports.
    1. Keep a copy the 2 lines of usage shown on the page
1. Open CMakeLists.txt and:
    1. Replace occurrences of `main` with your application's short id. This will become the main executable name.
    1. Append the copy of usage line pairs saved earlier for each new port
1. Run:
```
cmake --build build
```
