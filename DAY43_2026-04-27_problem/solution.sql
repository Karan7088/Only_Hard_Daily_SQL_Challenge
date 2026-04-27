 WITH BASE AS(select O.ORDER_ID,o.product_id,ROW_NUMBER() OVER(PARTITION BY PRODUCT_ID,PRICE_CHARGED,O.ORDER_TIME 
ORDER BY P.START_TIME DESC ) RN,o.price_charged,p.price as actual_price,O.ORDER_TIME,
P.START_TIME,P.END_TIME
 ,case when o.price_charged is not null and p.price
 is not null then (p.price- o.price_charged)*QUANTITY else 'IGNORE' END as leakage FROM ORDERS O INNER JOIN product_price_history
 P ON P.PRODUCT_ID=O.PRODUCT_ID AND O.order_time >= P.start_time AND 
(O.order_time < P.end_time OR P.end_time IS NULL) ORDER BY 1)
-- SELECT * FROM BASE;

SELECT ORDER_ID, PRODUCT_ID,PRICE_CHARGED,ACTUAL_PRICE,LEAKAGE FROM BASE WHERE RN=1 AND ACTUAL_PRICE!=PRICE_CHARGED ORDER BY ORDER_ID 
 ;
