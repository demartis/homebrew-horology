class TgTimer < Formula
  desc "A program for timing mechanical watches"
  homepage "https://tg.ciovil.li"
  url "https://github.com/demartis/tg/archive/v0.6.2.tar.gz"
  sha256 "e4a9fe485c18714e071ed1a42bdedcd4c3ea6e3dc7ef6ba4e945291fa65a3864"
  head "https://github.com/demartis/tg.git", :branch => "new-stuff"

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gtk+3"
  depends_on "portaudio"
  depends_on "fftw"
  depends_on "gnome-icon-theme"

  depends_on "python@3.11" => :recommended
  depends_on "numpy" if build.with? "python@3.11"
  depends_on "scipy" if build.with? "python@3.11"

  #resource "libtfr" do
  #  url "https://files.pythonhosted.org/packages/9e/58/b39b970e55e9e832f38b359c113a00579544f0ecbded5cb3ba4be52fb505/libtfr-2.1.7.tar.gz"
  #  sha256 "7d7134f6e71ecb48364c7f125bb1c4d469b7c42d494afd672307a9bdf7e72b4b"
  #end

  #resource "matplotlib" do
  #  url "https://files.pythonhosted.org/packages/b7/65/d6e00376dbdb6c227d79a2d6ec32f66cfb163f0cd924090e3133a4f85a11/matplotlib-3.7.1.tar.gz"
  #  sha256 "7b73305f25eab4541bd7ee0b96d87e53ae9c9f1823be5659b806cd85786fe882"
  #end

  # Attempting to pull in these python package resources with
  # "virtualenv_install_with_resources" resulted in them getting built from
  # source, along with *all* their dependencies!  Numpy, scipy, etc. all
  # re-built, even though they are already installed.  This takes litterally
  # hours.  So I've left it out.  One will need to "manually" pip3 install
  # libtfr and matplotlib.

  fails_with :gcc do
    version "9"
    cause "Requires gcc 10.x or newer"
  end

  def install
    ENV["LIBTOOL"] = "glibtool"
    ENV["LIBTOOLIZE"] = "glibtoolize"
    system "./autogen.sh"
    if build.with? "python@3.11"
      system "./configure", "--prefix=#{prefix}"
    else
      system "./configure", "--prefix=#{prefix}", "--without-python"
    end
    system "make"
    system "make", "install"
  end

  # This doesn't seem to be enough to get the icons to acutally work on MacOS
  def post_install
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end
end
