This is an End-to-End Machine learning project on Image Classification where our goal is to build a website where we can drag and drop an image of the sportsperson and it will tell us the info about that sportsperson. The project will be restricted to only 5 sportspersons for simplicity. We will be using images scrapped from google. We will do feature engineering, use OpenCV, cover wavelet transform and use our images to train a SVM classifier or a Logistic regression classifier(ANN are the best for this). 
We will build a model first, hypertune it, export it to a file, run a python falsk server around it, and our website will make a call to that python flask server. 
The dataset used to train our model is downloaded from : https://github.com/codebasics/py/tree/master/DataScience/CelebrityFaceRecognition/images_dataset.

Thanks to Dhaval Patel for the inspiration of this project!


Feature engineering

In this notebook, we are going to implement feature engineering. we will be using a techinque called wavelet transform which can be used to extract the facial features. We will build our training datasets for the model. 