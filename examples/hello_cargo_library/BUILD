load("@io_bazel_rules_rust//rust:rust.bzl", "rust_binary",)

rust_binary(
    name = "hello",
    srcs = ["src/main.rs"],
    deps = [
        "//examples/hello_cargo_library/vendor/fern-0.3.5:fern",
        "//examples/hello_cargo_library/vendor/log-0.3.7:log",
    ],
)
