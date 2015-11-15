
function myInit()
    --showKeyboard()
end

function getSum(tbl)
    local sum=0
    for i=1,#tbl do sum=sum+tbl[i] end
    return sum
end

function myDrawInit()
    background(40, 40, 50)
    strokeWidth(1)
    translate(WIDTH/10,HEIGHT/3.3)
end

function drawBorder(xLimit)
    pushStyle()
    stroke(255, 255, 255, 255)
    noSmooth()
    line(0,0,500,0);text(xLimit,560,-10)
    line(0,0,0,500);
    popStyle()
end

function getMean(tbl)
    local sum=0
    for i=1,#tbl do sum=sum+tbl[i] end
    return sum/#tbl
end


function getVariance(tbl) 
    
    local mean=getMean(tbl)
    local res=0
    for i=1,#tbl do res=res+((tbl[i]-mean)^2) end
    res=res/#tbl
    
    return res
    
end

function norm(args)
    -- miniMax normalization
    args.curr.min=args.curr.min or 0
    args.norm.min=args.norm.min or 0
    return args.norm.min+(args.norm.max* ( (args.curr.val-args.curr.min)/args.curr.max) )
end -- end norm

function round(num)
    local res=num*100
    res=math.floor(res)
    return (res/100)
end

function point(x,y,width)
    pushStyle()
    stroke(134, 56, 56, 255)
    strokeWidth( width or 2 )
    line(x,y,x,y)
    popStyle()
end


function lineWithWidth(x1,y1,x2,y2,width)
    pushStyle()
    stroke(103, 138, 160, 255)
    strokeWidth( width or 2 )
    line(x1,y1,x2,y2)
    popStyle()
end

function keyboard(key)
    if tostring(key)=='q' or tostring(key)=='Q' then
        close()
    end
end
