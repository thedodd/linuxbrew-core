class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      tag:      "1.7.2",
      revision: "a8c04f92e236676977b3ed58132437d9fafc9aed"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "21fd3f8d152c900924f9442ba4c24496b8fe6efcd1be61c8f8002efdf90441f9" => :catalina
    sha256 "7352427b7578b3e7cac3c5726530bd0cf8be78f9034b3e2182aa46153fe3183f" => :mojave
    sha256 "fbf3642fe4aeef5e9e771e74d7fc893ee39b9c327232139b1f8fd5ea4b817e09" => :high_sierra
    sha256 "02c01e33097bb47fb67733ab142e480351465d7af7148d8225284b5ae0b7c701" => :x86_64_linux
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    ENV["TAG"] = version.to_s
    ENV["ISTIO_VERSION"] = version.to_s
    ENV["HUB"] = "docker.io/istio"
    ENV["BUILD_WITH_CONTAINER"] = "0"

    srcpath = buildpath/"src/istio.io/istio"
    outpath = OS.mac? ? srcpath/"out/darwin_amd64" : srcpath/"out/linux_amd64"
    srcpath.install buildpath.children

    cd srcpath do
      system "make", "gen-charts", "istioctl", "istioctl.completion"
      bin.install outpath/"istioctl"
      bash_completion.install outpath/"release/istioctl.bash"
      zsh_completion.install outpath/"release/_istioctl"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/istioctl version --remote=false")
  end
end
