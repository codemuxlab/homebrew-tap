class Codemux < Formula
  desc "Terminal multiplexer for AI coding CLIs - code from anywhere with mobile-ready UI"
  homepage "https://www.codemux.dev"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.1.8/codemux-aarch64-apple-darwin.tar.xz"
      sha256 "d3e4ac0e3eb614df01e22a74896fa3d98e5abc20ab97edf57822588ceca6cd90"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.1.8/codemux-x86_64-apple-darwin.tar.xz"
      sha256 "c253e579a943812c2194209da474dba21d17f876ff003963267d8383c509cc97"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.1.8/codemux-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9e879533958814cec4b42c1e710046b93fa5bff0ca12c6d2783595f25d51b7bd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/codemuxlab/codemux-cli/releases/download/v0.1.8/codemux-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "13af33cf47d0571dd2accdb8e5080483d0324f661b16694ce68f111f552dce4f"
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
