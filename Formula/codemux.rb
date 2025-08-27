class Codemux < Formula
  desc "Terminal multiplexer for AI coding CLIs - code from anywhere with mobile-ready UI"
  homepage "https://www.codemux.dev"
  version "0.0.12"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.0.12/codemux-aarch64-apple-darwin.tar.xz"
      sha256 "1a8c07b4ed472b0e4e26ef326b5ffab11d02cbe2ffc7be3a2ad4d0f93d0f29be"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.0.12/codemux-x86_64-apple-darwin.tar.xz"
      sha256 "b495da3f671f3f3ffc0aa6ed305b9cad539de94550e97700d20a3525d18dbe88"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.0.12/codemux-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ca505c0a804ba8e49e39e5bbdc14231bbd2e9a76be473c8237109076a374bfeb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.0.12/codemux-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "76fc6fa010db9c34cc1fa555e10b41a464b7961a9ec4b4b4c24a5c3bf0d45938"
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
