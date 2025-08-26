class Codemux < Formula
  desc "Terminal multiplexer for AI coding CLIs with enhanced web UI support"
  homepage "https://www.codemux.dev"
  version "0.0.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.0.8/codemux-aarch64-apple-darwin.tar.xz"
      sha256 "a22a35d0b4ac00b03b8307265f88edee17e09f5af055e57c6e4eeee845da0568"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.0.8/codemux-x86_64-apple-darwin.tar.xz"
      sha256 "3fb5c406fce57cde682636bc42e265900e8190043220c8075c78c65447dae446"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.0.8/codemux-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "79fd9d56f1b86223f050daa4cabe58172260d4519c431b5024d153ca14b0a00e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.0.8/codemux-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7bbffc88f9ec933e65bb06aa48b75e0790eee547b68c8db488566bf2116fa707"
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
