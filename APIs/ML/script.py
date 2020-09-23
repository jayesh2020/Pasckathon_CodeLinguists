# keras_server.py 

# Python program to expose a ML model as flask REST API 

# import the necessary modules 
from keras.models  import load_model
from keras.preprocessing.image import img_to_array 
import tensorflow as tf 
from PIL import Image 
import numpy as np 
import flask 
# from flask_ngrok import run_with_ngrok
import io 

# Create Flask application and initialize Keras model 
app = flask.Flask(__name__) 

label_dict = {0:'Acne and Rosacea Photos',
 1:'Eczema',
 2: 'Melnoma'}

#Have model_3_clases.h5 genereted using train.ipynb in same directory of this script
   
model = load_model('model_3_classes.h5')


# Every ML/DL model has a specific format 
# of taking input. Before we can predict on 
# the input image, we first need to preprocess it. 
def prepare_image(image, target): 
  if image.mode != "RGB": 
    image = image.convert("RGB") 

  # Resize the image to the target dimensions 
  image = image.resize(target) 

  # PIL Image to Numpy array 
  image = img_to_array(image) 

  # Expand the shape of an array, 
  # as required by the Model 
  image = np.expand_dims(image, axis = 0) 

  # preprocess_input function is meant to 
  # adequate your image to the format the model requires 
  image = image/255

  # return the processed image 
  return image 

# Now, we can predict the results. 
@app.route("/predict", methods =["POST"]) 
def predict():
  data = {} # dictionary to store result    
  data["success"] = False

  # Check if image was properly sent to our endpoint 
  if flask.request.method == "POST": 
    if flask.request.files.get("image"): 
      image = flask.request.files["image"].read() 
      image = Image.open(io.BytesIO(image)) 

      # Resize it to 224x224 pixels 
      # (required input dimensions for ResNet) 
      image = prepare_image(image, target =(224, 224)) 

      # Predict ! global preds, results 

      preds  = model.predict(image) 

      data["predictions"] = [] 
      data["predictions"].append(label_dict[np.argmax(preds)])

      data["success"] = True

  # return JSON response 
  return flask.jsonify(data) 



if __name__ == "__main__": 
    print(("* Loading Keras model and Flask starting server..."
        "please wait until server has fully started")) 
    app.run() 
