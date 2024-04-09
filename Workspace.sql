-- Assignment 9-5: Processing Discounts
-- Brewbean’s is offering a new discount for return shoppers: Every fifth completed order gets a
-- 10% discount. The count of orders for a shopper is placed in a packaged variable named
-- pv_disc_num during the ordering process. This count needs to be tested at checkout to
-- determine whether a discount should be applied. Create a trigger named BB_DISCOUNT_TRG
-- so that when an order is confirmed (the ORDERPLACED value is changed from 0 to 1), the
-- pv_disc_num packaged variable is checked. If it’s equal to 5, set a second variable named
-- pv_disc_txt to Y. This variable is used in calculating the order summary so that a discount is
-- applied, if necessary.
-- Create a package specification named DISC_PKG containing the necessary packaged
-- variables. Use an anonymous block to initialize the packaged variables to use for testing the
-- trigger. Test the trigger with the following UPDATE statement:
-- UPDATE bb_basket
-- SET orderplaced = 1
-- WHERE idBasket = 13;
-- If you need to test the trigger multiple times, simply reset the ORDERPLACED column to 0
-- for basket 13 and then run the UPDATE again. Also, disable this trigger when you’re finished so
-- that it doesn’t affect other assignments.
CREATE OR REPLACE PACKAGE DISC_PKG AS
  pv_disc_num NUMBER;
  pv_disc_txt VARCHAR2(1);
END DISC_PKG;
/

CREATE OR REPLACE TRIGGER BB_DISCOUNT_TRG AFTER
  UPDATE OF orderplaced ON bb_basket FOR EACH ROW
BEGIN
  IF :NEW.orderplaced = 1 THEN
    IF DISC_PKG.pv_disc_num = 5 THEN
      DISC_PKG.pv_disc_txt := 'Y';
    END IF;
  END IF;
END;
/

BEGIN
  DISC_PKG.pv_disc_num := 5; -- Set the count of orders for testing
  DISC_PKG.pv_disc_txt := 'N'; -- Initialize pv_disc_txt
END;
/

UPDATE bb_basket
SET
  orderplaced = 1
WHERE
  idBasket = 13;

ALTER TRIGGER BB_DISCOUNT_TRG DISABLE;

-- Assignment 9-6: Using Triggers to Maintain Referential Integrity
-- At times, Brewbean’s has changed the ID numbers for existing products. In the past, developers
-- had to add a new product row with the new ID to the BB_PRODUCT table, modify all the
-- corresponding BB_BASKETITEM and BB_PRODUCTOPTION table rows, and then delete the
-- original product row. Can a trigger be developed to avoid all these steps and handle the update
-- of the BB_BASKETITEM and BB_PRODUCTOPTION table rows automatically for a change in
-- product ID? If so, create the trigger and test it by issuing an UPDATE statement that changes the
-- IDPRODUCT 7 to 22. Do a rollback to return the data to its original state, and disable the new
-- trigger after you have finished this assignment.
CREATE OR REPLACE TRIGGER BB_PRODUCT_ID_UPDATE_TRG AFTER
  UPDATE OF IDPRODUCT ON BB_PRODUCT FOR EACH ROW
BEGIN
 -- Update BB_BASKETITEM table
  UPDATE BB_BASKETITEM
  SET
    IDPRODUCT = :NEW.IDPRODUCT
  WHERE
    IDPRODUCT = :OLD.IDPRODUCT;
 -- Update BB_PRODUCTOPTION table
  UPDATE BB_PRODUCTOPTION
  SET
    IDPRODUCT = :NEW.IDPRODUCT
  WHERE
    IDPRODUCT = :OLD.IDPRODUCT;
END;
/

UPDATE BB_PRODUCT
SET
  IDPRODUCT = 22
WHERE
  IDPRODUCT = 7;

ROLLBACK;

ALTER TRIGGER BB_PRODUCT_ID_UPDATE_TRG DISABLE;
