# Project McNulty Proposal - Predicting Customer Purchasing Window

## Project Overview 

Machine learning has revolutionized the e-commerce industry as business decisions involving marketing efforts and product decisions are now being made with greater accuracy. One of the most important applications of this is in customer analysis, mainly predicting customer behavior and churn. Being able to predict customer purchasing behavior has the potential to save companies thousands of dollars per year, as they are able to direct marketing efforts to particular customer segments and alleviate the cost of acquiring new users.
To demonstrate this, I will be using a dataset I found on [Kaggle](https://www.kaggle.com/mkechinov/ecommerce-behavior-data-from-multi-category-store#2019-Nov.csv) containing over 1M customer actions, including product views, adds to cart, removals from cart, and purchases. The dataset contains 9 features (detailed below), which I will use to segment customers by recency, frequency, and monetary value (RFM), to then predict when they will make their next purchase, if any.

## Features

| Feature       | Description                                                  |
| ------------- | ------------------------------------------------------------ |
| event_time    | Timestamp the event occurred                                 |
| event_type    | The action the customer took (view, add to cart, remove from cart, purchase) |
| product_id    | Unique identifier of the product                             |
| category_id   | The unique identifier of the product category                |
| category_code | The categorical classification of the product that was interacted with |
| brand         | The brand name of the product                                |
| price         | The price of the product that was interacted with            |
| user_id       | The unique identifier of the user that took the action       |
| user_session  | The unique identifier of the session in which the user acted |

