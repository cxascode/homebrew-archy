cask "archy" do
  version "2.39.4"
  name "Archy"
  desc "YAML processor"
  homepage "https://developer.genesys.cloud/devapps/archy/"

  artifact = on_system_conditional macos: "archy-macos.zip", linux: "archy-linux.zip"

  on_macos do
    sha256 "eac7f7045f73a888be7eef30be1c205a9d99935a9e9c82e5d2abf329fdbacef3"
  end

  on_linux do
    sha256 "2ad6c90c5df260504ab5632a823621a38834ba1b1070b2b7daefe938f9f47dab"
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