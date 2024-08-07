
# Make redbean executeable file type working
sudo sh -c "echo ':APE:M::MZqFpD::/usr/bin/ape:' >/proc/sys/fs/binfmt_misc/register"
sudo sh -c "echo ':APE-jart:M::jartsr::/usr/bin/ape:' >/proc/sys/fs/binfmt_misc/register"

# Copy redbean.com.template to wekan.com
cp -f redbean.com.template wekan.com

# Add all files from srv directory to zip file at end of wekan.com
cd srv/
zip -r ../wekan.com `ls -A`
cd ..

# Start WeKan
./wekan.com
