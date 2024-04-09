# Assignment #4 – Using Triggers

# Question 1 – Assignment 9-5

Processing Discounts (5 marks)

Brewbean’s is offering a new discount for return shoppers: Every fifth completed order gets a
10% discount. The count of orders for a shopper is placed in a packaged variable named
pv_disc_num during the ordering process. This count needs to be tested at checkout to determine
whether a discount should be applied. Create a trigger named BB_DISCOUNT_TRG so that
when an order is confirmed (the ORDERPLACED value is changed from 0 to 1), the
pv_disc_num packaged variable is checked. If it’s equal to 5, set a second variable named
pv_disc_txt to Y. This variable is used in calculating the order summary so that a discount is
applied, if necessary.
Create a package specification named DISC_PKG containing the necessary packaged variables.
Use an anonymous block to initialize the packaged variables to use for testing the trigger. Test
the trigger with the following UPDATE statement:

``` sql
UPDATE bb_basket
 SET orderplaced = 1
 WHERE idBasket = 13;

```

If you need to test the trigger multiple times, simply reset the ORDERPLACED column to 0 for
basket 13 and then run the UPDATE again. Also, disable this trigger when you’re finished so
that it doesn’t affect other assignments.

# Question 2 – Assignment 9-6

Using Triggers to Maintain Referential Integrity (5 marks)

At times, Brewbean’s has changed the ID numbers for existing products. In the past, developers
had to add a new product row with the new ID to the BB_PRODUCT table, modify all the
corresponding BB_BASKETITEM and BB_PRODUCTOPTION table rows, and then delete the
original product row. Can a trigger be developed to avoid all these steps and handle the update of
the BB_BASKETITEM and BB_PRODUCTOPTION table rows automatically for a change in
product ID? If so, create the trigger and test it by issuing an UPDATE statement that changes the
IDPRODUCT 7 to 22. Do a rollback to return the data to its original state, and disable the new
trigger after you have finished this assignment.
