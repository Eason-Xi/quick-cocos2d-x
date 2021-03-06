
function createTouchableSprite(p)
    local sprite = display.newScale9Sprite(p.image)
    sprite:setContentSize(p.size)

    local cs = sprite:getContentSize()
    local label = ui.newTTFLabel({text = p.label})
    label:setPosition(cs.width / 2, cs.height / 2)
    sprite:addChild(label)

    return sprite
end


function createSimpleButton(imageName, name, movable, listener)
    local sprite = display.newSprite(imageName)

    if name then
        local cs = sprite:getContentSize()
        local label = ui.newTTFLabel({text = name, color = display.COLOR_BLACK})
        label:setPosition(cs.width / 2, cs.height / 2)
        sprite:addChild(label)
    end

    sprite:setTouchEnabled(true) -- enable sprite touch
    -- sprite:setTouchMode(cc.TOUCH_ALL_AT_ONCE) -- enable multi touches
    sprite:setTouchSwallowEnabled(false)
    sprite:addTouchEventListener(function(event, x, y, prevX, prevY)
        if event == "began" then
            sprite:setOpacity(128)
            -- return cc.TOUCH_BEGAN -- stop event dispatching
            return cc.TOUCH_BEGAN_NO_SWALLOWS -- continue event dispatching
        end

        local touchInSprite = sprite:getCascadeBoundingBox():containsPoint(CCPoint(x, y))
        if event == "moved" then
            sprite:setOpacity(128)
            if movable then
                local offsetX = x - prevX
                local offsetY = y - prevY
                local sx, sy = sprite:getPosition()
                sprite:setPosition(sx + offsetX, sy + offsetY)
                return cc.TOUCH_MOVED_RELEASE_OTHERS -- stop event dispatching, remove others node
                -- return cc.TOUCH_MOVED_SWALLOWS -- stop event dispatching
            end

        elseif event == "ended" then
            if touchInSprite then listener() end
            sprite:setOpacity(255)
        else
            sprite:setOpacity(255)
        end
    end)

    return sprite
end
