class NodeAT12 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v12.18.4/node-v12.18.4.tar.gz"
  sha256 "a802d87e579e46fc52771ed6f2667048320caca867be3276f4c4f1bbb41389c3"
  license "MIT"

  livecheck do
    url "https://nodejs.org/dist/"
    regex(%r{href=["']?v?(12(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "bff8247e2bc542eeea8292f38f169a2277c86fdab051402ee2ffc1dec51aa3d3" => :catalina
    sha256 "50a6fb5d4272d712924f16e339d7dfd4207cef99cc7f42b2e460a5865cb0dc8c" => :mojave
    sha256 "da4afa24c8986fa465994097b44893ac80172ae83ae2aebb8ec327100cf35b10" => :high_sierra
    sha256 "870457dca965548d8e4fc1b022956bc83c632df62d5d664d862fcb15dab003aa" => :x86_64_linux
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "python@3.8" => :build
  depends_on "icu4c"

  def install
    # make sure subprocesses spawned by make are using our Python 3
    ENV["PYTHON"] = Formula["python@3.8"].opt_bin/"python3"

    system "python3", "configure.py", "--prefix=#{prefix}", "--with-intl=system-icu"
    system "make", "install"
  end

  def post_install
    (lib/"node_modules/npm/npmrc").atomic_write("prefix = #{HOMEBREW_PREFIX}\n")
  end

  test do
    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = shell_output("#{bin}/node #{path}").strip
    assert_equal "hello", output
    output = shell_output("#{bin}/node -e 'console.log(new Intl.NumberFormat(\"en-EN\").format(1234.56))'").strip
    assert_equal "1,234.56", output

    output = shell_output("#{bin}/node -e 'console.log(new Intl.NumberFormat(\"de-DE\").format(1234.56))'").strip
    assert_equal "1.234,56", output

    # make sure npm can find node
    ENV.prepend_path "PATH", opt_bin
    ENV.delete "NVM_NODEJS_ORG_MIRROR"
    assert_equal which("node"), opt_bin/"node"
    assert_predicate bin/"npm", :exist?, "npm must exist"
    assert_predicate bin/"npm", :executable?, "npm must be executable"
    npm_args = ["-ddd", "--cache=#{HOMEBREW_CACHE}/npm_cache", "--build-from-source"]
    system "#{bin}/npm", *npm_args, "install", ("--unsafe-perm" if Process.uid.zero?), "npm@latest"
    unless head?
      system "#{bin}/npm", *npm_args, "install", ("--unsafe-perm" if Process.uid.zero?), "bufferutil"
    end
    assert_predicate bin/"npx", :exist?, "npx must exist"
    assert_predicate bin/"npx", :executable?, "npx must be executable"
    assert_match "< hello >", shell_output("#{bin}/npx cowsay hello")
  end
end
