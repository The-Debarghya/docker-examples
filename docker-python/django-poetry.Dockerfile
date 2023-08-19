FROM python:3.10 as python-base

# https://python-poetry.org/docs#ci-recommendations
ARG POETRY_VERSION=1.4.2
ENV POETRY_VERSION=${POETRY_VERSION}
ENV POETRY_HOME=/opt/poetry
ENV POETRY_VENV=/opt/poetry-venv

# Tell Poetry where to place its cache and virtual environment
ENV POETRY_CACHE_DIR=/opt/.cache

# Create stage for Poetry installation
FROM python-base as poetry-base

# Creating a virtual environment just for poetry and install it with pip
RUN python3 -m venv $POETRY_VENV \
    && $POETRY_VENV/bin/pip install -U pip setuptools \
    && $POETRY_VENV/bin/pip install poetry==${POETRY_VERSION}

# Create a new stage from the base python image
FROM python-base as final

ARG START_COMMAND="python manage.py makemigrations && python manage.py migrate && gunicorn <project_name>.wsgi:application --bind 0.0.0.0:80"

# Copy Poetry to app image
COPY --from=poetry-base ${POETRY_VENV} ${POETRY_VENV}

# Add Poetry to PATH
ENV PATH="${PATH}:${POETRY_VENV}/bin"

WORKDIR /app

# Copy Dependencies
COPY poetry.lock pyproject.toml ./

# [OPTIONAL] Validate the project is properly configured
RUN poetry check

# Install Dependencies
RUN poetry install --no-interaction --no-cache --without dev
RUN poetry add gunicorn

# Create user
RUN useradd -m -s /usr/sbin/nologin user && chown -R user:user /app

# Copy Application
COPY . /app

# Setup entrypoint
RUN echo ${START_COMMAND} >> /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Switch to non-root user
USER user

# Run app
CMD ["sh", "-c", "/app/entrypoint.sh"]
