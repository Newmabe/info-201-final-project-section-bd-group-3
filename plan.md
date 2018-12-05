# INFO 201 Final Project Section BD Group 3
## Project Proposal

# Project Description

### Dataset
The dataset we are working with contains information on hate crimes in the US based on press reports. It is located in a CSV file sourced from Kaggle, and individual pieces of data within it were collected from Google trends between 28 February 2017 to 16 August 2017. The dataset contains 3700 observations of the following features: Article Date, Article Title, Orgaization, City, State, URL, Keywords, Summary. One concern we have with the dataset is it only has information on reported hate crimes, and therefore is not an accurate representation of hate crimes themselves, but rather on the reporting of them. The dataset can be found [here](https://www.kaggle.com/team-ai/classification-of-hate-crime-in-the-us).

### Target Audience
This data could be useful to a variety of audiences, including but not limited to: media, law enforcement, politicians, and the general public. We will focus on the media, as this data set relies on news articles to record hate crimes. As a result, the data is most representative of reporting behaviors around hate crimes, and any conclusions can then be relayed back to the media to reflect on their reporting behaviors and methodologies.

### Questions

1. Where do the most hate crimes occur (or rather, where are most hate crimes reported)?
2. Are there certain time periods (months) during which hate crime reports seem to occur more/less frequently?
3. How does population density in cities affect reported hate crimes?

# Technical Description

### Final Project Format

Our current plan is to have the final project be an HTML page containing visualizations and our conclusions.

### Data Type

The data is contained in a static .csv file downloaded from Kaggle

### Data Wrangling

From the preview of the data on the website, it seems that some of the columns might be mislabeled, in which case we will have to figure out what the correct label is and rename the columns accordingly. Additionally, there might be null values within the dataset that we will need to account for.

### Libraries

The libraries we will likely be using are:
- R.util
- ggplot
- maps
- mapproj
- shiny

### Machine Learning and Analysis

We could attempt to predict locations for future hate crimes based on the current data set using machine learning. In addition, we could analyze the map to try to determine what areas hate crimes likely go unreported in.

### Challenges

Major challenges would likely be finding relevant insights from the data, as well as figuring out what types of interactive visualizations we can create. In addition, we are all busy people so figuring out a time to work on the project and evenly divide the workload is always a struggle in group projects.