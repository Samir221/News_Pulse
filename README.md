# News_Pulse
A news curator app that relevant news articles with a personalized stock watchlist

# News Pulse

![Project Logo](logo.png)

## Table of Contents
1. [Introduction](#introduction)
2. [Backend Functionality](#backend-functionality)
3. [Client Functionality](#client-functionality)
4. [Future Improvements](#future-improvements)
5. [Prerequisites and Installation](#prerequisites-and-installation)
6. [License](#license)

<a name="introduction"></a>
## Introduction

News Pulse is an application that curates news articles for users based on their specific stock watchlist. Users can log in using their Google, Twitter, or Facebook accounts, view and manage their stock watchlist, and get relevant news articles for each stock. All user data, including the watchlist, is stored in Firebase.

<a name="backend-functionality"></a>
## Backend Functionality

The backend is built on Google Cloud Platform (GCP), using Google Cloud Functions and BigQuery. Here is how it works:

- News articles are fetched from the NewsAPI.
- These articles are then analyzed using a Python library called Langchain. This library utilizes a Language Model to analyze the description and contents of an article and returns which sectors are impacted by the news.
- The analyzed articles are meant to be stored in tabular format in BigQuery. (Note: This is currently a work in progress)

<a name="client-functionality"></a>
## Client Functionality

The client application is built in Flutter. Here is how it works:

- Users can log in using their Google, Twitter, or Facebook accounts.
- They can view their stock watchlist, with each stock's current price displayed.
- Stocks can be added or removed from the watchlist. 
- Holding down a stock on the watchlist will display all relevant news articles for that stock. (Note: This feature is currently a work in progress)

<a name="future-improvements"></a>
## Future Improvements

In future iterations of News Pulse, the following improvements are planned:

- Enhancements to the frontend design for better user experience.
- Implementation of a batch process that periodically downloads new articles, analyzes them, and stores them in BigQuery.

<a name="prerequisites-and-installation"></a>
## Prerequisites and Installation

The frontend of the application runs on Flutter, and the backend is all handled in Python through the cloud.

<a name="license"></a>
## License

This project is licensed under the terms of the MIT license.
