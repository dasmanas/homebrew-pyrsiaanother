class Pyrsia < Formula
  desc "Open source software that helps protect the open source supply chain"
  homepage "https://pyrsia.io/"
  url "https://brewrepo.pyrsia.io/latest/x86_64/pyrsia-0.2.0+2477.tar.gz"
  sha256 "501e5294623d2b1fa781ae3511d682651ced9d713d9831619659148690820fae"
  license "Apache-2.0"
  version "0.2.0"

  def install
    ENV.deparallelize
    bin.install "pyrsia"
    bin.install "pyrsia_node"
  end

  service do
    run [opt_bin/"pyrsia_node"]
    keep_alive true
    process_type :standard
    environment_variables RUST_LOG: "info,pyrsia=debug"
  end

  test do
    system "false"
  end
end
