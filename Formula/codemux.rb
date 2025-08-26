class Codemux < Formula
  desc "Terminal multiplexer for AI coding CLIs with enhanced web UI support"
  homepage "https://www.codemux.dev"
  version "0.0.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.0.11/codemux-aarch64-apple-darwin.tar.xz"
      sha256 "4e85f7049d41d728bfee7bb848b8df331402492de9ce054d0f5392ae49ff4e50"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.0.11/codemux-x86_64-apple-darwin.tar.xz"
      sha256 "767619884a91f18c28e65513c46ef1bc84417b7069b5805695b7233cec66c6cd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.0.11/codemux-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f54dce33360230c62340473a53c576a1cbdd6104daaa442ca8f3029967319894"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.0.11/codemux-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "812c2d98aeca957f5876c21c36346d1253f58b371f3d5875c62d49b2e4b73212"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
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
