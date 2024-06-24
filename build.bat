
# Copy redbean.com.template to wekan.com
copy bin\redbean.com.template wekan.com

# Add all files from srv directory to zip file at end of wekan.com
cd srv
..\bin\zip.com -r ..\wekan.com `..\bin\ls -A`
cd ..

# Start WeKan
wekan.com
