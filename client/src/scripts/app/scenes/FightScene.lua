--[[
战斗场景
]]
local BaseScene = require("engin.mvcs.view.BaseScene")
local FightScene = class("FightScene", BaseScene)


	
function FightScene:ctor()
	
--	param.sceneSound = GameSoundProperties[levelData.sceneSound](); --GameSoundProperties.bg_sound();
--	param.backgroundImageName = levelData.backgroundImageName;
----	param.width = levelData.width;
----	param.height = display.height;
--	param.batchNodeImage = levelData.batchNodeImage;
	FightScene.super.ctor(self)
--    GameUtil.spriteFullScreen(self.backgroundSprite_)
--    http://gabrielecirulli.github.io/2048/
    
    
      --控制器
    local FightController = require("app.controllers.FightController")
	self.sceneController_ = FightController.new(self);
	
	
--	self:initView();
end





--function FightScene:initView()
--	local batch = self:getBatchLayer()
--	local function createOne(tile)
--		--		local tile = {
--		--	  positon= 0, -- 0-15
--		--	  number= 0, -- 这个格子显示的数字. 0表示灰的
--		--	  steps= 0  -- 0-3 经过计算这个格子移动的距离
--		--	};
--	
--		local txt = tile.number;
--		if txt == 0 then txt = "" end;
--		local position = tonum(tile.positon);
--		local x,y = toint(position%4)*90, math.floor(position/4)*90;
--	
--		local loginButtonParam = {
--		    on ="image/Button02.png",
--		}
--		return cc.ui.UICheckBoxButton.new(loginButtonParam)
--	        :setButtonLabel(cc.ui.UILabel.new({text = txt, size = 24,  color = display.COLOR_WHITE}))
--	        --:setButtonLabelOffset(0, 40)
--	        :setButtonEnabled(false)
--	        :setButtonLabelAlignment(display.CENTER)
----	        :onButtonStateChanged(function(event)
----	        	local plane = self.object_.sceneController_.plane;--飞机
----	            plane:decreasePlaneFlyRadians(1);
----	            
----	            local radians = plane:getPlaneFlyRadians();
----	            txt:setString("度数："..radians);
----	        end)
--	        :align(display.LEFT_BOTTOM,x,y)
--	        :addTo(batch)
--	end
--
--
--
--
--
--	local tiles = self.sceneController_.tiles_;--遍历所有格子
--	if tiles then
--		
--		
--	
--	
--		for k,v in pairs(tiles) do
--			local sprite = createOne(v)
--			v.sprite = sprite;
--		end
--	end
--end












----[[--
--	触摸事件 
--]]
function FightScene:onTouch(event, x, y)
	if event == "began" then
		self.startX_ = x;
		self.startY_ = y;
	elseif event == "ended" then
		
		local radians = Math2d.radians4point(self.startX_, self.startY_, x, y);--弧度
		
		if radians > -0.5 and radians < 0.5 then --向右
			local flag = self.sceneController_:moveRight();
			if flag then 
				self.sceneController_:createNewTile()
			end
			
		elseif radians > 1 and radians < 2 then --向下
			local flag = self.sceneController_:moveDown();
			if flag then 
				self.sceneController_:createNewTile()
			end
			
		elseif radians > -2.5 and radians < -1 then --向上
			local flag = self.sceneController_:moveUp();
			if flag then 
				self.sceneController_:createNewTile()
			end
			
		elseif radians > 2.5 or radians < -2.5 then --向左
			local flag = self.sceneController_:moveLeft();
			if flag then 
				self.sceneController_:createNewTile()
			end
		end
		
		
----    local radians = Math2d.radians4point(startX, startY, endX, endY)
--    local angle = Math2d.radians2degrees(radians)
--		self.sceneController_:moveLeft();
--		self.sceneController_:createNewTile()
	end
----		self.startY = y;
--		if x > display.cx then --向上
--			self.sceneController_.plane:decreasePlaneFlyRadians(-1);
--		elseif x < display.cx then --向下
--			self.sceneController_.plane:decreasePlaneFlyRadians(1);
--		end
--		
--		return true
--	elseif event == "moved" then
--	else
--	end
end




return FightScene
