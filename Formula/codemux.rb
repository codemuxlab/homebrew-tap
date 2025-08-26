class Codemux < Formula
  desc "Terminal multiplexer for AI coding CLIs with enhanced web UI support"
  homepage "https://www.codemux.dev"
  version "0.0.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.0.6/codemux-aarch64-apple-darwin.tar.xz"
      sha256 "a0dfc76feb8bcab7a84fc67f2e43dc505bba81ad5a241f8747bf5ff1e12f426f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.0.6/codemux-x86_64-apple-darwin.tar.xz"
      sha256 "089696df90176bf7b32c56eb28c031910e43ba733c566c0cf0c6994c6198c0fe"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.0.6/codemux-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d462126ea370e85d28e3d104f0b53a25219f7c1b89e7a11355dabae1ed82ea80"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.0.6/codemux-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "07c230367c7f20a9296fc2d443c906c433e9cfff8f909fb2768fc3a7b56a1f92"
    end
  end

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
    bin.install "codemux" if OS.mac? && Hardware::CPU.arm?
    bin.install "codemux" if OS.mac? && Hardware::CPU.intel?
    bin.install "codemux" if OS.linux? && Hardware::CPU.arm?
    bin.install "codemux" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
