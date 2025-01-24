import os
import subprocess
from src.config.config import logger

def extract_frames_with_ffmpeg(video_path, output_dir):
    """
    Extrai frames de um vídeo usando FFmpeg.

    :param video_path: Caminho do arquivo de vídeo a ser processado.
    :param output_dir: Diretório onde os frames extraídos serão salvos.
    :raises FileNotFoundError: Se o arquivo de vídeo ou o FFmpeg não forem encontrados.
    :raises subprocess.CalledProcessError: Se o comando FFmpeg falhar.
    """
    os.makedirs(output_dir, exist_ok=True)

    ffmpeg_path = '/tmp/ffmpeg'  # Caminho esperado para o binário do FFmpeg
    if not os.path.isfile(ffmpeg_path):
        logger.error(f"FFmpeg não encontrado em {ffmpeg_path}. Verifique o download e o caminho.")
        raise FileNotFoundError(f"FFmpeg não encontrado no caminho {ffmpeg_path}")

    if not os.path.isfile(video_path):
        logger.error(f"O arquivo de vídeo não foi encontrado: {video_path}")
        raise FileNotFoundError(f"O arquivo de vídeo não foi encontrado: {video_path}")

    output_frame_pattern = os.path.join(output_dir, 'frame_%04d.jpg')

    command = [
        ffmpeg_path,      # Caminho do executável FFmpeg
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
