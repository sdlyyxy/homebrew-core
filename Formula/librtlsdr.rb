class Librtlsdr < Formula
  desc "Use Realtek DVB-T dongles as a cheap SDR"
  homepage "https://osmocom.org/projects/rtl-sdr/wiki"
  license "GPL-2.0-or-later"
  revision 1
  head "https://git.osmocom.org/rtl-sdr", using: :git, branch: "master"

  stable do
    url "https://github.com/steve-m/librtlsdr/archive/0.6.0.tar.gz"
    sha256 "80a5155f3505bca8f1b808f8414d7dcd7c459b662a1cde84d3a2629a6e72ae55"
    # These patches are applied upstream after 0.6.0, but have not been released yet
    patch do # lib: Add workaround for Linux usbfs mmap() bug
      url "https://gitea.osmocom.org/sdr/rtl-sdr/commit/f68bb2fa772ad94f58c59babd78353667570630b.patch"
      sha256 "6467a2378793290573124b31dad7180e207ab8895651e2a53a5e5dbb30cecee0"
    end
    patch do # lib: fix memory leak in rtlsdr_open()
      url "https://gitea.osmocom.org/sdr/rtl-sdr/commit/be1d1206bfb6e6c41f7d91b20b77e20f929fa6a7.patch"
      sha256 "2778eb2e4b1ace7386ea5b96a9fb5baa2f407b73fb5ce1060cbd6e92ef7c4e43"
    end
    patch do # lib: disable usbfs zero-copy support by default
      url "https://gitea.osmocom.org/sdr/rtl-sdr/commit/81833a1cf6288fee93a9157c0f60cafb5ec340b9.patch"
      sha256 "17de7e509ff25e1fd3f2251a69574b756b931572bda6a3ea14e84fba7f28e360"
    end
    patch do # Improve librtlsdr.pc file
      url "https://gitea.osmocom.org/sdr/rtl-sdr/commit/222517b506278178ab93182d79ccf7eb04d107ce.patch"
      sha256 "da4fa0da5d3298a5a9f978eb11fad890d7e658999f6c06ae6c80e9aa344288d0"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f61808ab70f1d625cbc411d4f5e5e68a26b14f93eb926352353523cc54e188a6"
    sha256 cellar: :any,                 arm64_big_sur:  "7b8ccea097dd346fcaec28c4fd3545bbffe2bf0ddcd735fa2fd5dd6920c117a0"
    sha256 cellar: :any,                 monterey:       "39da4634626962907b3540fb365bf4272ef7082bdc8dad62763fef08658b3dae"
    sha256 cellar: :any,                 big_sur:        "6bdf828e23854791779071bd32cd346d7cbc8d566738f63dd5c3185b91d11c73"
    sha256 cellar: :any,                 catalina:       "8d09d3c7765995caed6f1e8fa26087e345d178c630b1ef2057fb8c34cdcddd7d"
    sha256 cellar: :any,                 mojave:         "0e9b14804b722d9efc959940e40ebcef7bf716eb636f0bb0dc600770cb005531"
    sha256 cellar: :any,                 high_sierra:    "71f28a8abd8e9e0245a61f841fcebcb7a179d952be786199bf21fae0edd11f6c"
    sha256 cellar: :any,                 sierra:         "d1b83b24f32d4857205be289f7c632ee3bd77af802e3445d7565bb9ba9e4f3b1"
    sha256 cellar: :any,                 el_capitan:     "f5196572498f20ff0ea38d4e7ceed95aea1199a558f29dd6aac5cec9db65ce33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d055564310defc7ef61bba3a621a57b9cd563f13b54c831cf186beb160ec5c9a"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "rtl-sdr.h"

      int main()
      {
        rtlsdr_get_device_count();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lrtlsdr", "-o", "test"
    system "./test"
  end
end
