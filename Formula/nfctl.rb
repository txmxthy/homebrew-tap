class Nfctl < Formula
  desc "Command-line interface and terminal UI for operating Numaflow pipelines"
  homepage "https://github.com/txmxthy/nfctl"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/txmxthy/nfctl/releases/download/v0.1.0/nfctl-cli-aarch64-apple-darwin.tar.xz"
      sha256 "2550f9fcd12a48aa20bbff623d0304e60a9d6b49a973990f337270b74bebe50c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txmxthy/nfctl/releases/download/v0.1.0/nfctl-cli-x86_64-apple-darwin.tar.xz"
      sha256 "227a9af79251e1af2c51a877bd5f9ec29036b0d0c8068cbd5397fe5172216c14"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/txmxthy/nfctl/releases/download/v0.1.0/nfctl-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bc550133b103b49a39381f0b4b18ab370d0ec24182d50b1ee32ad2258e36841a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txmxthy/nfctl/releases/download/v0.1.0/nfctl-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "32f58fe3c8138828c51eaff56c6c2fa5ebe2c90ec7e9ae3660b0581e4d444753"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "nfctl"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "nfctl"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "nfctl"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "nfctl"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nfctl --version")
  end
end
