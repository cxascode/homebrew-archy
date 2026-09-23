cask "archy" do
  version "2.43.0"
  name "Archy"
  desc "YAML processor"
  homepage "https://developer.genesys.cloud/devapps/archy/"

  artifact = on_system_conditional macos: "archy-macos.zip", linux: "archy-linux.zip"

  on_macos do
    sha256 "21d03c4f331599017382a440b766231fc3e267e3cb3406636a7e26a7837833e0"
  end

  on_linux do
    sha256 "be0ba4ae6220502cc35b47a41aca91d56e23eeb133a4792e250b6e586fdf70c8"
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