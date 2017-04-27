# bazel raze
A cargo-raze complementing Bazel rule set.

## Problem

You've already read about [cargo-raze](https://github.com/acmcarther/cargo-raze), and would like to keep vendored sources out of your source tree, or defer generation of BUILD files to Bazel load time so that users can let Cargo orchestrate the right dependencies for their platform.

## How it looks (speculative and untested)

In your Bazel WORKSPACE:
```python
# On demand vendoring
raze_vendor(
  name = "cargo_sources",
  cargo_toml = "//:Cargo.toml",
  cargo_lock = "//:Cargo.lock",
)

# Local (manual) vendoring
new_local_workspace(
    name = "local_cargo_sources"
    path = __workspace_dir__ + "/cargo_sources"
    build_file_content = """
filegroup(
    name = "sources",
    srcs = glob(["**"]),
    exclude_directories = 0,
)
"""
)

# WORKSPACE + BUILD generation
raze_generate(
  name = "cargo_deps",
  sources = ":cargo_sources",
  #sources = "@local_cargo_sources:sources",
  cargo_toml = "//:Cargo.toml",
  cargo_lock = "//:Cargo.lock",
)
```

In any new `rust_library`:
```python
load("@io_bazel_rules_rust//rust:rust.bzl", "rust_library",)

rust_library(
    name = "widget",
    srcs = glob(["src/**/*.rs"]),
    deps = [
        "@cargo_deps//:libc",
        "@cargo_deps//:bitflags",
        "@cargo_deps//:log",
        "@cargo_deps//:serde",
    ],
)
```

## How it works (soon!)

These Bazel `raze` rules wrap [cargo-vendor](https://github.com/alexcrichton/cargo-vendor) and `cargo-raze` in a warm Bazel-y blanket that lets you automagically use Cargo's ecosystem with Bazel. This is the way cargo-raze is "meant" to be used.

Using `cargo-vendor` and `cargo-raze`, Bazel performs Cargo dependency vendoring, and then supplements the dependencies with BUILD files. Either step can be perfomed manually, thereby "locking" either the sources or the BUILD rules for the whole project.

One important note: BUILD files are specific to the platform that `cargo-raze` is executed on. If you wish continue to leverage Cargo's platform-specific dependency resolution, you will need to defer generation of the BUILD files.
