FROM python:3.8
RUN pip install pipenv
WORKDIR /usr/src/app
COPY Pipfile Pipfile.lock ./
RUN pipenv install --system --deploy
COPY . ./
ENV FLASK_APP=app
ENV FLASK_ENV=production
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=5000
EXPOSE 5000
ENTRYPOINT flask run

