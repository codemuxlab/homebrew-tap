class Codemux < Formula
  desc "Terminal multiplexer for AI coding CLIs - code from anywhere with mobile-ready UI"
  homepage "https://www.codemux.dev"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.1.3/codemux-aarch64-apple-darwin.tar.xz"
      sha256 "c3751579e16b6251e2606601f0fce7d3b37e32322222b72d0688b12089431e3a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.1.3/codemux-x86_64-apple-darwin.tar.xz"
      sha256 "41f1bc900f62f52b51b7b02201182fe9481ecf8eacafab935aa45dfeaba672cc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.1.3/codemux-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d47af1114638cf8c1cb54062dfc98d00b56b42ce41dfe3be7c5e1aae3165eb92"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.1.3/codemux-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b54c4383dc6e95fa8a88a987050ef53f2c7f6d24eee9d9260166b36509514836"
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
