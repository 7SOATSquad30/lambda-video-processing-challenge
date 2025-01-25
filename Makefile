ZIP_FILE=deployment_package.zip
FFMPEG_URL=https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz
FFMPEG_DIR=ffmpeg

.PHONY: build
build:
	@echo "Criando diretórios necessários..."
	rm -rf package
	mkdir -p package/tmp
	@echo "Instalando dependências..."
	pip install --target ./package -r app/requirements.txt
	@echo "Baixando FFmpeg..."
	curl -L $(FFMPEG_URL) | tar -xJ -C package/tmp --strip-components 1
	cp package/tmp/ffmpeg package/
	@echo "Compactando pacote de implantação..."
	cd package && zip -r9 ../$(ZIP_FILE) .
	zip -g $(ZIP_FILE) lambda_function.py src/**/*
	@echo "Pacote de implantação criado: $(ZIP_FILE)"

.PHONY: clean
clean:
	@echo "Limpando arquivos temporários..."
	rm -rf package $(ZIP_FILE)
	@echo "Limpeza concluída."
