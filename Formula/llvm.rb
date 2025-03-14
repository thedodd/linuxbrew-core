require "os/linux/glibc"

class Llvm < Formula
  desc "Next-gen compiler infrastructure"
  homepage "https://llvm.org/"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  revision 1

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.1/llvm-10.0.1.src.tar.xz"
    sha256 "c5d8e30b57cbded7128d78e5e8dad811bff97a8d471896812f57fa99ee82cdf3"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.1/clang-10.0.1.src.tar.xz"
      sha256 "f99afc382b88e622c689b6d96cadfa6241ef55dca90e87fc170352e12ddb2b24"

      unless OS.mac?
        patch do
          url "https://gist.githubusercontent.com/iMichka/9ac8e228679a85210e11e59d029217c1/raw/e50e47df860201589e6f43e9f8e9a4fc8d8a972b/clang9?full_index=1"
          sha256 "65cf0dd9fdce510e74648e5c230de3e253492b8f6793a89534becdb13e488d0c"
        end
      end

      patch :p1 do
        url "https://raw.githubusercontent.com/Homebrew/formula-patches/c7da61787c62822804dd90192dd9dd254511192c/llvm/10.0.1-clang.diff"
        sha256 "44a605f614a26fb20d127b041e2a87e6adc9b8332e07cbbb6b457bc391cda660"
      end
    end

    resource "clang-tools-extra" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.1/clang-tools-extra-10.0.1.src.tar.xz"
      sha256 "d093782bcfcd0c3f496b67a5c2c997ab4b85816b62a7dd5b27026634ccf5c11a"
    end

    resource "compiler-rt" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.1/compiler-rt-10.0.1.src.tar.xz"
      sha256 "d90dc8e121ca0271f0fd3d639d135bfaa4b6ed41e67bd6eb77808f72629658fa"

      patch :p1 do
        url "https://raw.githubusercontent.com/Homebrew/formula-patches/c7da61787c62822804dd90192dd9dd254511192c/llvm/10.0.1-compiiler-rt.diff"
        sha256 "8ad0ce521b010dfb941c0979c1c072a2b40e4a69424374541d28122ba74ce4a0"
      end
    end

    if OS.mac?
      resource "libcxx" do
        url "https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.1/libcxx-10.0.1.src.tar.xz"
        sha256 "def674535f22f83131353b3c382ccebfef4ba6a35c488bdb76f10b68b25be86c"
      end
    end

    resource "libunwind" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.1/libunwind-10.0.1.src.tar.xz"
      sha256 "741903ec1ebff2253ff19d803629d88dc7612598758b6e48bea2da168de95e27"
    end

    resource "lld" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.1/lld-10.0.1.src.tar.xz"
      sha256 "591449e0aa623a6318d5ce2371860401653c48bb540982ccdd933992cb88df7a"

      patch :p1 do
        url "https://raw.githubusercontent.com/Homebrew/formula-patches/c7da61787c62822804dd90192dd9dd254511192c/llvm/10.0.1-lld.diff"
        sha256 "734f87580e89d76507b8c41a5a75b5105c41a2d03a8dc2fad5c7ef027d771a3e"
      end
    end

    resource "lldb" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.1/lldb-10.0.1.src.tar.xz"
      sha256 "07abe87c25876aa306e73127330f5f37d270b6b082d50cc679e31b4fc02a3714"

      patch :p1 do
        url "https://raw.githubusercontent.com/Homebrew/formula-patches/c7da61787c62822804dd90192dd9dd254511192c/llvm/10.0.1-lldb.diff"
        sha256 "69c7d4c803a174dff6809d02255e7e4c19d80f25c73dd5fcf2657769db158e25"
      end
    end

    resource "openmp" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.1/openmp-10.0.1.src.tar.xz"
      sha256 "d19f728c8e04fb1e94566c8d76aef50ec926cd2f95ef3bf1e0a5de4909b28b44"
    end

    resource "polly" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.1/polly-10.0.1.src.tar.xz"
      sha256 "d2fb0bb86b21db1f52402ba231da7c119c35c21dfb843c9496fe901f2d6aa25a"
    end
  end

  unless OS.mac?
    patch :p2 do
      url "https://github.com/llvm/llvm-project/commit/7f5fe30a150e7e87d3fbe4da4ab0e76ec38b40b9.patch?full_index=1"
      sha256 "9ed85d2b00d0b70c628a5d1256d87808d944532fe8c592516577a4f8906a042c"
    end

    # Needed for crystal
    patch :p2, :DATA
  end

  livecheck do
    url :homepage
    regex(/LLVM (\d+.\d+.\d+)/i)
  end

  bottle do
    cellar :any
    sha256 "8aef26f7e303ee40df830fa1ca7df5cd51c8ce1260a6b871277f6f0e8b80103b" => :catalina
    sha256 "5ad96fe536c054535aa9fb1c80db7d4468b6959cd903a20a7d81e25e470c8af1" => :mojave
    sha256 "bf6e80f0e3e31a13245aadaa76064b16d2f55e2ffed5decc551be50638218777" => :high_sierra
    sha256 "f335abb51d6248d26a5f96adb947181a1eddbb5edb1e37b63fcab6c4e578c155" => :x86_64_linux
  end

  # Clang cannot find system headers if Xcode CLT is not installed
  pour_bottle? do
    reason "The bottle needs the Xcode CLT to be installed."
    satisfy { !OS.mac? || MacOS::CLT.installed? }
  end

  head do
    url "https://github.com/llvm/llvm-project.git"

    unless OS.mac?
      patch do
        url "https://gist.githubusercontent.com/iMichka/9ac8e228679a85210e11e59d029217c1/raw/e50e47df860201589e6f43e9f8e9a4fc8d8a972b/clang9?full_index=1"
        sha256 "65cf0dd9fdce510e74648e5c230de3e253492b8f6793a89534becdb13e488d0c"
        directory "clang"
      end
    end
  end

  keg_only :provided_by_macos

  # https://llvm.org/docs/GettingStarted.html#requirement
  # We intentionally use Make instead of Ninja.
  # See: Homebrew/homebrew-core/issues/35513
  depends_on "cmake" => :build
  depends_on "python@3.8" => :build
  depends_on "libffi"

  uses_from_macos "libedit"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  unless OS.mac?
    depends_on "pkg-config" => :build
    depends_on "gcc" # needed for libstdc++
    if Formula["glibc"].any_version_installed? || OS::Linux::Glibc.system_version < Formula["glibc"].version
      depends_on "glibc"
    end
    depends_on "binutils" # needed for gold and strip
    depends_on "libelf" # openmp requires <gelf.h>

    conflicts_with "clang-format", because: "both install `clang-format` binaries"
  end

  patch :p1 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/c7da61787c62822804dd90192dd9dd254511192c/llvm/10.0.1-llvm.diff"
    sha256 "86b4e2bf10dfb9a04153e3d4fc744c3f323f3e13fc7b3a7d22e6791d47eb2e2c"
  end

  def install
    projects = %w[
      clang
      clang-tools-extra
      lld
      lldb
      polly
    ]
    # OpenMP currently fails to build on ARM
    # https://github.com/Homebrew/brew/issues/7857#issuecomment-661484670
    projects << "openmp" unless Hardware::CPU.arm?
    runtimes = %w[
      compiler-rt
      libunwind
    ]
    args << "libcxx" if OS.mac?
    # Can likely be added to the base runtimes array when 11.0.0 is released.
    runtimes << "libcxxabi" if build.head?

    llvmpath = buildpath/"llvm"
    unless build.head?
      llvmpath.install buildpath.children - [buildpath/".brew_home"]
      (projects + runtimes).each { |p| resource(p).stage(buildpath/p) }
    end

    py_ver = "3.8"

    # Apple's libstdc++ is too old to build LLVM
    ENV.libcxx if ENV.compiler == :clang

    # compiler-rt has some iOS simulator features that require i386 symbols
    # I'm assuming the rest of clang needs support too for 32-bit compilation
    # to work correctly, but if not, perhaps universal binaries could be
    # limited to compiler-rt. llvm makes this somewhat easier because compiler-rt
    # can almost be treated as an entirely different build from llvm.
    ENV.permit_arch_flags

    unless OS.mac?
      # see https://llvm.org/docs/HowToCrossCompileBuiltinsOnArm.html#the-cmake-try-compile-stage-fails
      # Basically, the stage1 clang will try to locate a gcc toolchain and often
      # get the default from /usr/local, which might contains an old version of
      # gcc that can't build compiler-rt. This fixes the problem and, unlike
      # setting the main project's cmake option -DGCC_INSTALL_PREFIX, avoid
      # hardcoding the gcc path into the binary
      inreplace "compiler-rt/CMakeLists.txt", /(cmake_minimum_required.*\n)/,
        "\\1add_compile_options(\"--gcc-toolchain=#{Formula["gcc"].opt_prefix}\")"
    end

    args = %W[
      -DLLVM_ENABLE_PROJECTS=#{projects.join(";")}
      -DLLVM_ENABLE_RUNTIMES=#{runtimes.join(";")}
      -DLLVM_POLLY_LINK_INTO_TOOLS=ON
      -DLLVM_BUILD_EXTERNAL_COMPILER_RT=ON
      -DLLVM_LINK_LLVM_DYLIB=ON
      -DLLVM_ENABLE_EH=ON
      -DLLVM_ENABLE_FFI=ON
      -DLLVM_ENABLE_RTTI=ON
      -DLLVM_INCLUDE_DOCS=OFF
      -DLLVM_INCLUDE_TESTS=OFF
      -DLLVM_INSTALL_UTILS=ON
      -DLLVM_ENABLE_Z3_SOLVER=OFF
      -DLLVM_OPTIMIZED_TABLEGEN=ON
      -DLLVM_TARGETS_TO_BUILD=all
      -DFFI_INCLUDE_DIR=#{Formula["libffi"].opt_lib}/libffi-#{Formula["libffi"].version}/include
      -DFFI_LIBRARY_DIR=#{Formula["libffi"].opt_lib}
      -DLLDB_USE_SYSTEM_DEBUGSERVER=ON
      -DLLDB_ENABLE_PYTHON=OFF
      -DLLDB_ENABLE_LUA=OFF
      -DLLDB_ENABLE_LZMA=OFF
      -DLIBOMP_INSTALL_ALIASES=OFF
      -DCLANG_PYTHON_BINDINGS_VERSIONS=#{py_ver}
    ]
    if OS.mac?
      args << "-DLLVM_BUILD_LLVM_C_DYLIB=ON"
      args << "-DLLVM_ENABLE_LIBCXX=ON"
      args << "-DLLVM_CREATE_XCODE_TOOLCHAIN=#{MacOS::Xcode.installed? ? "ON" : "OFF"}"
    else
      args << "-DLLVM_BUILD_LLVM_C_DYLIB=OFF"
      args << "-DLLVM_ENABLE_LIBCXX=OFF"
      args << "-DLLVM_CREATE_XCODE_TOOLCHAIN=OFF"
      args << "-DCLANG_DEFAULT_CXX_STDLIB=libstdc++"
    end

    sdk = MacOS.sdk_path_if_needed
    args << "-DDEFAULT_SYSROOT=#{sdk}" if sdk

    # Enable llvm gold plugin for LTO
    args << "-DLLVM_BINUTILS_INCDIR=#{Formula["binutils"].opt_include}" unless OS.mac?

    if OS.mac? & MacOS.version == :mojave && MacOS::CLT.installed?
      # Mojave CLT linker via software update is older than Xcode.
      # Use it to retain compatibility.
      args << "-DCMAKE_LINKER=/Library/Developer/CommandLineTools/usr/bin/ld"
    end

    mkdir llvmpath/"build" do
      system "cmake", "-G", "Unix Makefiles", "..", *(std_cmake_args + args)
      system "make"
      system "make", "install"
      system "make", "install-xcode-toolchain" if OS.mac? && MacOS::Xcode.installed?
    end

    unless OS.mac?
      # Strip executables/libraries/object files to reduce their size
      system("strip", "--strip-unneeded", "--preserve-dates", *(Dir[bin/"**/*", lib/"**/*"]).select do |f|
        f = Pathname.new(f)
        f.file? && (f.elf? || f.extname == ".a")
      end)
    end

    # Install LLVM Python bindings
    # Clang Python bindings are installed by CMake
    (lib/"python#{py_ver}/site-packages").install llvmpath/"bindings/python/llvm"

    # Install Emacs modes
    elisp.install Dir[llvmpath/"utils/emacs/*.el"] + Dir[share/"clang/*.el"]
  end

  def caveats
    <<~EOS
      To use the bundled libc++ please add the following LDFLAGS:
        LDFLAGS="-L#{opt_lib} -Wl,-rpath,#{opt_lib}"
    EOS
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/llvm-config --prefix").chomp

    (testpath/"omptest.c").write <<~EOS
      #include <stdlib.h>
      #include <stdio.h>
      #include <omp.h>
      int main() {
          #pragma omp parallel num_threads(4)
          {
            printf("Hello from thread %d, nthreads %d\\n", omp_get_thread_num(), omp_get_num_threads());
          }
          return EXIT_SUCCESS;
      }
    EOS

    clean_version = version.to_s[/(\d+\.?)+/]

    system "#{bin}/clang", "-L#{lib}", "-fopenmp", "-nobuiltininc",
                           "-I#{lib}/clang/#{clean_version}/include",
                           "omptest.c", "-o", "omptest", *ENV["LDFLAGS"].split
    testresult = shell_output("./omptest")

    sorted_testresult = testresult.split("\n").sort.join("\n")
    expected_result = <<~EOS
      Hello from thread 0, nthreads 4
      Hello from thread 1, nthreads 4
      Hello from thread 2, nthreads 4
      Hello from thread 3, nthreads 4
    EOS
    assert_equal expected_result.strip, sorted_testresult.strip

    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main()
      {
        printf("Hello World!\\n");
        return 0;
      }
    EOS

    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      int main()
      {
        std::cout << "Hello World!" << std::endl;
        return 0;
      }
    EOS

    unless OS.mac?
      system "#{bin}/clang++", "-v", "test.cpp", "-o", "test"
      assert_equal "Hello World!", shell_output("./test").chomp
    end

    # Testing Command Line Tools
    if OS.mac? && MacOS::CLT.installed?
      libclangclt = Dir[
        "/Library/Developer/CommandLineTools/usr/lib/clang/#{MacOS::CLT.version.to_i}*"
      ].last { |f| File.directory? f }

      system "#{bin}/clang++", "-v", "-nostdinc",
              "-I/Library/Developer/CommandLineTools/usr/include/c++/v1",
              "-I#{libclangclt}/include",
              "-I/usr/include",
              # need it because /Library/.../usr/include/c++/v1/iosfwd refers to <wchar.h>,
              # which CLT installs to /usr/include
              "test.cpp", "-o", "testCLT++"
      # Testing default toolchain and SDK location.
      system "#{bin}/clang++", "-v",
             "-std=c++11", "test.cpp", "-o", "test++"
      assert_includes MachO::Tools.dylibs("test++"), "/usr/lib/libc++.1.dylib"
      assert_equal "Hello World!", shell_output("./test++").chomp
      system "#{bin}/clang", "-v", "test.c", "-o", "test"
      assert_equal "Hello World!", shell_output("./test").chomp

      toolchain_path = "/Library/Developer/CommandLineTools"
      system "#{bin}/clang++", "-v",
             "-isysroot", MacOS::CLT.sdk_path,
             "-isystem", "#{toolchain_path}/usr/include/c++/v1",
             "-isystem", "#{toolchain_path}/usr/include",
             "-isystem", "#{MacOS::CLT.sdk_path}/usr/include",
             "-std=c++11", "test.cpp", "-o", "testCLT++"
      assert_includes MachO::Tools.dylibs("testCLT++"), "/usr/lib/libc++.1.dylib"
      assert_equal "Hello World!", shell_output("./testCLT++").chomp
      system "#{bin}/clang", "-v", "test.c", "-o", "testCLT"
      assert_equal "Hello World!", shell_output("./testCLT").chomp
    end

    # Testing Xcode
    if OS.mac? && MacOS::Xcode.installed?
      system "#{bin}/clang++", "-v",
             "-isysroot", MacOS::Xcode.sdk_path,
             "-isystem", "#{MacOS::Xcode.toolchain_path}/usr/include/c++/v1",
             "-isystem", "#{MacOS::Xcode.toolchain_path}/usr/include",
             "-isystem", "#{MacOS::Xcode.sdk_path}/usr/include",
             "-std=c++11", "test.cpp", "-o", "testXC++"
      assert_includes MachO::Tools.dylibs("testXC++"), "/usr/lib/libc++.1.dylib"
      assert_equal "Hello World!", shell_output("./testXC++").chomp
      system "#{bin}/clang", "-v",
             "-isysroot", MacOS.sdk_path,
             "test.c", "-o", "testXC"
      assert_equal "Hello World!", shell_output("./testXC").chomp
    end

    # link against installed libc++
    # related to https://github.com/Homebrew/legacy-homebrew/issues/47149
    if OS.mac?
      system "#{bin}/clang++", "-v",
             "-isystem", "#{opt_include}/c++/v1",
             "-std=c++11", "-stdlib=libc++", "test.cpp", "-o", "testlibc++",
             "-L#{opt_lib}", "-Wl,-rpath,#{opt_lib}"
      assert_includes MachO::Tools.dylibs("testlibc++"), "#{opt_lib}/libc++.1.dylib"
      assert_equal "Hello World!", shell_output("./testlibc++").chomp

      (testpath/"scanbuildtest.cpp").write <<~EOS
        #include <iostream>
        int main() {
          int *i = new int;
          *i = 1;
          delete i;
          std::cout << *i << std::endl;
          return 0;
        }
      EOS
      assert_includes shell_output("#{bin}/scan-build clang++ scanbuildtest.cpp 2>&1"),
        "warning: Use of memory after it is freed"

      (testpath/"clangformattest.c").write <<~EOS
        int    main() {
            printf("Hello world!"); }
      EOS
      assert_equal "int main() { printf(\"Hello world!\"); }\n",
      shell_output("#{bin}/clang-format -style=google clangformattest.c")
    end
  end
end
__END__
diff --git a/llvm/include/llvm/BinaryFormat/Dwarf.h b/llvm/include/llvm/BinaryFormat/Dwarf.h
index 2ad201831..8bb9c6bed 100644
--- a/llvm/include/llvm/BinaryFormat/Dwarf.h
+++ b/llvm/include/llvm/BinaryFormat/Dwarf.h
@@ -232,6 +232,8 @@ inline bool isCPlusPlus(SourceLanguage S) {
   case DW_LANG_hi_user:
     return false;
   }
+  if (S >= DW_LANG_lo_user && S <= DW_LANG_hi_user)
+    return false;
   llvm_unreachable("Invalid source language");
 }
 
