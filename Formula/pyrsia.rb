class Pyrsia < Formula
  desc "Open source software that helps protect the open source supply chain"
  homepage "https://pyrsia.io/"
  url "https://brewrepo.pyrsia.io/pyrsia-0.2.0.tar.gz"
  sha256 "fb90ba908ec0b635a02eaf5ec9edeb42c6aac68df32c081219f8c2fa50f6e51a"
  license "Apache-2.0"
  version "0.2.0"

  def install
    bin.install "pyrsia"
    # bin.install "pyrsia_node"
  end

  test do
    system "false"
  end
end
