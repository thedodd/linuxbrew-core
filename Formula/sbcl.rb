class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "http://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.0.8/sbcl-2.0.8-source.tar.bz2"
  sha256 "208d46f7b94d256d036f0efc9734e6b34a85c51bb03c3eb8bf39b7a3efe699f7"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]

  livecheck do
    url :stable
  end

  bottle do
    sha256 "bca69d1a79cd05234927371442ae7f86aaecf9ceb2b8f1715eca050d442613d9" => :catalina
    sha256 "08b19761b2023cbfd0f9186f02019ed3307b400d389cf20a6e4379f569e99ce5" => :mojave
    sha256 "b21b05d3ad53d1985f40ee9b8c1222888983cd7dccfbe76258f69e14af43d0c7" => :high_sierra
    sha256 "f8b28942e0ca77b2a69f7cfd64329b0c99a406088cbfcd60162f1615a5ba916a" => :x86_64_linux
  end

  uses_from_macos "zlib"

  # Current binary versions are listed at https://sbcl.sourceforge.io/platform-table.html
  resource "bootstrap64" do
    if OS.mac?
      url "https://downloads.sourceforge.net/project/sbcl/sbcl/1.2.11/sbcl-1.2.11-x86-64-darwin-binary.tar.bz2"
      sha256 "057d3a1c033fb53deee994c0135110636a04f92d2f88919679864214f77d0452"
    elsif OS.linux?
      url "https://downloads.sourceforge.net/project/sbcl/sbcl/1.3.3/sbcl-1.3.3-x86-64-linux-binary.tar.bz2"
      sha256 "e8b1730c42e4a702f9b4437d9842e91cb680b7246f88118c7443d7753e61da65"
    end
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/c5ffdb1118ce0c125c42ab396fa244a7aa01f863/sbcl/patch-make-doc.diff"
    sha256 "7c21c89fd6ec022d4f17670c3253bd33a4ac2784744e4c899c32fbe27203d87e"
  end

  def install
    # Remove non-ASCII values from environment as they cause build failures
    # More information: https://bugs.gentoo.org/show_bug.cgi?id=174702
    ENV.delete_if do |_, value|
      ascii_val = value.dup
      ascii_val.force_encoding("ASCII-8BIT") if ascii_val.respond_to? :force_encoding
      ascii_val =~ /[\x80-\xff]/n
    end

    tmpdir = Pathname.new(Dir.mktmpdir)
    resource("bootstrap64").unpack tmpdir

    command = "#{tmpdir}/src/runtime/sbcl"
    core = "#{tmpdir}/output/sbcl.core"
    xc_cmdline = "#{command} --core #{core} --disable-debugger --no-userinit --no-sysinit"

    args = [
      "--prefix=#{prefix}",
      "--xc-host=#{xc_cmdline}",
      "--with-sb-core-compression",
      "--with-sb-ldb",
      "--with-sb-thread",
    ]

    ENV["SBCL_MACOSX_VERSION_MIN"] = MacOS.version
    system "./make.sh", *args

    ENV["INSTALL_ROOT"] = prefix
    system "sh", "install.sh"

    # Install sources
    bin.env_script_all_files libexec/"bin",
                             SBCL_SOURCE_ROOT: pkgshare/"src",
                             SBCL_HOME:        lib/"sbcl"
    pkgshare.install %w[contrib src]
    (lib/"sbcl/sbclrc").write <<~EOS
      (setf (logical-pathname-translations "SYS")
        '(("SYS:SRC;**;*.*.*" #p"#{pkgshare}/src/**/*.*")
          ("SYS:CONTRIB;**;*.*.*" #p"#{pkgshare}/contrib/**/*.*")))
    EOS
  end

  test do
    (testpath/"simple.sbcl").write <<~EOS
      (write-line (write-to-string (+ 2 2)))
    EOS
    output = shell_output("#{bin}/sbcl --script #{testpath}/simple.sbcl")
    assert_equal "4", output.strip
  end
end
