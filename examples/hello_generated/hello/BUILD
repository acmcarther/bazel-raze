laod("@io_bazel_rules_rust//rust:rust.bzl", "rust_library",)

rust_library(
    name = "hello",
    srcs = ["src/main.rs"],
    deps = [
        "@cargo_deps//:log",
        "@cargo_deps//:fern",
    ],
)
