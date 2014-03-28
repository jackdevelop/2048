--[[
战斗控制器
]]


local FightController = class("FightController")


FightController.Left = "FightController.Left"
FightController.Right = "FightController.Right"
FightController.Up = "FightController.Up"
FightController.Down = "FightController.Down"

--[[
战斗控制器 构造函数
@param scene 场景
]]
function FightController:ctor(scene)
	--显示场景
	self.scene_  =  scene; 
	
	--模型
	local FightModel = require("app.model.FightModel")
	self.model_ = FightModel.new(self);
	
	--控制的数据
    self.over_ = false; 
	
	
	self:init();
end







--初始化
function FightController:init()
--	local tile = {
--	  positon= 0, -- 0-15
--	  number_= 0, -- 这个格子显示的数字. 0表示灰的
--	  steps= 0  -- 0-3 经过计算这个格子移动的距离
--	};
	--[[
	// 全局变量包含16个格子
	// 00 01 02 03
	// 10 11 12 13
	// 20 21 22 23
	// 30 31 32 33
	]]
--	self.tiles_ = {};
--	for i = 15, 0, -1 do
	for i = 15, 0, -1 do
--	  local currentTile = clone(tile)
--	  self.tiles_[i+1] = currentTile;
	  
	  local state = {
	  	x = 0,
	  	y = 0,
	  	positon = i,
	  	defineId =  "title",
	  }
	  self.model_:newObject(BaseObject.CLASS_ID["static"], state);
	end
	
	--随机两个赋值为2 
	local num = math.random(1, 16);
	local object = self.model_:getObject("static:"..num);
	object:setButtonLabel(2);
--	self.tiles_[num].number_ = 2;
	
	local num2 = num + math.random(1, 15);
	if num2 > 16 then num2 = num2 - 16 end;
	local object = self.model_:getObject("static:"..num2);
	object:setButtonLabel(2);
--	self.tiles_[num2].number_ = 2;
--transition.moveTo(object.sprite1_, {x=10   ,y = 500,time = 0.2 })
	
end



