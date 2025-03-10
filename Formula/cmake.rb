class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.18.3/cmake-3.18.3.tar.gz"
  sha256 "2c89f4e30af4914fd6fb5d00f863629812ada848eee4e2d29ec7e456d7fa32e5"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git"

  livecheck do
    url "https://cmake.org/download/"
    regex(/Latest Release \(v?(\d+(?:\.\d+)+)\)/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "2cc57360f3dc4889657e15ad7bd72187ac6a987de6582e92188897019975eee4" => :catalina
    sha256 "d021c273c99401bd4ae0a20f190f43887047d6170b1cf0586a7a28638d342d8c" => :mojave
    sha256 "0cc394f863fc73d0a93b134423ce8618be6dd30aab34f901af8fa56ec240115f" => :high_sierra
    sha256 "36a785b65abfa62bc94d5d560528d37a156fc40793a6af10d2e45f2570a62b79" => :x86_64_linux
  end

  depends_on "sphinx-doc" => :build
  depends_on "ncurses"

  on_linux do
    depends_on "openssl@1.1"
  end

  # The completions were removed because of problems with system bash

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use `brew cask install cmake`.

  def install
    ENV.cxx11 unless OS.mac?

    args = %W[
      --prefix=#{prefix}
      --no-system-libs
      --parallel=#{ENV.make_jobs}
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man
      --sphinx-build=#{Formula["sphinx-doc"].opt_bin}/sphinx-build
      --sphinx-html
      --sphinx-man
      --system-zlib
      --system-bzip2
      --system-curl
    ]
    args -= ["--system-zlib", "--system-bzip2", "--system-curl"] unless OS.mac?

    system "./bootstrap", *args, "--", *std_cmake_args,
                                       "-DCMake_INSTALL_EMACS_DIR=#{elisp}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."
  end
end
