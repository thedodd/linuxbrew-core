class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.9.0.tar.gz"
  sha256 "3811ee7baf8d652feb38db4199a8d6c5dd6668e8ed883768e1431c515a755a2f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "3ea2494b6636f8e3d10040bf9bce0a829d29c3ab72ee6ef76599b79a06aed6d8" => :catalina
    sha256 "a67c24abd7dc8ab084243be2cd7068e041db2a45ffd1944dbcf9de0a9c8427e1" => :mojave
    sha256 "7be71a1cc69e61fd5a9716b7915dcc829b11ff93d8e4cc916d36e15876c01b98" => :high_sierra
    sha256 "42573a049a074435835766e18d803313f3e5643f1ded80fa8aedc6192d917921" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", "-o", "#{bin}/#{name}", "-trimpath", "-ldflags", ldflags, "-tags", tags
  end

  test do
    touch "test.rb"
    system "echo | okteto init --overwrite --file test.yml"
    expected = <<~EOS
      name: #{Pathname.getwd.basename}
      image: okteto/ruby:2
      command:
      - bash
      sync:
      - .:/usr/src/app
      forward:
      - 1234:1234
      - 8080:8080
      persistentVolume: {}
    EOS
    got = File.read("test.yml")
    assert_equal expected, got
  end
end
