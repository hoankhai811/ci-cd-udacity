[![Python application test with Github Actions](https://github.com/hoankhai811/ci-cd-udacity/actions/workflows/pythonapp.yml/badge.svg?branch=main)](https://github.com/hoankhai811/ci-cd-udacity/actions/workflows/pythonapp.yml)
# Overview

This project will start with creating a scaffolding to assist in performing Continuous Integration and Continuous Delivery. And then it will use Github Actions along with a Makefile, requirements.txt and application code to perform an initial lint, test, and install cycle. Lastly, we will integrate this project with Azure Pipelines to enable Continuous Delivery to Azure App Service.

## Project Plan

### Trello board
[Link to a Trello board for the project](https://trello.com/b/BHNEfGDe/task-tracking)

### Spreadsheet Project Plan
[Link to a spreadsheet that includes the original and final project plan](https://docs.google.com/spreadsheets/d/135P-Og8Wr5ZT7m99ojmzN-oxu6nqG1gKoMvBaBFW92g/edit#gid=0)

## Instructions
### Architectural Diagram
![image](https://user-images.githubusercontent.com/59783952/235413758-13349dd7-ceba-46bf-b1cd-62c59c014517.png)

## CI: Set Up Azure Cloud Shell
## 1: Create the Cloud-Based Development Environment
- Create a Github repository
- Git clone the source code from github into Azure Cloud Shell
![git clone azure cloud shell](https://user-images.githubusercontent.com/59783952/235415853-0dbbfcbc-a4e8-4814-9d01-87eb35548cf9.png)

## 2: Create Project Scaffolding
The environment is set up, we can create the scaffolding for our project and test our code.

**Create the Makefile**

Create a file named Makefile and copy the below code into it. (Remember to use tab formatting). Makefile is a handy way to create shortcuts to build, test, and deploy a project.

```makefile
install:
    pip install --upgrade pip &&\
        pip install -r requirements.txt

test:
    python -m pytest -vv test_hello.py

lint:
    pylint --disable=R,C hello.py

all: install lint test
```

**Create requirements.txt**

Create a file named requirements.txt. A requirements.txt is a convenient way to list what packages a project needs. Another optional best practice would be to "pin" the exact version of the package you use.

```
pylint
pytest
```

**Create the Python Virtual Environment**

You can create a Python virtual environment both locally and inside your Azure Cloud Shell environment. By creating the virtual environment in a home directory it won't accidentally be checked into your project.

```bash
pip install virtualenv
virtualenv ~/.{your-env}
source ~/.{your-env}/bin/activate
```
or

```bash
python3 -m venv {your-env}
source ~/.{your-env}/bin/activate
```
![activate venv](https://user-images.githubusercontent.com/59783952/235416282-bb63becc-c16c-4a30-b8b0-8d0c4794b642.png)

**Create the script file and test file.**

The next step is to create the script file and test file. This is a boilerplate code to get the initial continuous integration process working. It will later be replaced by the real application code.

First, you will need to create ```hello.py``` with the following code at the top level of your Github repo:

```python
def toyou(x):
    return "hi %s" % x

def add(x):
    return x + 1

def subtract(x):
    return x - 1
```

Next, you will need to create ```test_hello.py``` with the following code at the top level of your Github repo:
```
from hello import toyou, add, subtract


def setup_function(function):
    print("Running Setup: %s" % function.__name__)
    function.x = 10


def teardown_function(function):
    print("Running Teardown: %s" % function.__name__)
    del function.x


### Run to see failed test
#def test_hello_add():
#    assert add(test_hello_add.x) == 12

def test_hello_subtract():
    assert subtract(test_hello_subtract.x) == 9
```

## 3: Local Test

Now it is time to run `make all` which will install, lint, and test code. This enables us to ensure we don't check in broken code to GitHub as it installs, lints, and tests the code in one command. Later we will have a remote build server perform the same step.

What is important to keep in mind is that we need to test our code locally first before we clone it to the Azure Cloud Shell. So I will install all the packages and test whether I can run the app.py application and make housing prediction successfully in my local machine first. 

![make all](https://user-images.githubusercontent.com/59783952/235416678-3f4ede33-a936-4fba-83dc-94f5e855e29d.png)

After running my tests locally, I want to run my python web application. Once it is successfully, you will see Sklearn Prediction Home in your browser.

```python
Python app.py
```
![python run cmd](https://user-images.githubusercontent.com/59783952/235416845-a3d22431-27ad-4fb4-8951-826667f0240a.png)

![local host](https://user-images.githubusercontent.com/59783952/235416880-ee1298eb-f7c1-4d46-8b7d-32e25263ad0f.png)

Then, we want to make sure whether we call call our ML API. Open another terminal and type `./make_prediction.sh` or test via **POSTMAN** in our terminal. We will be able to see the prediction. Here i'm testing with **POSTMAN**

![image](https://user-images.githubusercontent.com/59783952/235416987-47cd5c21-e9f8-4488-a4e9-29f9f0f7b2c5.png)

Since we got the prediction value, it means our application works perfectly on our localhost. Then we will modify the port in app.py to 443 and commit our changes to the repo.

## 4. Clone Project into Azure Cloud Shell

Go to Azure Portal, click the Azure CLI, and clone the project. And we can do the same steps like above in our Azure Cloud Shell.

# CI: Configure GitHub Actions

## Replace yml code

```yaml
name: Python application test with Github Actions

on: [push]

jobs:
  build:

    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2
    - name: Set up Python 3.8
      uses: actions/setup-python@v1
      with:
        python-version: 3.8
    - name: Install dependencies
      run: |
        make install
    - name: Lint with pylint
      run: |
        make lint
    - name: Test with pytest
      run: |
        make test
```
**Here i'm using python 3.8 for lastest matching with lib scikit-learn 1.1.3**
![image](https://user-images.githubusercontent.com/59783952/235417514-9f3f30a7-861f-4a48-8a46-2f2c5a0571e2.png)

## Continuous Delivery on Azure
### Load Test with locust
* First you will need to install lib locust with or you can put it into file **```requirements.txt```**
```
pip3 install locust
```
* Then create **```locustfile.py```** you can refer my code or refer this document: [Load Test With Locust](https://pflb.us/blog/load-testing-using-locust/)
![image](https://user-images.githubusercontent.com/59783952/235604732-60adfdea-2c82-4334-9c88-0be74de1b204.png)

```
locust
```
![image](https://user-images.githubusercontent.com/59783952/235606070-25a76398-4292-4222-b3bc-e1813987da3c.png)
![image](https://user-images.githubusercontent.com/59783952/235606149-b579a878-a00a-4f1d-a24c-440235628899.png)

### 1. Authorize Azure App Service
```az webapp up -n <your-appservice> -g <your-resources-group (if already exist else don't put this into your cmd)>```
I'm already deployed the webapp so i just need type this command 
```az webapp up -n <your-appservice>```
![image](https://user-images.githubusercontent.com/59783952/235418898-79d08413-d437-4757-bb25-c4ad3a69970e.png)

![image](https://user-images.githubusercontent.com/59783952/235418408-4884f09d-02b7-409f-abc3-08a58de80bb5.png)

* Project cloned into Azure Cloud Shell
![image](https://user-images.githubusercontent.com/59783952/235418595-4f299fd1-f422-4a46-b831-c67acea0e0cd.png)

* Passing tests that are displayed after running the `make all` command from the `Makefile`
![image](https://user-images.githubusercontent.com/59783952/235418658-8c4a8bf4-ef4d-4da5-ac37-3b387d987218.png)

* Output of a test run
![image](https://user-images.githubusercontent.com/59783952/235418718-65bd15b9-6ea8-4fc9-9c21-2f93321c313b.png)

### 2. Enable Continuous Deployment with Azure Pipelines

* Then we want to use Azure pipelines to deploy our flask ML web application. To do so, we need to create a Azure DevOps Project and then establish a service connection for Azure Pipelines and Azure App Service first.

* Here is the tutorial you can follow along.

[Use CI/CD to deploy a Python web app to Azure App Service on Linux](https://docs.microsoft.com/en-us/azure/devops/pipelines/ecosystems/python-webapp?view=azure-devops&WT.mc_id=udacity_learn-wwl)

* You can refer the ci-cd yml code in this file **```azure-pipelines.yml```**

After that, the Flask ML Web Application is deployed successful with Azure Pipelines.
![image](https://user-images.githubusercontent.com/59783952/235419800-dbd557aa-baeb-47fa-bc41-996f1503bf52.png)
![image](https://user-images.githubusercontent.com/59783952/235419745-3a82d4ff-6af5-42b4-ba9c-9e0f102d326e.png)

Go to this url check your result: ```<your-app-service-name>.azurewebsites.net```

* Successful deploy of the project in Azure Pipelines.  [Note the official documentation should be referred to and double checked as you setup CI/CD](https://docs.microsoft.com/en-us/azure/devops/pipelines/ecosystems/python-webapp?view=azure-devops).

* Running Azure App Service from Azure Pipelines automatic deployment

* Successful prediction from deployed flask app in Azure Cloud Shell.  [Use this file as a template for the deployed prediction](https://github.com/udacity/nd082-Azure-Cloud-DevOps-Starter-Code/blob/master/C2-AgileDevelopmentwithAzure/project/starter_files/flask-sklearn/make_predict_azure_app.sh).
The output should look similar to this:
![Sucess-test-make-predict-azure-app ](https://user-images.githubusercontent.com/59783952/235419968-c376faaa-6b2b-44c7-b81a-e753dcb657c8.png)

```bash
(.myvenv) nhutranhb96 [ ~/ci-cd-udacity ]$ ./make_predict_azure_app.sh 
Port: 443
{"prediction":[20.353731771344123]}
```
## Testing CI/CD Azure Pipeline
![image](https://user-images.githubusercontent.com/59783952/235420185-e65bd35b-36e9-4ec5-9638-98db32c77cf9.png)
![image](https://user-images.githubusercontent.com/59783952/235420214-9ec9002f-23e5-4ced-9062-a19679120736.png)
![image](https://user-images.githubusercontent.com/59783952/235420245-f0972741-978d-43f6-b370-03ec1752993c.png)
![image](https://user-images.githubusercontent.com/59783952/235420286-ce9ea879-31a4-4d15-ae79-f8f0e9e8c6da.png)
![image](https://user-images.githubusercontent.com/59783952/235420628-1be4f49f-ba91-42cc-b86a-1adc764d30af.png)
![image](https://user-images.githubusercontent.com/59783952/235420646-e2441ff3-ad1a-480c-b963-8966b70a5212.png)

### 3. Stream Logs

Here is the output of streamed log files from deployed application.

[stream log docker file](https://flaskmludacity.scm.azurewebsites.net/api/logs/docker)
![image](https://user-images.githubusercontent.com/59783952/235611710-ecc8a728-7cf8-45d4-aa6e-b6600bd56908.png)

View the log file in App Service - Log Stream
![image](https://user-images.githubusercontent.com/59783952/235611977-d4400714-c440-4993-a73d-7266fce3830c.png)

## Enhancements

- This project can be enhanced by using the GitHub actions to deploy the web applications. We can utilize GitHub Actions as well as Azure Pipelines for continous delivery. Also, we can modify the pipeline and only triggers when there is a Pull Request.
- Also, the whole process can be applied for other frameworks such as C# or Node.js.

## Demo 

[Link Screencast on YouTube](https://youtu.be/SgzD0Z-vYrs)


