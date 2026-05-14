cask "archy" do
  version "2.39.1"
  sha256 "cdeb249a0cde10f8a3b35918696d9dc665efff9738ccc5181b130a793b59e5e3"

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