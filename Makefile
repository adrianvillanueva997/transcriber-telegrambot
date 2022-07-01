run:
	poetry run python src/transcriber_telegrambot/main.py
prod:
	python src/transcriber_telegrambot/main.py
installwhl:
	. /venv/bin/activate && pip install *.whl
poetrybuild:
	. /venv/bin/activate && poetry build
installdeps:
	poetry run pip install -U pip && . /venv/bin/activate && poetry install --no-dev --no-root