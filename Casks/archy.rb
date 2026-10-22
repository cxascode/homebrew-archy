cask "archy" do
  version "2.44.0"
  name "Archy"
  desc "YAML processor"
  homepage "https://developer.genesys.cloud/devapps/archy/"

  artifact = on_system_conditional macos: "archy-macos.zip", linux: "archy-linux.zip"

  on_macos do
    sha256 "8e8b31263c12163903b54a1f90a814631d251551c96959e2351e5adb8eb89505"
  end

  on_linux do
    sha256 "886ecef103c2e4bcd1794a22b004b9c9222fcbaea208e426fb262ea100a2cac4"
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