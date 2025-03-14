class Fastlane < Formula
  desc "Easiest way to build and release mobile apps"
  homepage "https://fastlane.tools"
  url "https://github.com/fastlane/fastlane/archive/2.161.0.tar.gz"
  sha256 "d37bb7251be5ef85f2c15a4efbf5523de7841fbf0ffa936bbe0388d130c7f855"
  license "MIT"
  head "https://github.com/fastlane/fastlane.git"

  livecheck do
    url :head
    regex(/^([\d.]+)$/i)
  end

  bottle do
    cellar :any
    sha256 "fa9092e388bca3b32807eddcc1c6514e92f3e5e20da966f82bd7670c3e0d42d3" => :catalina
    sha256 "431e169597585884f93781f00c17c64fd779d6ea311602891567236146473c5f" => :mojave
    sha256 "39bdfc80e896775b45617f1b7bb9f209cad91b91a5bb0a3cbeae0ed0080f45cc" => :high_sierra
    sha256 "c6b377bf457a28d357ab15479da5a844c4595581b0950a38a80917c462635218" => :x86_64_linux
  end

  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec

    system "gem", "build", "fastlane.gemspec"
    system "gem", "install", "fastlane-#{version}.gem", "--no-document"

    (bin/"fastlane").write <<~EOS
      #!/bin/bash
      export PATH="#{Formula["ruby"].opt_bin}:#{libexec}/bin:$PATH"
      GEM_HOME="#{libexec}" GEM_PATH="#{libexec}" \\
        exec "#{libexec}/bin/fastlane" "$@"
    EOS
    chmod "+x", bin/"fastlane"
  end

  test do
    assert_match "fastlane #{version}", shell_output("#{bin}/fastlane --version")

    actions_output = shell_output("#{bin}/fastlane actions")
    assert_match "gym", actions_output
    assert_match "pilot", actions_output
    assert_match "screengrab", actions_output
    assert_match "supply", actions_output
  end
end
