--[[------------------------------------------------------------------
  HEALTH AND ARMOUR INDICATORS
  Default layout
]]--------------------------------------------------------------------

if CLIENT then
  -- Namespace
  local HEALTH = HOLOHUD.ELEMENTS.HEALTH;

  -- Panels and highlights
  local PANEL_NAME = HEALTH.PANELS.DEFAULT;
  local DEFAULT, ARMOUR = HEALTH.HIGHLIGHT.HEALTH, HEALTH.HIGHLIGHT.ARMOUR;

  -- Parameters
  local HEALTH_PANEL_OFFSET, HEALTH_PANEL_W, HEALTH_PANEL_H = 20, 153, 62;

  --[[
    Draws the armor indicator
    @param {number} x
    @param {number} y
    @param {number} armour
    @param {boolean|nil} invert the suit icon
    @void
  ]]
  local apLerp = 0;
  local function DrawArmour(x, y, armour, invert)
    invert = invert or false;

    -- Set up offset
    local offset = 0;
    if (invert) then offset = 65; x = x + SUIT_W; end

    -- Update lerp
    apLerp = Lerp(FrameTime() * 4, apLerp, armour);

    -- Draw
    HOLOHUD:DrawSilhouette(x, y, HEALTH:GetArmourColour(), apLerp * 0.01, HOLOHUD:GetHighlight(ARMOUR));
    HOLOHUD:DrawNumber(x + 28 - offset, y + 20, armour, HEALTH:GetArmourColour(), nil, HOLOHUD:GetHighlight(ARMOUR), "holohud_small", armour <= 0, TEXT_ALIGN_LEFT);
  end

  --[[
    Draws the health and armour indicators -- sandbox version
    @param {number} x
    @param {number} y
    @param {number} w
    @param {number} h
    @param {number} health
    @param {number} armour
    @param {number} armour number size
    @param {boolean} right aligned bar
    @void
  ]]
  local hpLerp = 100;
  local function DrawHealth(x, y, w, h, health, armour, armourMargin, right_align)
    -- Animate lerp
    hpLerp = Lerp(FrameTime() * 5, hpLerp, health);

    -- get bar drawing function to use
    local bar_func = HOLOHUD.DrawBar
    if right_align then bar_func = HOLOHUD.DrawBarRight end

    --  Draw
    DrawArmour(x + 4, y + 3, armour);
    HOLOHUD:DrawNumber(x + w - 7, y + 23, health, HEALTH:GetHealthColour(), nil, HOLOHUD:GetHighlight(DEFAULT), nil, nil, TEXT_ALIGN_RIGHT);
    bar_func(HOLOHUD, x + 7, y + 49, w + 1, 23, HEALTH:GetHealthColour(), hpLerp * 0.01, HOLOHUD:GetHighlight(DEFAULT));
  end

  --[[
    Draws the default panel
    @param {number} health
    @param {number} armour
    @param {boolean} right aligned bar
    @void
  ]]
  function HOLOHUD.ELEMENTS.HEALTH:DefaultPanel(health, armour, right_align)
    local hpW, apW = HOLOHUD:GetNumberSize(math.max(math.floor(math.log10(health) + 1), 3)), HOLOHUD:GetNumberSize(math.max(math.floor(math.log10(armour) + 1), 3), "holohud_small");
    local width = 44 + hpW + apW;
    HOLOHUD:DrawFragment(HEALTH_PANEL_OFFSET, ScrH() - (HEALTH_PANEL_H + HEALTH_PANEL_OFFSET), width, HEALTH_PANEL_H, DrawHealth, PANEL_NAME, health, armour, apW, right_align);

    return width, HEALTH_PANEL_H;
  end
end
