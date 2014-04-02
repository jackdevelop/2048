--[[
战斗场景
]]
local BaseScene = require("engin.mvcs.view.BaseScene")
local FightScene = class("FightScene", BaseScene)


	
function FightScene:ctor()
	param = {};
	param.sceneSound = GameSoundProperties.bg_sound();
--	param.backgroundImageName = "sound/bg.mp3";--levelData.backgroundImageName;
----	param.width = levelData.width;
----	param.height = display.height;
--	param.batchNodeImage = levelData.batchNodeImage;
	FightScene.super.ctor(self,param)
--    GameUtil.spriteFullScreen(self.backgroundSprite_)
--    http://gabrielecirulli.github.io/2048/
	 self.sptArr_ = {};
      --控制器
    local FightModel = require("app.model.FightModel")
	self.model_ = FightModel.new();
	self.model_:addEventListener(FightModel.WIN_EVENT,handler(self,self.winHandle))
	self.model_:addEventListener(FightModel.NOMOVE_EVENT,handler(self,self.noMoveHandle))
	self.model_:addEventListener(FightModel.MOVE_EVENT,handler(self,self.MoveHandle))
	self.model_:addEventListener(FightModel.MERGE_EVENT,handler(self,self.mergeHandle)) --合并
	self.model_:addEventListener(FightModel.FLASH_EVENT,handler(self,self.flashHandle))
	self.model_:addEventListener(FightModel.LOST_EVENT,handler(self,self.lostHandle))
	self.model_:startGame()
	
	self:initView();
end


 
--[[
	初始化视图
]]
function FightScene:initView()
	local batch = self:getBatchLayer();
  	for tag = 1, 16, 1 do
  		local row = math.floor((tag - 1)/4) + 1
		local col = math.mod(tag - 1, 4) + 1
		local x,y = row*90,col*90;--toint(i%4)*90, math.floor(i/4)*90;
		
		
		cc.ui.UIImage.new("image/Button02.png", {scale9 = true})
      	--:setLayoutSize(200, 100)
      	:pos(x,y)
--        :align(display.LEFT_BOTTOM, x, y)
        :addTo(batch,1)
        :setColor(ccc3(255, 0, 0));
	end
end





function FightScene:lostHandle()
	device.showAlert("tips","game is lost!!",nil,function()
		echoj("成功！！");
	end)
end
function FightScene:noMoveHandle()
	device.showAlert("tips","no move!!",nil,function()
		echoj("成功！！");
	end)
--	device.showAlert("", "Sure to remove this?", {"yes", "no"}, onButtonClicked)   请问这里的“sure to remove this”为啥换成中文就成乱码了？
end


function FightScene:MoveHandle(event)
	local srcId = event.srcId;
	local desTag = event.desTag;
	local dis = event.dis;
	--srcId=src.id,desTag=des.tag,dis=dis
	local spt =  self.sptArr_[srcId]
	local row = math.floor((desTag - 1)/4) + 1
	local col = math.mod(desTag - 1, 4) + 1
	local x,y = row*90,col*90;--toint(i%4)*90, math.floor(i/4)*90;
	transition.moveTo(spt, {x = x,y = y,time = 0.1*dis })
end

function FightScene:winHandle()
--	id = self.winId, num=self.winNum
	device.showAlert("tips","game is win!!",nil,function()
		echoj("成功！！");
	end)
end

function FightScene:mergeHandle(event)
--	name=FightModel.MERGE_EVENT,
--		src=src.id,des=des.id,num=des.v,dis=1
	local src = event.src;
	local des = event.des;
	local num = event.num;
	local dis = event.dis;
	local desTag = event.desTag;
	local row = math.floor((desTag - 1)/4) + 1
	local col = math.mod(desTag - 1, 4) + 1
	local x,y = row*90,col*90;--toint(i%4)*90, math.floor(i/4)*90;
	
	
	local spt =  self.sptArr_[src]
	local desSpt =  self.sptArr_[des]
	transition.moveTo(spt, {x = x,y = y,time = 0.1*dis,onComplete = function()
			spt:removeSelf();
			self.sptArr_[src] = nil;
			desSpt:setButtonLabelString(toint(num))
	end})
end
function FightScene:flashHandle(event)
	local id = event.id;
	local tag = event.tag;
	local num = event.num;
	local curr = event.curr;
	local best = event.best;
	local init = event.init;
	
	
	local row = math.floor((tag - 1)/4) + 1
	local col = math.mod(tag - 1, 4) + 1
	local x,y = row*90,col*90;--toint(i%4)*90, math.floor(i/4)*90;
	
	
	local batch = self:getBatchLayer();
--	local sprite = cc.ui.UIImage.new("image/Button02.png", {scale9 = true})
--  	--:setLayoutSize(200, 100)
--    :align(display.LEFT_BOTTOM, x, y)
--    :addTo(batch)
    
    local loginButtonParam = {
	    on ="image/Button02.png",
	}
   	local sprite = cc.ui.UICheckBoxButton.new(loginButtonParam)
	        :setButtonLabel(cc.ui.UILabel.new({text = tostring(num), size = 24,  color = display.COLOR_WHITE}))
	        --:setButtonLabelOffset(0, 40)
	        :setButtonEnabled(false)
--	        :setButtonLabelAlignment(display.CENTER)
--	        :onButtonStateChanged(function(event)
--	        	local plane = self.object_.sceneController_.plane;--飞机
--	            plane:decreasePlaneFlyRadians(1);
--	            
--	            local radians = plane:getPlaneFlyRadians();
--	            txt:setString("度数："..radians);
--	        end)
--			:pos(x,y)
	        :align(display.LEFT_BOTTOM, x, y)
	        :addTo(batch,2)
    
     self.sptArr_[id] = sprite;
end















----[[--
--	触摸事件 
--]]
function FightScene:onTouch(event, x, y)
	if event == "began" then
		self.startX_ = x;
		self.startY_ = y;
	elseif event == "ended" then
		
		if Math2d.dist(self.startX_, self.startY_, x, y) < 30 then 
			return 
		end
		
		
		local radians = Math2d.radians4point(self.startX_, self.startY_, x, y);--弧度
		if radians > -0.5 and radians < 0.5 then --向右
			self.model_:move(TOUCH_MOVED_DOWN);
		elseif radians > 1 and radians < 2 then --向下
			self.model_:move(TOUCH_MOVED_LEFT);
		elseif radians > -2.5 and radians < -1 then --向上
		 	self.model_:move(TOUCH_MOVED_RIGHT);
		elseif radians > 2.5 or radians < -2.5 then --向左
			self.model_:move(TOUCH_MOVED_UP);
		end
	end
end




return FightScene
