cask "archy" do
  version "2.43.2"
  name "Archy"
  desc "YAML processor"
  homepage "https://developer.genesys.cloud/devapps/archy/"

  artifact = on_system_conditional macos: "archy-macos.zip", linux: "archy-linux.zip"

  on_macos do
    sha256 "dfd4338ccebe58e2c7490e6ea660eb36727f59cb5473d869074fda434d825c55"
  end

  on_linux do
    sha256 "3d895bbaead5c15d9fd31c290cf98f345e765701005eae6202927708ee3521f3"
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