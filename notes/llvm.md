# LLVM

Install the LLVM toolchain system-wide using the script from [apt.llvm.org](https://apt.llvm.org):

```sh
cd /tmp
wget https://apt.llvm.org/llvm.sh
chmod +x llvm.sh
sudo ./llvm.sh <version>
rm -f llvm.sh
```

The script adds the LLVM apt repository for your distro and installs `clang`, `lldb`, `lld`, and `clangd` for the given major version (e.g., `clang-<version>`).

Pass `all` as a second argument to install everything, including `clang-format` and `clang-tidy`:

```sh
sudo ./llvm.sh <version> all
```

The unversioned binaries are in `/lib/llvm-<version>/bin`.
