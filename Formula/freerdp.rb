class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  url "https://github.com/FreeRDP/FreeRDP/archive/2.2.0.tar.gz"
  sha256 "883bc0396c6be9aba6bc07ebc8ff08457125868ada0f06554e62ef072f90cf59"
  license "Apache-2.0"
  revision 1 unless OS.mac?

  bottle do
    sha256 "a2ca3e1a307c549ab620d98fc5e96870017d63dc3d279da5ca56dda76fc38075" => :catalina
    sha256 "67732bc5f1195cd4c959243b02f3f7a3f81c516f97b6f5eda7376cdf2ee73edd" => :mojave
    sha256 "a08c1b8bb532c6c9b9ada2b5ff9f6c2dbfef696abd4ac6e3de4d38e58bd9592a" => :high_sierra
    sha256 "efe3de752e7cde4b862a8e2ab362e5b2835701ef034d74717c872f56320d9169" => :x86_64_linux
  end

  head do
    url "https://github.com/FreeRDP/FreeRDP.git"
    depends_on xcode: :build if OS.mac?
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"
  depends_on "openssl@1.1"
  depends_on :x11 if OS.mac?

  on_linux do
    depends_on "alsa-lib"
    depends_on "ffmpeg"
    depends_on "glib"
  end

  unless OS.mac?
    depends_on "systemd"
    depends_on "linuxbrew/xorg/libx11"
    depends_on "linuxbrew/xorg/libxcursor"
    depends_on "linuxbrew/xorg/libxext"
    depends_on "linuxbrew/xorg/libxinerama"
    depends_on "linuxbrew/xorg/libxv"
    depends_on "linuxbrew/xorg/wayland"
  end

  def install
    cmake_args = std_cmake_args
    cmake_args << "-DWITH_X11=ON" << "-DBUILD_SHARED_LIBS=ON"
    unless OS.mac?
      cmake_args << "-DWITH_CUPS=OFF"
      # cmake_args << "-DWITH_FFMPEG=OFF"
      # cmake_args << "-DWITH_ALSA=OFF"
      # cmake_args << "-DWITH_LIBSYSTEMD=OFF"
    end
    system "cmake", ".", *cmake_args
    system "make", "install"
  end

  test do
    # failed to open display
    return if ENV["CI"]

    success = `#{bin}/xfreerdp --version` # not using system as expected non-zero exit code
    details = $CHILD_STATUS
    raise "Unexpected exit code #{$CHILD_STATUS} while running xfreerdp" if !success && details.exitstatus != 128
  end
end
