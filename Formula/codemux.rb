class Codemux < Formula
  desc "Terminal multiplexer for AI coding CLIs with enhanced web UI support"
  homepage "https://www.codemux.dev"
  version "0.0.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.0.5/codemux-aarch64-apple-darwin.tar.xz"
      sha256 "24876f30e10b0b13e4de9bbc1bb6f6fb14f5f1c95e9c27e2b3bdca7bede3f5e1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.0.5/codemux-x86_64-apple-darwin.tar.xz"
      sha256 "844c7168ab01483a86a5de1c6b95f1cbc46c76a489b684abf4673b429077c208"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.0.5/codemux-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e2d4ebe10956dbc293b95f77083774a9848809cf9a57654a4272f77c896d8b30"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.0.5/codemux-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7b08d0cb339aa2a44699dbe734a8edabd0d3879f5a2212c7f3bda2f6d5c77dba"
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
