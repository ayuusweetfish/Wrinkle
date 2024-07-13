local draw = require 'draw_utils'
local audio = require 'audio'
local scroll = require 'scroll' -- Continuous
local timeline_scroll = require 'timeline_scroll' -- Timeline

local debug = not false

return function ()
  local bgm_light, bgm_light_update = audio.loop(
    'aud/background_light_intro.ogg', (2 * 4) * (60 / 70),
    'aud/background_light_loop.ogg', (24 * 4) * (60 / 70),
    1600 * 4
  )
  bgm_light:setVolume(0)

  local bgm_cat, bgm_cat_update = audio.loop(
    nil, 0,
    'aud/background_cat.ogg', (28 * 4) * (60 / 68),
    1600 * 4
  )
  bgm_cat:setVolume(0)
  bgm_cat:play()

  local bgm_cat_rain, bgm_cat_rain_update = audio.loop(
    nil, 0,
    'aud/background_cat_rain.ogg', (28 * 4) * (60 / 68),
    1600 * 4
  )
  bgm_cat_rain:setVolume(0)
  bgm_cat_rain:play()

  local since_bgm_update = 0
  local bgm_update_all = function ()
    since_bgm_update = since_bgm_update + 1
    if since_bgm_update >= 120 then
      since_bgm_update = 0
      bgm_light_update()
      bgm_cat_update()
      bgm_cat_rain_update()
    end
  end

  local s = {}
  local W, H = W, H
  local text_font = _G['global_font']
  local num_font = _G['numbers_font']

  local album_ticks = {0, 0.25, 0.5, 0.75, 1, 1.75, [20] = -100, [21] = 90, [22] = 100}
  local album_dates = {
    '1997.03',
    '1997.07',
    '1998.09',
    '1999.08',
    '2000.04',
    '2018.05',
    [20] = '70570724 BCE',
    [21] = '113578246 CE',
  }
  for k, v in pairs(album_dates) do
    album_dates[k] = love.graphics.newText(num_font(28), tostring(v))
  end
  local album_backgrounds = {
    'background_1',
    'background_2',
    'background_3',
    'background_4',
    'background_5',
    'background_6',
    [20] = 'background_20',
    [21] = 'background_21',
  }
  local album_backgrounds_alter = {
    [2] = 'background_2_off',
  }
  local album_backgrounds_overlay = {
    [4] = 'letter_a_overlay',
    [5] = 'letter_b_overlay',
  }
  local bg_tracks = {
    bgm_light,
    bgm_cat,
    bgm_cat,
    bgm_cat_rain,
    bgm_cat,
    bgm_cat,
    [20] = bgm_light,
  }
  local bg_tracks_all = {bgm_light, bgm_cat, bgm_cat_rain}

  local objs_in_album = {
    [1] = {
      {x = 877, y = 395, rx = 30, ry = 12, zoom_img = 'obj_insect_anim1', unlock = 3, unlock_seq = {'obj_insect_anim2', 'obj_insect_anim3', 'obj_insect_anim4', 'obj_insect_anim5', 'obj_insect_anim6', 'obj_insect_anim7'}, unlocked_img = 'obj_insect_anim7', unlocked_x = 702, unlocked_y = 381},
      -- {x = 952, y = 275, rx = 60, ry = 70, zoom_img = 'bee'},
      {x = 858, y = 710, rx = 50, ry = 30, zoom_img = 'obj_go'},
      {x = 1034, y = 581, rx = 43, ry = 26, zoom_img = 'obj_journal_1'},
      {x = 961, y = 271, rx = 45, ry = 60, zoom_img = 'obj_dinosaur'},
    },
    [2] = {
      {x = 646, y = 370, rx = 70, ry = 40, zoom_img = 'obj_insect_anim7'},
      {x = 826, y = 653, rx = 80, ry = 40, zoom_imgs = {'obj_fortune_1', 'obj_fortune_2', 'obj_fortune_3', 'obj_fortune_4'}},
      {x = 415, y = 352, rx = 45, ry = 45, scene_sprites = {nil, 'obj_musical_box_a'}, sprite_w = nil, index = 1, musical_box = 'orchid'},
      {x = 1020, y = 314, rx = 70, ry = 80, zoom_img = 'obj_journal_2'},
      {x = 1127, y = 217, rx = 45, ry = 60, switch = true},
      {x = 435, y = 254, rx = 48, ry = 35, zoom_img = 'obj_illust', night_interactable = true},
    },
    [3] = {
      {x = 702, y = 381, rx = 77, ry = 45, zoom_img = 'obj_insect_anim7'},
      {x = 544, y = 210, rx = 250, ry = 110, zoom_img = 'obj_map'},
      {x = 516, y = 367, rx = 60, ry = 40, zoom_img = 'obj_frames'},
      {x = 798, y = 664, rx = 30, ry = 25, zoom_img = 'obj_amber_anim1', unlock = 20, unlock_seq = {
        'obj_amber_anim2', 'obj_amber_anim3', 'obj_amber_anim4', 'obj_amber_anim5',
        'obj_amber_anim6', 'obj_amber_anim7', 'obj_amber_anim8'
      }, unlocked_img = 'obj_amber_anim8'},
      {x = 859, y = 605, rx = 50, ry = 75, zoom_img = 'obj_fish_anim1', unlock = 2, unlock_seq = {'obj_fish_anim2', 'obj_fish_anim3', 'obj_fish_anim4', 'obj_fish_anim5', 'obj_fish_anim6', 'obj_fish_anim7'}, unlocked_img = 'obj_fish_anim7', unlocked_x = 646, unlocked_y = 370},
      {x = 864, y = 219, rx = 60, ry = 50, scene_sprites = {nil, 'obj_lamp_3'}, sprite_w = nil, index = 1, sound = 'switch_small'},
      {x = 415, y = 352, rx = 45, ry = 45, scene_sprites = {nil, 'obj_musical_box_a'}, sprite_w = nil, index = 1, musical_box = 'orchid'},
      {x = 1140, y = 271, rx = 105, ry = 200, zoom_img = 'obj_bull'},
      {x = 973, y = 347, rx = 70, ry = 80, zoom_img = 'obj_journal_3'},
      {x = 879, y = 381, rx = 20, ry = 36, zoom_img = 'obj_sunglasses'},
      {x = 260, y = 361, rx = 125, ry = 45, zoom_img = 'obj_telescope'},
      {x = 847, y = 295, rx = 42, ry = 23, zoom_img = 'obj_workbook'},
      {x = 649, y = 601, rx = 100, ry = 80, zoom_img = 'obj_sack', star_sack = true, child =
        {x = 649, y = 601, rx = 100, ry = 80, zoom_img = 'obj_bottle_anim01', unlock = 4, unlock_seq = {
          'obj_bottle_anim02', 'obj_bottle_anim03', 'obj_bottle_anim04', 'obj_bottle_anim05',
          'obj_bottle_anim06', 'obj_bottle_anim07', 'obj_bottle_anim08', 'obj_bottle_anim09',
          'obj_bottle_anim10', 'obj_bottle_anim11', 'obj_bottle_anim12', 'obj_bottle_anim13',
          'obj_bottle_anim14', 'obj_bottle_anim15', 'obj_bottle_anim16'
        }, unlocked_img = 'obj_bottle_anim16'}},
    },
    [4] = {
      {x = 429, y = 522, rx = 45, ry = 45, scene_sprites = {nil, 'obj_musical_box_b'}, sprite_w = nil, index = 1, musical_box = 'orchid_broken'},
      {x = 889, y = 609, rx = 80, ry = 50, zoom_img = 'letter_a', cont_scroll = 2000, letter_initial = true},
      {x = 779, y = 535, rx = 85, ry = 145, zoom_img = 'letter_a', cont_scroll = 2000, letter_after = true},
      {x = 891, y = 642, rx = 30, ry = 30, zoom_img = 'obj_plastic_anim01', unlock = 21, unlock_seq = {
        'obj_plastic_anim02', 'obj_plastic_anim03', 'obj_plastic_anim04', 'obj_plastic_anim05',
        'obj_plastic_anim06', 'obj_plastic_anim07', 'obj_plastic_anim08', 'obj_plastic_anim09',
        'obj_plastic_anim10'
      }, unlocked_img = 'obj_plastic_anim10', letter_after = true, unlocked_x = 680, unlocked_y = 620},
    },
    [5] = {
      {x = 810, y = 510, rx = 42, ry = 52, zoom_img = 'letter_b', cont_scroll = 1880, letter_initial = true},
      {x = 999, y = 523, rx = 60, ry = 30, zoom_img = 'letter_b', cont_scroll = 1880, letter_after = true},
      {x = 828, y = 512, rx = 40, ry = 40, zoom_img = 'obj_beer', unlock = 1, unlock_seq = {'obj_beer_anim1', 'obj_beer_anim2', 'obj_beer_anim3', 'obj_beer_anim4', 'obj_beer_anim5', 'obj_beer_anim6'}, unlocked_img = 'obj_beer_anim6', letter_after = true},
    },
    [6] = {
      {x = 631, y = 449, rx = 45, ry = 50, zoom_img = 'obj_journal_6'},
    },
    [20] = {
    },
    [21] = {
      {x = 680, y = 620, rx = 50, ry = 35, zoom_img = 'obj_star_anim01', unlock = 6, unlock_seq = {
        'obj_star_anim02', 'obj_star_anim03', 'obj_star_anim04', 'obj_star_anim05',
        'obj_star_anim06', 'obj_star_anim07', 'obj_star_anim08', 'obj_star_anim09',
        'obj_star_anim10',
      }, unlocked_img = 'obj_star_anim10'},
    },
  }
  local album_idx = 5
  local objs = objs_in_album[album_idx]

  local light_on = true     -- Scene 2
  local letter_read = {[4] = false, [5] = false}

  local STAR_SACK_BTNS = {
    {x = 464, y = 508, r = 75, img = 'sack_btn_2', key = true},
    {x = 609, y = 539, r = 75, img = 'sack_btn_4', key = false},
    {x = 755, y = 552, r = 75, img = 'sack_btn_6', key = true},
    {x = 916, y = 568, r = 75, img = 'sack_btn_8', key = true},
    {x = 1061, y = 570, r = 75, img = 'sack_btn_10', key = false},
    {x = 1191, y = 557, r = 75, img = 'sack_btn_12', key = false},
    {x = 1306, y = 540, r = 75, img = 'sack_btn_14', key = true},
    {x = 1410, y = 523, r = 75, img = 'sack_btn_16', key = true},
    {x = 1504, y = 508, r = 75, img = 'sack_btn_18', key = false},
    {x = 368, y = 581, r = 75, img = 'sack_btn_1', key = true},
    {x = 518, y = 590, r = 75, img = 'sack_btn_3', key = true},
    {x = 658, y = 651, r = 75, img = 'sack_btn_5', key = false},
    {x = 828, y = 660, r = 75, img = 'sack_btn_7', key = true},
    {x = 988, y = 675, r = 75, img = 'sack_btn_9', key = false},
    {x = 1136, y = 663, r = 75, img = 'sack_btn_11', key = true},
    {x = 1263, y = 658, r = 75, img = 'sack_btn_13', key = false},
    {x = 1382, y = 635, r = 75, img = 'sack_btn_15', key = true},
    {x = 1473, y = 607, r = 75, img = 'sack_btn_17', key = true},
    {x = 1565, y = 581, r = 75, img = 'sack_btn_19', key = false},
  }
  for i = 1, #STAR_SACK_BTNS do
    STAR_SACK_BTNS[i].x = STAR_SACK_BTNS[i].x * (1280 / 1920)
    STAR_SACK_BTNS[i].y = STAR_SACK_BTNS[i].y * (1280 / 1920)
  end

  local PT_INITIAL_R = W * 0.01
  local PT_HELD_R = W * 0.03

  local px, py = W/2, H/2
  local pr = PT_INITIAL_R
  local p_hold_time, p_rel_time = -1, -1
  local px_rel, py_rel

  local zoom_obj = nil
  local zoom_in_time, zoom_out_time = -1, -1
  local zoom_pressed = false

  local zoom_text
  local zoom_scroll
  local UNLOCK_SEQ_PROG_RATE = 6
  local zoom_seq_prog

  local sack_btn = nil
  local sack_key_match_time = -1

  local mbox_playing = nil
  local mbox_counter = 0
  local mbox_counter_limitless = 0

  local tl = timeline_scroll()
  -- XXX: Mark to ease testing
  if debug then
    tl.add_tick(album_ticks[1], 1)
    tl.add_tick(album_ticks[2], 2)
    tl.add_tick(album_ticks[3], 3)
    tl.add_tick(album_ticks[4], 4)
    tl.add_tick(album_ticks[6], 6)
    tl.add_tick(album_ticks[20], 20)
    tl.add_tick(album_ticks[21], 21)
  end
  tl.add_tick(album_ticks[5], 5)

  local tl_obj_unlock

  local tl_time = -1
  local TIMELINE_STAY_DUR = 1200

  local s1_seq_time = -1
  local s4_seq_time = -1
  local s20_seq_time = -1

  s.press = function (x, y)
    if sack_key_match_time >= 0 then return end
    if s1_seq_time >= 0 then return end
    if s4_seq_time >= 0 then return end
    -- Entry sequence for scene 20 does not affect (disable) pointer events
    if zoom_obj ~= nil then
      if zoom_in_time >= 120 then
        if zoom_obj.star_sack then
          -- Sack
          local best_dist, best_btn = 1e9, nil
          for i = 1, #STAR_SACK_BTNS do
            local b = STAR_SACK_BTNS[i]
            local dist = (x - b.x) * (x - b.x) + (y - b.y) * (y - b.y)
            if dist < b.r * b.r and dist < best_dist then
              best_dist, best_btn = dist, b
            end
          end
          if best_btn ~= nil then
            sack_btn = best_btn
          else
            zoom_pressed = true
          end
        elseif zoom_scroll ~= nil then
          zoom_scroll.press(y, x)
        else
          zoom_pressed = true
        end
      end
      return true
    end

    p_hold_time, p_rel_time = 0, -1
    px, py = x, y
  end

  s.cancel = function (x, y)
    zoom_pressed = false
    p_hold_time, p_rel_time = -1, -1
    if zoom_scroll then zoom_scroll.cancel(y, x) end
  end

  s.enter_hover = function (x, y) px, py = x, y end

  s.hover = function (x, y)
    if p_hold_time == -1 then px, py = x, y end
  end

  s.move = function (x, y)
    if zoom_scroll ~= nil then zoom_scroll.move(y, x) end
  end

  -- https://stackoverflow.com/a/46007540
  local dist_ellipse = function (a, b, px, py)
    if (px*b)*(px*b) + (py*a)*(py*a) <= a*a*b*b then return 0 end
    px = math.abs(px)
    py = math.abs(py)
    local px0, py0 = px, py
    local tx = math.sqrt(2)
    local ty = math.sqrt(2)
    for i = 1, 3 do
      local x = a * tx
      local y = b * ty
      local ex = (a*a - b*b) * (tx*tx*tx) / a
      local ey = (b*b - a*a) * (ty*ty*ty) / b
      local rx = x - ex
      local ry = y - ey
      local qx = px - ex
      local qy = py - ey
      local r = math.sqrt(rx*rx + ry*ry)
      local q = math.sqrt(qx*qx + qy*qy)
      tx = math.min(1, math.max(0, (qx * r / q + ex) / a))
      ty = math.min(1, math.max(0, (qy * r / q + ey) / b))
      t = math.sqrt(tx*tx + ty*ty)
      tx = tx / t
      ty = ty / t
    end
    dx = px0 - a * tx
    dy = py0 - b * ty
    return math.sqrt(dx*dx + dy*dy)
  end

  local synchronise_tl = function ()
    local unlock = album_idx
    if not tl.find_tag(unlock) then
      tl.add_tick(album_ticks[unlock], unlock)
    end
    -- Synchronise timelines
    tl.tx = tl.find_tag(unlock)
    tl.dx = tl.tx
    tl.update()
    tl_obj_unlock = nil
  end

  s.release = function (x, y)
    if sack_key_match_time >= 0 then return end
    if s1_seq_time >= 0 then return end
    if s4_seq_time >= 0 then return end
    if zoom_obj ~= nil then
      if zoom_pressed then
        zoom_in_time, zoom_out_time = -1, 0
        if zoom_obj.unlock and album_idx == zoom_obj.unlock then
          synchronise_tl()
        end
        zoom_pressed = false
        audio.sfx('object_close')
      elseif sack_btn then
        local b = sack_btn
        local dist = (x - b.x) * (x - b.x) + (y - b.y) * (y - b.y)
        if dist < b.r * b.r then
          -- Pressed sack button
          b.active = not b.active
          -- Check key match
          local key_match = true
          for i = 1, #STAR_SACK_BTNS do
            if (STAR_SACK_BTNS[i].active or false) ~= STAR_SACK_BTNS[i].key then
              key_match = false
              break
            end
          end
          if key_match then
            zoom_obj.sack_open = true
            -- Add overlay sprite
            zoom_obj.scene_sprites = {'obj_sack_open'}
            zoom_obj.index = 1
            sack_key_match_time = 0
            audio.sfx('sack_open')
          else
            audio.sfx('sack_click')
          end
        end
        sack_btn = false
      elseif zoom_scroll then
        if zoom_scroll.release(y, x) == 2 then
          zoom_in_time, zoom_out_time = -1, 0
          if zoom_obj.unlock and album_idx == zoom_obj.unlock then
            synchronise_tl()
          end
          audio.sfx('object_close')
        end
      end
      return true
    end

    p_hold_time, p_rel_time = -1, 0
    local best_dist, best_obj = pr, nil
    for i = 1, #objs do
      local o = objs[i]
      -- Handle scene 2 where objects' interactivity depends on light state
      local valid = (album_idx ~= 2 or o.switch or (light_on == not o.night_interactable))
      -- Handle scenes 4, 5 where objects' interactivity depends on whether the letter has been read
      if letter_read[album_idx] ~= nil then
        local disable_match = nil
        if o.letter_initial then disable_match = true
        elseif o.letter_after then disable_match = false end
        valid = valid and letter_read[album_idx] ~= disable_match
      end
      if valid then
        local dist = dist_ellipse(o.rx, o.ry, px - o.x, py - o.y)
        if dist < best_dist then
          best_dist, best_obj = dist, o
        end
      end
    end
    if best_obj ~= nil then
      local o = best_obj
      -- Activate object
      if o.zoom_imgs then
        o.index = (o.index or 0) % #o.zoom_imgs + 1
        o.zoom_img = o.zoom_imgs[o.index]
      end
      if o.zoom_img then
        -- Zoom-in; possibly unlocks new album scene
        -- Use the object contained in the sack, if the latter is open (unlocked)
        if o.star_sack and o.sack_open then o = o.child end
        zoom_obj = o
        zoom_in_time, zoom_out_time = 0, -1
        -- Text
        if o.text ~= nil then
          zoom_text = love.graphics.newText(text_font(42), o.text)
        end
        -- Scrolling
        if o.cont_scroll ~= nil then
          zoom_scroll = scroll({
            x_min = -(o.cont_scroll - H),
            x_max = 0,
          })
        end
        -- Object unlocks a tick in the album?
        if o.unlock --[[ and not tl.find_tag(o.unlock) ]] then
          tl_obj_unlock = timeline_scroll()
          tl_obj_unlock.add_tick(album_ticks[album_idx], album_idx)
          tl_obj_unlock.add_tick(album_ticks[o.unlock], o.unlock)
          zoom_seq_prog = 0
        end
        if o.cont_scroll then
          audio.sfx('letter_paper')
        else
          audio.sfx('object_activate')
        end
      elseif o.scene_sprites then
        -- In-scene image
        o.index = (o.index == #o.scene_sprites and 1 or o.index + 1)
        if o.musical_box then
          -- Music!
          if o.index == 2 then
            audio.sfx(o.musical_box, nil, o.musical_box == 'orchid')
            audio.sfx_vol(o.musical_box, 0) -- Will be updated at draw
            mbox_playing = o
          else
            audio.sfx_stop(o.musical_box)
            mbox_playing = nil
          end
        elseif o.sound then
          audio.sfx(o.sound)
        end
      elseif o.switch then
        -- Light switch
        light_on = not light_on
        audio.sfx('switch')
      end
      if o.letter_initial then
        letter_read[album_idx] = true
      end
    end
    px_rel, py_rel = px, py
    px, py = x, y
  end

  local T = 0

  local scroll_accum = 0
  local SCROLL_ACCUM_LIMIT = 8

  s.update = function ()
    bgm_update_all()

    T = T + 1

    scroll_accum = math.max(0, scroll_accum * 0.95 - 0.1)

    if zoom_in_time >= 0 then zoom_in_time = zoom_in_time + 1
    elseif zoom_out_time >= 0 then
      zoom_out_time = zoom_out_time + 1
      if zoom_out_time == 120 then
        zoom_obj = nil
        zoom_out_time = -1
        if zoom_text then
          zoom_text:release()
          zoom_text = nil
        end
        zoom_scroll = nil
        tl_obj_unlock = nil
      end
    end

    if p_hold_time >= 0 then
      pr = pr + (PT_HELD_R - pr) * 0.01
    elseif pr ~= PT_INITIAL_R then
      pr = pr + (PT_INITIAL_R - pr) * 0.05
      if math.abs(pr - PT_INITIAL_R) < 0.1 then
        pr = PT_INITIAL_R
      end
    end

    if p_hold_time >= 0 then p_hold_time = p_hold_time + 1
    elseif p_rel_time >= 0 then
      p_rel_time = p_rel_time + 1
      if p_rel_time >= 240 then p_rel_time = -1 end
    end

    tl.update()
    local last_album_idx = album_idx
    album_idx = tl.sel_tag
    if tl_obj_unlock then
      tl_obj_unlock.update()
      album_idx = tl_obj_unlock.sel_tag
    end
    if album_idx ~= last_album_idx then
      -- Stop sounds
      for i = 1, #objs do
        local o = objs[i]
        if o.musical_box then
          audio.sfx_stop(o.musical_box)
          o.index = 1   -- Turn off
        end
      end
      mbox_playing = nil
      -- Update objects
      objs = objs_in_album[album_idx]
      -- Slow down scroll
      scroll_accum = SCROLL_ACCUM_LIMIT
    end

    if tl_time >= 0 then
      tl_time = tl_time + 1
      if tl_time >= TIMELINE_STAY_DUR then
        tl_time = -1
      end
    end

    if zoom_scroll ~= nil then
      zoom_scroll.update()
    end

    if sack_key_match_time >= 0 then
      sack_key_match_time = sack_key_match_time + 1
      if sack_key_match_time >= 600 then
        sack_key_match_time = -1
        zoom_in_time, zoom_out_time = -1, 0
      end
    end

    if mbox_playing then
      mbox_counter = math.min(mbox_counter + 1, 180)
      mbox_counter_limitless = mbox_counter_limitless + 1
      if mbox_playing.musical_box == 'orchid_broken' and mbox_counter_limitless > 650 then
        mbox_playing.index = 1
        audio.sfx_stop(mbox_playing.musical_box)
        mbox_playing = nil
      end
    else
      mbox_counter = math.max(mbox_counter - 1, 0)
      mbox_counter_limitless = 0
    end

    -- Special case: entering album scenes 1, 4, and 20
    if tl_obj_unlock and zoom_obj and
      ((s1_seq_time == -1 and zoom_obj.unlock == 1) or
       (s4_seq_time == -1 and zoom_obj.unlock == 4) or
       (zoom_obj.unlock == 20))
    then
      local i = tl_obj_unlock.find_tag(zoom_obj.unlock)
      if (tl_obj_unlock.dx - 1.5) * (i - 1.5) >= 0 then
        -- This disables further interactions
        if zoom_obj.unlock == 1 then
          s1_seq_time = 0
          bgm_light:play()
        elseif zoom_obj.unlock == 4 then
          s4_seq_time = 0
        elseif zoom_obj.unlock == 20 then
          -- Overlaid timeline cannot be immediately cleared, as animation will glitch
          -- So wait a few frames before doing so (by calling `synchronise_tl()`)
          s20_seq_time = 0
        end
        -- Clear zoomed-in object
        zoom_obj = nil
        zoom_in_time, zoom_out_time = -1, -1
        if zoom_text then -- XXX: to determine whether this is needed
          zoom_text:release()
          zoom_text = nil
        end
      end
    end

    if s1_seq_time >= 0 then
      s1_seq_time = s1_seq_time + 1
      if s1_seq_time == 1645 then -- 240 ticks/s * (8 * 60/70 seconds)
        s1_seq_time = -2  -- Finished
        synchronise_tl()
      end
    end

    if s4_seq_time >= 0 then
      s4_seq_time = s4_seq_time + 1
      if s4_seq_time == 480 then
        audio.sfx('thunder')
      end
      if s4_seq_time == 960 then
        s4_seq_time = -2  -- Finished
        synchronise_tl()
      end
    end

    if s20_seq_time >= 0 then
      s20_seq_time = s20_seq_time + 1
      if s20_seq_time >= 240 then
        s20_seq_time = -1
        synchronise_tl()
      end
    end
  end

  local particles = {}
  for freq = 0.001, 0.006, 0.0005 do
    for vel = 0.02, 0.08, 0.01 do
      local f0 = freq + love.math.noise(vel * 39292.3456, freq * 8118.888) * 0.002
      local v0 = vel + love.math.noise(freq * 27461.1234, vel * 3553.16253) * 0.04
      local n1 = love.math.noise(freq * 11111, vel * 222 + 22) * 33333.332
      local n2 = love.math.noise(vel * 112, freq * 333) * 45678.9876
      local n4 = love.math.noise((vel + freq * 1823.3) * 13619.94, vel * 123646.17373)
      particles[#particles + 1] = {f0, v0, n1, n2, n4}
    end
  end

  s.draw = function ()
    love.graphics.clear(0.1, 0.1, 0.1)

    local bg_r, bg_g, bg_b, bg_a = 0, 0, 0, 0
    if album_idx == 4 then
      bg_r, bg_g, bg_b, bg_a = 0.05, 0.05, 0.05, 1
    elseif album_idx == 5 or album_idx == 6 then
      bg_r, bg_g, bg_b, bg_a = 0.95, 0.95, 0.95, 1
    end
    if bg_a > 0 then
      love.graphics.setColor(bg_r, bg_g, bg_b, bg_a)
      love.graphics.rectangle('fill', 0, 0, W, H)
    end

    -- Grass
    love.graphics.setColor(1, 1, 1)
    if album_idx == 4 or album_idx == 5 or album_idx == 6 then
      local ampl = (album_idx == 4 and 1 or 0.4)
      local freq = (album_idx == 4 and 1 or 0.3)
      local kx_ampl = (album_idx == 4 and 0.15 or 0.06)
      for i = 1, 3 do
        local dx = math.sin(0.5 + album_idx + i * (1.22 + album_idx) + T * (0.01 + 0.001 * freq * i)) * 4 * ampl
        local dy = math.sin(0.15 + album_idx * 1.77 + i * (3.66 - album_idx) + T * (0.005 - 0.0006 * freq * i)) * 2 * ampl
        local kx = kx_ampl * math.sin(i * i * 7788 + album_idx * i * 3399 + T * 0.007 * freq)
        draw.img('grass_' .. i, W * 0.5 + dx, H * 0.6 + dy, W * 1.2, H * 1.2, 0.5, 0.6, 0, kx)
      end
    end

    -- Rain
    if album_idx == 4 then
      local rain_img_idx = math.floor(T % 160 / 40) + 1
      draw.img('rain_' .. rain_img_idx, W / 2, H / 2, W, H)
    end

    -- Main background image
    local background = album_backgrounds[album_idx]
    if album_idx == 2 and not light_on then
      background = album_backgrounds_alter[album_idx]
    end
    draw.img(background, W / 2, H / 2, W, H)
    if letter_read[album_idx] then
      local background = album_backgrounds_overlay[album_idx]
      draw.img(background, W / 2, H / 2, W, H)
    end

    -- Stage setup for album scene 2 (campfire)
    if album_idx == 2 and not light_on then
      local seq = {'overlay_2_fire_1', 'overlay_2_fire_2'}
      local seq_idx = math.floor(T / 100) % #seq + 1
      draw.img(seq[seq_idx], W / 2, H / 2, W, H)
    end

    -- Stage setup for album scene 20 (remote age)
    if album_idx == 20 then
      draw.img('stage_20_middleground', W / 2, H / 2, W, H)
      -- Gecko
      local gecko_idx = math.floor(T / 20) % 48 + 1
      if gecko_idx > 22 then gecko_idx = 1 end
      draw.img(string.format('stage_20_gecko_%02d', gecko_idx), W / 2, H / 2, W, H)
      draw.flush()

      local bush_move = function (sx_ampl, sx_period, sy_ampl, sy_period, kx_ampl, kx_period, T, seed)
        local n1, n2, n3 = seed, seed, seed
        local sx = 1 + sx_ampl * math.sin((T + n1) / sx_period * math.pi * 2)
        local sy = 1 + sy_ampl * math.sin((T + n2) / sy_period * math.pi * 2)
        local kx = kx_ampl * math.sin((T + n3) / kx_period * math.pi * 2)
        sy = sy * math.cos(kx * 0.5)
        return sx, sy, kx
      end

      local sx1, sy1, kx1 = bush_move(0.002, 2880, 0.005, 2400, 0.01, 1200, T, 77881234)
      draw.img('stage_20_bush_1', W * 0.6, H * 0.9, W * sx1, H * sy1, 0.6, 0.9, 0, kx1, 0)
      local sx2, sy2, kx2 = bush_move(0.002, 2560, 0.004, 1700, 0.01, 1900, T, 17772)
      draw.img('stage_20_bush_2', W * 0.83, H * 0.96, W * sx2, H * sy2, 0.83, 0.96, 0, kx2, 0)
      draw.img('stage_20_light', W / 2, H / 2, W, H)
      local sx3, sy3, kx3 = bush_move(0.0015, 2440, 0.003, 1900, 0.012, 1010, T, 999998)
      draw.img('stage_20_bush_3', W * 0.19 - W * 0.01, H * 1.1, W * sx3, H * sy3, 0.19, 1.1, 0, kx3, 0)

      -- Particles
      local par_ox, par_oy = W * 0.54, H * 0.33
      local par_dx, par_dy = W * 0.02, H * 0.29
      for i = 1, #particles do
        local f0, v0, n1, n2, n4 = unpack(particles[i])
        local n3 = (love.math.noise(T / 371.2818, f0 * 36351858.1, v0 * 16373447.1) - 0.5)
        local n5 = love.math.noise(T / 269.7, f0 * 191774.3, v0 * 28383.2235)
        local n6 = love.math.noise(T / 311.7, v0 * 191774.3, f0 * 28383.2235)
        local phase = f0 * (T + n1) % (2 * math.pi / 0.7)
        local ydist = (T + n2) * v0 % par_dy
        local yprog = ydist / par_dy
        local x = par_ox + par_dx * (math.sin(phase * 0.7 + n5 * 0.3) + n3 * 1.8) * (0.7 + yprog)
        local y = par_oy - ydist + (n6 - 0.5) * par_dy * 0.04
        local alpha = 0.4 + 0.55 * math.sin(T * (3e-4 * (1 + n4)) + n1 + n2)
        if alpha > 0 then
          alpha = alpha * alpha
          if yprog < 0.1 then alpha = alpha * (yprog * 10)
          elseif yprog > 0.8 then alpha = alpha * ((1 - yprog) * 5) end
          love.graphics.setColor(0.95, 0.95, 0.95, alpha)
          love.graphics.circle('fill', x, y, 1, 5)
        end
      end
    end

    -- Lightnings
    if album_idx == 4 then
      local lightning = false
      if s4_seq_time >= 0 then lightning = true
      else lightning = (T % 2400 < 80) end
      if lightning then
        draw.img('lightning', W / 2, H / 2, W, H)
      end
    end

    -- In-scene objects
    love.graphics.setColor(1, 1, 1)
    for i = 1, #objs do
      local o = objs[i]
      if o.scene_sprites then
        local index = o.index
        -- Special case: broken musical box
        if o.musical_box == 'orchid_broken' and index == 2 then
          if mbox_counter_limitless >= 240 and mbox_counter_limitless <= 360 then
            index = math.floor(mbox_counter_limitless / 35) % 2 + 1
          elseif
            (mbox_counter_limitless > 360 and mbox_counter_limitless < 530) or
            (mbox_counter_limitless > 650)
          then
            index = 1
          end
        end

        local image = o.scene_sprites[index]
        if image then
          if o.sprite_w then
            draw.img(image, o.x, o.y, o.sprite_w)
          else
            draw.img(image, W / 2, H / 2, W)
          end
        end
      end
    end
    if debug then
      love.graphics.setColor(1, 0.8, 0.7, 0.3)
      for i = 1, #objs do
        local o = objs[i]
        love.graphics.ellipse('fill', o.x, o.y, o.rx, o.ry)
      end
    end

    -- Zoom-in
    if zoom_obj ~= nil then
      local o_alpha, move_prog
      if zoom_in_time >= 0 then
        local x = math.min(1, zoom_in_time / 120)
        o_alpha = 1 - (1 - x) * (1 - x)
        move_prog = (1 - x) * math.exp(-3 * x)
      else
        local x = math.min(1, zoom_out_time / 120)
        o_alpha = (1 - x) * (1 - x) * (1 - x)
        if x < 0.5 then move_prog = x * x * x * 4
        else move_prog = 1 - (1 - x) * (1 - x) * (1 - x) * 4 end
      end
      local x_target, y_target = W * 0.275, H * 0.5
      if zoom_text == nil then
        x_target = W * 0.5
      end
      local scale = 0.5 + 0.5 * math.sqrt(math.sqrt(o_alpha))
      local w, h = W * scale, H * scale
      local img = zoom_obj.zoom_img
      if zoom_obj.unlocked_img and album_idx == zoom_obj.unlock then
        img = zoom_obj.unlocked_img
      elseif zoom_obj.unlock_seq and zoom_seq_prog >= 10 then
        img = zoom_obj.unlock_seq[math.floor(zoom_seq_prog / UNLOCK_SEQ_PROG_RATE)]
      end
      if zoom_scroll ~= nil then
        local iw, ih = draw.get(img):getDimensions()
        y_target = ih * 0.5 + zoom_scroll.dx
        w, h = iw, ih
      end
      local return_x, return_y = zoom_obj.x, zoom_obj.y
      if zoom_obj.unlock == album_idx and zoom_obj.unlocked_x ~= nil then
        return_x, return_y = zoom_obj.unlocked_x, zoom_obj.unlocked_y
      end
      local x_cen = x_target + (return_x - x_target) * move_prog
      local y_cen = y_target + (return_y - y_target) * move_prog
      if zoom_obj.star_sack then
        local t = sack_key_match_time / 600
        local ampl = (1 - t) * math.exp(-t * 5) * 0.3
        w = w * (1 + math.sin(t * 3 * (math.pi * 2)) * ampl * 0.25)
        h = h * (1 + math.sin(t * 5 * (math.pi * 2)) * ampl)
      end
      local dim_alpha = (1 - (1 - o_alpha) * (1 - o_alpha)) * 0.2
      love.graphics.setColor(0.1, 0.1, 0.1, dim_alpha)
      love.graphics.rectangle('fill', 0, 0, W, H)
      love.graphics.setColor(1, 1, 1, o_alpha)
      draw.img(img, x_cen, y_cen, w, h)
      -- Text
      if zoom_text then
        draw.shadow(0.9, 0.9, 0.9, o_alpha, zoom_text, W * 0.67, H * 0.5)
      end

      -- Star sack?
      if zoom_obj.star_sack then
        for i = 1, #STAR_SACK_BTNS do
          local b = STAR_SACK_BTNS[i]
          if b.active then
            local x_offs, y_offs = -W / 2, -H / 2
            draw.img(b.img, x_cen, y_cen, w, h)
          end
        end
        love.graphics.setColor(1, 1, 1, o_alpha)
        draw.flush()
      end
    end

    -- Pointer
    local p_alpha = 0
    local px_anim, py_anim = px, py
    if p_rel_time >= 0 then
      local x = math.max(0, 1 - p_rel_time / 120)
      p_alpha = x * x
      x = 1 - x ^ 6
      px_anim = px_rel + (px - px_rel) * x
      py_anim = py_rel + (py - py_rel) * x
    elseif p_hold_time >= 0 then
      p_alpha = math.min(1, p_hold_time / 60)
      p_alpha = 1 - (1 - p_alpha) * (1 - p_alpha)
    end
    local p_hide_alpha = 1
    if _G['is_touch'] then
      if p_hold_time >= 0 then
        local x = math.min(1, p_hold_time / 60)
        p_hide_alpha = 1 - (1 - x) * (1 - x)
      elseif p_rel_time == -1 then
        p_hide_alpha = 0
      elseif p_rel_time >= 120 then
        local x = math.max(0, 1 - (p_rel_time - 120) / 120)
        p_hide_alpha = x * x
      end
    end
    love.graphics.setColor(0.97, 0.97, 0.97, (1 - p_alpha) * p_hide_alpha)
    love.graphics.setLineWidth(2)
    love.graphics.circle('line', px_anim, py_anim, pr)
    love.graphics.setColor(0.97, 0.97, 0.97, p_alpha * p_hide_alpha)
    love.graphics.circle('fill', px_anim, py_anim, pr)

    -- Blur
    local blur_alpha = 0
    local tl0 = tl
    local tl = tl_obj_unlock or tl
    if tl.blur_disp > 0.2 then
      blur_alpha = (tl.blur_disp - 0.2) / 0.8
      blur_alpha = blur_alpha^(1/3)
    end
    local audio_bg_vol = 1 - blur_alpha
    if s1_seq_time >= 0 then
      blur_alpha = 1
    end
    if s4_seq_time >= 0 then
      blur_alpha = 1
      if s4_seq_time >= 440 and s4_seq_time < 520 then blur_alpha = 0 end
      if s4_seq_time >= 600 then
        audio_bg_vol = math.min(1, (s4_seq_time - 600) / 240)
      else
        audio_bg_vol = 0
      end
    end
    if blur_alpha > 0 then
      love.graphics.setColor(0.04, 0.04, 0.04, blur_alpha)
      love.graphics.rectangle('fill', 0, 0, W, H)
    end
    -- Audio volume
    -- In-scene
    for i = 1, #objs do
      local o = objs[i]
      if o.musical_box and o.index == 2 then
        audio.sfx_vol(o.musical_box, (1 - blur_alpha) * 0.125)
      end
    end
    -- Background tracks
    if album_idx ~= 4 then
      audio_bg_vol = audio_bg_vol * (0.25 + 0.75 * (1 - mbox_counter / 180) ^ 2)
    end
    local bg_track = bg_tracks[album_idx]
    for i = 1, #bg_tracks_all do bg_tracks_all[i]:setVolume(0) end
    if bg_track then
      bg_track:setVolume(audio_bg_vol)
    end

    -- Timeline
    local tl_alpha = 0
    if tl_time >= 0 then
      if tl_time >= TIMELINE_STAY_DUR - 120 then
        tl_alpha = (TIMELINE_STAY_DUR - tl_time) / 120
      else
        tl_alpha = math.min(1, tl_time / 120)
      end
    end
    if tl_alpha > 0 then
      local timeline_min = tl0.ticks[1]
      local timeline_max = tl0.ticks[#tl0.ticks]
      if tl_obj_unlock then
        timeline_min = math.min(timeline_min,
          math.max(tl_obj_unlock.ticks[1], tl_obj_unlock.dx_disp))
        timeline_max = math.max(timeline_max,
          math.min(tl_obj_unlock.ticks[#tl_obj_unlock.ticks], tl_obj_unlock.dx_disp))
      end
      local scale = 0
      if tl.dx_disp < -0.1 and timeline_min < 0 then
        scale = -tl.dx_disp - 0.1
        local w = (1 - math.exp(-(-tl.dx_disp - 0.1) * 0.1))
        scale = scale * (1 - w * 0.01)
      elseif tl.dx_disp > 1.1 and timeline_max > 1 then
        scale = tl.dx_disp - 1.1
        local w = (1 - math.exp(-(tl.dx_disp - 1.1) * 0.1))
        scale = scale * (1 - w * 0.01)
      end
      local y = function (t)
        local y = (t + scale) / (scale * 2 + 1)
        return H * (0.15 + y * 0.7)
      end
      love.graphics.setColor(1, 1, 1, 0.4 * tl_alpha)
      love.graphics.setLineWidth(4)
      local x = W * 0.94
      love.graphics.line(x, y(timeline_min), x, y(timeline_max))
      for i = 1, #tl0.ticks do
        love.graphics.circle('fill', x, y(tl0.ticks[i]), 12)
      end
      local tl0_ticks = {}
      for i = 1, #tl0.ticks do
        tl0_ticks[tl0.ticks[i]] = true
        draw(album_dates[tl0.tags[i]], x - W * 0.025, y(tl0.ticks[i]), nil, nil, 1, 0.3)
      end
      for i = 1, #tl.ticks do if not tl0_ticks[tl.ticks[i]] then
        local dist = math.min(1, math.abs(tl.dx - i))
        local a = math.max(0, 1 - dist * 2)
        love.graphics.setColor(1, 1, 1, 0.4 * tl_alpha * a)
        draw(album_dates[tl.tags[i]], x - W * 0.025, y(tl.ticks[i]), nil, nil, 1, 0.3)
      end end
      love.graphics.setColor(1, 1, 1, tl_alpha)
      love.graphics.circle('fill', x, y(tl.dx_disp), 20)
    end

    love.graphics.setColor(0.1, 0.1, 0.1)
    love.graphics.rectangle('fill', 0, -H, W, H)
    love.graphics.rectangle('fill', 0, H, W, H)
    love.graphics.rectangle('fill', -W, 0, W, H)
    love.graphics.rectangle('fill', W, 0, W, H)
  end

  s.wheel = function (x, y, x_raw, y_raw)
    if sack_key_match_time >= 0 then return end
    if s1_seq_time >= 0 then return end
    if s4_seq_time >= 0 then return end
    if s20_seq_time >= 0 then return end

    local limit = SCROLL_ACCUM_LIMIT - scroll_accum
    if y < -limit then y = -limit
    elseif y > limit then y = limit end
    scroll_accum = scroll_accum + math.abs(y)

    if zoom_obj ~= nil then
      if zoom_in_time >= 120 then
        if tl_obj_unlock and zoom_obj.unlock ~= album_idx then
          local sign = (album_ticks[zoom_obj.unlock] > album_ticks[album_idx]) and 1 or -1
          local total_prog = #zoom_obj.unlock_seq * UNLOCK_SEQ_PROG_RATE
          if zoom_seq_prog >= total_prog and y * sign >= 0 then
            tl_obj_unlock.push(y * 0.75)
            tl_time = math.max(0, math.min(120, tl_time))
          else
            zoom_seq_prog = math.max(0, math.min(total_prog, zoom_seq_prog + y * sign))
            if zoom_seq_prog >= total_prog then
              scroll_accum = SCROLL_ACCUM_LIMIT -- Slow down!
            end
          end
        elseif zoom_scroll then
          if _G['trackpadMode'] then
            zoom_scroll.dx = zoom_scroll.dx + y_raw * 0.5
          else
            zoom_scroll.impulse(y * 3)
          end
        end
      end
    elseif #tl.ticks > 1 then
      tl.push(y)
      tl_time = math.max(0, math.min(120, tl_time))
    end
  end

  s.destroy = function ()
  end

  return s
end
