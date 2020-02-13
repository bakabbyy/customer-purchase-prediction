# Customer Purchase Prediction

**Problem statement**: Can we determine who will become a customer based on user behavior?

For this project, I analyzed ~9M records of unique user actions from an online cosmetics storefront. Each record represents a unqiue action taken by the user in relation to a product that was interacted with. This data includes:

-  `event_time` - timestamp the event occurred.
- `event_type` - action taken by the user, including; viewing a product, adding a product to their cart, removing a product from their cart, and purchasing a product.
- `product_id` - identifier of the product interacted with.
- `category_id` - identifier of the product category.
- `category_code` - classification of the product.
- `brand ` - brand associated with the product.
- `price` - price of the product.
- `user_id` - identifier of the user. 
- `user_session` - UTM code of the session logged by the user.

## Getting Started

The data used for this project can be found on [Kaggle](https://www.kaggle.com/mkechinov/ecommerce-events-history-in-cosmetics-shop). 

Run the [data_prep.py](https://github.com/bakabrooks/customer-purchase-prediction/blob/master/src/data_prep.py) file to consolidate the user data and the [setup.sql](https://github.com/bakabrooks/customer-purchase-prediction/blob/master/src/setup.sql) file to create a database table with all user events.

## Built With

* [AWS EC2](https://aws.amazon.com/ec2/?nc2=h_ql_prod_fs_ec2) - Cloud computing service used for supervised learning models
* [PostgreSQL](https://www.postgresql.org/) - Relational database used for base and modeling data storage as well as feature engineering

## Files

[eda_feature_eng.ipynb](https://github.com/bakabrooks/customer-purchase-prediction/blob/master/eda_feature_eng.ipynb) shows the process of evaluating and cleaning the data as well as engineering of all features used for modeling. 

[modeling.ipynb](https://github.com/bakabrooks/customer-purchase-prediction/blob/master/modeling.ipynb) shows the process of training various supervised learning models, tuning the models and evaluating their effectiveness.



The slide deck for this project can be found [here](https://github.com/bakabrooks/customer-purchase-prediction/blob/master/slide_deck.pdf).