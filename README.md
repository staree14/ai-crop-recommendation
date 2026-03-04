
# 🌾 AI Crop Recommendation System

## 📌 Overview

The **AI-Powered Smart Agriculture System** is an intelligent, data-driven decision support platform designed to assist farmers and agricultural stakeholders in making accurate and profitable farming decisions.

The system analyzes soil nutrients (N, P, K), pH levels, temperature, humidity, rainfall, and location data to recommend the **Top 3 most suitable crops** using advanced machine learning models. 

Beyond crop recommendation, the platform integrates:

* 🌾 Yield prediction and profit margin analysis  
* 🦠 AI-based pest and disease detection through image uploads  
* 📈 Live mandi prices and market trend insights  
* 🛰 Real-time weather and satellite data integration  
* 🤖 AI chatbot for personalized farming assistance  
* 🗣 Multilingual voice and text support for rural accessibility  

By leveraging Artificial Intelligence, Machine Learning, and Deep Learning technologies, the system aims to increase crop yield, reduce agricultural risk, improve profitability, and promote sustainable farming practices.
<p align="center">
<img width="300" height="auto" alt="image" src="https://github.com/user-attachments/assets/c0868c17-a97f-4f85-8750-5634195d2bcb" />
</p>

## 🎯 Objectives

* Recommend the **Top 3 most suitable crops** based on soil nutrients, pH, weather, and location data
* Enable farmers to make **data-driven and profitable decisions**
* Reduce crop failure caused by unsuitable soil and climatic conditions
* Provide **yield prediction and profit margin analysis** before cultivation
* Detect plant diseases early using **AI-powered image analysis**
* Provide real-time **mandi prices and market trend insights**
* Offer multilingual voice and text support for better rural accessibility
* Demonstrate the practical implementation of **AI/ML, Deep Learning, and IoT integration in agriculture**

## 🧠 Core Features

* Input-based crop prediction using:

  * Soil nutrients (N, P, K)
  * Soil pH
  * Temperature
  * Humidity
  * Rainfall
  * Location data

* Trained machine learning classification model
* Fast and accurate Top 3 crop recommendations
* Scalable design for integration with web or mobile applications
* Real-time soil & weather data integration using Satellite APIs
* Yield prediction with profit margin and sustainability analysis
* AI-based pest and disease detection using crop image uploads
* Instant treatment recommendations and preventive care guidance
* Live mandi prices from nearby markets
* Market trend analysis and best time-to-sell insights
* AI chatbot for personalized farming assistance
* Simple voice and multilingual text support for rural accessibility


---
<p align="left">
   <h3> TOP 3 CROPS RECOMMENDATION</h3>
<img width="200" height="auto" alt="image" src="https://github.com/user-attachments/assets/86e23a0c-5e50-41ec-ad0d-37a625e15775" />
</p>
<p align="right">
   <h3> CHECKING CROP HEALTH </h3>
<img width="200" height="auto" alt="image" src="https://github.com/user-attachments/assets/594f1455-c454-47e8-9a81-7ad039b1c180" />
  </p>

## 🗂️ Dataset

The model is trained on an agriculture dataset containing:

* Nutrient values: Nitrogen (N), Phosphorus (P), Potassium (K)
* Environmental factors: temperature, humidity, rainfall
* Soil parameter: pH
* Target label: recommended crop

The dataset is preprocessed to handle:

* Missing values
* Feature scaling (if required)
* Train–test split for evaluation

---

## ⚙️ Technologies Used

* **Programming Languages:**
  * Python (AI/ML model training & backend)
  * Dart (Flutter frontend)
  * SQL (Database management)

* **Libraries & Frameworks:**

  * NumPy → Numerical computations
  * Pandas → Data handling & preprocessing
  * Scikit-learn (sklearn) → Machine learning model training
  * Matplotlib / Seaborn → Data visualization
  * TensorFlow → Deep learning for image processing & plant disease detection

* **Machine Learning Models Used:**

  * Random Forest
  * Gradient Boosting
  * Logistic Regression

* **Backend Framework:**

  * Flask → Lightweight web framework to expose ML models as REST APIs
  * API Integration → Enables Flutter frontend to communicate with Flask backend

* **Frontend Framework:**

  * Flutter (Dart) → Cross-platform mobile application (Android & iOS)
  * HTTP Package → Used to make API calls to Flask backend

* **Crop Recommendation Model Details:**

  * Training Dataset Size: 22,000 samples
  * Cross-Validation Accuracy: 89.7%
---

## 🧪 Model Workflow

1. Data collection from soil, weather, and crop datasets
2. Data cleaning and preprocessing (handling missing values, encoding, normalization)
3. Feature selection (N, P, K, pH, temperature, humidity, rainfall, location)
4. Model training using Random Forest, Gradient Boosting, and Logistic Regression
5. Cross-validation and hyperparameter tuning
6. Model evaluation (Accuracy score, Confusion Matrix, Precision/Recall)
7. Crop prediction based on real-time user inputs
8. Yield and profit prediction analysis
9. Disease detection using deep learning (TensorFlow-based image model)
10. API deployment using Flask for frontend integration

---

## 🌱 Future Enhancements

* Integration with advanced real-time weather & satellite APIs
* Region-specific and soil-history-based crop recommendations
* AI-powered fertilizer and smart irrigation scheduling
* Blockchain-based supply chain transparency
* Government scheme and subsidy recommendation system
* Advanced market trend forecasting using time-series models
* IoT sensor integration for live field monitoring


## 📜 License

This project is intended for **educational and research purposes**.
Please cite the source if used in academic or production settings.


