# Go
export GOPATH=$HOME/.go
export PATH=$PATH:/usr/local/opt/go/libexec/bin
export PATH=$PATH:$GOPATH
# add go path bin to path
export PATH=$PATH:$GOPATH/bin

# Compile erlang with OpenSSL from Homebrew via asdf
export ERLANG_OPENSSL_PATH="/usr/local/opt/openssl@1.1"

# OPEN SSL
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"

# For compilers to find openssl@1.1:
export LDFLAGS="$LDFLAGS -L/usr/local/opt/openssl@1.1/lib"
export CPPFLAGS="$CPPFLAGS -I/usr/local/opt/openssl@1.1/include"

# For pkg-config to find openssl@1.1:
export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig"

# ASDF version manager
source $HOME/.asdf/asdf.sh
