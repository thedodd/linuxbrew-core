class PythonYq < Formula
  desc "Command-line YAML and XML processor that wraps jq"
  homepage "https://kislyuk.github.io/yq/"
  url "https://files.pythonhosted.org/packages/50/4b/65a4e82636c21b8ffb96550191b463c6c56b99cc2db3c80f414ff2df5c75/yq-2.11.1.tar.gz"
  sha256 "74f64e3784a34d8a18efd8addc83cf5ca3478a0a69517d70fd9158a3809f99e0"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "14367444c4678afdef3b135fe1cac576c87dfa70b30f15262a38e22692c12d3c" => :catalina
    sha256 "74be260f3b475b0117ddaa1ea78bcc2d29f45cecd6e72e829ba2a19720760ca1" => :mojave
    sha256 "1d99de9b25e693959ee8d30f9181d541a74348b951e6b795899c2b08fdca66d7" => :high_sierra
    sha256 "95d6039deef05d85808028a984ab77c5890ef5b98761e9e3b5de00f97ae9d153" => :x86_64_linux
  end

  depends_on "jq"
  depends_on "python@3.8"

  conflicts_with "yq", because: "both install `yq` executables"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/45/bd/98dfd56ea8f6b2b7dd89bea8b067a55a6dbaec7b4cc28186cbafe2e1d24e/argcomplete-1.12.1.tar.gz"
    sha256 "849c2444c35bb2175aea74100ca5f644c29bf716429399c0f2203bb5d9a8e4e6"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/58/40/0d783e14112e064127063fbf5d1fe1351723e5dfe9d6daad346a305f6c49/xmltodict-0.12.0.tar.gz"
    sha256 "50d8c638ed7ecb88d90561beedbf720c9b4e851a9fa6c47ebd64e99d166d8a21"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV["PYTHONPATH"] = libexec/"lib/python#{xy}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"

    resources.each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    env = {
      PATH:       "#{Formula["jq"].opt_bin}:$PATH",
      PYTHONPATH: ENV["PYTHONPATH"],
    }
    bin.env_script_all_files(libexec/"bin", env)
  end

  test do
    input = <<~EOS
      foo:
       bar: 1
       baz: {bat: 3}
    EOS
    expected = <<~EOS
      3
      ...
    EOS
    assert_equal expected, pipe_output("#{bin}/yq -y .foo.baz.bat", input, 0)
  end
end
