cask "archy" do
  version "2.43.1"
  name "Archy"
  desc "YAML processor"
  homepage "https://developer.genesys.cloud/devapps/archy/"

  artifact = on_system_conditional macos: "archy-macos.zip", linux: "archy-linux.zip"

  on_macos do
    sha256 "fddba6d0341783a2131304836003ea36dffa271de1e71672de349f844117907c"
  end

  on_linux do
    sha256 "0b6ba14cc8e034373856e7e1a300711477331ec40c5ef270492aff3b0913018e"
  end

  url "https://sdk-cdn.mypurecloud.com/archy/#{version}/#{artifact}"

  binary "archy", target: "archy"

  postflight_steps do
    on_macos do
      inreplace "archy", %r{exec "\./archyBin/archy-macos-[^"]+"},
                'exec "{{staged_path}}/archyBin/archy-macos-{{version}}"'
    end
    on_linux do
      inreplace "archy", %r{exec "\./archyBin/archy-linux-[^"]+"},
                'exec "{{staged_path}}/archyBin/archy-linux-{{version}}"'
    end
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