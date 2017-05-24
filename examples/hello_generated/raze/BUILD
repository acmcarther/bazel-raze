package(default_visibility = ["//visibility:private"])

filegroup(
    name = "cargo_toml",
    srcs = [ "Cargo.toml" ],
)

filegroup(
    name = "cargo_lock",
    srcs = [ "Cargo.lock" ],
)

raze_vendor(
    name = "cargo_sources",
    cargo_toml = ":cargo_toml",
    cargo_lock = ":cargo_lock",
)

raze_generate(
    name = "cargo_deps",
    cargo_toml = ":cargo_toml",
    cargo_lock = ":cargo_lock",
    cargo_sources = ":cargo_sources",
    visibility = [ "//visibility:public" ],
    overrides = [ ],
)

