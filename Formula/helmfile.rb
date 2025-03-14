class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.130.0.tar.gz"
  sha256 "233b82ed7670caa08c8056f27f972d1bc389c319b551c2ab5d12241284cf502b"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "82120effc1bfdea6b622a8e180b0f0a04c5ae0e1e58c0000c2f81355c91d7867" => :catalina
    sha256 "78b5a2625da5d5b4500dbb5340b3238970e403868790841d25bc1550a5d43bba" => :mojave
    sha256 "276f546aff1a051e43e8151727b1bdea2906008d216cd05cbc31bac0eea52354" => :high_sierra
    sha256 "b91b1cabf7c6deb5b783752dd84d3a5ee0deb1fbb7f8e5620b67ab74b382fa29" => :x86_64_linux
  end

  depends_on "go" => :build
  depends_on "helm"

  def install
    system "go", "build", "-ldflags", "-X github.com/roboll/helmfile/pkg/app/version.Version=v#{version}",
             "-o", bin/"helmfile", "-v", "github.com/roboll/helmfile"
  end

  test do
    (testpath/"helmfile.yaml").write <<-EOS
    repositories:
    - name: stable
      url: https://kubernetes-charts.storage.googleapis.com

    releases:
    - name: vault                            # name of this release
      namespace: vault                       # target namespace
      createNamespace: true                  # helm 3.2+ automatically create release namespace (default true)
      labels:                                # Arbitrary key value pairs for filtering releases
        foo: bar
      chart: stable/vault                    # the chart being installed to create this release, referenced by `repository/chart` syntax
      version: ~1.24.1                       # the semver of the chart. range constraint is supported
    EOS
    system Formula["helm"].opt_bin/"helm", "create", "foo"
    output = "Adding repo stable https://kubernetes-charts.storage.googleapis.com"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end
