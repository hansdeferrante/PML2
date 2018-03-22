# PML2

This Github contains all code used for the project part of the course "Machine Learning" at Vrije Universiteit Amsterdam. For this project, we chose to embark on a replication of a prepint paper by Al-'Rfou (available through https://arxiv.org/abs/1211.0498). Al-'Rfou has published the raw data on which the paper is based on BitBucket (see https://bitbucket.org/aboSamoor/wikitalk) and also made code available there. An exact replication was not possible but we do get quite close to the 74.5% classification performance mentioned in the preprint. 

Unfortunately, the BitBucket code lacks instructions on how to run the code and we had difficulties understanding it. Hence, we have implemented procedures in R-markdown documents and iPython notebooks to enhance readability. These are deposited in this repository. 

With regards to the project, in addition to the replication we investigated performance of classification based on the document-term matrix directly and by tuning/changing machine learning algorithms. Here, we include a brief description of each file in the repository.

# Contents/Attribution

## Preprocessing

- `JSON_to_Tidy.rmd` takes as input the raw data from "data.json.txt.details" which can be retrieved from Al-`Rfou's bitbucket repository. It contains the entire pre-processing procedure of the data. It assumes it is run on a Linux computer and depends on a SENNA installation (see https://ronan.collobert.com/senna/, V3.0 was used here). It generates a training set, test set and validation set on which we base our analysis in Python.

- The script filters demonyms contained in `demonymsAndCorrespondingTags`. 

- CleaningScript.py is called from `JSON_to_Tidy.rmd` and was only slightly modified to work with CSV data from a script in Al-'Rfou's repository.

## Jupyter notebooks

- `ML - Feature extraction & learning`: Contains the replication of Al-'Rfou, parameter tuning for SVM algorithms & Random Forests all based on similarity scores.

- `Character 10-grams`: Where we do classification based entirely on character 10 grams. Idea comes from Kulmizev et al. (2017)

- `Using TF-IDF to find important grams`: Classification based on document-term matrix directly. Entire matrix crashes Python. We downsize based on the notion of odds ratios, and evaluate performance with Naive Bayes & SVM.

## Analysis

- `PlotsGenerator.rmd`: R-markdown code in which we construct all plots used in the paper. Dependencies are in `Rstart.R`. We chose to do this in R as ggplot2 yields nice plots.

- All plots are committed to as PDFs. 

