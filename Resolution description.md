# Risk analyst – Position case

Olá, tudo bem?
Me chamo Renato Pires e sou candidato a vaga de **Risk Analyst** da **CloudWalk**.

Nesse espaço, detalho as soluções e análises utilizadas no case proposto. Seguindo um gosto pessoal, procuro sempre abordar meus trabalhos de forma detalhada, explorando opções e sendo o mais assertivo possível e valorizando as ferramentas disponíveis que encontro e confio. Dessa forma, decidi me aperfeiçoar nos conhecimentos e tecnicas requeridas, por meio de alguns cursos da Udemy. Acredito ser importante lista-los para complementar minha jornada:

 - [Payment Risk 101](https://www.udemy.com/course/payment-and-payment-fraud/)
 - [Fraud Prevention, Dispute Resolution and PCI-DSS Masterclass](https://www.udemy.com/course/fraud-prevention/)
 - [Fraud Risk Analytics (Excel & AI based tools) and Prevention](https://www.udemy.com/course/fraud-risk-analytics-and-prevention/)

Para as duas primeiras sessões, a proposta de abordagem e possível solução são apresentados em texto corrido, imagens e diagramas.
Para a terceira sessão, visando a fidelização a ferramentas reais, utilizei de um servidor dedicado do Google Cloud para armazenas os dados apresentados, MySQL para visualizar a tabela de acordo com os requisitos que acredito serem necessários e utilizo de um notebook Jupyter para complementar a análise de dados e gerar visualizações que credibilizam minha análise.

Visando manter o  estabelecido na entrevista e no material do case, tanto as soluções, comentários e análise de dados foram mantidos em inglês.

## **Understanding the industry**

1.1 **Explain the money flow, the information flow and the role of the main players in the payment industry.**

Solution: For this situation, I've considered the following assumptions:
— Open Loop system;
— Pull payment method;
— There's a Payment gateway or processor;
— There's both an issue bank and acquirer bank.
— Both flows happen at the same time.

The money flow can be summarized in the following steps:
1.  Cardholder provides the payment card information to the merchant.
2.  Merchant sends the transaction information to the payment gateway/processor for authorization and settlement.
3.  Payment gateway/processor sends the transaction information to the acquirer bank.
4. Acquirer bank sends the transaction information to the card network for authorization.
5.  The card network contacts the card issuer (or issuer bank) to verify the availability of funds and authorize the transaction.
6.  If the transaction is approved, the card network sends an authorization response back to the acquirer bank.
7.  The acquirer bank settles the transaction with the merchant, deducting a transaction fee and the issue bank pays the acquirer bank for the transaction, minus the transaction fee.

The information flow, it can be summarized in the following steps:
1.  The cardholder provides the card information to the merchant.
2.  The merchant sends the transaction information to the payment gateway/processor.
3.  Payment gateway/processor sends the transaction information to the acquirer bank.
4. Acquirer bank sends the transaction information to the card network for authorization.
5.  Card network contacts the card issuer (or issuer bank) to verify the availability of funds and authorize the transaction.
6.  Either approved or denied, the card network sends an authorization response back to the acquirer bank.

The main players in the payment industry and their roles:
 - Cardholder— individual who owns the payment card and uses it to make
   purchases. 
 - Merchant — business that accepts payment cards as a form of
   payment from the cardholder. 
- Issue bank — financial institution that issues the payment card to the cardholder.
-  Acquirer bank — financial institution that facilitates the transaction between the merchant and
   the issue bank.
- Card network — company that operates the payment card
   network and enables transactions between the issue bank and the
   merchant. 
- Payment gateway (or processor) — company that acts as a
   mediator between the merchant and the acquirer bank, facilitating the
   transaction and providing security measures to protect the
   cardholder's information.

1.2 **Explain the difference between acquirer, sub-acquirer and payment gateway, and how
the flow explained in the previous question changes for these players.**

Solution: For this situation, I've considered the following assumptions:
— Open Loop system;
— Pull payment method;
— There's a Payment gateway or processor;
— There's both issue bank, acquirer bank and sub-acquirer;
— Both flows happen at the same time.

The money flow works as follows:
1.  Cardholder provides the payment card information to the merchant.
2.  Merchant sends the transaction information to the payment gateway/processor for authorization and settlement.
3.  Payment gateway/processor sends the transaction information to the sub-acquirer.
4.  Sub-acquirer sends the transaction information to the acquirer bank.
5.  Acquirer bank sends the transaction information to the card network (such as Visa or Mastercard) for authorization.
6.  Card network contacts the issue bank to verify the availability of funds and authorize the transaction.
7.  Either approved or denied, the card network sends an authorization response back to the acquirer bank.
8.  If approved, the acquirer bank settles the transaction with the merchant, deducting a transaction fee and the Issuer bank pays the acquirer bank for the transaction, minus the transaction fee.

The information flow works as follows:
1.  Cardholder provides the payment card information to the merchant.
2.  Merchant sends the transaction information to the payment gateway/processor.
3.  Payment gateway/processor sends the transaction information to the sub-acquirer.
4.  Sub-acquirer sends the transaction information to the acquirer bank.
5.  Acquirer bank sends the transaction information to the card network for authorization.
6.  Card network contacts the issue bank to verify the availability of funds and authorize the transaction.
7.  If the transaction is approved, the card network sends an authorization response back to the acquirer bank. If not approved, the acquirer sends a deny message to the merchant.

Main players in the payment industry and their roles:

 - Cardholder— individual who owns the payment card and uses it to make
   purchases. 
 - Merchant — business that accepts payment cards as a form of
   payment from the cardholder. 
- Issue bank — financial institution that issues the payment card to the cardholder.
-  Acquirer bank — financial institution that facilitates the transaction between the merchant and
   the issue bank.
- Card network — company that operates the payment card
   network and enables transactions between the issue bank and the
   merchant. 
- Payment gateway (or processor) — company that acts as a
   mediator between the merchant and the acquirer bank, facilitating the
   transaction and providing security measures to protect the
   cardholder's information.
 - Sub-acquirer – Bank that processes transactions on behalf of the acquirer bank and is responsible for settling transactions with the merchants.

1.3 **Explain what chargebacks are, how they differ from a cancellation and what is the
connection with fraud in the acquiring world.**
Solution:
Chargeback is a term used to describe a transaction that is reversed due to a dispute between the cardholder and the merchant. It occurs when a cardholder disputes a transaction with their issuing bank and requests that the funds be returned. This can occur for a variety of reasons:
 - fraud related issue,  
 - unauthorized transactions,  
 - processing or authorization error, 
 -  customer unsatisfaction with a product or service 
 - undelivered product claim.

A cancellation is a voluntary action initiated by the merchant to terminate a transaction that has not yet been completed or processed. This can happen before the transaction has been authorized, settled or cleared. Cancellations do not involve a dispute between the cardholder and the merchant, and are typically processed without issue.

Cancellations and refunds, are initiated by the merchant and are a voluntary return of funds to the cardholder. 

Also related, a refund is a return of funds to the cardholder after the transaction has been completed and processed. Refunds are usually initiated by the merchant in response to a request from the cardholder, and involve the return of funds to the cardholder's account. Unlike cancellations, which occur before a transaction is completed, refunds take place after the transaction has been processed, and the funds already transferred.

Unlike chargebacks, which are initiated by the cardholder and involve a dispute, cancellations, or refunds need to be agreed by both parties and are typically processed without issue.

By the acquiring side, payment gateway/processor plays a key role in processing chargebacks and refunds. The payment gateway acts as the intermediary between the merchant, acquiring bank, and card networks, and is responsible for processing transactions and ensuring the transfer of funds. If a chargeback is initiated, the payment gateway will work with the acquiring bank and the card network to process the dispute and return the funds to the cardholder if necessary.

The sub-acquirer are responsible for processing transactions on behalf of the acquiring bank. Sub-acquirer may work with the payment gateway to resolve disputes and process chargebacks, and may also be responsible for assessing and mitigating the risk of fraud.

Chargebacks are related with fraud in the acquiring world because they are often used as a way for cardholders to dispute unauthorized transactions or other fraudulent activities. As a result, chargebacks can be seen as an indicator of potential fraud, so merchants and acquiring banks may use this information to identify and prevent future fraudulent activities.

Chargebacks have a significant impact on merchants, as they can result in the return of funds and additional fees, as well as damage to their reputation and payment processing capabilities. As a result, it is important for merchants to have effective fraud prevention strategies in place to minimize the risk of chargebacks and associated losses. Security Systems such as 3DS 2.0 and OTP mostly helps to reduce the unauthorized transactions volume and consequently frauds.


##  **Solve the problem**

 2. **A client sends you an email asking for a chargeback status. You check the system, and see that we have received his defense documents and sent them to the issuer, but the issuer has not accepted our defense. They claim that the cardholder continued to affirm that she did not receive the product, and our documents were not sufficient to prove otherwise.
You respond to our client informing that the issuer denied the defense, and the next day he emails you back, extremely angry and disappointed, claiming the product was delivered and that this chargeback is not right.
Considering that the chargeback reason is “Product/Service not provided”, what would you do in this situation?**

Solution:

For this problem, I've decided to first gather the specific resolutions guidelines for this code on Visa and Mastercard, since those are the biggest players on the payment systems in Brazil. Is noticible that this kind of chargeback is one of the main cause of friendly fraud, which requires a deep analysis based on patterns and information available. 
Considering the information presented, the chargeback loss probably will be laid on the merchant, since the problem mostly points out for a transaction without the card present.
In this case, Visa displays the code **13.1 – Merchandise/Services Not Received** and Mastercard provides the code  **4853 - Goods or Services Not Provided**. In both codes, the overall guideline is almost the same, which can be seen on the image below:
Mostly the chargeback guides provide the following guideline for this specific code:

![Conditions to chargeback of product not delivered](https://i.imgur.com/atuVeXY.png)

The frameworks of chargebacks are shown bellow.
Besides of not showing the payment gateway or sub-acquierer role, the framewoks are effective in presenting the steps of this process.

![First attempt flow](https://i.imgur.com/f9Bx290.jpg)
 
 Here we can see the first attempt of settle the chargeback dispute. By the problem description, all the steps have occurred and the issuing bank already decided in favor of the cardholder. This could mean that the description of the merchant wasn't enough to show he's right. Since he claimed that the provided the service, it means that the merchant is requesting arbitration of the decision, leading to the second framework; 
 ![Second attempt flow](https://i.imgur.com/IxMN1dC.jpg)
This framework represents the current state of the problem, where the cardhold may have provided new evidence on the case. Now, my action would be to first check the data available, to find patterns that may help this case.

 - Does the cardholder had previous chargebacks?
 - Was the product/service bought for the first time on this merchant or the cardholder is a regular?
 - Does the merchant have many chargeback claims? If yes, what are the charback codes?
 - It this the first purchase of the cardholder?
 - Is the transaction amount an outlier according to the cardholder's past transactions?
 - Was the transaction held by the same devide of others purchases of this cardholder?

Besides from data, checking the documentation of this chargeback process is a must, since the first step wasn't accepted.

 - Did the cardholder tried to resolve the issue with the merchant before the chargeback process?
 - Was the delivery estimated date provided?
 - Did the delivery was received by someone? Did this person signed the delivery?
 - The delivery company provided any proof of attempt to delivery the product?
 - Did the delivery company had any contact with the cardholder regarding delivery?
 
By gathering all this information and running again the contact with the merchant, the step is to approve the proccess and send to issuing bank to process and review the process.
 If after all this data and information is presented and the chargeback is still decided in favor of the the cardholder, there's still a last attempt of dispute, which requires that us initiate once again an arbitration. The following framework illustrate the process:

![Final attempt flow](https://i.imgur.com/bl8mJqr.jpg)


## Get your hands dirty
For this analysis, was used MySQL Workbench, Jupyter Notebook and Google Cloud platform.
 
At glance, considering that we only need the CSV file and this dataset was stored on a gist GitHub repository, it could be cloned, downloaded or extracted by URL request. I've decided to progress by using a URL request, which can be seen on “get_data.ipynb”, leading to a “transactional-sample.csv”.
The database and table creation was done by using MySQL Workbench after getting an instance on Google SQL ready to use. A proper user was used, to avoid confusion with the root properties.
 
The dataset was loaded into an instance, by using a bucket on Google Cloud Platform. Getting an external server connection leads to a better performance for the queries and allows the most secure way to import data on Jupyter and MySQL at the same time, without risk of losing any information. 

Although mostly of the data explorantion and visualization being handle on jupyter by using seaborn and pandas, I've used a rule-based on SQL to ensure that both files had some analysis within.

3.1 **Analyze the data provided and present your conclusions. What
   suspicious behaviors did you find? What led you to this conclusion?** 
   
Solution: My conclusion rely mostly on data analysis and visualization combined with previous statistical knowledge. The topics displays patters encountered and conclusions made.
 - The most of the transactions occur 12pm to 09pm, following a histogram graph analysis.
 - Between Friday, Saturday and Sunday mostly transactions occur. But the histogram shows that the distribution of fraud activity is well patterned during the whole week days, while the normal transactions display a mostly random distribution.
 - The benford's Law display that the whole dataset mostly represents a normal (real) dataset distribution, where the values of low numers (1 to 5) is close to the recommendation. When checking only the chargeback data, the benford's Law is not followed, which reinforces the fraud behaviour.
 - Fraudulent transactions are far away from a normal distribution, which implies that mostly the variance of this cases are high.
 - Normal transactions rely something close to a qui-quadratic distribution, displaying a very usual patern, where most of the transactions are concentrated on the left side on the data, with a visible assymetric schema.
 - By comparing two box-plots, is seen that the normal transactions have the last quartile around $1700 and fraud transactions have the last quartile around $2200. Also, the median of frauds stays above the thid quartile of a normal transaction. As seen on the graph, mostly high value normal transactions are outliers that occur after $1700, which indicates that from this value, it's likely to pay attention on the transaction details and may run a security check.
 - When checking the cards that already had the fraud label, it's seen that chargebacks may occur in a short period of time, and in the same merchant, but it does't follow a rule. It the dataset, at least 109 cards had a fraud transaction with more than one transaction on it's history, which means that sometimes even after one simple transaction, the fraud may occur on the second one.
 - Also checking the user with a high number of transactions that had at least one fraudulent chargeback, it seen that the practice repeats frequently. The highest account had 31 transactions with 25 labeled as fraud, which represents 80% of his transactions, and some other users had 100% of their transactions labeled as fraud.
 - Almost the same can be said about the card numbers, were 274 cards had at least a fraud flag on it. The highest one had 10 transactions and 10 fraud flags on it.
 - By the merchant side, the problem need to be investigated too, since there's always a chance of this frauds being related somehow by a bad practice of the business or even a fraud attempt by both parts (merchant and card-holder). 82 merchants had endured a chargeback process, with some of them having 100% of their transactions being labeled as fraud. This turn on a red light for them, leading to possible contact and investigation on possible problems or criminal activity. Some merchants may be using something as a "ghost customer"to create a fake invoice process and do money laundry.
 - Sometime the user does more than one purchase at a fast rate (in this case, 3 minutes was the cut), which is a important alert of fraud. For this situation, on SQL a query was set to define cards that had more than one transaction in a the set period of time and the query returned with  many card numbers that fits the fraud description. This type of handler is known as rule-based model.

3.2 **In addition to the spreadsheet data, what other data would you consider to find patterns
of possible fraudulent behavior?** 
 All the data related to consumer fraud, or any suiting data could be linked with the foreigh keys provided on the variables already presented at the transaction_sample, such as:

 -  **Address Verification System for online purchases**
 - **Which card network is responsible for the card**
 - **The credict card limit, and if the usage always follows the limit patter**
 -  **IP address of a card holder**
 - **Cardholder e-mail used on the purchase**
 - **Cardholder e-mail used on the issuer bank**
 -  **Cardholder gender, since models mostly point out that males are more likely to commit fraud**
 -  **Cardholder clusters, such as age or city**
 - **Cardholder Not due to payments, that occurred more than once**
 - **Merchant Information - Type of business and size**
 - **Chargeback code - for the payment system**
 - **Purchase processing details - Security check**
 - **Product details or SKU, to check if the product indeed exists**

3.3 **Considering your conclusions, what would you further suggest in order to prevent frauds and/or chargebacks?**
In the fraud management maturity, using constant training, having a full time team assessing fraud transactions, audicting the framework for fraud and having constact connection on the fraud detection team with other areas may provide a good approach to react on fraud, prevent and predict possible future frauds.

Using machine learning techniques along with accurated data analysis, can lead to less fraud and better risk assessment. Mostly models related to random-forrest and gradient optimization can deal mostly fraud if fed with the proper labelled data and supervised by someone who knows to to handle it outputs. In this case, I would consider using a Anomaly Detection Algorithms, since others data sources had a good result with this type of algorithm on credict card fraud assessment.

Also, providing a better security system along with proper usage can lead merchants to better handle struggles with chargeback. It's less likely to occuor a non-fraudulent chargeback when all the proper care is taken by the merchant and the conflict resolution is handle before the necessity of a chargeback appears.
