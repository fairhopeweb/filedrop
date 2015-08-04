@0xf432f4735ec7ac78;

using Spk = import "/sandstorm/package.capnp";
# This imports:
#   $SANDSTORM_HOME/latest/usr/include/sandstorm/package.capnp
# Check out that file to see the full, documented package definition format.

const pkgdef :Spk.PackageDefinition = (
  # The package definition. Note that the spk tool looks specifically for the
  # "pkgdef" constant.

  id = "nn7axgy3y8kvd0m1mtk3cwca34t916p5d7m4j1j2e874nuz3t8y0",
  # Your app ID is actually its public key. The private key was placed in
  # your keyring. All updates must be signed with the same key.

  manifest = (
    appTitle = (defaultText = "FileDrop"),

    appVersion = 1,  # Increment this for every release.

    appMarketingVersion = (defaultText = "1.0.1"),
    # Human-readable representation of appVersion. Should match the way you
    # identify versions of your app in documentation and marketing.

    actions = [
      ( title = (defaultText = "New Drop"),
        command = .myCommand
      )
    ],

    continueCommand = .myCommand
    # This is the command called to start your app back up after it has been
    # shut down for inactivity. Here we're using the same command as for
    # starting a new instance, but you could use different commands for each
    # case.
  ),

  sourceMap = (
    searchPath = [
      ( sourcePath = "LICENSE.all",
        packagePath = "LICENSE" ),
      ( sourcePath = ".",
        packagePath = "filedrop",
        hidePaths = [".git"]
      ),
      ( sourcePath = "/",
        hidePaths = [ "home", "proc", "sys",
                      "etc/passwd", "etc/hosts", "etc/host.conf",
                      "etc/nsswitch.conf", "etc/resolv.conf",
                      "etc/ld.so.cache" ]
      )
    ]
  ),

  fileList = "sandstorm-files.list",
  # `spk dev` will write a list of all the files your app uses to this file.
  # You should review it later, before shipping your app.

  alwaysInclude = ["LICENSE", "filedrop/third_party/roboto"],
  # Fill this list with more names of files or directories that should be
  # included in your package, even if not listed in sandstorm-files.list.
  # Use this to force-include stuff that you know you need but which may
  # not have been detected as a dependency during `spk dev`. If you list
  # a directory here, its entire contents will be included recursively.

  bridgeConfig = (
    viewInfo = (
      permissions = [
        ( name = "read",
          title = (defaultText = "View Files")
        ),
        # TODO(light): break this apart into creating vs. modifying
        ( name = "write",
          title = (defaultText = "Edit Files")
        ),
        ( name = "delete",
          title = (defaultText = "Delete Files")
        )
      ],
      roles = [
        ( title = (defaultText = "viewer"),
          verbPhrase = (defaultText = "can view"),
          permissions = [true, false, false]
        ),
        ( title = (defaultText = "editor"),
          verbPhrase = (defaultText = "can edit"),
          permissions = [true, true, true]
        )
      ]
    )
  )
);

const myCommand :Spk.Manifest.Command = (
  argv = ["/sandstorm-http-bridge", "8080", "--",
          "/filedrop/filedrop",
          "-address=[::]:8080",
          "-storage=/var/files",
          "-datadir=/filedrop",
          "-sandstorm_acls"],
  environ = [
    (key = "PATH", value = "/usr/local/bin:/usr/bin:/bin")
  ]
);