--赋值新的
function FightController:createNewTile()
	local empTiles = self:emptyTiles();
	echoj("创建新的格子",#empTiles);
	if #empTiles>0 then 
		local index = math.random(1, #empTiles);
		local oneTile = empTiles[index];
		if oneTile then
			oneTile.number_ = 2;
			echoj("创建新的格子",oneTile.postion_);
			oneTile:setButtonLabel(oneTile.number_);
		end
	end
end





--获得所有的空格子
function FightController:emptyTiles()
  	local tiles = self.model_:getAllObjects(); --self.tiles_;
  	
  	local emptyTilesArr = {};
  	for k,v in pairs(tiles) do
  		if v.number_ == 0 then
			emptyTilesArr[#emptyTilesArr+1] = v 
		end
	end
	
--	  // 获得所有空格子的位置
--	  var tilesPositoin = empTiles.map(function(t){
--	    return t.position;
--	  })
	
	  --返回所有空格子
	 return emptyTilesArr
end


--是否结束：所有格子都含有数字，且相邻两个资格数字都不一样。
function FightController:isEnd()
  --检查是否还有空格子
--  local tiles = self.tiles_;
  local tiles = self.model_:getAllObjects();
  local empTiles = self:emptyTiles()

  if #empTiles == 0 then
  		-- 2 没有空格子时，检查是否能合并格子。即是否有两个相邻格子的数字相同。
	    -- 2.1 第一、二、三列前三个只需要检查格子数字是否与右边的格子和下边的格子相同。
	    for i = 0, 2, 1 do
	    	 for j = 0, 2, 1 do
	        p = i*4 + j;
	        
	        --检查是否与右边格子数字相同
	        if tiles[p+1].number == tiles[p+1].number then
	          return false;
	        end
	
	        -- 检查是否与下边格子相同
	        if tiles[p+1].number == tiles[p+5].number then
	          return false;
	        end
	      end
	    end
	
	
	    -- 2.2 第四列前三个检查是否与下边格子相同. 注意这里 i+=4
--	    for (i=3; i<16; i+=4){
	     for i = 3, 15, 4 do
	      if tiles[i+1] == tiles[p+5] then
	        return false;
	       end
	    end
	
	    -- 2.3 第四行前三个是否与右边格子相同
--	    for (i=12; i<16; i++){
	     for i = 12, 15, 1 do
	      if tiles[i+1] == tiles[i+1+1] then
	        return false;
	      end
	    end
	
	  -- 前面都检查结束了没有中途return，就结束游戏
	  return true;
  		
  		
  else
    --1 如果还有空格子, 不结束游戏
    return false
  end
end



--var tile = {15361810610
--  positon: 0 // 0-15
--  number: 0 // 这个格子显示的数字. 0表示灰的
--  steps: 0  // 0-3 经过计算这个格子移动的距离
--
--};
--
--// 全局变量包含16个格子
--// 00 01 02 03
--// 10 11 12 13
--// 20 21 22 23
--// 30 31 32 33
--var tiles = new Array()
--for(i = 0; i<16; i++){
--  tiles[i] = tile.clone()
--}








function FightController:mergeTile(source, target, step)
  local sourceNumber = toint(target.number_) + toint(source.number_);
  target.number_ = 0;
  
  source:setButtonLabel(sourceNumber);
  target:setButtonLabel(0);
end


function FightController:movingTile(tile, moveFlag,step,onComplete)
  step = toint(step);
  echoj("位置：",tile.positon_,"移动步数：",step);
  
  
  local len = step * 90;
  local sprite = tile.sprite_;
--  if not sprite or step == 0  then 
  	if onComplete then onComplete(); end
  	return 
--  end
  
  
--  if FightController.Left == moveFlag then
--  		transition.moveTo(sprite, {x=tile.x_ - len,y = tile.y_,time = 0.2 ,onComplete = onComplete})
--  elseif FightController.Right == moveFlag then
--  		transition.moveTo(sprite, {x=tile.x_ + len,y = tile.y_,time = 0.2 ,onComplete = onComplete})
--   elseif FightController.Up == moveFlag then
--  
--  elseif FightController.Down == moveFlag then
--  		
--  end
end



























--// 用户按方向键左键或者向左滑动触摸屏。所有数字向左移动
--var moveLeft = function(){
function FightController:moveRight()
--  // 格子有移动或者合并则返回 true
--  // 格子没有移动或者合并则返回 false
 
  local isMoved = false;
   local tiles = self.model_:getObjectsByClassId("static");
--  // 四列同时进行。注意这里 i+=4
--  for (i=0; i<16; i+=4){
 for i = 0, 15, 4 do
 
--    // 从第一个格子到第三个格子进行计算
--    for (j=0; j<3; j++){
     for j = 0, 2, 1 do
      local p = i+j;
--      // 1 如果这个格子是空格子。 向右搜索找到非空的格子移到此格子里
--      // 2 如果这个格子不是空格子。向右搜索找到非空的格子且数字相同的格子进行合并
      if(tiles[p+1].number_ == 0) then
       for k = 1, 3-j, 1 do
--        for (k=1; k<=3-j; k++){
          if(tiles[p+k+1].number_ ~= 0) then
            self:mergeTile(tiles[p+1], tiles[p+k+1]);
            self:movingTile(tiles[p+k+1], k+1);
            isMoved = true
          end
          
          if (tiles[p+1].number_ ~= 0) then break; end
        end
      end
 
--      // 移动空格子之后 再判断此格子是否为空 并进行合并操作
      if (tiles[p+1].number_ ~= 0) then
--        for (k=1; k<=3-j; k++) do
         for k = 1, 3-j, 1 do
          if(tiles[p+k+1].number_ == tiles[p+1].number_) then
            self:mergeTile(tiles[p+1], tiles[p+k+1]);
            self:movingTile(tiles[p+k+1], k+1);
            isMoved = true
            break;
          end
        end
      end
 
 
    end --// for (j=0; j<3; i++){
  end --// for (i=0; i<16; i+=4){
 
  return isMoved;
end





--用户按方向键右键或者向右滑动触摸屏。所有数字向右移动
function FightController:moveLeft()
  -- 格子有移动或者合并则返回 true
  -- 格子没有移动或者合并则返回 false

	  local tiles = self.model_:getObjectsByClassId("static");
  local isMoved = false;

  -- 四列同时进行。注意这里 i+=4
 -- for (i=0; i<16; i+=4){
 	for i = 0, 15, 4 do
    -- 从第四个格子到第二个格子进行计算
--    for (j=3; j>0; j--){
    for j = 3, 1, -1 do
      local p = i+j;
      -- 1 如果这个格子是空格子。 向左搜索找到非空的格子移到此格子里
      -- 2 如果这个格子不是空格子。向左搜索找到非空的格子且数字相同的格子进行合并
      if(tiles[p+1].number_ == 0) then
--        for (k=1; k<=3-j; k++){
        for k = 1, j, 1 do
          if(tiles[p-k+1].number_ ~= 0) then
          	 self:movingTile(tiles[p-k+1], k+1);
            self:mergeTile(tiles[p+1], tiles[p-k+1]);
            isMoved = true
          end
          
           if (tiles[p+1].number_ ~= 0) then break end;
        end
      end

      -- 移动空格子之后 再判断此格子是否为空 并进行合并操作
      if (tiles[p+1].number_ ~= 0) then
--      for (k=1; k<=3-j; k++){
        for k = 1, j, 1 do 
          if(tiles[p-k+1].number_ == tiles[p+1].number_) then
          	self:movingTile(tiles[p-k+1], k+1);
            self:mergeTile(tiles[p+1], tiles[p-k+1]);
            isMoved = true
            break
          end
        end
      end

   end --// for (j=0; j<3; i++){
  end --// for (i=0; i<16; i+=4){

  return isMoved;
end















--用户按方向键上键或者向上滑动触摸屏。所有数字向上移动
function FightController:moveUp()
  -- 格子有移动或者合并则返回 true
  -- 格子没有移动或者合并则返回 false
   local tiles = self.model_:getObjectsByClassId("static");
  local isMoved = false;
  --四行同时进行。注意这里 i++
  --for (i=0; i<4; i++){
 for i = 0, 3, 1 do
    -- 从第一个格子到第三个格子进行计算 注意这里 j+=4
--    for (j=0; j<12; j+=4){
     for j = 0, 11, 4 do
      local p = i+j;
--      -- 1 如果这个格子是空格子。 向下搜索找到非空的格子移到此格子里
--      -- 2 如果这个格子不是空格子。向下搜索找到非空的格子且数字相同的格子进行合并
      if(tiles[p+1].number_ == 0) then
        for k=4, 16-j-1,4 do
          if(tiles[p+k+1].number_ ~= 0) then
          
          self:movingTile(tiles[p+k+1], k+1);
            self:mergeTile(tiles[p+1], tiles[p+k+1]);
            
            isMoved = true
          end
          if (tiles[p+1].number_ ~= 0) then break end;
        end
      end
 
      -- 移动空格子之后 再判断此格子是否为空 并进行合并操作
      if (tiles[p+1].number_ ~= 0) then
        for k=4, 16-j-1, 4 do
          if(tiles[p+k+1].number_ == tiles[p+1].number_) then
          
          self:movingTile(tiles[p+k+1], k+1);
            self:mergeTile(tiles[p+1], tiles[p+k+1]);
            
            isMoved = true
            break
          end
        end
      end

    end
  end
  return isMoved;
end









-- 用户按方向键下键或者向下滑动触摸屏。所有数字向下移动
--var moveDown = function(){
function FightController:moveDown()
  -- 格子有移动或者合并则返回 true
  -- 格子没有移动或者合并则返回 false
 
  local isMoved = false;
   local tiles = self.model_:getObjectsByClassId("static");
  -- 四行同时进行。注意这里 i++
--  for (i=0; i<4; i++){
 for i = 0, 3, 1 do
    -- 从第一个格子到第三个格子进行计算 注意这里 j-=4
--    for (j=12; j>0; j-=4){
    for j = 12, 1, -4 do
      local p = i+j;
      --1 如果这个格子是空格子。 向下搜索找到非空的格子移到此格子里
      -- 2 如果这个格子不是空格子。向下搜索找到非空的格子且数字相同的格子进行合并
      if(tiles[p+1].number_ == 0)then
       for k = 4, j, 4 do
--        for (k=4; k<=j; k+=4){ // 0325
          if(tiles[p-k+1].number_ ~= 0)then
           self:movingTile(tiles[p-k+1], k+1);
            self:mergeTile(tiles[p+1], tiles[p-k+1]);
           
            isMoved = true
          end
          
           if (tiles[p+1].number_ ~= 0) then break end;
        end
      end
 
      -- 移动空格子之后 再判断此格子是否为空 并进行合并操作
      if (tiles[p+1].number_ ~= 0) then
--        for (k=4; k<=j; k+=4){ // 0325
        for k = 4, j, 4 do
          if(tiles[p-k+1].number_ == tiles[p+1].number_) then
          self:movingTile(tiles[p-k+1], k+1);
            self:mergeTile(tiles[p+1], tiles[p-k+1]);
            
            isMoved = true
            break; --// 0325 2
          end
        end
      end
 
    end
  end
 
  return isMoved;
end

return FightController
