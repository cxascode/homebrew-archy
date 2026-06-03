cask "archy" do
  version "2.39.4"
  sha256 "eac7f7045f73a888be7eef30be1c205a9d99935a9e9c82e5d2abf329fdbacef3"

  url "https://sdk-cdn.mypurecloud.com/archy/#{version}/archy-macos.zip",
      verified: "sdk-cdn.mypurecloud.com/archy/"
  name "Archy"
  desc "YAML processor"
  homepage "https://developer.genesys.cloud/devapps/archy/"

  binary "archy", target: "archy"

  postflight do
    archypath = staged_path
    launcher = archypath/"archy"

    ohai "Patching Archy launcher"

    unless File.exist?(launcher)
      raise "Launcher not found: #{launcher}"
    end

    content = File.read(launcher)

    new_content = content.gsub(
      %r{exec "\./archyBin/archy-macos-[^"]+"},
      "exec \"#{archypath}/archyBin/archy-macos-#{version}\""
    )

    File.write(launcher, new_content)
  end

  caveats do
    requires_rosetta

    <<~EOS
      This binary is not signed or notarized. macOS will block it on first run.

      To run it, either allow it in System Settings (Privacy & Security) or remove the
      quarantine attribute:

        xattr -dr com.apple.quarantine "$(brew --caskroom)/archy"
    EOS
  end
end