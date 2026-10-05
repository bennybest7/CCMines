local custom = false
while true do
    term.setBackgroundColor(colors.cyan)
    term.clear()
    term.setCursorPos(1,1)
    term.setTextColor(colors.black)
    print("CCMines v1.0 | Made by Bennybest7")
    paintutils.drawFilledBox(15,5,36,12,colors.white)
    term.setCursorPos(15,5)
    
    print("Choose difficulty:")
    term.setBackgroundColor(colors.green)
    term.setCursorPos(16,7) 
    print("        Easy        ")
    term.setBackgroundColor(colors.blue)
    term.setCursorPos(16,8)
    print("       Medium       ")
    term.setBackgroundColor(colors.red)
    term.setCursorPos(16,9)
    print("        Hard        ")
    term.setCursorPos(36,5)
    print("x")
    term.setBackgroundColor(colors.lightGray)
    term.setCursorPos(16,11)
    print("   -Coming Soon!-   ")
    
    
    local event,button,x,y = os.pullEvent("mouse_click")
    if x >= 16 and x <= 35 then
        if y == 7 then
            map_size_x = 14
            map_size_y = 12
            break
        elseif y == 8 then
            map_size_x = 22
            map_size_y = 16
            break
        elseif y == 9 then
            map_size_x = 51
            map_size_y = 16
            break
        end   
    end
end



mines = 0
flags = 0
game = "living"
--map_size_x = 50
--map_size_y = 15

bomb_chance = math.floor(100/math.sqrt(map_size_x*map_size_y))+3
term.setBackgroundColor(colors.cyan)
term.clear()







function setColor(x,y)
    local num = map[y][x].neighbours
    if num == 0 then
        term.setTextColor(colors.white)
    elseif num == 1 then
        term.setTextColor(colors.blue)
    elseif num == 2 then
        term.setTextColor(colors.green)
    elseif num == 3 then
        term.setTextColor(colors.red)
    elseif num == 4 then
        term.setTextColor(colors.purple)
    elseif num == 5 then
        term.setTextColor(colors.orange)
    elseif num == 6 then
        term.setTextColor(colors.cyan)
    elseif num == 7 then
        term.setTextColor(colors.pink)
    elseif num == 8 then
        term.setTextColor(colors.lime)
    end
end

function draw(size_x,size_y)
    
    --draw top bar
    paintutils.drawLine(1,1,size_x,1,colors.blue)
    term.setTextColor(colors.white)
    term.setCursorPos(1,1)
    print("Mines left: "..mines-flags)
    term.setBackgroundColor(colors.lightGray)
    term.setTextColor(colors.gray)
    for y = 1,size_y do
        term.setCursorPos(1,y+1)
        for x = 1,size_x do
            if map[y][x].uncovered == 1 or game == "over" then
                term.setBackgroundColor(colors.white)
                if map[y][x].mine == 0 then
                    setColor(x,y)
                    io.write(map[y][x].neighbours)
                else
                    term.setTextColor(colors.black)
                    io.write("*")
                end
            else
                if map[y][x].flag == 0 then
                    term.setBackgroundColor(colors.lightGray)
                    term.setTextColor(colors.gray)
                    io.write("O")
                else
                    term.setBackgroundColor(colors.lightGray)
                    term.setTextColor(colors.red)
                    io.write("F")
                end
            end
        end
    end
end
function getNeighbours(x,y,size_x,size_y)
    local neighbours = 0
    if x > 1 and y > 1 then
        if map[y-1][x-1].mine == 1 then
            neighbours = neighbours + 1
        end
    end
    if y > 1 then    
        if map[y-1][x].mine == 1 then
            neighbours = neighbours + 1
        end
    end 
    if y > 1 and x < size_x then   
        if map[y-1][x+1].mine == 1 then
            neighbours = neighbours + 1
        end
    end
    if x > 1 then    
        if map[y][x-1].mine == 1 then
            neighbours = neighbours + 1
        end
    end
    if x < size_x then    
        if map[y][x+1].mine == 1 then
            neighbours = neighbours + 1
        end 
    end
    if x > 1 and y < size_y then   
        if map[y+1][x-1].mine == 1 then
            neighbours = neighbours + 1
        end
    end 
    if y < size_y then   
        if map[y+1][x].mine == 1 then
            neighbours = neighbours + 1
        end 
    end  
    if y < size_y and x < size_x then 
        if map[y+1][x+1].mine == 1 then
            neighbours = neighbours + 1
        end
    end    
    
    return neighbours
end


function generate(size_x,size_y)
    map = {}
    for i = 1,size_y do
        table.insert(map,{})
    end
    
    for y = 1,size_y do
        for x = 1,size_x do
            if math.random(1,bomb_chance) == 1 then
                map[y][x] = {mine=1,uncovered=0,flag=0}
                mines = mines + 1
            else
                map[y][x] = {mine=0,uncovered=0,flag=0}
            end
        end
    end
    
    --get neighbours
    for y = 1,size_y do
        for x = 1,size_x do
            map[y][x].neighbours = getNeighbours(x,y,size_x,size_y)
        end
    end
end

