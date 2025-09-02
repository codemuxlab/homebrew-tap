class Codemux < Formula
  desc "Terminal multiplexer for AI coding CLIs - code from anywhere with mobile-ready UI"
  homepage "https://www.codemux.dev"
  version "0.1.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.1.9/codemux-aarch64-apple-darwin.tar.xz"
      sha256 "541dedb494b1d8c70edaa9294ec171f813303f59eba80dbbf3d7ae87229e01f7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.1.9/codemux-x86_64-apple-darwin.tar.xz"
      sha256 "8b0d61727b0b2fbd7b9d453c0c5773fc920b8e5da022d11f1a24942f7672666a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.1.9/codemux-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6b8e6c758f78363b99e009c68fd8b06aad0ca6a8916457b6d977a926b76ca4ca"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.1.9/codemux-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "353cf43659802fe28588f862ee4add827bd15e5aff0e8e962aaf55b9ff9f71aa"
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
