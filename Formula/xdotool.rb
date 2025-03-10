class Xdotool < Formula
  desc "Fake keyboard/mouse input and window management for X"
  homepage "https://www.semicomplete.com/projects/xdotool/"
  url "https://github.com/jordansissel/xdotool/archive/v3.20160805.1.tar.gz"
  sha256 "ddafca1239075c203769c17a5a184587731e56fbe0438c09d08f8af1704e117a"
  revision OS.mac? ? 1 : 3

  bottle do
    sha256 "8dbfb2b1c32176c7cba00aaa2365f3cd438619dc0286e668e5d87412c3717d53" => :catalina
    sha256 "860e5e7f2ca2ae88c86e8a979eba543f544960894bb4d8ec59d98cbba9805614" => :mojave
    sha256 "9de15325d8ed42b629a94e34ff710672e96c1570dc51a6544aff0d0445de5e9c" => :high_sierra
    sha256 "eb2c19573448569504c6dbb38eaaee168d5ef115270d7d696118f809f789d229" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "libxkbcommon"
  depends_on :x11 if OS.mac?

  unless OS.mac?
    depends_on "linuxbrew/xorg/libxtst"
    depends_on "linuxbrew/xorg/libx11"
    depends_on "linuxbrew/xorg/libxi"
    depends_on "linuxbrew/xorg/libxinerama"
  end

  def install
    # Work around an issue with Xcode 8 on El Capitan, which
    # errors out with `typedef redefinition with different types`
    ENV.delete("SDKROOT") if MacOS.version == :el_capitan && MacOS::Xcode.version >= "8.0"

    system "make", "PREFIX=#{prefix}", "INSTALLMAN=#{man}", "install"
  end

  def caveats
    <<~EOS
      You will probably want to enable XTEST in your X11 server now by running:
        defaults write org.x.X11 enable_test_extensions -boolean true

      For the source of this useful hint:
        https://stackoverflow.com/questions/1264210/does-mac-x11-have-the-xtest-extension
    EOS
  end

  test do
    system "#{bin}/xdotool", "--version"
  end
end
