import os
import random
import string

from PIL import Image
from flask import Flask, render_template, request, url_for, redirect, send_from_directory, send_file
from werkzeug.datastructures import FileStorage

SIGN_LOCATION = 225, 1300
SIGN_SIZE = 1443, 900
OVERLAY: Image.Image = Image.open('herrschwarz.png')

if not os.path.exists('uploads'):
    os.mkdir("uploads")

app = Flask(__name__)


def herrschwarzify(image: Image.Image) -> Image.Image:
    canvas = Image.new(OVERLAY.mode, OVERLAY.size)
    image = image.resize(SIGN_SIZE)
    canvas.alpha_composite(image, SIGN_LOCATION)
    canvas.alpha_composite(OVERLAY)
    return canvas


def random_name():
    return ''.join(random.choice(string.ascii_lowercase + string.digits) for _ in range(20)) + ".png"


@app.route("/")
def index():
    return render_template('index.html')


@app.route("/res/<image>")
def image_resource(image):
    return send_from_directory('uploads', image)


@app.route("/herrschwarz")
def herrschwarz():
    return send_file('herrschwarz.png')


@app.route("/upload", methods=["POST"])
def upload():
    if 'file' not in request.files or not request.files["file"].filename:
        return redirect(url_for('index'))
    image: FileStorage = request.files["file"]
    converted_image = herrschwarzify(Image.open(image.stream).convert(OVERLAY.mode))
    name = random_name()
    converted_image.save(f"uploads/{name}")
    return redirect(url_for('image_resource', image=name))


if __name__ == '__main__':
    app.run()
