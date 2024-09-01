# See textfile bin/SOURCE about source code of binaries of bin directory
#
ARCH="$(uname -m)"

#if [[ "$ARCH" != "x86_64" && "$ARCH" != "aarch64" && "$ARCH" != "s390x"]]; then
#  echo "Unsupported architecture: $ARCH"
#  exit
#fi

# Linux: Make redbean executeable file type working
if [[ "$OSTYPE" == "linux-gnu" ]]; then
  sudo sh -c "echo ':APE:M::MZqFpD::/usr/bin/ape:' >/proc/sys/fs/binfmt_misc/register"
  sudo sh -c "echo ':APE-jart:M::jartsr::/usr/bin/ape:' >/proc/sys/fs/binfmt_misc/register"
fi

# Android Termux
if [[ "$OSTYPE" == "linux-android" ]]; then
  pkg install blink git zip 
fi

# Copy redbean.com.template to wekan.com
cp -f bin/redbean-3.0.0.com wekan.com

# Add all files from srv directory to zip file at end of wekan.com
cd srv/
zip -r ../wekan.com `ls -A`
cd ..
chmod +x wekan.com

# Android Termux
if [[ "$OSTYPE" == "linux-android" ]]; then
  blink wekan.com
elif [[ "$ARCH" == "riscv64" ]]; then
  chmod +x bin/blink-linux-riscv64
  ./bin/blink-linux-riscv64 wekan.com
elif [[ "$ARCH" == "s390x" ]]; then
  chmod +x bin/blink-linux-s390x
  ./bin/blink-linux-s390x wekan.com
else
  # Others: Linux/BSD/Mac
  ./wekan.com
fi
