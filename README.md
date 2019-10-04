# GPR_vs_SVM

A network of K sensors is deployed in a geographical area to monitor a physical phenomenon. At any given time instant, only M<K stations provide the data to the central server. It is required to analyze the data values at other (K-M) stations. The data values at the server are governed by the model equation:

t_n=z(x_n,y_n )+ϵ_n,  n=1,2,….K

where, z(x_n,y_n ) are the actual values, (x_n,y_n )  are sensor positions and ϵ_n is zero-mean Gaussian noise.
Address the following: 
	Development of mathematical equations for regression of t_n  using Gaussian Process Regression (GPR).
	Results of GPR and analysis on the regression performance of the approach. 
	Regression using Support Vector Machine (SVM) / Relevance Vector Machine (RVM)
	Comparison of the results with those of GPR and comments on the model accuracies.
