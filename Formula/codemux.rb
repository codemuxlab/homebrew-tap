class Codemux < Formula
  desc "Terminal multiplexer for AI coding CLIs with enhanced web UI support"
  homepage "https://www.codemux.dev"
  version "0.0.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.0.10/codemux-aarch64-apple-darwin.tar.xz"
      sha256 "0c7b6da932116593f311a6b1377b598c8e84486edc89aef189f6278f63eada4e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.0.10/codemux-x86_64-apple-darwin.tar.xz"
      sha256 "f288bf9670d0f6bb658db0e170e499a70a2ddc3fd8a39a8b3f3fd2c9af83d886"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.0.10/codemux-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0649be9bfe8ea01489627aba1c2882c94423fee67f8d65aac178de6b91b0e8a1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.0.10/codemux-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d02b43af5889c18a1c2d95903d4bb8e37e80f8a6b4924dc6ddb7e8527e17e936"
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
