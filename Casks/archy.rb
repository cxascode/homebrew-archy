cask "archy" do
  version "2.44.1"
  name "Archy"
  desc "YAML processor"
  homepage "https://developer.genesys.cloud/devapps/archy/"

  artifact = on_system_conditional macos: "archy-macos.zip", linux: "archy-linux.zip"

  on_macos do
    sha256 "06ce442727013bb6ac47b510bf02c9f79aa4352fed79a0800cee09c412a4375f"
  end

  on_linux do
    sha256 "f49a8808590cb420379b1885df58bae4dad7d2433a06ba27339bf88632f4ed4e"
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