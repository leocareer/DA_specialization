-- Level 1 Exercise 1
/* Your task is to design and create a table called "credit_card" that stores crucial details about 
credit cards. The new table must be able to uniquely identify each card and establish an appropriate 
relationship with the other two tables ("transaction" and "company"). After creating the table, 
you will need to enter the information from the document called "data_introduir_credit". 
Remember to show the diagram and make a brief description of it. */

-- Level 1 Exercise 2
/* The Human Resources department has identified an error in the account number of the user 
with ID CcU-2938. The information to be displayed for this record is: R323456312213576817699999. 
Remember to show that the change was made. */

-- Level 1 Exercise 3
/* In the "transaction" table, enter a new user with the following information: 
Id: 108B1D1D-5B23-A76C-55EF-C568E49A99DD
credit_card_id: CcU-9999
company_id: b-9999
user_id: 9999
lat: 829.999
longitude: -117.999
amount: 111.11
declined: 0	*/

-- Level 1 Exercise 4
/* From human resources you are asked to delete the "pan" column from the credit_*card table. 
Remember to show the change made. */

-- Level 2 Exercise 1
/* Delete the record with ID 02C6201E-D90A-1859-B4EE-88D2986D3B02 from the transaction table
in the database. */

-- Level 2 Exercise 2
/* The marketing department wants to have access to specific information to perform analysis and 
effective strategies. Requested to create a view that provides key details about companies and their 
transactions. You will need to create a view called VistaMarketing that contains the following 
information: Company name. Contact phone number. Country of residence Average purchase made by each
company. Presents the created view, sorting the data from highest to lowest purchase average. */

-- Level 2 Exercise 3
/* Filter the VistaMarketing view to show only companies that have their country of 
residence in "Germany" */

-- Level 3 Exercise 1
/* Next week you will have another meeting with the marketing managers. A colleague on your team 
made changes to the database, but he doesn't remember how he made them. He asks you to help him 
leave the commands executed to obtain the following diagram (look in repository) */

-- Level 3 Exercise 2
/* The company also asks you to create a view called "Technical Report" that contains 
the following information:
- Transaction ID;
- Name of the user;
- Surname of the user;
- IBAN of the credit card used;
- Name of the company of the transaction carried out;
- Be sure to include relevant information from both tables and use aliases to rename columns as needed;
Display the results of the view, sort the results in descending order based on
the transaction ID variable. */