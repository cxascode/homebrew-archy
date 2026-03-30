cask "archy" do
  version "2.38.0"
  sha256 "7b089520d27125a528189da49a5a14416ccab1f83a2fbb6372f9bbf78bbf360d"

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
      opoo "Launcher not found: #{launcher}"
      next
    end

    content = File.read(launcher)
    if content.include?("./archyBin/")
      inreplace launcher,
        %r{^exec "\./archyBin/archy-macos-[^"]+"},
        "exec \"#{archypath}/archyBin/archy-macos-#{version}\""
    end
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