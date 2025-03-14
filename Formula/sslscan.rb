class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites"
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/2.0.1.tar.gz"
  sha256 "89208e59a8946f44e6d4e7c7d371ff3fdeb8db1f4c5324e1b42f4abd05ff28cc"
  license "GPL-3.0-or-later"
  head "https://github.com/rbsec/sslscan.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:-rbsec)?$/i)
  end

  bottle do
    cellar :any
    sha256 "b342b9409e3fc40ec23aa6d05ea18fb8629493e5209e33bfb683313156364dc2" => :catalina
    sha256 "e09987d3aa3659f35c263e4b90dd7f9ceb2c2ba340dc63cd50ae824252fae887" => :mojave
    sha256 "d6378f91cc8d47530e7eac7a36fdc276740e192262d4cad8eb72ad1f1e6062ca" => :high_sierra
    sha256 "700926d42044b1fa2e90cd6275d3fbb9f945fb1bd5a3ce0aca7e010db6366a36" => :x86_64_linux
  end

  depends_on "openssl@1.1"

  def install
    # use `libcrypto.dylib`/`libcrypto.a` built from `openssl@1.1`
    libcrypto = OS.mac? ? "libcrypto.dylib" : "libcrypto.a"
    inreplace "Makefile", "static: openssl/libcrypto.a",
                          "static: #{Formula["openssl@1.1"].opt_lib}/#{libcrypto}"

    system "make", "static"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "static", shell_output("#{bin}/sslscan --version")
    system "#{bin}/sslscan", "google.com"
  end
end
