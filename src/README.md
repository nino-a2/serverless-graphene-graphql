# 1. Acquire requirements

## 1.1 Global (option)
NOTE: there's an option to use a virtualenv as well (see 1.2)

To install the requirements globally anyway, just run:
```
pip install graphene
pip install flask
```

## 1.2 In a virtualenv (option)
To acquire the required dependencies, do the following:

In the src folder, run:

```
python -m venv ./venv
source venv/Scripts/activate

pip install graphene
pip install flask
```

### 1.2.1 Deactivating the virtualenv
If you want to disable/deactivate the virtualenv, just run:
`deactivate`


# 2. Run the local Flask server
NOTE: If you installed the dependencies in a virtualenv, the virtualenv must be active to run the local server. So, if it's disbled, just run `source venv/Scripts/activate`.

To start the local server, just run:
`python main.py`
