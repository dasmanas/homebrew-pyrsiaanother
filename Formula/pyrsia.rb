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

  def post_install
    (var/"pyrsia").mkpath
  end

  def caveats
    s = <<~EOS
      We've installed your Pyrsia Node. It should be running as background service.
      To check the service status:
        brew services list
    EOS
    s
  end

  # service do
  #   def envvarhash
  #     return {PATH: std_service_path_env, RUST_LOG: "info,pyrsia=debug"}
  #   end
  #   run [opt_bin/"pyrsia_node"]
  #   keep_alive true
  #   process_type :background
  #   environment_variables envvarhash
  #   log_path var/"pyrsia/logs/stdout/pyrsia_node.log"
  #   error_log_path var/"pyrsia/logs/stderr/pyrsia_node_err.log"
  #   working_dir var/"pyrsia"
  # end

  test do
    (testpath/"pyrsia").mkpath
    (testpath/"tmp").mkpath
    # system bin/"pyrsia_node"
    # port = free_port
    child_pid = fork do
      puts "Child process initiated to run pyrsia_node"
      puts "Child pid: #{Process.pid}, pgid: #{Process.getpgrp}"
      #setsid() creates a new session if the calling process is not a process group leader.
      Process.setsid
      puts "Child new pgid: #{Process.getpgrp}"
      puts "Initiating pyrsia_node..."
      system "#{bin}/pyrsia_node"
    end
    puts "Waiting for pyrsia_node to come up..."
    sleep 30
    assert_match "Connection not Successful !!",
                 shell_output("#{bin}/pyrsia ping")
    pgid = Process.getpgid(child_pid)
    puts "Sending HUP to group #{pgid}..."
    Process.kill('HUP', -pgid)
    Process.detach(pgid)
    puts "Parent: exiting..."
  end
end
