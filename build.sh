
# Linux: Make redbean executeable file type working
if [[ "$OSTYPE" == "linux-gnu" ]]; then
  sudo sh -c "echo ':APE:M::MZqFpD::/usr/bin/ape:' >/proc/sys/fs/binfmt_misc/register"
  sudo sh -c "echo ':APE-jart:M::jartsr::/usr/bin/ape:' >/proc/sys/fs/binfmt_misc/register"
fi

# Android Termux
if [[ "$OSTYPE" == "linux-android" ]]; then
  pkg install blink git zip 
fi

# https://redbean.dev
# redbean v3.0.0 was released on 2024-08-17.
# redbean-3.0.0.com
# 5.5m - PE+ELF+MachO+ZIP+SH for AMD64 and ARM64 (source code)
# 382f1288bb96ace4bab5145e7df236846c33cc4f1be69233710682a9e71e7467

# Copy redbean.com.template to wekan.com
cp -f redbean-3.0.0.com.template wekan.com

# Add all files from srv directory to zip file at end of wekan.com
cd srv/
zip -r ../wekan.com `ls -A`
cd ..
chmod +x wekan.com

# Android Termux
if [[ "$OSTYPE" == "linux-android" ]]; then
  blink wekan.com
else
  # Others
  ./wekan.com
fi
