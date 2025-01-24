import boto3
from src.config.config import logger
from src.config.config import get_env_variable


def send_email_notification(to_email, error_message):
    ses_client = boto3.client('ses')
    response = ses_client.send_email(
        Source=get_env_variable('SES_SOURCE_EMAIL'),
        Destination={'ToAddresses': [to_email]},
        Message={
            'Subject': {'Data': 'Erro no processamento Lambda'},
            'Body': {'Text': {'Data': error_message}}
        }
    )
    logger.info(f"E-mail de erro enviado para {to_email}: {response}")