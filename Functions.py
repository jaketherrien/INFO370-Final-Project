# -*- coding: utf-8 -*-
"""
Created on Tue Feb 27 17:28:52 2018

@author: maryh
"""

import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split # typically done at the start of the script
from sklearn.model_selection import KFold
from sklearn.model_selection import cross_val_score
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import MinMaxScaler
from sklearn.neighbors import KNeighborsClassifier
from sklearn.model_selection import GridSearchCV
from sklearn.metrics import accuracy_score
from sklearn.tree import DecisionTreeClassifier
from sklearn.decomposition import PCA
from sklearn.ensemble import RandomForestClassifier

#making sure all colums are matching before regressison
def standardize(df, numeric_only=True):
    numeric = df.select_dtypes(include=['int64', 'float64'])
    
    # subtracy mean and divide by std
    df[numeric.columns] = (numeric - numeric.mean()) / numeric.std()
    
    return df

def pre_process(df, enforce_cols=None, stand = False):
    if(stand == True):
        df = standardize(df)
    df = pd.get_dummies(df)

    
    return df

def run_model(model, param_grid, xtrain, ytrain, do_pca = False):
    if(do_pca == True):
        pca = PCA(n_components = 10)
        scaler = MinMaxScaler()
        pipe = make_pipeline(pca, model)
        grid = GridSearchCV(pipe,param_grid)
        grid.fit(xtrain, ytrain)
        grid.best_params_
        accuracy = grid.score(xtrain, ytrain)
        print(f"In-sample accuracy: {accuracy:0.2%}")
        return(grid)
    scaler = MinMaxScaler()
    pipe = make_pipeline(model)
    grid = GridSearchCV(pipe,param_grid)
    grid.fit(xtrain, ytrain)
    grid.best_params_
    accuracy = grid.score(xtrain, ytrain)
    print(f"In-sample accuracy: {accuracy:0.2%}")
    return(grid)
    
def make_country_sub(preds, test_feat, country):
    # make sure we code the country correctly
    country_codes = ['A', 'B', 'C']
    
    # get just the poor probabilities
    country_sub = pd.DataFrame(data=preds[:, 1],  # proba p=1
                               columns=['poor'], 
                               index=test_feat.index)

    
    # add the country code for joining later
    country_sub["country"] = country
    return country_sub[["country", "poor"]]
    


