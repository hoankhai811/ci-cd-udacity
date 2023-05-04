# Clone git repo into Azure Cloud Shell
git clone https://github.com/hoankhai811/ci-cd-udacity.git

# Make change directories folder
cd ci-cd-udacity.git

# List all file and folder in the Azure Cloud Shell 
ls -a

# Install virtual env
pip install virtualenv

# Create virtual env
virtualenv ~/.udacity-devops

# Activate virtual env
source ~/.udacity-devops/bin/activate

# Install all package for application & lint & test code
make all

# Run app python local
python app.py

# Load test with locust
pip install locust

# Run Locust
locust

# Deployed webapp in Azure Cloud Shell
az webapp up -n flaskmludacity

# See stream log webapp
az webapp log tail
