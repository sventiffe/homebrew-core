class Liqoctl < Formula
  desc "Is a CLI tool to install and manage Liqo-enabled clusters"
  homepage "https://liqo.io"
  url "https://github.com/liqotech/liqo/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "d53935cc0f82d7562adabdb60614ffdb76bc944cab5d2df087e1046379e1f63f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e0f7708120b4b770539bda049b723e20876e1015fdc306c7fb41897f8338daf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e0f7708120b4b770539bda049b723e20876e1015fdc306c7fb41897f8338daf"
    sha256 cellar: :any_skip_relocation, monterey:       "261e57d2b6d4c0b5829d4a8c2e49090efa2a5930d4aa6a28aa6d3b9aa389fa44"
    sha256 cellar: :any_skip_relocation, big_sur:        "261e57d2b6d4c0b5829d4a8c2e49090efa2a5930d4aa6a28aa6d3b9aa389fa44"
    sha256 cellar: :any_skip_relocation, catalina:       "261e57d2b6d4c0b5829d4a8c2e49090efa2a5930d4aa6a28aa6d3b9aa389fa44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de3d7da06555ba9098b40f9eff1bac12caffdf737381d09a18b34108cc81ed2b"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/liqotech/liqo/pkg/liqoctl/version.liqoctlVersion=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/liqoctl"

    output = Utils.safe_popen_read(bin/"liqoctl", "completion", "bash")
    (bash_completion/"liqoctl").write output
    output = Utils.safe_popen_read(bin/"liqoctl", "completion", "zsh")
    (zsh_completion/"_liqoctl").write output
    output = Utils.safe_popen_read(bin/"liqoctl", "completion", "fish")
    (fish_completion/"liqoctl").write output
  end

  test do
    run_output = shell_output("#{bin}/liqoctl 2>&1")
    assert_match "liqoctl is a CLI tool to install and manage Liqo.", run_output
    assert_match version.to_s, shell_output("#{bin}/liqoctl version --client")
  end
end