function uncoverCircle(x,y,ret,size_x,size_y)
    local action = 0
    if x > 1 and y > 1 then
        if map[y-1][x-1].uncovered == 0 and map[y-1][x-1].flag == 0 then
            map[y-1][x-1].uncovered = 1
            action = 1
        end
    end
    if y > 1 then    
        if map[y-1][x].uncovered == 0 and map[y-1][x].flag == 0 then
            map[y-1][x].uncovered = 1
            action = 1
        end
    end 
    if y > 1 and x < size_x then   
        if map[y-1][x+1].uncovered == 0 and map[y-1][x+1].flag == 0 then
            map[y-1][x+1].uncovered = 1
            action = 1
        end
    end
    if x > 1 then    
        if map[y][x-1].uncovered == 0 and map[y][x-1].flag == 0 then
            map[y][x-1].uncovered = 1
            action = 1
        end
    end
    if x < size_x then    
        if map[y][x+1].uncovered == 0 and map[y][x+1].flag == 0 then
            map[y][x+1].uncovered = 1
            action = 1
        end 
    end
    if x > 1 and y < size_y then   
        if map[y+1][x-1].uncovered == 0 and map[y+1][x-1].flag == 0 then
            map[y+1][x-1].uncovered = 1
            action = 1
        end
    end 
    if y < size_y then   
        if map[y+1][x].uncovered == 0 and map[y+1][x].flag == 0 then
            map[y+1][x].uncovered = 1
            action = 1
        end 
    end  
    if y < size_y and x < size_x then 
        if map[y+1][x+1].uncovered == 0 and map[y+1][x+1].flag == 0 then
            map[y+1][x+1].uncovered = 1
            action = 1
        end
    end
    if ret then
        return action
    end 
      
end
function checkMine(x,y)
    if map[y][x].mine == 1 and map[y][x].flag == 0 and map[y][x].uncovered == 1 then
        game = "over"
        
    end
end

function zeroSpread(size_x,size_y)
    --local continue = true
    for i = 1,30 do
        --continue = true
        for y = 1,size_y do
            for x = 1,size_x do
                if map[y][x].neighbours == 0 and map[y][x].uncovered == 1 then
                    --local found = true
                    uncoverCircle(x,y,false,size_x,size_y)
                    
                        
                    --end
                end
            end
        end
        --if not found then break end
    end
    --return continue
end
generate(map_size_x,map_size_y)
--open a random spot
while true do
    rand_x = math.random(1,map_size_x)
    rand_y = math.random(1,map_size_y)
    if map[rand_y][rand_x].mine == 0 and map[rand_y][rand_x].neighbours == 0 then
        map[rand_y][rand_x].uncovered = 1
        break
    end
    
end
zeroSpread(map_size_x,map_size_y)





while true do
    --local event,button,x,y = os.pullEvent("mouse_click")
    draw(map_size_x,map_size_y)
    if game == "over" then
        paintutils.drawFilledBox(15,5,36,7,colors.black)
        term.setTextColor(colors.red)
        term.setBackgroundColor(colors.black)
        term.setCursorPos(15,5)   --x
        print("      Game Over!     ")
        term.setTextColor(colors.white)
        term.setCursorPos(15,6)
        print("    Click anywhere   ")
        term.setCursorPos(15,7)
        print("       to exit.")
        os.pullEvent("mouse_click")
        term.setBackgroundColor(colors.black)
        term.setTextColor(colors.white)
        term.setCursorPos(1,1)
        term.clear()
        break
    elseif game == "won" then
        paintutils.drawFilledBox(15,5,36,7,colors.black)
        term.setTextColor(colors.green)
        term.setBackgroundColor(colors.black)
        term.setCursorPos(15,5)
        print("      You Won!!!     ")
        term.setTextColor(colors.white)
        term.setCursorPos(15,6)
        print("    Click anywhere   ")
        term.setCursorPos(15,7)
        print("       to exit.")
        os.pullEvent("mouse_click")
        term.setBackgroundColor(colors.black)
        term.setTextColor(colors.white)
        term.setCursorPos(1,1)
        term.clear()
        break
    end

    
    
    
    
    
    --mouse interaction
    local event,button,x,y = os.pullEvent("mouse_click")
    if button == 1 then
        map[y-1][x].uncovered = 1
        
    elseif button == 2 then
        if map[y-1][x].uncovered == 0 then
            if map[y-1][x].flag == 0 then
                map[y-1][x].flag = 1
            else
                map[y-1][x].flag = 0
            end
        end
    elseif button == 3 then
        if map[y-1][x].uncovered == 1 then
            uncoverCircle(x,y-1,false,map_size_x,map_size_y)
        end
    end
    --check for mines and flags
    flags = 0
    for check_y = 1,map_size_y do
        for check_x = 1,map_size_x do
            checkMine(check_x,check_y)
            if map[check_y][check_x].flag == 1 then
                flags = flags + 1
            end
        end
    end
    
    --zero spreading
    --for i = 1,10 do
        zeroSpread(map_size_x,map_size_y)
    --end
    
    
    --win detecttion
    local left = map_size_x*map_size_y-mines
    for check_y = 1,map_size_y do
        for check_x = 1,map_size_x do
            if map[check_y][check_x].uncovered == 1 then
                left = left - 1
            end
        end
    end
    if left == 0 then
        game = "won"
    end
end  


