require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.16.1.tgz"
  sha256 "bffe86ded337ba1b6a3cd8a46d7ea4b3806e6fc7567b4e9d1ce3e3d6cca29f29"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b9f346e300fab74edb6d4c51b2eef9be878268fa78316c90596b67ce23ae060e" => :catalina
    sha256 "6d0e419d21758cd5a07f32e13a96c6c462656455681f4b493b53e9d12a53beb7" => :mojave
    sha256 "2dad0be161076e9764e6a9a687d5f3de33c8c15e32ce626e4c065199f4b0c36e" => :high_sierra
    sha256 "a74dbd499c54f8be5d958118530132bf360128fa21ff0cc97039a6a94a5f144c" => :x86_64_linux
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.write_exec_script libexec/"bin/ask"
  end

  test do
    output = shell_output("#{bin}/ask deploy 2>&1", 1)
    assert_match "[Error]: CliFileNotFoundError: File #{testpath}/.ask/cli_config not exists.", output
  end
end
