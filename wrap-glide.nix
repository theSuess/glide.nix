# wrapFirefox picks its ffmpeg by `versionAtLeast browser.version <N>`; Forks
# like Glide or Zen never clear that, so it's stuck on the oldest ffmpeg. Fake
# the version for that check only, restore the real one everywhere else.
wrapFirefox: unwrapped: config:
wrapFirefox (unwrapped // { version = unwrapped.firefoxVersion or "9999"; }) (
  { version = unwrapped.version; } // config
)
// {
  inherit unwrapped;
}
