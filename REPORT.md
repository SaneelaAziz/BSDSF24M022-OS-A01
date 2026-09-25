# REPORT.md

## Part 2: Multi-file Project using Make Utility

### Linking Rule `$(TARGET): $(OBJECTS)` vs. Library Linking
* **Direct Objects (`$(TARGET): $(OBJECTS)`):** Combines every listed `.o` file directly into the executable binary.
* **Library Linking (`-L -l`):** Links against an archive (`.a`) or shared object (`.so`) file. The linker extracts only the required symbol code (static) or sets up dynamic symbol references (dynamic).

### Git Tags & Types
* **Git Tag:** An immutable pointer to a specific commit used to mark version milestones (e.g., `v1.0`).
* **Lightweight vs. Annotated Tag:** Lightweight tags are simple pointers to commits. Annotated tags are full Git database objects storing author details, dates, messages, and optional digital signatures.

### GitHub Releases & Binary Assets
* Releases distribute versioned snapshots of source code associated with a tag. Attaching binary assets allows users to download pre-compiled executables/libraries without needing a local build environment.

---

## Part 3: Static Library Build

### Makefile Differences (Part 2 vs. Part 3)
* Part 2 links object files straight into the binary executable.
* Part 3 introduces `ar` / `ranlib` rules to bundle object files into `lib/libmyutils.a` first, then links the client using `-Llib -lmyutils`.

### `ar` Command & `ranlib`
* **`ar`:** Archives multiple `.o` files into a single `.a` static library.
* **`ranlib`:** Generates or updates an index/symbol table within the archive to speed up symbol resolution during linking.

### `nm` Symbol Inspection
* Symbols like `mystrlen` appear in `client_static`. This proves that the static linker copied the function's machine code directly out of `libmyutils.a` into the final executable.

---

## Part 4: Dynamic Library Build

### Position-Independent Code (`-fPIC`)
* Generates memory addresses using relative positions rather than absolute addresses. Required for shared libraries so the OS can load them into varying virtual memory locations across different processes.

### File Size Difference (`client_static` vs `client_dynamic`)
* **`client_static`:** Larger because it physically contains all bundled library function code.
* **`client_dynamic`:** Smaller because it only contains symbol reference stubs; the actual code lives in `libmyutils.so`.

### `LD_LIBRARY_PATH` & The Dynamic Loader
* **`LD_LIBRARY_PATH`:** An environment variable listing custom directories for the OS loader to search for shared libraries.
* **Necessity:** Local paths like `./lib/` are not in default system library locations (e.g., `/usr/lib`).
* **Dynamic Loader Responsibility:** At program startup, the loader finds required `.so` files, maps them into process memory, and resolves function address references.
# BSDSF24M022-OS-A01
