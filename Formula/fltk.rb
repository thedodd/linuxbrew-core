class Fltk < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https://www.fltk.org/"
  url "https://www.fltk.org/pub/fltk/1.3.5/fltk-1.3.5-source.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/fltk-1.3.5.tar.gz"
  sha256 "8729b2a055f38c1636ba20f749de0853384c1d3e9d1a6b8d4d1305143e115702"
  revision 2 unless OS.mac?

  livecheck do
    url "https://www.fltk.org/software.php"
    regex(/href=.*?fltk[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)-source\.t/i)
  end

  bottle do
    sha256 "d0ff3728a8da506e399b094b0e2a94ffef5a32805308d73fd2fb5fd0e402c88b" => :catalina
    sha256 "3ea6ccc2fec9151f3ed0f20761794b9fe0477d168dbc4e83ba88b3f3d16c530b" => :mojave
    sha256 "6edac0b91f19783376ec95c84819405a6f029d7d2bf8ac636d421682fc064e34" => :high_sierra
    sha256 "e2bd28a348c8fbf948f2400d3df29ba786a2ca9cc3f87b3727477fb49ebf57f0" => :sierra
    sha256 "2c4fe039448868af45be93f3da222fb3b16e2f884dbd4e6d2b1d7afc7730db75" => :x86_64_linux
  end

  depends_on "jpeg"
  depends_on "libpng"

  unless OS.mac?
    depends_on "pkg-config" => :build
    depends_on "linuxbrew/xorg/glu"
    depends_on "linuxbrew/xorg/libx11"
    depends_on "linuxbrew/xorg/libxext"
    depends_on "linuxbrew/xorg/libxft"
    depends_on "linuxbrew/xorg/libxt"
    depends_on "mesa"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-threads",
                          "--enable-shared"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <FL/Fl.H>
      #include <FL/Fl_Window.H>
      #include <FL/Fl_Box.H>
      int main(int argc, char **argv) {
        Fl_Window *window = new Fl_Window(340,180);
        Fl_Box *box = new Fl_Box(20,40,300,100,"Hello, World!");
        box->box(FL_UP_BOX);
        box->labelfont(FL_BOLD+FL_ITALIC);
        box->labelsize(36);
        box->labeltype(FL_SHADOW_LABEL);
        window->end();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lfltk", "-o", "test"
    system "./test"
  end
end
