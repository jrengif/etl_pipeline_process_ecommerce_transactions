"""
This scripts allows to generate a fernet key
in the context of using that generated key for airflow webserver container
"""
from cryptography.fernet import Fernet
print(Fernet.generate_key().decode())
