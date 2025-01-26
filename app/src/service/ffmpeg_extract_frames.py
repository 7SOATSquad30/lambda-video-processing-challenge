import os
import subprocess
import tarfile
import boto3
from app.src.config.config import logger

s3 = boto3.client('s3')
S3_BUCKET = 'ffmpeg-package-for-lambda'
FFMPEG_S3_KEY = 'ffmpeg/ffmpeg-release-amd64-static.tar.xz'
FFMPEG_LOCAL_PATH = '/tmp/ffmpeg-release-amd64-static.tar.xz'
FFMPEG_BIN_PATH = '/tmp/ffmpeg'


def extract_ffmpeg():
    try:
        logger.info("Tentando extrair FFmpeg com tar via subprocess...")
        subprocess.run(
            ['tar', '-xJf', FFMPEG_LOCAL_PATH, '-C', '/tmp', '--strip-components', '1'],
            check=True,
            capture_output=True,
            text=True
        )
        logger.info("Extração via subprocess concluída com sucesso.")
    except subprocess.CalledProcessError as e:
        logger.error(f"Erro ao extrair com tar: {e.stderr}")
        raise e


def extract_frames_with_ffmpeg(video_path, output_dir):
    """
    Extrai frames de um vídeo usando FFmpeg.

    :param video_path: Caminho do arquivo de vídeo a ser processado.
    :param output_dir: Diretório onde os frames extraídos serão salvos.
    :raises FileNotFoundError: Se o arquivo de vídeo ou o FFmpeg não forem encontrados.
    :raises subprocess.CalledProcessError: Se o comando FFmpeg falhar.
    """
    os.makedirs(output_dir, exist_ok=True)

    if not os.path.isfile(FFMPEG_BIN_PATH):
        extract_ffmpeg()

    if not os.path.isfile(video_path):
        logger.error(f"O arquivo de vídeo não foi encontrado: {video_path}")
        raise FileNotFoundError(f"O arquivo de vídeo não foi encontrado: {video_path}")

    output_frame_pattern = os.path.join(output_dir, 'frame_%04d.jpg')

    command = [
        FFMPEG_BIN_PATH,  # Caminho do executável FFmpeg
        '-i', video_path, # Caminho do vídeo de entrada
        '-vf', 'fps=1',   # Extrair 1 frame por segundo
        output_frame_pattern  # Padrão para salvar os frames
    ]

    try:
        logger.info(f"Executando comando: {' '.join(command)}")
        result = subprocess.run(command, capture_output=True, text=True, check=True)
        logger.info(f"Saída do FFmpeg: {result.stdout}")
        logger.info(f"Frames extraídos com sucesso para: {output_dir}")
    except subprocess.CalledProcessError as e:
        logger.error(f"Erro ao executar FFmpeg: {e.stderr}")
        raise e

    return output_dir