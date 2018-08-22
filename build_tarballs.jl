# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "MetisBuilder"
version = v"1.3.5"

# Collection of sources required to build MetisBuilder
sources = [
    "https://github.com/coin-or-tools/ThirdParty-Metis/archive/releases/1.3.5.tar.gz" =>
    "98a6110d5d004a16ad42ee26cfac508477f44aa6fe296b90a6413fe0273ebe24",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd ThirdParty-Metis-releases-1.3.5/
./get.Metis 
update_configure_scripts
mkdir build
cd build/
../configure --prefix=$prefix --disable-pkg-config --host=${target} --enable-shared --enable-static --enable-dependency-linking lt_cv_deplibs_check_method=pass_all
make -j${nproc}
make install

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, :glibc),
    Linux(:x86_64, :glibc),
    Linux(:aarch64, :glibc),
    Linux(:armv7l, :glibc, :eabihf),
    Linux(:powerpc64le, :glibc),
    Linux(:i686, :musl),
    Linux(:x86_64, :musl),
    Linux(:aarch64, :musl),
    Linux(:armv7l, :musl, :eabihf),
    MacOS(:x86_64),
    Windows(:i686),
    Windows(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libcoinmetis", :libcoinmetis)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

