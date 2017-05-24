_raze_generate_attrs = {
    "cargo_sources": attr.label(
        mandatory = True,
    ),
    "cargo_toml": attr.label(
        mandatory = True,
    ),
    "cargo_lock": attr.label(
        mandatory = True,
    ),
    "_cargo_raze": attr.label(
        default = Label("@io_bazel_cargo_repository_rules//:cargo_raze"),
        executable = True,
        cfg = "host",
        single_file = True,
    )
}

CARGO_BUILD_FILE = """
package(default_visibility = ["//visibility:public"])

"""

_CARGO_REPOSITORY_TOOLS_BUILD_FILE = """
package(default_visibility = ["//visibility:public"])

alias(
  name = "cargo_vendor",
  path = "bin/cargo-vendor",
)

alias(
  name = "cargo_raze",
  path = "bin/cargo-raze",
)
"""

def _cargo_repository_tools_impl(ctx):
    print("_cargo_repository_tools_impl")
    print("hello?")
    print("ctx.attr._cargo_tool", str(ctx.attr._cargo_tool))
    ctx.symlink(ctx.attr._cargo_tool, "cargo")

    for tool in ["cargo-vendor", "cargo-raze"]:
        print("Installing %s" % tool)
        result = ctx.execute([
            ctx.path(ctx.attr._cargo_tool),
            "install",
            tool,
            "--force",
            "--root",
            ctx.path("")])
        if result.return_code:
            fail("failed to build %s:\n%s" % (tool, result.stderr))

    ctx.file('BUILD', _CARGO_REPOSITORY_TOOLS_BUILD_FILE, False);
    print("made build file")

def _raze_generate_impl(ctx):
    print("_raze_generate_impl")
    cargo_sources = ctx.attr.cargo_sources

    ctx.symlink(ctx.attr.cargo_toml, "Cargo.toml")
    ctx.symlink(ctx.attr.cargo_lock, "Cargo.lock")
    print("symlinked some files")
    st = ctx.execute(["bash", "-c", "set -ex", "cp {sources} {working_dir} -r".format(sources=cargo_sources, working_dir=ctx.path("."))])
    if st.return_code != 0:
      fail("error copying %s:\n%s" % (ctx.name, st.stderr))

    st = ctx.execute(["bash", "-c", "set -ex", ctx.path(ctx.attr._cargo_raze)])
    if st.return_code != 0:
      fail("error generating BUILD files %s:\n%s" % (ctx.name, st.stderr))


_cargo_repository_tools = repository_rule(
    _cargo_repository_tools_impl,
    attrs = {
        "_cargo_tool": attr.label(
            default = Label("@cargo_linux_x86_64//:cargo"),
        ),
        "_rustc": attr.label(
            default = Label("@rust_linux_x86_64//:rustc"),
            cfg = "host",
        )
    }
)

def cargo_repositories():
    print("cargo_repositories")
    native.new_http_archive(
        name = "cargo_linux_x86_64",
        url = "https://static.rust-lang.org/dist/cargo-0.16.0-x86_64-unknown-linux-gnu.tar.gz",
        strip_prefix = "cargo-nightly-x86_64-unknown-linux-gnu/cargo/bin",
        sha256 = "0655713cacab054e8e5a33e742081eebec8531a8c77d28a4294e6496123e8ab1",
        build_file_content = CARGO_BUILD_FILE,
    )

    native.new_http_archive(
        name = "cargo_darwin_x86_64",
        url = "https://static.rust-lang.org/dist/cargo-0.16.0-x86_64-apple-darwin.tar.gz",
        strip_prefix = "cargo-0.16.0-x86_64-apple-darwin",
        sha256 = "38606e464b31a778ffa7d25d490a9ac53b472102bad8445b52e125f63726ac64",
        build_file_content = CARGO_BUILD_FILE,
    )

def raze_repositories():
    print("raze_repositories")
    _cargo_repository_tools(
        name = "io_bazel_cargo_repository_rules",
    )
    print("made some archive")

raze_generate = repository_rule(
    implementation = _raze_generate_impl,
    local=False,
    attrs=_raze_generate_attrs,
)
