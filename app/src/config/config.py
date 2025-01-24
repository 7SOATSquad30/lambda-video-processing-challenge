import os
from aws_lambda_powertools import Logger

def get_env_variable(var_name, default_value=None):
    """
    Recupera uma variável de ambiente, com a opção de fornecer um valor padrão.

    :param var_name: Nome da variável de ambiente.
    :param default_value: Valor padrão caso a variável não esteja definida.
    :return: Valor da variável de ambiente ou o valor padrão.
    """
    return os.environ.get(var_name, default_value)

# Configurações
LOG_LEVEL = get_env_variable('LOG_LEVEL', 'INFO')

# Configuração do logger
logger = Logger(service="s3-file-processor", level=LOG_LEVEL)
