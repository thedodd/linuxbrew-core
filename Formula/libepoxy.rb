class Libepoxy < Formula
  desc "Library for handling OpenGL function pointer management"
  homepage "https://github.com/anholt/libepoxy"
  url "https://download.gnome.org/sources/libepoxy/1.5/libepoxy-1.5.4.tar.xz"
  sha256 "0bd2cc681dfeffdef739cb29913f8c3caa47a88a451fd2bc6e606c02997289d2"
  license "MIT"
  revision OS.mac? ? 1 : 3

  # We use a common regex because libepoxy doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libepoxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "9f58a2eab6aafcc95ade6893bde8d878ab422284353e22c11d04c3a6f3a1e7cb" => :catalina
    sha256 "e42a0410e6f94fa419f785c5b0901eea1506242b1729f97b672f25b463ce3d4e" => :mojave
    sha256 "95cbc3ce1fc94931e0259f9e55a25d9dcacacd70713ae3e59cba28f3d7ff2a3a" => :high_sierra
    sha256 "234d5a715ed2154a92c0917b52b78ca53c85addff9ef9bddd186ad72e0ccb2b9" => :x86_64_linux
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  unless OS.mac?
    depends_on "freeglut"
    depends_on "linuxbrew/xorg/xorgproto"
    depends_on "mesa"
  end

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS

      #include <epoxy/gl.h>
      #ifdef OS_MAC
      #include <OpenGL/CGLContext.h>
      #include <OpenGL/CGLTypes.h>
      #endif
      int main()
      {
          #ifdef OS_MAC
          CGLPixelFormatAttribute attribs[] = {0};
          CGLPixelFormatObj pix;
          int npix;
          CGLContextObj ctx;

          CGLChoosePixelFormat( attribs, &pix, &npix );
          CGLCreateContext(pix, (void*)0, &ctx);
          #endif

          glClear(GL_COLOR_BUFFER_BIT);
          #ifdef OS_MAC
          CGLReleasePixelFormat(pix);
          CGLReleaseContext(pix);
          #endif
          return 0;
      }
    EOS
    args = %w[-lepoxy]
    args += %w[-framework OpenGL -DOS_MAC] if OS.mac?
    args += %w[-o test]
    system ENV.cc, "test.c", *args
    system "ls", "-lh", "test"
    system "file", "test"
    system "./test"
  end
end
