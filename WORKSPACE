workspace(name = "io_bazel_rules_raze")

# Examples cannot be run from root because their dependencies are special
# When recursive WORKSPACES are supported, revisit this

git_repository(
    name = "io_bazel_rules_rust",
    remote = "https://github.com/acmcarther/rules_rust.git",
    commit = "49a7345"
)
load("@io_bazel_rules_rust//rust:rust.bzl", "rust_repositories")

rust_repositories()
