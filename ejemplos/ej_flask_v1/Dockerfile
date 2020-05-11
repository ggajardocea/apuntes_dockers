FROM ubuntu
RUN apt-get update
RUN apt-get -y install python
RUN apt-get -y install python-pip

RUN pip install flask
RUN pip install flask-mysql

COPY . /opt/source-code
EXPOSE 80
ENTRYPOINT FLASK_APP=/opt/source-code/app.py flask run
