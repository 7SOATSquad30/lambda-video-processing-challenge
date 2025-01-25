ZIP_FILE=deployment_package.zip
FFMPEG_URL=https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz
S3_BUCKET=ffmpeg-package-for-lambda
FFMPEG_S3_KEY=ffmpeg/ffmpeg-release-amd64-static.tar.xz

.PHONY: build
build:
	@echo "Criando diretórios necessários..."
	rm -rf package
    mkdir -p package/tmp
    @echo "Instalando dependências..."
    pip install --target ./package -r app/requirements.txt
    @echo "Compactando pacote de implantação..."
    cd package && zip -r9 ../$(ZIP_FILE) .
    zip -g $(ZIP_FILE) app/lambda_function.py app/src/**/*
    @echo "Pacote de implantação criado: $(ZIP_FILE)"

.PHONY: upload-ffmpeg
upload-ffmpeg:
    @echo "Baixando FFmpeg..."
    curl -L $(FFMPEG_URL) -o ffmpeg-release-amd64-static.tar.xz
    @echo "Enviando FFmpeg para o S3..."
    aws s3 cp ffmpeg-release-amd64-static.tar.xz s3://$(S3_BUCKET)/$(FFMPEG_S3_KEY)
    @echo "FFmpeg enviado para o S3: s3://$(S3_BUCKET)/$(FFMPEG_S3_KEY)"

.PHONY: clean
clean:
    @echo "Limpando arquivos temporários..."
    rm -rf package $(ZIP_FILE) ffmpeg-release-amd64-static.tar.xz
    @echo "Limpeza concluída."