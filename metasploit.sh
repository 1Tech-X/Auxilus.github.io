#!/data/data/com.termux/files/usr/bin/sh

echo "installing Prequisities \n"
apt update && apt upgrade
apt install autoconf bison clang coreutils curl findutils git apr apr-util libffi-dev libgmp-dev libpcap-dev \
    postgresql-dev readline-dev libsqlite-dev openssl-dev libtool libxml2-dev libxslt-dev ncurses-dev pkg-config \
    postgresql-contrib wget make ruby-dev libgrpc-dev termux-tools ncurses-utils ncurses

echo "\n"
echo "cloning Metasploit framework\n"
git clone https://github.com/rapid7/metasploit-framework --depth 1
cd metasploit-framework

echo "\n"
echo "Installing bundler"
gem install bundler

echo "\n"
echo "Installing nokogiri\n"
gem install nokogiri -- --use-system-libraries

echo "\n"
echo "installing Network_interface"
cd $HOME
gem unpack network_interface
cd network_interface-0.0.1
sed 's|git ls-files|find -type f|' -i network_interface.gemspec
curl -L https://wiki.termux.com/images/6/6b/Netifaces.patch -o netifaces.patch
patch -p1 < netifaces.patch

echo "\n"
echo "Building gem\n"
gem build network_interface.gemspec
gem install network_interface-0.0.1.gem
cd ..
rm -r network_interface-0.0.1

echo "\n"
echo "Installing grpc"
sed 's|grpc (.*|grpc (1.4.1)|g' -i Gemfile.lock
gem unpack grpc -v 1.4.1
cd grpc-1.4.1
curl -LO https://raw.githubusercontent.com/grpc/grpc/v1.4.1/grpc.gemspec
curl -L https://wiki.termux.com/images/b/bf/Grpc_extconf.patch -o extconf.patch
patch -p1 < extconf.patch
gem build grpc.gemspec
gem install grpc-1.4.1.gem
cd ..
rm -r grpc-1.4.1

echo "\n"
echo "Installig gems\n"
cd $HOME/metasploit-framework
bundle install -j5


echo "\n"
echo "Performing shebang fix"
$PREFIX/bin/find -type f -executable -exec termux-fix-shebang \{\} \;

echo "\n"
echo "Metasploit Successfully installed"
echo
echo "Type ./msfconsole to start metasploit"
echo
cd $HOME/metasploit-framework
