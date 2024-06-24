
# Copy redbean.com.template to wekan.com
copy bin\redbean.com.template wekan.com

# Add all files from srv directory to zip file at end of wekan.com
cd srv
zip -r ..\wekan.com `dir -A`
cd ..

# Start WeKan
wekan.com
