cask "archy" do
  version "2.42.1"
  name "Archy"
  desc "YAML processor"
  homepage "https://developer.genesys.cloud/devapps/archy/"

  artifact = on_system_conditional macos: "archy-macos.zip", linux: "archy-linux.zip"

  on_macos do
    sha256 "02b163b17387b1cca0740cf498eab7ce55ec5c09f099bef79be2edc180392fbe"
  end

  on_linux do
    sha256 "9cb2caa8dac733481c4999305e91afaf1dd301cdeeec0fd568dba9107ce15eb1"
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