# Music Assistant (Spotify proxy)

Music Assistant with a proxy setting for the Spotify provider. Install it, start it, and it
runs the server from the [`claude/spotify-proxy`](https://github.com/notraiday/ma-server-spotify-proxy/tree/claude/spotify-proxy)
branch of `notraiday/ma-server-spotify-proxy`. There is nothing to configure first.

## Using the proxy

1. Open the Spotify provider in Music Assistant and choose to set it up or reconfigure it.
2. The first step is **Connect through a proxy?**. Enter `host:port`, or
   `http://user:password@host:port` if the proxy needs a login. Leave it empty to connect
   directly.
3. Carry on with the sign-in. The proxy is used for signing in, browsing and playback,
   with both librespot and Soloist.

Only HTTP(S) proxies are supported, not SOCKS. Changing the proxy later means going through
the reconfigure flow again.

## Good to know

- **It starts with an empty library.** Each App has its own data, so this App does not see the
  settings, providers or library of the regular Music Assistant App. Use Music Assistant's
  own backup and restore if you want to carry them over.
- **Run only one Music Assistant App at a time.** They share the same ports and the host
  network, so stop the regular App before starting this one.
- **The server is installed from the branch on every start**, so a start takes longer than
  the regular App, and a new commit on the branch is picked up by restarting.
- **It is a fork build.** It follows the upstream `dev` branch as of the fork, not the
  stable releases, and it only moves when the fork is updated.
- **Soloist and proxies:** Spotify does not document whether the Soloist engine honors proxy
  settings. If the engine's connections do not show up in your proxy's log, playback with
  Soloist is not going through it.

## Going back to the nightly build

Set **Server repository** in the App's configuration to an empty value to run the nightly
build that is baked into the App image, or to any branch, pull request or fork. This App is
the Music Assistant DEV App with a different default, so everything in that App's options
applies here too.
