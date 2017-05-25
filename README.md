# bazel raze
A cargo-raze complementing Bazel rule set.

## Problem

You've already read about [cargo-raze](https://github.com/acmcarther/cargo-raze) and now have Cargo.bzl files and don't know what to do with them. `bazel-raze` knows what to do with them -- generate, link and build your cargo dependencies!

## How it looks

In your Bazel WORKSPACE:
```python
git_repository(
    name = "io_bazel_rules_raze",
    remote = "https://github.com/acmcarther/bazel-raze.git",
    commit = "93dfb2a"
)

git_repository(
    name = "io_bazel_rules_rust",
    remote = "https://github.com/acmcarther/rules_rust.git",
    commit = "49a7345"
)
load("@io_bazel_rules_rust//rust:rust.bzl", "rust_repositories")

rust_repositories()
```

Then, see the [example](examples/hello_cargo_library/README.md). Remember to replace references to `//raze:raze.bzl` with `@io_bazel_rules_raze//raze:raze.bzl`.

## How it works

These Bazel `raze` rules wrap [cargo-vendor](https://github.com/alexcrichton/cargo-vendor) and `cargo-raze` in a warm Bazel-y blanket that lets you automagically use Cargo's ecosystem with Bazel.

Using `cargo-vendor` and `cargo-raze`, Bazel performs Cargo dependency vendoring, and then supplements the dependencies with Cargo.bzl files. Those files can then be interpreted by bazel to generate `rust_library` rules that you can use as if you'd manually written them.
