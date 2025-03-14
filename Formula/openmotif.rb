class Openmotif < Formula
  desc "LGPL release of the Motif toolkit"
  homepage "https://motif.ics.com/motif"
  url "https://downloads.sourceforge.net/project/motif/Motif%202.3.8%20Source%20Code/motif-2.3.8.tar.gz"
  sha256 "859b723666eeac7df018209d66045c9853b50b4218cecadb794e2359619ebce7"
  license "LGPL-2.1"
  revision 1 unless OS.mac?

  livecheck do
    url :stable
  end

  bottle do
    sha256 "a997ddf37cc71329a09ca6616cbf0ef63bbe1a477a65a94781fdb72d8ec15822" => :catalina
    sha256 "f9eec7b02d0e04b8a41a5c7e3b8c0096c9156100fe888ee663742dca1298f7c5" => :mojave
    sha256 "ca0c7a96b098ed5efc2dace2cb1b9bc2447c8f1cf0780e882bfee691160466e0" => :high_sierra
    sha256 "21120a7b3aab57d5660c480ab5f1924cbfb31e8625674bf02704971f103616f9" => :sierra
    sha256 "bef02966fb2d72ac23235c8038cdf864cefe47d1cb905fac08a9194d7c9ed554" => :el_capitan
    sha256 "dcdc89a25236ac65de5dc6f40572fff24f5feccf65326be73203eba95b6e58da" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on :x11 if OS.mac?

  unless OS.mac?
    depends_on "flex" => :build
    depends_on "linuxbrew/xorg/libsm"
    depends_on "linuxbrew/xorg/libxext"
    depends_on "linuxbrew/xorg/libxft"
    depends_on "linuxbrew/xorg/libxt"
    depends_on "linuxbrew/xorg/xbitmaps"
  end

  conflicts_with "lesstif",
    because: "both Lesstif and Openmotif are complete replacements for each other"

  def install
    unless OS.mac?
      inreplace ["demos/programs/Exm/simple_app/Makefile.am", "demos/programs/Exm/simple_app/Makefile.in"],
        /(LDADD.*\n.*libExm.a)/,
        "\\1 -lX11"
    end
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make"
    system "make", "install"

    # Avoid conflict with Perl
    mv man3/"Core.3", man3/"openmotif-Core.3"
  end

  test do
    assert_match /no source file specified/, pipe_output("#{bin}/uil 2>&1")
  end
end
