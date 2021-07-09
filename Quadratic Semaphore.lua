
instrument { name = "Quadratic Semaphore", overlay = true, icon="indicators:ATR" }
p = input(6)
length = input(30)
x1 = bar_index
x2 = sqrt(x1)
y = high

S11 = sum(x2,length) - sqrt(sum(x1,length)) / length  
S12 = sum(x1*x2,length) - (sum(x1,length) * sum(x2,length)) / length  
S22 = sum(sqrt(x2),length) - sqrt(sum(x2,length)) / length            
Sy1 = sum (y*x1,length) - (sum(y,length) * sum(x1,length)) / length   
Sy2 = sum (y*x2,length) - (sum(y,length) * sum(x2,length)) / length   

max1 = sma(x1,length) 
max2 = sma(x2,length)
may = sma(y,length)
b2 = ((Sy1 * S22) - (Sy2*S12))/(S22*S11 - sqrt(S12))
b3 = ((Sy2 * S11) - (Sy1 * S12))/(S22 * S11 - sqrt(S12))
b1 = may - b2*max1 - b3*max2
qr = b1 + b2*x1 + b3*x2

yl = low

Sy1l = sum(yl*x1,length) - (sum(yl,length) * sum(x1,length)) / length  
Sy2l = sum(yl*x2,length) - (sum(yl,length) * sum(x2,length)) / length  

mayl = sma(yl,length)
b2l = ((Sy1l * S22) - (Sy2l*S12))/(S22*S11 - sqrt(S12))
b3l = ((Sy2l * S11) - (Sy1l * S12))/(S22 * S11 - sqrt(S12))
b1l = mayl - b2l*max1 - b3l*max2
qrl = b1l + b2l*x1 + b3l*x2

period = round(p/2)+1
hh = qr[period]
ll = qrl[period]
countH = 0
countL = 0
buy=0
sell=0

for i=0,period-1 do
    if qr[i]<hh then countH =countH+1 return end
    if qrl[i]>ll then countL =countL+1 return end
   
end
        

for i = period+1 , p+1 do
    if qr[i]<hh then countH = countH+1 return end
    if qrl[i]>ll then countL =countL+1 return end
    
end

if countH==p then
    pivotH = high[period]
    buy = true
  
end

    
if countL==p then
    pivotL = low[period]
    sell = true 
    
end
   
plot_shape(buy, "long", shape_style.triangleup, shape_size.large, 'green', shape_location.belowbar,0,'BUY', 'green')
plot_shape(sell , "short", shape_style.triangledown, shape_size.large, 'red', shape_location.abovebar,0,'SELL', 'red')