cask "archy" do
  version "2.42.0"
  name "Archy"
  desc "YAML processor"
  homepage "https://developer.genesys.cloud/devapps/archy/"

  artifact = on_system_conditional macos: "archy-macos.zip", linux: "archy-linux.zip"

  on_macos do
    sha256 "8b209d69c38edc869c88d2dc27b0bdf74e8300a44491fe9f6f03d4d2983900b4"
  end

  on_linux do
    sha256 "2b19e09a5eec1a33167c6a993fdfa5d39c738b95e39009aa942d3b3673c1e29c"
  end

  url "https://sdk-cdn.mypurecloud.com/archy/#{version}/#{artifact}",
      verified: "sdk-cdn.mypurecloud.com/archy/"

  binary "archy", target: "archy"

  postflight do
    platform = OS.mac? ? "macos" : "linux"
    archypath = staged_path
    launcher = archypath/"archy"

    ohai "Patching Archy launcher"
    raise "Launcher not found: #{launcher}" unless File.exist?(launcher)

    content = File.read(launcher)
    new_content = content.gsub(
      %r{exec "\./archyBin/archy-#{platform}-[^"]+"},
      "exec \"#{archypath}/archyBin/archy-#{platform}-#{version}\""
    )
    File.write(launcher, new_content)
  end

  on_macos do
    caveats do
      requires_rosetta
      <<~EOS
        This binary is not signed or notarized. macOS may block it the first time you run it.

        To run it, either allow it in System Settings → Privacy & Security, or remove the
        quarantine attribute:

          xattr -dr com.apple.quarantine "$(brew --caskroom)/archy"
      EOS
    end
  end
end