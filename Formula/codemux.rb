class Codemux < Formula
  desc "Terminal multiplexer for AI coding CLIs - code from anywhere with mobile-ready UI"
  homepage "https://www.codemux.dev"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.1.2/codemux-aarch64-apple-darwin.tar.xz"
      sha256 "85c93c9768f7537d953440c1d9eb28e448e066edc4c15f5891b614daa13f9aaa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.1.2/codemux-x86_64-apple-darwin.tar.xz"
      sha256 "46d0a0fc30945566d79bce107b053881ead3797687cc87df2e7cb4a3cc1efae2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.1.2/codemux-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e22f9b8b5eb4e02a943d0f5d095f62840a9b9c6a3214aa164ee9c36e17d693c0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.1.2/codemux-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5c74b816b800c592a2feeafef86dbba13dfbc9c1ab37fbd0df15219c06f627ff"
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
