class Serialterm < Formula
  desc "Serial terminal for USB-serial instruments, with built-in ZMODEM"
  homepage "https://github.com/mousebrains/SerialTerm"
  license "GPL-3.0-or-later"
  head "https://github.com/mousebrains/SerialTerm.git", branch: "main"

  depends_on macos: :sequoia
  depends_on "lrzsz"

  def install
    swift = Utils.safe_popen_read("swift", "--version")[/Swift version (\d+(?:\.\d+)+)/, 1]
    if swift.nil? || Version.new(swift) < Version.new("6.2")
      odie "SerialTerm needs Swift 6.2 or later (Xcode 26 or the Command Line Tools 26); " \
           "found #{swift || "none"}."
    end

    # SwiftPM's own sandbox can't run inside Homebrew's.
    ENV["SWIFT_BUILD_FLAGS"] = "--disable-sandbox"
    ENV["VERSION"] = version.to_s
    system "./scripts/make-app.sh"
    prefix.install "build/SerialTerm.app"

    (bin/"serialterm").write <<~SH
      #!/bin/sh
      exec open -a "#{opt_prefix}/SerialTerm.app" "$@"
    SH
    chmod 0755, bin/"serialterm"
  end

  def caveats
    <<~EOS
      SerialTerm.app is in #{opt_prefix}. Start it with `serialterm`, or link it into
      /Applications:
        ln -sf #{opt_prefix}/SerialTerm.app /Applications/SerialTerm.app
    EOS
  end

  test do
    app = prefix/"SerialTerm.app"
    assert_predicate app/"Contents/MacOS/SerialTerm", :executable?
    system "codesign", "--verify", "--strict", app
    assert_equal version.to_s,
                 shell_output("plutil -extract CFBundleShortVersionString raw #{app}/Contents/Info.plist").strip
  end
end
