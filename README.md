# Customer_Lifetime_Value_Prediction_R
Prediction of Customer Life-time Value for an Auto Insurance Company using Multiple Linear Regression Model

Objective:-
For an Auto Insurance company, predict the customer life time value (CLV). CLV is the total revenue the client will derive from their entire relationship with a customer. 

Problem Statement: 
To examine which are the factors which influence,  Customer Lifetime Value (CLV) of Insurance Premium Company, based on the given attributes of the customer.

Business Context: 
What are the attributes of customer, who have a higher Customer Lifetime Value.

About the dataset:
The dataset has 9134 observations of 24 variables which are described as follows:

1. Customer: ID of a customer.
2. State: The state a customer belongs to.
3. Customer Lifetime Value: The total revenue the auto insurance company will derive from their entire relationship with a customer. 
4. Response: The response given by a customer.
5. Coverage: The type of coverage the insurance policy provides.	
6. Education: Education level of a customer.	
7. Effective To Date: Day of policy inception.
8. EmploymentStatus: The employment status of a customer.
9. Gender: Gender of a customer.
10. Income: Yearly income of employed customers.
11. Location Code: Location category of the place where a customer resides.
12. Marital Status: Maritus status of a customer.	
13. Monthly Premium Auto: Monthly Premium given by a customer for a policy.
14. Months Since Last Claim: Number of months passed since a customer has last claimed a policy.
15. Months Since Policy Inception: Number of months passed since a customer has bought a policy.
16. Number of Open Complaints: Number of unresolved complaints of a customer.	
17. Number of Policies: Number of policies a customer has bought till now.
18. Policy Type: Type of policy bought by a customer.
19. Policy: Type and tier of the policy bought by a customer.	
20. Renew Offer Type: The type of renewal offer offered to a customer for renewal of their policies.
21. Sales Channel: The type of sales channel through which a policy is sold to a customer.
22. Total Claim Amount: Total amount claimed by a customer from their policies till now.
23. Vehicle Class: Class of the vehicle the policy is meant for.
24. Vehicle Size: Size of the vehicle the policy is meant for.

The dependent variable is Customer Lifetime Value (CLV) which is continuous in nature. All other variables are independent. So Multiple Linear Regression is used to predict the dependent variable as well as identify which variables statistically explain the dependent the most.

Results obtained after running MLRM are given below:

FOR TRAIN DATA
- R-square: 30.54% and adjusted-R-square: 30.37% 
- BP test p-value < 0.00000000000000022. This means we reject the null hypothesis that the error is non-homogeneous.
- AD-test p-value < 0.00000000000000022. This means we reject the null hypothesis that the error values follow a normal distribution.
- DWT test p value is 0.852. This means We fail to reject the null hypothesis that the data is uncorrelated.
- MAPE value for train data is 35.45%. This means the train accuracy of the model is 64.55%

FOR TEST DATA
- R-square: 30.3% and adjusted-R-square: 30.04% 
- BP test p-value < 0.00000000000000022. This means we reject the null hypothesis that the error is non-homogeneous.
- AD-test p-value < 0.00000000000000022. This means we reject the null hypothesis that the error values follow a normal distribution.
- DWT test p value is 0.028. This means we reject the null hypothesis that the data is uncorrelated.
- MAPE value for test data is 36.16%. This means the test accuracy of the model is 63.84%

