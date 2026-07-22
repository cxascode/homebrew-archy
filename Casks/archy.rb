cask "archy" do
  version "2.41.0"
  name "Archy"
  desc "YAML processor"
  homepage "https://developer.genesys.cloud/devapps/archy/"

  artifact = on_system_conditional macos: "archy-macos.zip", linux: "archy-linux.zip"

  on_macos do
    sha256 "d7c332869a2c29eb117c88cb209f06f6e51aab67a9676969677954b78670601e"
  end

  on_linux do
    sha256 "bc9b96be81806ea32b1f1e3d2356f7295bc48d741fa094b7de5fb65d6b6f6fae"
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