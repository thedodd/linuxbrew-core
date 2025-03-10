class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli/archive/v3.0.59.tar.gz"
  sha256 "4126f155d02405980b476996eee2ae28711a604d32072ec40f22dafa63649174"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "fdf4fc9384c967e663eb24bb51ab692c227f13a1d8cb58d17864175999c950ed" => :catalina
    sha256 "ccd3a5fb239c8e8a74b422c56b63871e25b24f5ba42f076dac9c773fa88ed10b" => :mojave
    sha256 "5730ce8b6987ef0b4d5349a2c6bed20ae4e19e34dd71af4d063f877e0e9b9d83" => :high_sierra
    sha256 "05510ef67c673a0858af9680ba7f7da328128fa7762993f84a753261f721bcd5" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "off"
    ENV["GOPATH"] = buildpath
    ENV["PATH"] = "#{ENV["PATH"]}:#{buildpath}/bin"
    (buildpath/"src/github.com/aliyun/aliyun-cli").install buildpath.children
    cd "src/github.com/aliyun/aliyun-cli" do
      system "make", "metas"
      system "go", "build", "-o", bin/"aliyun", "-ldflags",
                            "-X 'github.com/aliyun/aliyun-cli/cli.Version=#{version}'", "main/main.go"
    end
  end

  test do
    version_out = shell_output("#{bin}/aliyun version")
    assert_match version.to_s, version_out

    help_out = shell_output("#{bin}/aliyun --help")
    assert_match "Alibaba Cloud Command Line Interface Version #{version}", help_out
    assert_match "", help_out
    assert_match "Usage:", help_out
    assert_match "aliyun <product> <operation> [--parameter1 value1 --parameter2 value2 ...]", help_out

    oss_out = shell_output("#{bin}/aliyun oss")
    assert_match "Object Storage Service", oss_out
    assert_match "aliyun oss [command] [args...] [options...]", oss_out
  end
end
