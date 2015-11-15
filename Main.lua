-- paperSeller simulation
-- Written by Omid Yaghoubi
-- deopenmail@gmail.com
-- Simulation Home Work , fall 2015
-- Made With Codea

-- page 46 



function setup()
    myInit()
    
    -- initial conditions
    paper={}
    paper["price"]={}
    paper.price["buy"]=13
    paper.price["sell"]=20
    paper.price["outOfDate"]=2
    -- paper man can buy 10 , 20 , 30 , 50 ... papers
    -- paper man can buy 10*X pack of papers
    -- point: best amount off papers to buy
    
    -- ============== day ================================
    day={}
    day["chance"]={}
    day["chance"]["good"]=0.35
    day["chance"]["med"]=0.45
    day["chance"]["bad"]=0.20
    function day:rndDay()
        return generateRandomWithChance(day["chance"])
    end
    -- ===================================================
    
    -- ============= demand ==============================
    demand={}
    demand["good"]={}
    demand["med"]={}
    demand["bad"]={}
    
    demand.good["chance"]={}
    demand.med["chance"]={}
    demand.bad["chance"]={}
    
    demand.good.chance[40]=0.03
    demand.good.chance[50]=0.05
    demand.good.chance[60]=0.15
    demand.good.chance[70]=0.20
    demand.good.chance[80]=0.35
    demand.good.chance[90]=0.15
    demand.good.chance[100]=0.07
    
    demand.med.chance[40]=0.1
    demand.med.chance[50]=0.18
    demand.med.chance[60]=0.4
    demand.med.chance[70]=0.2
    demand.med.chance[80]=0.08
    demand.med.chance[90]=0.04
    demand.med.chance[100]=0.0

    demand.bad.chance[40]=0.44
    demand.bad.chance[50]=0.22
    demand.bad.chance[60]=0.16
    demand.bad.chance[70]=0.12
    demand.bad.chance[80]=0.06
    demand.bad.chance[90]=0.00
    demand.bad.chance[100]=0.00
    
    function demand.good:rndDemand()
        return generateRandomWithChance(demand.good["chance"])
    end
    
    function demand.med:rndDemand()
        return generateRandomWithChance(demand.med["chance"])
    end
    
    function demand.bad:rndDemand()
        return generateRandomWithChance(demand.bad["chance"])
    end
    
    -- END Initial canditions =================================

    buyAmountStep=1
    parameter.integer("countOfDays",1,1000)
    parameter.watch("bestBuyAmountWithProfit")
    parameter.action("reset",reset)
     
    maxBuyAmount=100
    countOfDays=365
    lastCountOfDays=0
    maxProfitPerDay=0
    bestBuyAmountWithProfit=""
    profitPerDayList={}
    
end

function reset()
    maxProfitPerDay=0
    buyAmount=0
    profitPerDayList={}
end

function draw()
    myDrawInit()
    
    if lastCountOfDays~=countOfDays then
        lastCountOfDays=countOfDays
        reset()
    end
    
    if buyAmount<=maxBuyAmount then buyAmount=(buyAmount+buyAmountStep) end
    
    drawBorder(round(buyAmount))
    

    if buyAmount<=maxBuyAmount then
        sumProfit=0
        for dayCounter=1,countOfDays do
            
            currentDay=day.rndDay()
            currentDemand=demand[currentDay].rndDemand()
            deposit,moneyLossForBuying=buyPaper(buyAmount)
            deposit,moneyEarnFromSelling=sellPaper(currentDemand,deposit)
            moneyEarnFromOutOfDates=0
            profitLoss=0
            if deposit>0 then
                moneyEarnFromOutOfDates=sellOutOfDatePaper(deposit)
                --print(moneyEarnFromOutOfDates.." , ",deposit) -- for debug porpus
            else
                profitLoss=math.abs(deposit)*( paper.price.sell - paper.price.buy)
                --print(profitLoss) -- for debug porpus
            end --end if
                
            profit=moneyEarnFromSelling-moneyLossForBuying-profitLoss+moneyEarnFromOutOfDates
            sumProfit=sumProfit+profit
            
        end -- end loop ( from day 1 to countOfDays for example 1 year )
        -- calcuate mean:
        profitPerDay=sumProfit/countOfDays
        
        if profitPerDay>maxProfitPerDay then
            maxProfitPerDay=profitPerDay 
            bestBuyAmountWithProfit="buyAmount:"..buyAmount.." profitPerDay:"..round(profitPerDay)
        end -- end if profit ...
        
        profitPerDayList[buyAmount]=profitPerDay
    end -- end if buy amount reach to max
    
    
    lastX=buyAmountStep
    lastY=profitPerDayList[buyAmountStep]
    for x,y in pairs(profitPerDayList) do
        --print(x,y) --debug porpuse
        normedX=norm { curr={val=x,max=buyAmount},norm={max=500} }
        normedY=norm { curr={val=y,max=maxProfitPerDay},norm={max=450} }
        
        if y==maxProfitPerDay then
            text(round(y).." buyAmount:"..x,normedX,normedY+15)
        end
        lineWithWidth(lastX,lastY,normedX,normedY,2)
        point(normedX,normedY,1+norm{curr={val=y,max=maxProfitPerDay},norm={max=7}} )
        lastX=normedX
        lastY=normedY
    end
    
    
    
end


-- Actions =======================================================
function buyPaper(amount)
    newDeposit=amount
    return newDeposit,(paper.price.buy*amount)
end

function sellPaper(amount,yourDeposit)
    result=math.min(amount,yourDeposit)
    newDeposit=yourDeposit-amount -- could be a negative number
    return newDeposit,(result*paper.price.sell)
end

function sellOutOfDatePaper(amount)
    return amount*paper.price.outOfDate
end
-- Actions =======================================================

