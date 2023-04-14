from setuptools import setup,find_packages

setup(
    name='Mojaloop_Services_DFSPID',
    version='1.0.0',
    author='',
    author_email='',
    packages=find_packages(),
    include_package_data=True,
    install_requires= [
        'flask',
        'flask-restplus',
        'flask_healthz ',
        'flask-swagger-ui',
        'flask-cors',
        'mysql-connector-python'
    ],
)
