--[[
I`am 100% qhouz lover ❤️
SenkoTech 1❤️
A student of qhouz himself❤️
--]]
-- print('new startup')
local http = require('neverlose/http_lib')
local gradient = require('neverlose/gradient')
local inspect = require('neverlose/inspect') local inspect = function(...) return print(inspect(...)) end
local mtools = require('neverlose/mtools')
local clipboard = require('neverlose/clipboard')
local JSON = require('neverlose/better_json')
local base64 = require('neverlose/base64')
local net = utils.net_channel()

local FFI = {
    ffi.cdef[[
        void* __stdcall URLDownloadToFileA(void* LPUNKNOWN, const char* LPCSTR, const char* LPCSTR2, int a, int LPBINDSTATUSCALLBACK);
        bool DeleteUrlCacheEntryA(const char* lpszUrlName);
    ]],
    setup = function(self)
        self.wininet = ffi.load('WinInet')
        self.urlmon  = ffi.load('UrlMon')
    end
}; FFI:setup()

local accent_clr = color(0, 178, 255)
local screen = render.screen_size()
local DEBUG = false
local BUILD = 'STABLE'
local LASTUPDATE = '25.10.2023'
local literal = {
    FL_ONGROUND = bit.lshift(1, 0),
    FL_FROZEN = bit.lshift(1, 6)
}

local resource = {}
local font = {}
local animation = { data = {} }
local renderer = {}
local http = { task = http.new({task_interval = 0.3, enable_debug = false, timeout = 10}) }

local c_item = {}; c_item.__index = c_item
local c_nui = { data = {} }; c_nui.__index = c_nui
local nui = { data = {} }

local assistant = {
    global = function()
        -- * table
        table.shall_copy = function(t)
            local new_t = {}
            for i = 1, #t do
                table.insert(new_t, t[i])
            end
            return new_t
        end
        table.reverse = function(t)
            local new_t = table.shall_copy(t)
            for i = 1, math.floor(#t / 2), 1 do
                new_t[i], new_t[#t - i + 1] = new_t[#t - i + 1], new_t[i]
            end
            return new_t
        end
        table.add_table = function(t, add_t)
            local new_t = table.shall_copy(t)
            for _, v in pairs(add_t) do
                table.insert(new_t, v)
            end
            return new_t
        end
        table.key_rotate = function(t, i)
            i = -i
            for k = 1, math.abs(i) do
                if i < 0 then
                    table.insert(t, 1, table.remove(t))
                else
                    table.insert(t, table.remove(t, 1))
                end
            end
            return t
        end
        table.show = function(t)
            for k, v in pairs(t) do
                print(k, ' | ', v)
            end
        end
        table.contains = function(t, value)
            for k, v in pairs(t) do
                if v == value then
                    return true, type(k) == 'string' and k or false, k
                end
            end
            return false, false
        end
        table.get_new_index = function(t, type)
            local new_i = #t; if t[new_i + 1] == nil then
                t = type or 0
                return new_i + 1
            end
        end

        -- * string
        string.split = function(text)
            local t = {}
            for i = 1, text:len() do
                table.insert(t, text:sub(i, i))
            end
            return t
        end

        -- * math
        math.flerp = function(a, b, t)
            return a + t * (b - a)
        end
        math.flerp_inverse = function(a, b, v)
            return (v - a) / (b - a)
        end
        math.lerp_values_by_step = function(start, final, step)
            local val_t = {}; for i = 0, 1, 1 / (step - 1) do
                table.insert(val_t, math.flerp(start, final, i))
            end
            return val_t
        end
        math.is_nan = function(n)
            return tostring(n) == 'nan' or tostring(n) == '-nan'
        end
        math.interval = function(variation, start, final, speed, sway)
            local diff = math.abs(start - final)

            local val = (variation * speed / 5) % (sway and diff * 2 or diff)
            if math.is_nan(val) then val = 0 end

            if sway then
                val = val < diff and val or diff - (val - diff)
            end

            local fval = math.flerp_inverse(0, diff, val)
            if math.is_nan(fval) then fval = 0 end

            return math.flerp(start, final, fval)
        end
        math.is_float = function(num)
            return num % 1 ~= 0
        end
        math.round = function(value, decimals)
            local multiplier = 10 ^ (decimals or 0)
            return math.floor(value * multiplier + 0.5) / multiplier
        end
        math.to_ticks = function(x)
            return math.round(x / globals.tickinterval);
        end
        math.angle_to_forward = function(vec)
            local rad = {
                x = math.rad(vec.x),
                y = math.rad(vec.y),
            }

            local sp = math.sin(rad.x)
            local sy = math.sin(rad.y)
            local cp = math.cos(rad.x)
            local cy = math.cos(rad.y)

            return vector(cp * cy, cp * sy, -sp)
        end
        math.normalize = function(angle)
            if angle < -180 then
                angle = angle + 360
            end
            if angle > 180 then
                angle = angle - 360
            end
            return angle
        end

    end,
    render = function()
        renderer.rect = function(vec1, vec2, ...)
            render.rect(vec1, vec1 + vec2, ...)
        end
        renderer.gradient = function(vec1, vec2, ...)
            render.gradient(vec1, vec1 + vec2, ...)
        end
        renderer.blur = function(vec1, vec2, ...)
            render.blur(vec1, vec1 + vec2, ...)
        end
        renderer.shadow = function(vec1, vec2, ...)
            render.shadow(vec1, vec1 + vec2, ...)
        end
        renderer.glow_text = function(font, vec, clr, flags, text)
            local size = render.measure_text(font, nil, text)
            if flags == 'c' then
                size = size / 2
                render.shadow(vec + vector(-size.x, size.y - 5), vec + vector(size.x, size.y - 5), clr, 20);
            else
                render.shadow(vector(vec.x, vec.y + size.y / 2 + 1), vector(vec.x + size.x, vec.y + size.y / 2 + 1), clr, 20)
            end
            render.text(font, vec, clr, flags, text)
        end
        renderer.push_clip = function(vec1, vec2, ...)
            render.push_clip_rect(vec1, vec1 + vec2, ...)
        end
        renderer.pop_clip = function()
            render.pop_clip_rect()
        end
    end,
    http = function()
        http.download = function(url, path)
            FFI.wininet.DeleteUrlCacheEntryA(url)
            FFI.urlmon.URLDownloadToFileA(nil, url, path, 0, 0)
        end
    end,
    aqua = function(self)
        self.path = 'nl/aqua club'; files.create_folder(self.path)
        self.f_resource = self.path..'/resource'; files.create_folder(self.f_resource)
        self.f_icons = self.f_resource..'/icons'; files.create_folder(self.f_icons)
        self.f_fonts = self.f_resource..'/fonts'; files.create_folder(self.f_fonts)
        self.f_configs = self.path..'/configs'; files.create_folder(self.f_configs)

        local download = {
            icons = {
                ['logo_small'] = 'https://github.com/pullyfy/logins/blob/main/aqua%20club/icons/logo_small.png?raw=true',
                ['logo_original'] = 'https://github.com/pullyfy/logins/blob/main/aqua%20club/icons/logo_original.png?raw=true',
                ['user']     = 'https://github.com/pullyfy/logins/blob/main/aqua%20club/neverlose/user.png?raw=true',
                ['fps']      = 'https://github.com/pullyfy/logins/blob/main/aqua%20club/neverlose/fps.png?raw=true',
                ['ping']     = 'https://github.com/pullyfy/logins/blob/main/aqua%20club/neverlose/ping.png?raw=true',
                ['time']     = 'https://github.com/pullyfy/logins/blob/main/aqua%20club/neverlose/time.png?raw=true',
                ['settings'] = 'https://github.com/pullyfy/logins/blob/main/aqua%20club/neverlose/settings.png?raw=true',
                ['toggle']   = 'https://github.com/pullyfy/logins/blob/main/aqua%20club/neverlose/toggle.png?raw=true',
                ['hold']     = 'https://github.com/pullyfy/logins/blob/main/aqua%20club/neverlose/hold.png?raw=true',
                ['ghost']    = 'https://github.com/pullyfy/logins/blob/main/aqua%20club/neverlose/ghost.png?raw=true',
                ['jitter']   = 'https://github.com/pullyfy/logins/blob/main/aqua%20club/neverlose/jitter.png?raw=true',
                ['keyboard'] = 'https://github.com/pullyfy/logins/blob/main/aqua%20club/neverlose/keyboard.png?raw=true',
            },
            fonts = {
                ['Calibri Bold'] = 'https://github.com/pullyfy/logins/raw/main/aqua%20club/neverlose/Calibri%20Bold.ttf',
                ['Museo Sans 700'] = 'https://github.com/pullyfy/logins/raw/main/aqua%20club/neverlose/Museo%20Sans%20700.ttf',
            }
        }

        for k, v in pairs(download.icons) do
            local path = string.format('%s/%s.png', self.f_icons, k)
            if files.read(path) == nil then
                http.download(v, path)
            end
        end

        for k, v in pairs(download.fonts) do
            local path = string.format('%s/%s.ttf', self.f_fonts, k)
            if files.read(path) == nil then
                http.download(v, path)
            end
        end
    end,
    animation = function()
        animation.lerp = function(start, _end, time, do_extraanim)
            if (not do_extraanim and math.floor(start) == _end) then
                return
                _end
            end
            time = globals.frametime * (time * 175)
            if time < 0 then
                time = 0.01
            elseif time > 1 then
                time = 1
            end
            return (_end - start) * time + start
        end
        animation.lerp_color = function(start, _end, time)
            local new = {start.r, start.g, start.b, start.a}
            for i, v in pairs({_end.r, _end.g, _end.b, _end.a}) do
                new[i] = math.lerp(new[i], v, time, false)
            end
            return color(math.round(new[1]), math.round(new[2]), math.round(new[3]), math.round(new[4]))
        end

        animation.new = function(name, start, value, time, do_extraanim)
            if animation.data[name] == nil then animation.data[name] = start end
            animation.data[name] = type(start) == 'number' and animation.lerp(animation.data[name], value, time, do_extraanim) or animation.lerp_color(animation.data[name], value, time)
            return animation.data[name]
        end
        animation.condition_new = function(name, condition, time)
            if animation.data[name] == nil then animation.data[name] = 0 end
            animation.data[name] = animation.lerp(animation.data[name], condition and 1 or 0, time, true)
            return animation.data[name]
        end
        animation.on_enable = function(name, condition, time)
            if animation.data[name] == nil then animation.data[name] = 0 end
            animation.data[name] = animation.lerp(animation.data[name], condition and 1 or 0, time, true)
            if animation.data[name] < 0.01 then
                return false
            end
            return animation.data[name]
        end

        animation.get = function(name)
            return animation.data[name]
        end
    end,
    resource = function(self)
        resource.icon = {
            logo_original = render.load_image_from_file(self.f_icons..'/logo_original.png'),
            logo_small = render.load_image_from_file(self.f_icons..'/logo_small.png'),

            user = render.load_image_from_file(self.f_icons..'/user.png'),
            fps  = render.load_image_from_file(self.f_icons..'/fps.png'),
            ping = render.load_image_from_file(self.f_icons..'/ping.png'),
            time = render.load_image_from_file(self.f_icons..'/time.png'),
            settings = render.load_image_from_file(self.f_icons..'/settings.png'),

            toggle = render.load_image_from_file(self.f_icons..'/toggle.png'),
            hold = render.load_image_from_file(self.f_icons..'/hold.png'),

            ghost = render.load_image_from_file(self.f_icons..'/ghost.png'),
            jitter = render.load_image_from_file(self.f_icons..'/jitter.png'),

            keyboard = render.load_image_from_file(self.f_icons..'/keyboard.png'),

            -- steam_avatar = mtools.Client.GetAvatar(1)
        }
    end,
    handler = function(self)
        self._function = {}; events.render:set(function()
            for _, _function in pairs(self._function) do
                _function(self)
            end
        end)
    end,
    drag_system = function(self)
        self.drags_t = {}
        self.drags = {
            holded = false,
        }
        local cached = {
            menu = nui.create('DEBUG', 'drag system')
        }

        self.drag_object_setup = function(name, pos_t)
            if self.drags_t[name] == nil then
                cached[name] = {
                    x = cached.menu:slider(string.format('%s.x', name), 0, screen.x),
                    y = cached.menu:slider(string.format('%s.y', name), 0, screen.y),
                }

                cached[name].x:visibility(DEBUG)
                cached[name].y:visibility(DEBUG)

                pos_t.x = cached[name].x:get()
                pos_t.y = cached[name].y:get()

                self.drags_t[name] = pos_t
            end

            if nui.get_alpha() == 1 then
                cached[name].x = cached[name].x:set(self.drags_t[name].x)
                cached[name].y = cached[name].y:set(self.drags_t[name].y)

                table.insert(self.drags, self.drags_t[name])
            end

            return self.drags_t[name]
        end
        self.drag_object_change_size = function(name, w, h)
            self.drags_t[name].w = w
            self.drags_t[name].h = h
        end
        self.get_drag_object = function(name)
            return self.drags_t[name]
        end

        table.insert(self._function, function()
            local cursor = nui.get_mouse_position()
            local key = common.is_button_down(1)
            for index, drag in pairs(self.drags) do
                if type(drag) == 'table' then
                    if not drag[index] then drag[index] = {} end
                    if not drag[index].x then drag[index].x = 0.0 end
                    if not drag[index].y then drag[index].y = 0.0 end
                    if not drag[index].backup then drag[index].backup = false end

                    if cursor.x >= drag.x and cursor.x <= drag.x + drag.w and cursor.y >= drag.y and cursor.y <= drag.y + drag.h then
                        if not drag[index].backup and key and not self.drags.holded then
                        drag[index].x = drag.x - cursor.x
                        drag[index].y = drag.y - cursor.y
                        drag[index].backup = true
                        self.drags.holded = true
                        end
                    end

                    if not key then
                        drag[index].backup = false
                        self.drags.holded = false
                    end

                    if drag[index].backup then
                        drag.x = math.min(math.max(cursor.x + drag[index].x, 0.0), screen.x - drag.w)
                        drag.y = math.min(math.max(cursor.y + drag[index].y, 0.0), screen.y - drag.h)
                    end

                    table.remove(self.drags, index)
                end
            end
        end)
    end,
    font = function(self)
        font.CalibriBold = render.load_font(self.f_fonts..'/Calibri Bold.ttf', 13, 'a')
        font.MuseoSans700 = render.load_font(self.f_fonts..'/Museo Sans 700.ttf', 14, 'a')
    end,
    nui = function(self)
        nui.new = function(data) local i = table.get_new_index(nui.data); nui.data[i] = data; return setmetatable(nui.data[i], c_nui) end
        c_nui.new = function(data) local i = table.get_new_index(c_nui.data); c_nui.data[i] = data; return setmetatable(c_nui.data[i], c_item) end

        do -- c_item
            do -- neverlose methods
                function c_item:get(...)
                    return self[1]:get(...)
                end
                function c_item:id()
                    return self[1]:id()
                end
                function c_item:list()
                    return self[1]:list()
                end
                function c_item:type()
                    return self[1]:type()
                end
                function c_item:override(...)
                    return self[1]:override(...)
                end
                function c_item:get_override(...)
                    return self[1]:override(...)
                end
                function c_item:update(...)
                    return self[1]:update(...)
                end
                function c_item:reset()
                    return self[1]:reset()
                end
                function c_item:set(...)
                    return self[1]:set(...)
                end
                function c_item:name(...)
                    return self[1]:name(...)
                end
                function c_item:tooltip(...)
                    return self[1]:tooltip(...)
                end
                function c_item:visibility(...)
                    return self[1]:visibility(...)
                end
                function c_item:disabled(...)
                    return self[1]:disabled(...)
                end
                function c_item:set_callback(...)
                    return self[1]:set_callback(...)
                end
                function c_item:unset_callback(...)
                    return self[1]:unset_callback(...)
                end
                function c_item:color_picker(...)
                    return self[1]:color_picker(...)
                end
                function c_item:create(...)
                    return nui.new({
                        self[1]:create(...)
                    }, c_nui)
                end
                function c_item:parent()
                    return self[1]:parent()
                end
            end

            function c_item:class(str)
                if str ~= nil then
                    self.g_class = str
                else
                    return self.g_class
                end
            end
        end
        do -- c_nui
            local new = c_nui.new
            do -- items
                function c_nui:switch(...)
                    local item = self[1]:switch(...)
                    return new({
                        item,
                        g_class = ''
                    })
                end
                function c_nui:slider(...)
                    local item = self[1]:slider(...)
                    return new({
                        item,
                        g_class = ''
                    })
                end
                function c_nui:combo(...)
                    local item = self[1]:combo(...)
                    return new({
                        item,
                        g_class = ''
                    })
                end
                function c_nui:selectable(...)
                    local item = self[1]:selectable(...)
                    return new({
                        item,
                        g_class = ''
                    })
                end
                function c_nui:color_picker(...)
                    local item = self[1]:color_picker(...)
                    return new({
                        item,
                        g_class = ''
                    })
                end
                function c_nui:input(...)
                    local item = self[1]:input(...)
                    return new({
                        item,
                        g_class = ''
                    })
                end
                function c_nui:list(...)
                    local item = self[1]:list(...)
                    return new({
                        item,
                        g_class = ''
                    })
                end
                function c_nui:listable(...)
                    local item = self[1]:listable(...)
                    return new({
                        item,
                        g_class = ''
                    })
                end
                function c_nui:hotkey(...)
                    local item = self[1]:hotkey(...)
                    return new({
                        item,
                        g_class = ''
                    })
                end
                function c_nui:button(...)
                    local item = self[1]:button(...)
                    return new({
                        item,
                        g_class = ''
                    })
                end
                function c_nui:label(...)
                    local item = self[1]:label(...)
                    return new({
                        item,
                        g_class = ''
                    })
                end
                function c_nui:texture(...)
                    local item = self[1]:texture(...)
                    return new({
                        item,
                        g_class = ''
                    })
                end
            end
            do -- methods
                function c_nui:visibility(...)
                    return self[1]:visibility(...)
                end
            end
        end
        do -- nui
            for k, v in pairs(ui) do
                if k == 'create' then
                    v = function(...)
                        return nui.new({
                            ui.create(...)
                        }, c_nui)
                    end
                end; nui[k] = v
            end

            nui.reset = function()
                for _, item in ipairs(c_nui.data) do
                    item[1]:reset()
                end
            end

            nui.save = function(name)
                local saved = {owner = common.get_username(), data = {}}
                for _, item in ipairs(c_nui.data) do
                    if item[1]:type() ~= 'button' then
                        table.insert(saved.data, {
                            id    = item[1]:id(),
                            value = item[1]:type() == 'color_picker' and item[1]:get():to_hex() or item[1]:get(),
                            class = item:class()
                        })
                    end
                end
                return JSON.stringify(saved)
            end
            nui.load = function(data_str, class, reset)
                if data_str == nil then
                    return
                end
                if reset then
                    nui.reset()
                end
                data_str = JSON.parse(data_str)
                for _, item in ipairs(c_nui.data) do
                    for _, v in pairs(data_str.data) do
                        if item[1]:id() == v.id and ((class == nil) and true or (class == item:class())) then
                            item:set(v.value)
                        end
                    end
                end
                return data_str.owner, data_str.name
            end

            nui.encode = function(script, data)
                return string.format('%s:%s', script or 'CFG', base64.encode(data))
            end
            nui.decode = function(script, data)
                if data:find(script or 'CFG') == nil then
                    common.add_notify('Config', 'Invalid. Check your clipboard.')
                    return
                end
                return base64.decode(data:sub((script or 'CFG'):len() + 2, data:len()))
            end

            nui.export = function()
                clipboard.set(nui.encode('AQUA', nui.save()))
            end
            nui.import = function(class, reset)
                return nui.load(nui.decode('AQUA', clipboard.get()), class, reset)
            end

            nui.file_save = function(path, name)
                files.write(string.format('%s/%s.cfg', path, name), nui.encode('AQUA', nui.save()))
            end
            nui.file_load = function(path, name, class, reset)
                return nui.load(nui.decode('AQUA', files.read(string.format('%s/%s.cfg', path, name))), class, reset)
            end
        end
    end,
    setup = function(self)
        self:global()
        self:nui()
        self:handler()
        self:render()
        self:animation()
        self:http(); self:aqua(); self:resource(); self:font()
        self:drag_system()

        self.check = function()
            return globals.is_connected and globals.is_in_game
        end
        self.wave_text = function(text, stage, anim_speed)
            text = string.split(text)

            if not anim_speed then
                stage = stage or 1
                if math.is_float(stage) then
                    stage = math.round(stage * #text)
                end
            else
                stage = math.floor(globals.curtime * anim_speed % (#text * 2))
            end

            local way = math.lerp_values_by_step(0, 1, #text)
            way = table.add_table(way, table.reverse(way))
            way = table.key_rotate(way, stage)

            return text, way
        end
        self.html_wave_text = function(text, clr_left, clr_right, stage, reverse, anim_speed)
            local text, wave = self.wave_text(text, stage, anim_speed)

            local new_text = {}
            for k, v in pairs(text) do
                local ab = clr_left:lerp(clr_right, wave[k]):to_hex()
                table.insert(new_text, string.format('\a%s%s', ab, v))
            end

            return table.concat(new_text)
        end
        self.color_the_text = function(s, clr)
            clr = clr or color()
            return string.format('\a%s%s', clr:to_hex(), s)
        end
        self.color_text = function(text_t)
            local s = {}
            for k, v in pairs(text_t) do
                v[2] = v[2] or color(255, 255, 255)
                table.insert(s, string.format('\a%s%s', v[2]:to_hex(), v[1]))
            end
            return table.concat(s)
        end
        self.icon_text = function(icon, text)
            return string.format('%s%s', nui.get_icon(icon), text)
        end
        self.get_latency = function()
            -- print(net)
            return math.floor((net.latency[1] - 0.007) * 1000)
        end
        self.get_ping = function()
            if not globals.is_in_game then
                return 'offline'
            end

            local ping = self.get_latency()
            if ping <= 4 then
                return 'local'
            end

            return ping .. 'ms'
        end
        self.get_fps = function()
            return math.floor(1 / (globals.frametime))
        end
        self.get_time = function(h12)
            local t = common.get_system_time()
            local h = h12 and t.hours % 12 or t.hours

            return string.format('%s%s:%s%s %s', tostring(h):len() == 1 and '0' or '', h, t.minutes < 10 and '0' or '', t.minutes, h12 and (t.hours % 24 >= 12 and 'PM' or 'AM') or '')
        end
        self.get_binds = function(name, include, sort_f, animation_speed)
            local binds_t, output = {}, false

            local add_info = function(bind_t, bind_name, info)
                if bind_t.name == bind_name then
                    -- bind_t.info = info
                    for k, v in pairs(info) do
                        bind_t[k] = v
                    end
                end
            end

            for k, v in pairs(nui.get_binds()) do
                output = true

                v = {
                    name = v.name,
                    mode = v.mode,
                    value = v.value,
                    active = v.active,
                    reference = v.reference
                }

                local icon = v.name:find('[^%w .]'); if icon then
                    v.name = v.name:sub(icon + 4, v.name:len())
                end

                add_info(v, v.name, {
                    anim = animation.new(string.format('%s.%s', name, v.name), v.active and 1 or 0, v.active and 1 or 0, animation_speed, true)
                })
                add_info(v, 'Double Tap', {
                    charge = rage.exploit:get()
                })

                if include ~= nil then
                    local contain, key = table.contains(include, v.name)
                    if contain then
                        if key ~= false then
                            v.name = key
                        end
                    else
                        goto proceed
                    end
                end

                table.insert(binds_t, v)
                ::proceed::
            end

            if sort_f ~= nil then
                table.sort(binds_t, sort_f)
            end

            return binds_t, {output = output}
        end
        self.get_desync_delta = function()
            return math.min(math.abs(rage.antiaim:get_rotation() - rage.antiaim:get_rotation(true)), 58)
        end
        self.get_player_speed = function(player)
            return player.m_vecVelocity:length()
        end
        self.player_in_air = function(player)
            return bit.band(player['m_fFlags'], literal.FL_ONGROUND) == 1
        end
        self.get_current_group_weapon = function(player)
            local weapon = player:get_player_weapon()
            if weapon == nil then
                return
            end

            local group = {
                'Pistols',
                'Submachineguns',
                'Rifles',
                'Shotguns',
                'Snipers',
                'Machineguns'
            }

            local current = group[weapon:get_weapon_info().weapon_type]

            local name = weapon:get_weapon_info().console_name
            if current == 'Pistols' then
                if name == 'weapon_revolver' then
                    current = 'R8 Revolver'
                elseif name == 'weapon_deagle' then
                    current = 'Desert Eagle'
                end
            elseif current == 'Snipers' then
                current = 'AutoSnipers'
                if name == 'weapon_ssg08' then
                    current = 'SSG-08'
                elseif name == 'weapon_awp' then
                    current = 'AWP'
                end
            end

            return current
        end
        local nWay = {}; self.nWay = function(name, start, final, condition, ways)
            if nWay[name] == nil then
                nWay[name] = 1
            end; local val_t = math.lerp_values_by_step(start, final, ways)

            if condition then
                nWay[name] = nWay[name] + 1
                if nWay[name] > ways then
                    nWay[name] = 1
                end
            end

            if not val_t[nWay[name]] then
                val_t[nWay[name]] = 0
            end

            return val_t[nWay[name]]
        end
        self.defensive = {}; do
            self.defensive.tick = 0
            self.defensive.duration = 0
            self.defensive.old_simtime = 0

            self.defensive.update = function()
                if not self.check() then
                    return
                end

                local lp = entity.get_local_player()
                if lp == nil then
                    return
                end

                local simtime = lp['m_flSimulationTime']
                local delta = self.defensive.old_simtime - simtime

                if delta > 0 then
                    self.defensive.tick = globals.tickcount;
                    self.defensive.duration = math.to_ticks(delta);
                end

                self.defensive.old_simtime = simtime
            end
            self.defensive.get = function()
                return globals.tickcount < self.defensive.tick + (self.defensive.duration - math.to_ticks(net.latency[0]))
            end
            self.defensive.reset = function()
                self.defensive.tick = 0
                self.defensive.duration = 0
                self.defensive.old_simtime = 0
            end

            local reseted = false; table.insert(self._function, function()
                if not self.check then
                    if not reseted then
                        self.defensive.reset()
                        reseted = true
                    end
                else
                    reseted = false
                end
            end)

            events.net_update_start:set(function()
                self.defensive.update()
            end)
        end
        local air_tick = 0; self.get_condition = function()
            local lp = entity.get_local_player()
            if lp == nil then
                return
            end

            if not self.check() then
                return
            end

            local m_fFlags = lp['m_fFlags']
            local m_bDucked = lp['m_bDucked']
            local speed = self.get_player_speed(lp)
            local slowwalk = nui.find('Aimbot', 'Anti Aim', 'Misc', 'Slow Walk'):get()
            local in_air = false

            if bit.band(m_fFlags, literal.FL_ONGROUND) == 0 then
                in_air = true
                air_tick = globals.tickcount + 3
            else
                in_air = (air_tick > globals.tickcount) and true or false
            end

            if in_air and m_bDucked then
                return 'AIR-C'
            end

            if in_air then
                return 'AIR'
            end

            if m_bDucked then
                return 'DUCKED'
            end

            if slowwalk then
                return 'WALK'
            end

            if speed < 8 then
                return 'STAND'
            else
                return 'RUN'
            end
        end
        local update_value_data = {}; self.update_value = function(name, variation, value, delay)
            if update_value_data[name] == nil then
                update_value_data[name] = value
            end

            if type(variation) == 'boolean' then
                if variation then
                    update_value_data[name] = value
                end
            else
                if variation % (delay or 0) == 0 then
                    update_value_data[name] = value
                end
            end

            return update_value_data[name]
        end
        self.choke = {f = false, aa = false}; self.get_choke = function()
            return {
                bool = self.choke.f,
                int = globals.choked_commands
            }
        end
    end,
}; assistant:setup()

local ref = {
    rage = {
        ssg08 = {
            hitchance = nui.find('Aimbot', 'Ragebot', 'Selection', 'SSG-08', 'Hit Chance'),
        },

    },
    antiaim = {
        pitch               = nui.find('Aimbot', 'Anti Aim', 'Angles', 'Pitch'),
        yaw                 = nui.find('Aimbot', 'Anti Aim', 'Angles', 'Yaw'),
        yaw_offset          = nui.find('Aimbot', 'Anti Aim', 'Angles', 'Yaw', 'Offset'),
        yaw_base            = nui.find('Aimbot', 'Anti Aim', 'Angles', 'Yaw', 'Base'),
        hidden              = nui.find('Aimbot', 'Anti Aim', 'Angles', 'Yaw', 'Hidden'),
        avoid_backstab     = nui.find('Aimbot', 'Anti Aim', 'Angles', 'Yaw', 'Avoid Backstab'),
        yaw_modifier        = nui.find('Aimbot', 'Anti Aim', 'Angles', 'Yaw Modifier'),
        yaw_modifier_offset = nui.find('Aimbot', 'Anti Aim', 'Angles', 'Yaw Modifier', 'Offset'),
        desync              = nui.find('Aimbot', 'Anti Aim', 'Angles', 'Body Yaw'),
        desync_inverter     = nui.find('Aimbot', 'Anti Aim', 'Angles', 'Body Yaw', 'Inverter'),
        desync_left         = nui.find('Aimbot', 'Anti Aim', 'Angles', 'Body Yaw', 'Left Limit'),
        desync_right        = nui.find('Aimbot', 'Anti Aim', 'Angles', 'Body Yaw', 'Right Limit'),
        desync_options      = nui.find('Aimbot', 'Anti Aim', 'Angles', 'Body Yaw', 'Options'),
        desync_freestand    = nui.find('Aimbot', 'Anti Aim', 'Angles', 'Body Yaw', 'Freestanding'),

        leg_movement        = nui.find('Aimbot', 'Anti Aim', 'Misc', 'Leg Movement'),
    },
    world = {
        scope_overlay = nui.find('Visuals', 'World', 'Main', 'Override Zoom', 'Scope Overlay')
    },
    misc = {
        air_strafe = nui.find('Miscellaneous', 'Main', 'Movement', 'Air Strafe')
    }
}

local home = {}; do
    local clr = nui.get_style('Button')
    home.info = {}; do
        local group = nui.create(assistant.icon_text('house', ' Main'), 'Information')


        home.logo = group:texture(resource.icon.logo_original, vector(260, 260))
        group:button('\a'..clr:to_hex()..'     '..assistant.icon_text('discord', ' Discord')..'      ', function()
            panorama.SteamOverlayAPI.OpenExternalBrowserURL('https://discord.gg/qh5QpPW9Nd')
        end, true)
        group:label(assistant.color_text{
            {'Username: '},
            {common.get_username(), clr}
        })
        group:label(assistant.color_text{
            {'Build: '},
            {BUILD, clr}
        })
        group:label(assistant.color_text{
            {'Last update: '},
            {LASTUPDATE, clr}
        })
    end
    home.config = {}; do
        local group = nui.create(assistant.icon_text('house', ' Main'), 'Config')

        local t = {
            ['export'] = '\a'..clr:to_hex()..'           '..assistant.icon_text('arrow-up-from-line', ' Export')..'           ',
            ['import'] = '\a'..clr:to_hex()..'          '..assistant.icon_text('arrow-down-from-line', ' Import')..'           ',
            ['default'] = '\a'..clr:to_hex()..'        🌊 Default         ',
            ['reset'] = '\a'..clr:to_hex()..'           '..assistant.icon_text('rotate-right', ' Reset')..'            ',
        }

        home.config.export = group:button(t['export'], nil, true)
        home.config.import = group:button(t['import'], nil, true)

        home.config.default = group:button(t['default'], nil, true)
        home.config.reset = group:button(t['reset'], nil, true)

        home.config.new_cfg = group:input('\a'..clr:to_hex()..assistant.icon_text('input-text', ' New config'))
        home.config.new_cfg:visibility(false)
    end
end

local antiaim = {}; do
    antiaim.general = {}; do
        local general = nui.create(assistant.icon_text('location-crosshairs-slash', ' Anti-Aim'), 'General')

        antiaim.general.mode = general:combo(assistant.icon_text('gear', ' Mode'), 'Default', 'Builder')
        antiaim.general.tweaks = general:selectable(assistant.icon_text('filter', ' Additions'), 'Avoid backstab')
        antiaim.general.legit_aa = general:switch(assistant.icon_text('hand', ' Legit anti-aim')); antiaim.general.legit_aa:tooltip('Also works on USE button')
        antiaim.general.edge_yaw = general:switch(assistant.icon_text('arrow-rotate-left', ' Edge yaw'))

        antiaim.general.anim_breakers = general:switch(assistant.icon_text('wheelchair', ' Animation breakers'))
        -- antiaim.general.anim_tester = general:slider(string.format("%s Feature", nui.get_icon("tree")), 0, 100)
        local anim_breakers = antiaim.general.anim_breakers:create(); do
            antiaim.general.anim_breakers_gear = {}

            antiaim.general.anim_breakers_gear.legs = anim_breakers:combo('Legs', 'None', 'Backward', 'Jitter', 'Running', 'Static')
            antiaim.general.anim_breakers_gear.in_air = anim_breakers:combo('In air', 'None', 'Static legs')
            antiaim.general.anim_breakers_gear.crouch = anim_breakers:combo('In crouch', 'None', 'Static legs', 'Amogus')
        end
    end

    antiaim.builder = {}; do
        antiaim.builder.self = nui.create(assistant.icon_text('location-crosshairs-slash', ' Anti-Aim'), 'Builder')
        local builder = antiaim.builder.self
        antiaim.builder.states = {'Global', 'Stand', 'Run', 'Walk', 'Ducked', 'Air', 'Air-c'} -- STAND, RUN, WALK, DUCKED, AIR, AIR-C

        antiaim.general.state = builder:combo('State', unpack(antiaim.builder.states))

        antiaim.builder.el = {}; for _, v in pairs(antiaim.builder.states) do
            v = v:lower()

            antiaim.builder.el[v] = {
                override = builder:switch('Override '..v),
                pitch = builder:combo('Pitch ', 'Disabled', 'Down', 'Fake down', 'Fake up'),

                yaw = builder:combo('Yaw', 'Disabled', 'Local view', 'At target'),
                yaw_start = builder:slider('Start', -180, 180, 0),
                yaw_end = builder:slider('End', -180, 180, 0),
                yaw_modifier = builder:combo('Yaw modifier', 'Disabled', 'Center', 'Offset', 'Random', 'Spin', '3-Way', '5-Way'),

                desync = builder:switch('Desync '),
                desync_start = builder:slider('Start', -60, 60, 0),
                desync_end = builder:slider('End', -60, 60, 0),

                force_defensive = builder:switch('Force hidden'),

                hiddenConYaw = builder:switch('Configure yaw'),
                hiddenYaw_start = builder:slider('Start', -180, 180, 0),
                hiddenYaw_end = builder:slider('End', -180, 180, 0),

                hiddenConPitch = builder:switch('Configure pitch'),
                hiddenPitch_start = builder:slider('Start', -89, 89, -89),
                hiddenPitch_end = builder:slider('End', -89, 89, -89),
            }

            for k, v in pairs(antiaim.builder.el[v]) do
                v:class('anti-aim')
            end
        end

        antiaim.builder.gear = {}; for k, v in pairs(antiaim.builder.el) do
            local yaw = v.yaw:create()
            local yaw_modifier = v.yaw_modifier:create()
            local desync = v.desync:create()
            local hidden_yaw = v.hiddenConYaw:create()
            local hidden_pitch = v.hiddenConPitch:create()

            antiaim.builder.gear[k] = {
                yaw_mode            = yaw:combo('Mode', 'Start', 'Start/End'),
                yaw_mode_type       = yaw:combo('Mode type', '<->', 'N-Way', 'Rotate', 'Sway', 'Random'),
                yaw_mode_value      = yaw:slider('', 0, 10),
                yaw_adjuster        = yaw:combo('Adjuster', 'Choke', 'Tick', 'Speedable', 'Random'),
                yaw_adjuster_value1 = yaw:slider('yaw_adjuster_value1', 0, 200),
                yaw_adjuster_value2 = yaw:slider('yaw_adjuster_value2', 0, 200),

                yaw_offset = yaw_modifier:slider('Offset', -180, 180, 0),

                desync_options   = desync:selectable('Options', 'Avoid Overlap', 'Anti Bruteforce'),
                desync_freestand = desync:combo('Freestanding', 'Off', 'Peek Fake', 'Peek Real'),

                desync_mode            = desync:combo('Mode', 'Start', 'Start/End'),
                desync_mode_type       = desync:combo('Mode type', '<->', 'N-Way', 'Rotate', 'Sway', 'Random'),
                desync_mode_value      = desync:slider('', 0, 10),
                desync_adjuster        = desync:combo('Adjuster', 'Choke', 'Tick', 'Speedable', 'Random'),
                desync_adjuster_value1 = desync:slider('desync_adjuster_value1', 0, 200),
                desync_adjuster_value2 = desync:slider('desync_adjuster_value2', 0, 200),

                hiddenYaw_mode            = hidden_yaw:combo('Mode', 'Start', 'Start/End'),
                hiddenYaw_mode_type       = hidden_yaw:combo('Mode type', '<->', 'N-Way', 'Rotate', 'Sway', 'Random'),
                hiddenYaw_mode_value      = hidden_yaw:slider('', 0, 10),
                hiddenYaw_adjuster        = hidden_yaw:combo('Adjuster', 'Choke', 'Tick', 'Speedable', 'Random'),
                hiddenYaw_adjuster_value1 = hidden_yaw:slider('hiddenYaw_adjuster_value1', 0, 200),
                hiddenYaw_adjuster_value2 = hidden_yaw:slider('hiddenYaw_adjuster_value2', 0, 200),

                hiddenPitch_mode            = hidden_pitch:combo('Mode', 'Start', 'Start/End'),
                hiddenPitch_mode_type       = hidden_pitch:combo('Mode type', '<->', 'N-Way', 'Rotate', 'Sway', 'Random'),
                hiddenPitch_mode_value      = hidden_pitch:slider('', 0, 10),
                hiddenPitch_adjuster        = hidden_pitch:combo('Adjuster', 'Choke', 'Tick', 'Speedable', 'Random'),
                hiddenPitch_adjuster_value1 = hidden_pitch:slider('hiddenPitch_adjuster_value1', 0, 200),
                hiddenPitch_adjuster_value2 = hidden_pitch:slider('hiddenPitch_adjuster_value2', 0, 200),

            }

            for k, v in pairs(antiaim.builder.gear[k]) do
                v:class('anti-aim')
            end
        end
        antiaim.builder.import = builder:button('                       '..ui.get_icon('arrow-down-from-line')..' Import anti-aims                        ', nil, true)
    end
end

local misc = {}; do
    misc.visuals = {}; do
        local visuals = nui.create(assistant.icon_text('bars', ' Misc'), 'Visuals')

        misc.visuals.windows = visuals:selectable(assistant.icon_text('window', ' Windows'), 'Watermark', 'Binds', 'Desync indicator', 'Fake lag indicator')
        local windows_gear = misc.visuals.windows:create(); do
            misc.visuals.windows_gear = {}

            misc.visuals.windows_gear.windows_clr = windows_gear:color_picker('Color', accent_clr)
            misc.visuals.windows_gear.display = windows_gear:selectable('Display', 'Username', 'Config', 'Ping', 'FPS', 'Time')
            misc.visuals.windows_gear.background_alpha = windows_gear:slider('Background alpha', 0, 255, 125)
            misc.visuals.windows_gear.custom_username = windows_gear:input('Username', common.get_username())
            misc.visuals.windows_gear.use_steam_avatar = windows_gear:switch('Use steam avatar')
            misc.visuals.windows_gear.use_12h_format = windows_gear:switch('Use 12h format')
        end

        misc.visuals.crosshair_indicator = visuals:switch(assistant.icon_text('crosshairs', ' Crosshair indicator'))
        local crosshair_indicator_gear = misc.visuals.crosshair_indicator:create(); do
            misc.visuals.crosshair_indicator_gear = {}

            misc.visuals.crosshair_indicator_gear.ind_clr1 = crosshair_indicator_gear:color_picker('Color 1', accent_clr)
            misc.visuals.crosshair_indicator_gear.ind_clr2 = crosshair_indicator_gear:color_picker('Color 2', color(80))
        end

        misc.visuals.scope_overlay = visuals:switch(assistant.icon_text('crosshairs-simple', ' Scope overlay'))
        local scope_overlay_gear = misc.visuals.scope_overlay:create(); do
            misc.visuals.scope_overlay_gear = {}

            misc.visuals.scope_overlay_gear.start_clr = scope_overlay_gear:color_picker('Start', color())
            misc.visuals.scope_overlay_gear.end_clr = scope_overlay_gear:color_picker('End', accent_clr:alpha_modulate(0))
            misc.visuals.scope_overlay_gear.lines = scope_overlay_gear:slider('Lines', 1, 4, 4)
            misc.visuals.scope_overlay_gear.length = scope_overlay_gear:slider('Length', 10, 500, 160)
            misc.visuals.scope_overlay_gear.width = scope_overlay_gear:slider('Width', 1, 10, 1)
            misc.visuals.scope_overlay_gear.gap = scope_overlay_gear:slider('Gap', 0, 100, 18)
            misc.visuals.scope_overlay_gear.rotate = scope_overlay_gear:slider('Rotate', 0, 360, 0)
            misc.visuals.scope_overlay_gear.move_speed = scope_overlay_gear:slider('Move speed', -100, 100, 0, 0.1)
            misc.visuals.scope_overlay_gear.move_rotate = scope_overlay_gear:switch('Move rotate')
            misc.visuals.scope_overlay_gear.remove = scope_overlay_gear:switch('Remove scope', true)
        end

        misc.visuals.aimbot_logs = visuals:switch(assistant.icon_text('square-list', ' Visual aimbot logs'))
        local aimbot_logs_gear = misc.visuals.aimbot_logs:create(); do
            misc.visuals.aimbot_logs_gear = {}

            misc.visuals.aimbot_logs_gear.position = aimbot_logs_gear:selectable('Position', 'Under crosshair', 'At left center')
            misc.visuals.aimbot_logs_gear.style = aimbot_logs_gear:combo('Style', 'Aqua', 'Simplified')
            misc.visuals.aimbot_logs_gear.glow = aimbot_logs_gear:slider('Glow', 0, 255, 180)
            misc.visuals.aimbot_logs_gear.max_logs = aimbot_logs_gear:slider('Max. logs', 2, 10, 5)
            misc.visuals.aimbot_logs_gear.gap_y = aimbot_logs_gear:slider('Gap Y', 50, 400, 120)
            misc.visuals.aimbot_logs_gear.debug = aimbot_logs_gear:button('DEBUG: Show logs', nil, true)
        end

        misc.visuals.gang1700888 = visuals:switch(assistant.icon_text('gun', '\a'..color(255, 90, 90):to_hex()..' 1700 888')); misc.visuals.gang1700888:visibility(false)
    end

    misc.other = {}; do
        local other = nui.create(assistant.icon_text('bars', ' Misc'), 'Other')


        misc.other.clantag = other:switch(assistant.icon_text('tag', ' Clantag'))
        local clantag_gear = misc.other.clantag:create(); do
            misc.other.clantag_gear = {}

            misc.other.clantag_gear.tag = clantag_gear:combo('Tag', 'Aqua Club', '1700888 gang')
        end
        misc.other.aspect_ratio = other:switch(assistant.icon_text('expand-wide', ' Aspect ratio'))
        local aspect_ratio_gear = misc.other.aspect_ratio:create(); do
            misc.other.aspect_ratio_gear = {}

            misc.other.aspect_ratio_gear.ratio = aspect_ratio_gear:slider('Ratio', 0, 200, 134, 0.1)
        end
        misc.other.view_model = other:switch(assistant.icon_text('hand', ' View model'))
        local view_model_gear = misc.other.view_model:create(); do
            misc.other.view_model_gear = {}
            misc.other.view_model_gear.vm = {
                fov = cvar.viewmodel_fov:int(),
                x = cvar.viewmodel_offset_x:int(),
                y = cvar.viewmodel_offset_y:int(),
                z = cvar.viewmodel_offset_z:int(),
            }
            vm = misc.other.view_model_gear.vm

            misc.other.view_model_gear.fov = view_model_gear:slider('FOV', -120, 120, vm.fov)
            misc.other.view_model_gear.fov:tooltip('Default is '..'68')

            misc.other.view_model_gear.x = view_model_gear:slider('X', -30, 30, vm.x)
            misc.other.view_model_gear.x:tooltip('Default is '..'2')

            misc.other.view_model_gear.y = view_model_gear:slider('Y', -30, 120, vm.y)
            misc.other.view_model_gear.y:tooltip('Default is '..'0')

            misc.other.view_model_gear.z = view_model_gear:slider('Z', -15, 25, vm.z)
            misc.other.view_model_gear.z:tooltip('Default is '..'-1')
        end
        misc.other.console_mod = other:switch(assistant.icon_text('rectangle-terminal', ' VGUI modify'))
        local console_mod_gear = misc.other.console_mod:create(); do
            misc.other.console_mod_gear = {}

            misc.other.console_mod_gear.clr = console_mod_gear:color_picker('Color')
        end
    end

    misc.rage = {}; do
        local rage = nui.create(assistant.icon_text('bars', ' Misc'), 'Aimbot')

        -- misc.rage.enhance_dt = rage:switch(assistant.icon_text('fire-flame-curved', ' Enhance double tap'))
        -- local enhance_dt_gear = misc.rage.enhance_dt:create(); do
        --     misc.rage.enhance_dt_gear = {}
        --     misc.rage.enhance_dt_gear.dt2hp = enhance_dt_gear:switch('DT to HP')
        -- end

        misc.rage.on_enemy_lethal = rage:selectable(assistant.icon_text('heart-crack', ' On enemy lethal'), 'Force body aim', 'Force safe points')
        local on_enemy_lethal_gear = misc.rage.on_enemy_lethal:create(); do
            misc.rage.on_enemy_lethal_gear = {}
            misc.rage.on_enemy_lethal_gear.weapon = on_enemy_lethal_gear:selectable('Weapons', 'AutoSnipers', 'SSG-08', 'Desert Eagle', 'R8 Revolver')
        end
        -- misc.rage.auto_tp_in_air = rage:switch(assistant.icon_text('transporter-3', ' Auto teleport in air'))
        misc.rage.jump_scout = rage:switch(assistant.icon_text('arrow-down-to-line', ' Jump scout'))
        local jump_scout_gear = misc.rage.jump_scout:create(); do
            misc.rage.jump_scout_gear = {}
            misc.rage.jump_scout_gear.hc = jump_scout_gear:slider('Hitchance', 10, 90, ref.rage.ssg08.hitchance:get())
        end
        misc.rage.grenade_fix = rage:switch(assistant.icon_text('bomb', ' Nade throw fix'))

        misc.rage.aimbot_logs = rage:switch(assistant.icon_text('square-list', ' Logs'))
        local aimbot_logs_gear = misc.rage.aimbot_logs:create(); do
            misc.rage.aimbot_logs_gear = {}

            misc.rage.aimbot_logs_gear.clr = aimbot_logs_gear:color_picker('Color', accent_clr)
            misc.rage.aimbot_logs_gear.events = aimbot_logs_gear:selectable('Events', 'Aimbot fire', 'Damage dealt', 'Purchases')
            misc.rage.aimbot_logs_gear.output = aimbot_logs_gear:selectable('Output', 'Console', 'Event')
        end
    end

    misc.move = {}; do
        local move = nui.create(assistant.icon_text('bars', ' Misc'), 'Movement')

        misc.move.fast_ladder = move:switch(assistant.icon_text('stairs', ' Fast ladder'))
        misc.move.no_fall_damage = move:switch(assistant.icon_text('person-falling', ' No fall damage'))
        misc.move.avoid_collision = move:switch(assistant.icon_text('block-brick', ' Avoid collision')); misc.move.avoid_collision:visibility(false)
    end
end

local script = {
    var = function(self)
        do -- helper
            self.override = function(name, state, value)
                if self.var.override[name] == nil then
                    self.var.override[name] = {
                        value = value,
                        change = value == nil,
                        state = state
                    }
                end

                if state == nil then
                    if self.var.override[name].state then
                        self.var.override[name].state = false
                    end
                    if value ~= nil then
                        if self.var.override[name].change then
                            self.var.override[name].value = value
                            self.var.override[name].change = false
                        end
                    end
                else
                    self.var.override[name].state = state
                    self.var.override[name].change = true
                end

                return self.var.override[name]
            end
            self.get_raw_override = function(name)
                return self.var.override[name]
            end
        end
        self.var = {
            animation_speed = 0.05,
            binds = {
                anim = {
                    v = {},
                    gap = {},
                    start_index_division = 0
                }
            },
            windows = {
                desync_ind_max_w = 0
            },
            clantag = {
                aqua = {
                    '水',
                    '水a',
                    '水aq',
                    '水aqu',
                    '水aqua',
                    '水aqua ',
                    '水aqua c',
                    '水aqua cl',
                    '水aqua clu',
                    '水aqua club',
                    '水aqua club',
                    '水aqua club',
                    '水aqua clu',
                    '水aqua cl',
                    '水aqua c',
                    '水aqua ',
                    '水aqua',
                    '水aqu',
                    '水aq',
                    '水a',
                    '水',
                    '♡'
                },
                gang1700888 = {
                    '1',
                    '17',
                    '17?',
                    '170?',
                    '1700',
                    '1700 /',
                    '1700 8/',
                    '1700 88/',
                    '1700 888',
                    '1700-888',
                    '1700888',
                    '1700888-',
                    '1700888-g',
                    '1700888-ga',
                    '1700888-gan',
                    '1700888-gang',
                    '1700888 gang',
                    '1700888 gang',
                    '1700888 gang',
                    '1700888 gan',
                    '1700888 ga',
                    '1700888 g',
                    '1700888 ',
                    '170088',
                    '1700',
                    '170',
                    '17',
                },
                override = false,
                on_frozen = false,
                old_time = 0
            },
            shittalk = {
                'Aqua Club - The best choice.', -- for neverlose
                'Aqua Club - The best anti-aims.',
                'Aqua Club - The best visuals.',
                'Aqua Club - More than a project.',
                'Aqua Club - Orion Club??'
            },
            edge_yaw = {
                start = vector(),
                is_working = false,
            },
            legit_aa = {
                is_working = false,
                override = false
            },
            logs = {
                aimbot = {},
                anim = {},
                stamp = 0
            },
            hitgroup = {
                [0] = 'generic',
                'head', 'chest', 'stomach',
                'left arm', 'right arm',
                'left leg', 'right leg',
                'neck', 'generic', 'gear'
            },
            override = {
                VGUI_clr_cached = false,
                VGUI_on_enable = true,
            },
            weapon = {
                group = {
                    'AutoSnipers',
                    'SSG-08',
                    'AWP',
                    'Desert Eagle',
                    'R8 Revolver',
                    'Pistols'
                }
            },
            target = {
                c = nil,
            },
            avoid_collision = {
                test = nil
            },
            materials = {
                VGUI = {'vgui_white', 'vgui/hud/800corner1', 'vgui/hud/800corner2', 'vgui/hud/800corner3', 'vgui/hud/800corner4'}
            },
            cfg = {
                action = nil,
                confirm_action = false
            }
        }
    end,
    pre_render = function(self)
        local f = {
            aqua_club = function()
                local text = gradient.text_animate('Aqua club', -2, {
                    color(255),
                    color(0, 143, 255),
                    color(255),
                    color(0, 178, 255),
                })
                text:animate()
                nui.sidebar(text:get_animated_text(), '🌊') -- droplet 💧
            end
        }

        events.pre_render:set(function()
            for _, v in pairs(f) do
                v()
            end
        end)
    end,
    render = function(self)
        local f = {
            UI_Management = function()
                do -- misc > visuals
                    misc.visuals.windows_gear.display:visibility(misc.visuals.windows:get(1))
                    misc.visuals.windows_gear.windows_clr:visibility(misc.visuals.windows:get(1) or misc.visuals.windows:get(2))
                    misc.visuals.windows_gear.background_alpha:visibility(misc.visuals.windows:get(1) or misc.visuals.windows:get(2))
                    misc.visuals.windows_gear.custom_username:visibility(misc.visuals.windows_gear.display:get(1))
                    misc.visuals.windows_gear.use_steam_avatar:visibility(misc.visuals.windows_gear.display:get(1))
                    misc.visuals.windows_gear.use_12h_format:visibility(misc.visuals.windows_gear.display:get(4))
                end
                do -- aa builder
                    antiaim.builder.self:visibility(antiaim.general.mode:get() == 'Builder')
                    local selected_state = antiaim.general.state:get():lower()
                    for menu_state, state_v in pairs(antiaim.builder.el) do
                        for k, v in pairs(state_v) do
                            if menu_state == selected_state then
                                do
                                    if menu_state == 'global' then
                                        state_v.override:set(true)
                                        state_v.override:visibility(false)
                                    end
                                    v:visibility(k ~= 'override' and state_v.override:get())
                                    state_v.override:visibility(menu_state ~= 'global')
                                end

                                local gear = antiaim.builder.gear[menu_state]

                                do -- yaw
                                    do -- gear
                                        local g_yaw_mode = gear.yaw_mode:get()
                                        local g_mode_type = gear.yaw_mode_type:get()
                                        local g_adjuster = gear.yaw_adjuster:get()
                                        if g_yaw_mode == 'Start' then
                                            state_v.yaw_end:visibility(false)
                                        end

                                        gear.yaw_mode_type:visibility(g_yaw_mode == 'Start/End')
                                        gear.yaw_adjuster:visibility(g_yaw_mode == 'Start/End')
                                        gear.yaw_mode_value:visibility(g_yaw_mode == 'Start/End' and g_mode_type ~= '<->' and g_mode_type ~= 'Random')
                                        gear.yaw_adjuster_value1:visibility(g_adjuster ~= 'Choke' and g_yaw_mode == 'Start/End')
                                        gear.yaw_adjuster_value2:visibility(g_adjuster ~= 'Choke' and g_yaw_mode == 'Start/End')

                                        if g_mode_type == 'N-Way' then
                                            gear.yaw_mode_value:name('Ways')
                                            gear.yaw_mode_value:update(2, 9)
                                        elseif g_mode_type == 'Rotate' then
                                            gear.yaw_mode_value:name('Speed')
                                            gear.yaw_mode_value:update(2, 200)
                                        elseif g_mode_type == 'Sway' then
                                            gear.yaw_mode_value:name('Speed')
                                            gear.yaw_mode_value:update(2, 200)
                                        end

                                        if g_adjuster == 'Tick' then
                                            gear.yaw_adjuster_value1:name('Minimum tick')
                                            gear.yaw_adjuster_value1:update(1, 100)
                                            gear.yaw_adjuster_value2:name('Maximum tick')
                                            gear.yaw_adjuster_value2:update(1, 100)
                                        elseif g_adjuster == 'Speedable' then
                                            gear.yaw_adjuster_value1:name('Minimum tick')
                                            gear.yaw_adjuster_value1:update(1, 100)
                                            gear.yaw_adjuster_value2:name('Maximum tick')
                                            gear.yaw_adjuster_value2:update(1, 100)
                                        elseif g_adjuster == 'Random' then
                                            gear.yaw_adjuster_value1:name('Minimum value')
                                            gear.yaw_adjuster_value1:update(1, 100)
                                            gear.yaw_adjuster_value2:name('Maximum value')
                                            gear.yaw_adjuster_value2:update(2, 100)
                                        end
                                    end

                                    local yaw = state_v.yaw:get()
                                    if yaw == 'Disabled' then
                                        if k:find('yaw_') then
                                            v:visibility(false)
                                        end
                                    end
                                end
                                do -- desync
                                    do -- gear
                                        local g_desync_mode = gear.desync_mode:get()
                                        local g_mode_type = gear.desync_mode_type:get()
                                        local g_adjuster = gear.desync_adjuster:get()
                                        if g_desync_mode == 'Start' then
                                            state_v.desync_end:visibility(false)
                                        end

                                        gear.desync_mode_type:visibility(g_desync_mode == 'Start/End')
                                        gear.desync_adjuster:visibility(g_desync_mode == 'Start/End')
                                        gear.desync_mode_value:visibility(g_desync_mode == 'Start/End' and g_mode_type ~= '<->' and g_mode_type ~= 'Random')
                                        gear.desync_adjuster_value1:visibility(g_adjuster ~= 'Choke' and g_desync_mode == 'Start/End')
                                        gear.desync_adjuster_value2:visibility(g_adjuster ~= 'Choke' and g_desync_mode == 'Start/End')

                                        if g_mode_type == 'N-Way' then
                                            gear.desync_mode_value:name('Ways')
                                            gear.desync_mode_value:update(2, 9)
                                        elseif g_mode_type == 'Rotate' then
                                            gear.desync_mode_value:name('Speed')
                                            gear.desync_mode_value:update(2, 200)
                                        elseif g_mode_type == 'Sway' then
                                            gear.desync_mode_value:name('Speed')
                                            gear.desync_mode_value:update(2, 200)
                                        end

                                        if g_adjuster == 'Tick' then
                                            gear.desync_adjuster_value1:name('Minimum tick')
                                            gear.desync_adjuster_value1:update(1, 100)
                                            gear.desync_adjuster_value2:name('Maximum tick')
                                            gear.desync_adjuster_value2:update(1, 100)
                                        elseif g_adjuster == 'Speedable' then
                                            gear.desync_adjuster_value1:name('Minimum tick')
                                            gear.desync_adjuster_value1:update(1, 100)
                                            gear.desync_adjuster_value2:name('Maximum tick')
                                            gear.desync_adjuster_value2:update(1, 100)
                                        elseif g_adjuster == 'Random' then
                                            gear.desync_adjuster_value1:name('Minimum value')
                                            gear.desync_adjuster_value1:update(1, 100)
                                            gear.desync_adjuster_value2:name('Maximum value')
                                            gear.desync_adjuster_value2:update(2, 100)
                                        end
                                    end

                                    local desync = state_v.desync:get()
                                    if desync == false then
                                        if k:find('desync_') then
                                            v:visibility(false)
                                        end
                                    end
                                end
                                do -- hidden
                                    state_v.force_defensive:visibility(state_v.yaw:get() ~= 'Disabled')
                                    local hidden = state_v.force_defensive:get()
                                    if hidden == false then
                                        if k:find('hiddenY') then
                                            v:visibility(false)
                                        end
                                        state_v.hiddenConYaw:visibility(false)
                                        state_v.hiddenConPitch:visibility(false)
                                    end
                                    do -- hidden yaw
                                        do -- gear
                                            local g_hiddenYaw_mode = gear.hiddenYaw_mode:get()
                                            local g_mode_type = gear.hiddenYaw_mode_type:get()
                                            local g_adjuster = gear.hiddenYaw_adjuster:get()
                                            if g_hiddenYaw_mode == 'Start' then
                                                state_v.hiddenYaw_end:visibility(false)
                                            end

                                            gear.hiddenYaw_mode_type:visibility(g_hiddenYaw_mode == 'Start/End')
                                            gear.hiddenYaw_adjuster:visibility(g_hiddenYaw_mode == 'Start/End')
                                            gear.hiddenYaw_mode_value:visibility(g_hiddenYaw_mode == 'Start/End' and g_mode_type ~= '<->' and g_mode_type ~= 'Random')
                                            gear.hiddenYaw_adjuster_value1:visibility(g_adjuster ~= 'Choke' and g_hiddenYaw_mode == 'Start/End')
                                            gear.hiddenYaw_adjuster_value2:visibility(g_adjuster ~= 'Choke' and g_hiddenYaw_mode == 'Start/End')

                                            if g_mode_type == 'N-Way' then
                                                gear.hiddenYaw_mode_value:name('Ways')
                                                gear.hiddenYaw_mode_value:update(2, 9)
                                            elseif g_mode_type == 'Rotate' then
                                                gear.hiddenYaw_mode_value:name('Speed')
                                                gear.hiddenYaw_mode_value:update(2, 200)
                                            elseif g_mode_type == 'Sway' then
                                                gear.hiddenYaw_mode_value:name('Speed')
                                                gear.hiddenYaw_mode_value:update(2, 200)
                                            end

                                            if g_adjuster == 'Tick' then
                                                gear.hiddenYaw_adjuster_value1:name('Minimum tick')
                                                gear.hiddenYaw_adjuster_value1:update(1, 100)
                                                gear.hiddenYaw_adjuster_value2:name('Maximum tick')
                                                gear.hiddenYaw_adjuster_value2:update(1, 100)
                                            elseif g_adjuster == 'Speedable' then
                                                gear.hiddenYaw_adjuster_value1:name('Minimum tick')
                                                gear.hiddenYaw_adjuster_value1:update(1, 100)
                                                gear.hiddenYaw_adjuster_value2:name('Maximum tick')
                                                gear.hiddenYaw_adjuster_value2:update(1, 100)
                                            elseif g_adjuster == 'Random' then
                                                gear.hiddenYaw_adjuster_value1:name('Minimum value')
                                                gear.hiddenYaw_adjuster_value1:update(1, 100)
                                                gear.hiddenYaw_adjuster_value2:name('Maximum value')
                                                gear.hiddenYaw_adjuster_value2:update(2, 100)
                                            end
                                        end

                                        local hiddenYaw = state_v.hiddenConYaw:get()
                                        if hiddenYaw == false then
                                            if k:find('hiddenY') then
                                                v:visibility(false)
                                            end
                                        end
                                    end
                                    do -- hidden pitch
                                        do -- gear
                                            local g_hiddenPitch_mode = gear.hiddenPitch_mode:get()
                                            local g_mode_type = gear.hiddenPitch_mode_type:get()
                                            local g_adjuster = gear.hiddenPitch_adjuster:get()
                                            if g_hiddenPitch_mode == 'Start' then
                                                state_v.hiddenPitch_end:visibility(false)
                                            end

                                            gear.hiddenPitch_mode_type:visibility(g_hiddenPitch_mode == 'Start/End')
                                            gear.hiddenPitch_adjuster:visibility(g_hiddenPitch_mode == 'Start/End')
                                            gear.hiddenPitch_mode_value:visibility(g_hiddenPitch_mode == 'Start/End' and g_mode_type ~= '<->' and g_mode_type ~= 'Random')
                                            gear.hiddenPitch_adjuster_value1:visibility(g_adjuster ~= 'Choke' and g_hiddenPitch_mode == 'Start/End')
                                            gear.hiddenPitch_adjuster_value2:visibility(g_adjuster ~= 'Choke' and g_hiddenPitch_mode == 'Start/End')

                                            if g_mode_type == 'N-Way' then
                                                gear.hiddenPitch_mode_value:name('Ways')
                                                gear.hiddenPitch_mode_value:update(2, 9)
                                            elseif g_mode_type == 'Rotate' then
                                                gear.hiddenPitch_mode_value:name('Speed')
                                                gear.hiddenPitch_mode_value:update(2, 200)
                                            elseif g_mode_type == 'Sway' then
                                                gear.hiddenPitch_mode_value:name('Speed')
                                                gear.hiddenPitch_mode_value:update(2, 200)
                                            end

                                            if g_adjuster == 'Tick' then
                                                gear.hiddenPitch_adjuster_value1:name('Minimum tick')
                                                gear.hiddenPitch_adjuster_value1:update(1, 100)
                                                gear.hiddenPitch_adjuster_value2:name('Maximum tick')
                                                gear.hiddenPitch_adjuster_value2:update(1, 100)
                                            elseif g_adjuster == 'Speedable' then
                                                gear.hiddenPitch_adjuster_value1:name('Minimum tick')
                                                gear.hiddenPitch_adjuster_value1:update(1, 100)
                                                gear.hiddenPitch_adjuster_value2:name('Maximum tick')
                                                gear.hiddenPitch_adjuster_value2:update(1, 100)
                                            elseif g_adjuster == 'Random' then
                                                gear.hiddenPitch_adjuster_value1:name('Minimum value')
                                                gear.hiddenPitch_adjuster_value1:update(1, 100)
                                                gear.hiddenPitch_adjuster_value2:name('Maximum value')
                                                gear.hiddenPitch_adjuster_value2:update(2, 100)
                                            end
                                        end

                                        local hiddenPitch = state_v.hiddenConPitch:get()
                                        if hiddenPitch == false then
                                            if k:find('hiddenP') then
                                                v:visibility(false)
                                            end
                                        end
                                    end
                                end
                            else
                                v:visibility(false)
                            end
                        end
                    end
                end
                do -- scope overlay
                    misc.visuals.scope_overlay_gear.rotate:visibility(not misc.visuals.scope_overlay_gear.move_rotate:get())
                    misc.visuals.scope_overlay_gear.move_speed:visibility(misc.visuals.scope_overlay_gear.move_rotate:get())
                end
            end,
            windows = function()
                local anim = {}; do
                    anim.watermark = animation.on_enable('visual.windows.watermark', misc.visuals.windows:get(1), self.var.animation_speed)
                    anim.binds = animation.on_enable('visual.windows.binds', misc.visuals.windows:get(2), self.var.animation_speed)
                    anim.desyncindicator = animation.on_enable('visual.windows.desyncindicator', misc.visuals.windows:get(3), self.var.animation_speed)
                    anim.fakelagindicator = animation.on_enable('visual.windows.fakelagindicator', misc.visuals.windows:get(4), self.var.animation_speed)
                end

                local g_font = font.CalibriBold
                local clr = misc.visuals.windows_gear.windows_clr:get()
                local g_alpha = misc.visuals.windows_gear.background_alpha:get()
                local rounding = 6
                local blur_density = 2

                local watermark = {}; do
                    if anim.watermark ~= false then
                        local display = {
                            {
                                icon = {
                                    id = resource.icon.logo_small,
                                    size = vector(20, 20),
                                },
                                text = gradient.text('Aqua club', false, {color(0, 178, 255), color()}),
                                i = 'script'
                            },
                            {
                                icon = {
                                    id = misc.visuals.windows_gear.use_steam_avatar:get() and resource.icon.steam_avatar or resource.icon.user,
                                    size = vector(14, 14)
                                },
                                text = misc.visuals.windows_gear.custom_username:get(),
                                i = 'user'
                            },
                            {
                                icon = {
                                    id = resource.icon.settings,
                                    size = vector(14, 14)
                                },
                                text = common.get_config_name(),
                                i = 'cfg'
                            },
                            {
                                icon = {
                                    id = resource.icon.ping,
                                    size = vector(14, 14)
                                },
                                text = assistant.get_ping(),
                                i = 'ping'
                            },
                            {
                                icon = {
                                    id = resource.icon.fps,
                                    size = vector(14, 14)
                                },
                                text = assistant.update_value('watermark.fps', globals.tickcount, mtools.Client.GetFPS(), 60)..'fps',
                                i = 'fps'
                            },
                            {
                                icon = {
                                    id = resource.icon.time,
                                    size = vector(14, 14)
                                },
                                text = assistant.get_time(misc.visuals.windows_gear.use_12h_format:get()),
                                i = 'time'
                            },
                        }; local displayed = {
                            {
                                icon = {
                                    id = resource.icon.logo_small,
                                    size = vector(20, 20)
                                },
                                text = gradient.text('Aqua club', false, {clr, color()}),
                                i = 'script'
                            },
                        }

                        local place = 24

                        local measure_text = render.measure_text(g_font, '', display[1].text)
                        for k, v in ipairs(display) do -- 'Username', 'Server', 'Ping', 'FPS', 'Time'
                            if misc.visuals.windows_gear.display:get(k - 1) and k ~= 1 then
                                measure_text = measure_text + render.measure_text(g_font, '', v.text) + place
                                table.insert(displayed, v)
                            end
                        end

                        local pos = {
                            x = screen.x - 8,
                            y = 10,
                            w = (measure_text.x * 0.99 + 7 + place) * anim.watermark,
                            h = 20,
                        }; pos.x = pos.x - pos.w

                        pos.x = animation.new('visual.windows.watermark.pos.x', pos.x, pos.x, self.var.animation_speed)
                        pos.w = animation.new('visual.windows.watermark.pos.w', pos.w, pos.w, self.var.animation_speed)

                        renderer.blur(vector(pos.x, pos.y), vector(pos.w, pos.h), blur_density, anim.watermark, rounding)
                        renderer.rect(vector(pos.x, pos.y), vector(pos.w, pos.h), color(0):alpha_modulate(anim.watermark * g_alpha), rounding)

                        renderer.push_clip(vector(pos.x, pos.y), vector(pos.w, pos.h))
                        local measure = 0
                        for k, v in ipairs(displayed) do
                            local ipos = vector(
                                pos.x + measure + (v.i == 'script' and 2 or 5) + (v.i == 'fps' and 1 or 0) + (v.i == 'cfg' and 1 or 0),
                                pos.y + (v.i == 'script' and 0 or 3)
                            )
                            local iclr = (misc.visuals.windows_gear.use_steam_avatar:get() and v.i == 'user') and color() or clr

                            render.text(g_font, vector(pos.x + measure + place, pos.y + 4), color():alpha_modulate(anim.watermark * 255), nil, v.text)
                            render.texture(v.icon.id, ipos, v.icon.size, iclr:alpha_modulate(anim.watermark * 255), nil, rounding /2)

                            measure = measure + render.measure_text(g_font, '', v.text).x + place
                        end
                        renderer.pop_clip()
                    end
                end

                local binds = {}; do
                    if anim.binds ~= false then
                        local binds_t, info = assistant.get_binds('binds', nil, nil, 0.05)
                        binds.max_w = 62
                        binds.max_h = 0

                        local pos = assistant.drag_object_setup('Binds', {
                            w = binds.max_w,
                            h = 27
                        })

                        for k, v in pairs(binds_t) do
                            local size = render.measure_text(font.MuseoSans700, nil, v.name).x + 60
                            if binds.max_w < size then
                                binds.max_w = size
                            end
                            binds.max_h = k * 22 + 4
                        end

                        assistant.drag_object_change_size('Binds',
                            animation.new('visual.keybinds.change_w', binds.max_w, binds.max_w, self.var.animation_speed),
                            27 + animation.new('visual.keybinds.change_h', binds.max_h, binds.max_h, self.var.animation_speed)
                        )

                        -- print(pos.h)
                        local show = info.output or nui.get_alpha() > 0.5
                        local show_anim = animation.condition_new('visual.keybinds.show', show, self.var.animation_speed)

                        pos.x, pos.y, pos.w, pos.h = math.round(pos.x), math.round(pos.y), math.round(pos.w), math.round(pos.h)

                        renderer.blur(vector(pos.x, pos.y), vector(pos.w, pos.h), blur_density, anim.binds * show_anim, rounding)
                        renderer.rect(vector(pos.x, pos.y), vector(pos.w, pos.h), color(0):alpha_modulate(g_alpha * anim.binds * show_anim), rounding)

                        local division_anim = animation.condition_new('visual.keybinds.division', info.output, self.var.animation_speed) * anim.binds
                        renderer.rect(vector(
                            pos.x + 0,
                            pos.y + 26
                        ), vector(math.round(animation.get('visual.keybinds.change_w') * division_anim), 1), color():alpha_modulate(division_anim * 60))
                        -- render.rect_filled(vec2_t(pos.x + math.round(self.var.binds.anim.max_w) / 2 - math.round((self.var.binds.anim.max_w / 2) * division_anim), pos.y + 26), vec2_t(math.round(self.var.binds.anim.max_w * division_anim), 1), color_t(255, 255, 255, math.round(division_anim * 60)))

                        render.texture(resource.icon.keyboard, vector(pos.x + 5, pos.y + 5), vector(18, 18), clr:alpha_modulate(255 * anim.binds * show_anim))
                        render.text(g_font, vector(pos.x + 27, pos.y + 8), color(), nil, gradient.text('Binds', false, {clr:alpha_modulate(255 * anim.binds * show_anim), color():alpha_modulate(255 * anim.binds * show_anim)}))

                        renderer.push_clip(vector(pos.x, pos.y), vector(pos.w, pos.h))
                        for k, v in pairs(binds_t) do
                            if self.var.binds.anim.gap[v.name] == nil then
                                self.var.binds.anim.gap[v.name] = 0
                            end; self.var.binds.anim.gap[v.name] = animation.lerp(self.var.binds.anim.gap[v.name], (k) * 22, self.var.animation_speed)

                            if self.var.binds.anim.v[v.name] == nil then
                                self.var.binds.anim.v[v.name] = 0
                            end; self.var.binds.anim.v[v.name] = animation.condition_new('visual.keybinds.'..v.name, v.active, self.var.animation_speed)

                            local anim_inside = self.var.binds.anim.v[v.name]
                            local anim_gap = self.var.binds.anim.gap[v.name]

                            do -- mode
                                local icon, ipos, size

                                if v.mode == 1 then
                                    icon = resource.icon.hold
                                    ipos = vector(pos.x + math.round(9 * anim_inside), pos.y + 13 + math.round(anim_gap))
                                    size = vector(10, 10)
                                elseif v.mode == 2 then
                                    icon = resource.icon.toggle
                                    ipos = vector(pos.x + math.round(7 * anim_inside), pos.y + 12 + math.round(anim_gap))
                                    size = vector(14, 12)
                                end

                                if icon ~= nil then
                                    -- render.texture(icon, ipos, size, color_t(clr.r, clr.g, clr.b, math.round(v.anim * 255 * anim.keybinds)))
                                    render.texture(icon, ipos, size, clr:alpha_modulate(255 * anim_inside * anim.binds))
                                end
                            end

                            do -- division
                                if k ~= 1 then
                                    renderer.rect(vector(pos.x + 10 + 16, pos.y + 12 + k * 22 - 5), vector(math.round(animation.get('visual.keybinds.change_w') * anim_inside * self.var.binds.anim.start_index_division) - 26, 1), color():alpha_modulate(math.round(anim_inside * 25 * self.var.binds.anim.start_index_division * anim.binds)))
                                else
                                    self.var.binds.anim.start_index_division = anim_inside
                                end
                            end

                            do -- secondary
                                if v.name == 'Double Tap' then
                                    render.circle_outline(
                                        vector(pos.x + pos.w - 12, pos.y + math.round(anim_gap) + 18),
                                        color(49, 49, 49):alpha_modulate(255 * anim.binds * anim_inside),
                                        6,
                                        0, 1, 2
                                    )
                                    render.circle_outline(
                                        vector(pos.x + pos.w - 12, pos.y + math.round(anim_gap) + 18),
                                        color(255, 112, 112):lerp(color(112, 255, 126), v.charge):alpha_modulate(255 * anim.binds * anim_inside),
                                        6,
                                        0, v.charge, 2
                                    )
                                else
                                    local secondary = 'on'
                                    if v.name == 'Min. Damage' then
                                        secondary = v.value
                                    end
                                    render.text(font.MuseoSans700, vector(pos.x + pos.w - 8 - render.measure_text(font.MuseoSans700, nil, secondary).x, pos.y + math.round(anim_gap) + 11), color():alpha_modulate(255 * anim.binds * anim_inside), nil, secondary)
                                end
                            end

                            render.text(font.MuseoSans700, vector(
                                pos.x + 12 + math.round(15 * anim_inside + 0.1),
                                pos.y + 11 + math.round(anim_gap)
                            ), color():alpha_modulate(255 * anim.binds * anim_inside), nil, v.name)
                        end
                        renderer.pop_clip()
                    end
                end

                local desyncindicator = {}; do
                    if anim.desyncindicator ~= false then
                        local text_t = assistant.color_text({
                            {'FAKE: ('},
                            {tostring(assistant.check() and math.round(assistant.get_desync_delta()) or 888), clr},
                            {'°)'}
                        }); local tsize = render.measure_text(g_font, nil, text_t)

                        local free_place = 20

                        local pos = {
                            x = screen.x - 13 - tsize.x - free_place,
                            y = math.round((7 + 20) * (anim.watermark ~= false and anim.watermark or 0)) + 7,
                            w = tsize.x + free_place,
                            h = 20,
                        }; local tgap = 5

                        renderer.blur(vector(pos.x - tgap, pos.y), vector(pos.w + tgap * 2, pos.h), blur_density, anim.desyncindicator, rounding)
                        renderer.rect(vector(pos.x - tgap, pos.y), vector(pos.w + tgap * 2, pos.h), color(0):alpha_modulate(g_alpha * anim.desyncindicator), rounding)
                        render.text(g_font, vector(pos.x + free_place, pos.y + 4), color():alpha_modulate(255 * anim.desyncindicator), nil, text_t)
                        render.texture(resource.icon.ghost, vector(pos.x, pos.y + 3), vector(14, 14), clr:alpha_modulate(255 * anim.desyncindicator))

                        self.var.windows.desync_ind_max_w = animation.new('visuals.windows.desyncindicator.smooth_max_w', self.var.windows.desync_ind_max_w, pos.w, self.var.animation_speed) + 15
                    else
                        self.var.windows.desync_ind_max_w = animation.new('visuals.windows.desyncindicator.smooth_max_w', self.var.windows.desync_ind_max_w, 0, self.var.animation_speed)
                    end
                end

                local fakelagindicator = {}; do
                    local binds = nui.get_binds()
                    if anim.fakelagindicator ~= false then
                        local state = 'GANG'
                        local ticking = 1700
                        if assistant.check() then
                            if rage.exploit:get() ~= 0 then
                                state = 'CHARGING->>'
                                ticking = math.round(rage.exploit:get(), 2)
                                if (ticking == 1) then
                                    state = 'SHIFTING'
                                end
                            else
                                state = 'FAKELAG'
                                ticking = globals.choked_commands
                            end
                        end

                        local text_t = assistant.color_text{
                            {state == 'SHIFTING' and 'EXP: ' or 'FL: '},
                            {tostring(ticking), clr},
                            {' | '},
                            {tostring(state)}
                        }; local tsize = render.measure_text(g_font, nil,  text_t)

                        local free_place = 20

                        local pos = {
                            x = screen.x - 18 - tsize.x - free_place - self.var.windows.desync_ind_max_w,
                            y = math.round((7 + 20) * (anim.watermark ~= false and anim.watermark or 0)) + 7,
                            w = tsize.x + free_place,
                            h = 20,
                        }; local tgap = 5

                        renderer.blur(vector(pos.x, pos.y), vector(pos.w + tgap * 2, pos.h, pos.h), blur_density, anim.fakelagindicator, rounding)
                        renderer.rect(vector(pos.x, pos.y), vector(pos.w + tgap * 2, pos.h), color(0):alpha_modulate(g_alpha * anim.fakelagindicator), rounding)
                        render.text(g_font, vector(pos.x + tgap + free_place, pos.y + 4), color():alpha_modulate(255 * anim.fakelagindicator), nil, text_t)
                        render.texture(resource.icon.jitter, vector(pos.x + 6, pos.y + 3), vector(14, 14), clr:alpha_modulate(255 * anim.fakelagindicator))
                    end
                end
            end,
            crosshair_indicator = function()
                local anim = animation.on_enable('visuals.crosshair_indicator', misc.visuals.crosshair_indicator:get(), self.var.animation_speed)
                if not anim then
                    return
                end

                local lp = entity.get_local_player()
                if lp == nil then
                    return
                end
                if not lp:is_alive() then
                    return
                end
                local weapon = lp:get_player_weapon()
                if weapon == nil then
                    return
                end

                if string.match(weapon:get_classname(), 'Grenade') then
                    anim = 0.5
                end

                local on_scope = animation.condition_new('visuals.crosshair_indicator.on_scope', not lp['m_bIsScoped'], self.var.animation_speed * 2)
                local on_scope_inv = math.abs(on_scope - 1)

                local pos = {
                    x = screen.x / 2 + (on_scope_inv * (misc.visuals.scope_overlay_gear.width:get() / 2 + 3 + 5)),
                    y = screen.y / 2 + 20,
                }

                local clr1 = misc.visuals.crosshair_indicator_gear.ind_clr1:get():alpha_modulate(255 * anim)
                local clr2 = misc.visuals.crosshair_indicator_gear.ind_clr2:get():alpha_modulate(255 * anim)

                local text = gradient.text_animate('aquaclub', -2, {
                    clr1,
                    clr2
                }); text:animate()
                text = text:get_animated_text()

                local tsize = render.measure_text(1, nil, text) * vector(on_scope, 1)
                tsize.x, tsize.y = math.round(tsize.x), math.round(tsize.y)
                render.text(1, vector(pos.x - tsize.x / 2, pos.y - tsize.y / 2), color(), nil, text)

                local tsize = render.measure_text(2, nil, assistant.get_condition()) * vector(on_scope, 1)
                tsize.x, tsize.y = math.round(tsize.x), math.round(tsize.y)
                render.text(2, vector(pos.x - tsize.x / 2, pos.y - tsize.y / 2 + 10), color(180):alpha_modulate(255 * anim), nil, assistant.get_condition())

                local binds = assistant.get_binds('crosshair_indicator', {
                    ['DT'] = 'Double Tap',
                    ['DMG'] = 'Min. Damage',
                    ['HS'] = 'Hide Shots',
                    ['FD'] = 'Fake Duck',
                    ['FS'] = 'Freestanding',
                    ['PA'] = 'Peek Assist',
                    ['EY'] = 'Edge yaw'
                }, nil, self.var.animation_speed)

                for k, v in pairs(binds) do
                    local clr = v.name == 'DT' and (v.charge == 1 and color(0, 255, 0) or color(255, 0, 0)) or color(180)

                    local tsize = render.measure_text(2, nil, v.name) * vector(on_scope, 1)
                    tsize.x, tsize.y = math.round(tsize.x), math.round(tsize.y)
                    render.text(2, vector(pos.x - tsize.x / 2, pos.y - tsize.y / 2 + 18 + (k - 1) * 7), clr:alpha_modulate(anim * v.anim * 255), nil, v.name)
                end
            end,
            scope_overlay = function()
                local anim = animation.on_enable('scope_overlay', misc.visuals.scope_overlay:get(), self.var.animation_speed)
                if not anim then
                    if ref.world.scope_overlay:get_override() ~= nil then
                        ref.world.scope_overlay:override()
                    end
                    return
                end

                local lp = entity.get_local_player()
                if lp == nil then
                    if ref.world.scope_overlay:get_override() ~= nil then
                        ref.world.scope_overlay:override()
                    end
                    return
                end

                local pos = {
                    x = screen.x / 2,
                    y = screen.y / 2,
                }

                local is_scoped = animation.condition_new('scope_overlay.on_scope', lp['m_bIsScoped'], self.var.animation_speed * 2) * anim
                if misc.visuals.scope_overlay_gear.remove:get() then
                    ref.world.scope_overlay:override('Remove All')
                else
                    if ref.world.scope_overlay:get_override() ~= nil then
                        ref.world.scope_overlay:override()
                    end
                end
                if is_scoped < 0.01 then
                    return
                end

                local gap = misc.visuals.scope_overlay_gear.gap:get()
                local length = math.round(misc.visuals.scope_overlay_gear.length:get() * is_scoped)
                local width = misc.visuals.scope_overlay_gear.width:get()

                local start_clr = misc.visuals.scope_overlay_gear.start_clr:get()
                local end_clr = misc.visuals.scope_overlay_gear.end_clr:get()
                start_clr = start_clr:alpha_modulate(is_scoped * 255 * start_clr.a)
                end_clr = end_clr:alpha_modulate(is_scoped * 255 * end_clr.a)

                local lines = misc.visuals.scope_overlay_gear.lines:get()

                local info = {
                    {
                        pos = vector(pos.x + gap, pos.y - math.floor(width / 2)),
                        size = vector(length, width),
                        clr = {start_clr, end_clr, start_clr, end_clr}
                    }, -- left
                    {
                        pos = vector(pos.x - gap - length, pos.y - math.floor(width / 2)),
                        size = vector(length, width),
                        clr = {end_clr, start_clr, end_clr, start_clr},
                    }, -- right
                    {
                        pos = vector(pos.x - math.floor(width / 2), pos.y + gap),
                        size = vector(width, length),
                        clr = {start_clr, start_clr, end_clr, end_clr}
                    }, -- bottom
                    {
                        pos = vector(pos.x - math.floor(width / 2), pos.y - gap - length),
                        size = vector(width, length),
                        clr = {end_clr, end_clr, start_clr, start_clr}
                    }, -- top
                }
                render.push_rotation(misc.visuals.scope_overlay_gear.move_rotate:get() and globals.tickcount * (misc.visuals.scope_overlay_gear.move_speed:get() / 10 * -1) % 360 or misc.visuals.scope_overlay_gear.rotate:get())
                for l, v in ipairs(info) do
                    local l_anim = animation.condition_new('scope_overlay.line.'..l, lines >= l, self.var.animation_speed * 2); for i = 1, #v.clr do
                        v.clr[i] = v.clr[i]:alpha_modulate(v.clr[i].a * l_anim + 1)
                    end;
                    renderer.gradient(v.pos, v.size, unpack(v.clr))
                end
                render.pop_rotation()
            end,
            log_handler = function()
                local g_anim = animation.on_enable('visuals.aimbot_logs', misc.visuals.aimbot_logs:get(), self.var.animation_speed)
                if g_anim == false then
                    return
                end

                local lp = entity.get_local_player()
                if lp == nil then
                    self.var.logs.aimbot = {}
                end

                local position = misc.visuals.aimbot_logs_gear.position
                local style = misc.visuals.aimbot_logs_gear.style:get()
                local is_aqua = style == 'Aqua'

                local anim_speed = 0.08
                local max_logs = misc.visuals.aimbot_logs_gear.max_logs:get() + 1

                for i, v in pairs(self.var.logs.aimbot) do
                    local anim; do -- operation :/
                        anim = animation.on_enable('misc.logs.'..v.stamp, v.time > globals.curtime and not v.is_max and anim ~= false, v.is_max and (anim_speed * 2) or anim_speed)
                        if anim ~= false then
                            anim = anim * g_anim
                        end
                        if max_logs == i then
                            if i == 1 then
                                table.remove(self.var.logs.aimbot, i)
                            end
                        end
                        if not anim then
                            table.remove(self.var.logs.aimbot, i)
                            self.var.logs.anim[v.stamp] = nil
                            goto proceed
                        end
                        if max_logs == i then
                            self.var.logs.aimbot[1].is_max = true
                        end
                    end

                    local info = {
                        gap = misc.visuals.aimbot_logs_gear.gap_y:get(),
                        x_gap = 5,
                        y_gap = 2,
                        free_place = 9
                    }

                    local data = v.data
                    local duration = math.flerp_inverse(v.time, v.time - v.speed, globals.curtime)
                    local measure = render.measure_text(is_aqua and font.MuseoSans700 or 1, nil, data.text)

                    if position:get('Under crosshair') then
                        local pos = {
                            x = screen.x / 2,
                            y = screen.y / 2 + info.gap
                        }

                        local on_start = math.round(anim * 10)
                        local gap = (i - 1) * 30 * anim
                        if self.var.logs.anim[v.stamp] == nil then
                            self.var.logs.anim[v.stamp] = (i ~= 1 and self.var.logs.anim[v.stamp - 1] or 0)
                        end; self.var.logs.anim[v.stamp] = animation.lerp(self.var.logs.anim[v.stamp], gap, anim_speed)

                        pos.x = pos.x - 10 + on_start - (is_aqua and info.free_place / 2 or -3)
                        pos.y = pos.y + self.var.logs.anim[v.stamp]

                        renderer.shadow(vector(pos.x - measure.x / 2, pos.y + measure.y / 2), vector(measure.x - info.x_gap + (is_aqua and (info.free_place + 5) or 0), 0), data.clr:alpha_modulate(misc.visuals.aimbot_logs_gear.glow:get() * anim))
                        if is_aqua then
                            renderer.rect(vector(pos.x - measure.x / 2 - info.x_gap, pos.y - info.y_gap), measure + vector(info.x_gap * 2 + info.free_place, info.y_gap * 2), color(0, 125 * anim), 6)
                            render.circle_outline(vector(pos.x + measure.x / 2 + 5, pos.y + measure.y / 2), data.clr:alpha_modulate(255 * anim * duration), 5, 270, duration, 2) -- color(255, 0, 0):lerp(color(0, 255, 0), duration):alpha_modulate(255 * anim)
                        end
                        render.text(is_aqua and font.MuseoSans700 or 1, vector(pos.x - measure.x / 2, pos.y), color():alpha_modulate(255 * anim), nil, data.text)
                    end

                    if position:get('At left center') then
                        local pos = {
                            x = 0,
                            y = screen.y / 2
                        }

                        local gap = i * 40; if v.gap == nil then
                            v.gap = 0
                        end; v.gap = animation.lerp(v.gap, gap, anim_speed)
                        gap = v.gap

                        if i == 2 then gap = gap + 7 end
                        if i == 4 then gap = gap - 7 end

                        local radius = 60
                        local degree = math.rad(120 - gap)

                        pos.x = pos.x + (math.cos(degree) * radius)
                        pos.y = pos.y + (math.sin(degree) * radius)

                        renderer.shadow(vector(pos.x, pos.y + measure.y / 2), vector(measure.x - info.x_gap + (is_aqua and (info.free_place + 5) or 0), 0), data.clr:alpha_modulate(misc.visuals.aimbot_logs_gear.glow:get() * anim))
                        if is_aqua then
                            renderer.rect(vector(pos.x - info.x_gap, pos.y - info.y_gap), measure + vector(info.x_gap * 2 + info.free_place, info.y_gap * 2), color(0, 125 * anim), 6)
                            render.circle_outline(vector(pos.x + measure.x + 5, pos.y + measure.y / 2), data.clr:alpha_modulate(255 * anim * duration), 5, 270, duration, 2)
                        end
                        render.text(is_aqua and font.MuseoSans700 or 1, vector(pos.x, pos.y), color():alpha_modulate(255 * anim), nil, data.text)
                    end

                    ::proceed::
                end
            end,
            test = function()
                if not misc.move.avoid_collision:get() then
                    return
                end

                local lp = entity.get_local_player()
                if lp == nil then
                    return
                end
                local camera = render.camera_angles()
                camera.z = 0

                local origin = lp:get_origin()
                origin.z = origin.z + 20
                local m_vecVelocity = lp['m_vecVelocity']

                local angle = m_vecVelocity:angles()
                local forward = vector():angles(angle); forward.z = 0

                local start = origin
                local final = origin + forward * 120

                local trace = utils.trace_line(start, final, lp, 0x46004003)
                render.line(render.world_to_screen(start), render.world_to_screen(final), color(0))

                local pos_end = {}; for i = -90, 90, 45 do
                    local start = origin
                    local final = origin + vector():angles(vector(0, angle.y + i, 0)) * 100
                    local trace = utils.trace_line(start, final, lp, 0x46004003)
                    render.line(render.world_to_screen(start), render.world_to_screen(final), color())

                    if trace.fraction ~= 1 then
                        table.insert(pos_end, trace.end_pos)
                    end
                end

                if #pos_end >= 2 then
                    render.line(render.world_to_screen(pos_end[1]), render.world_to_screen(pos_end[2]), color(0, 0, 255))
                    local a, b, c = pos_end[1]:dist(pos_end[2]), origin:dist(pos_end[1]),  origin:dist(pos_end[2])
                    local p = (a + b + c) / 2
                    local S = math.sqrt(p * (p - a) * (p - b) * (p - c))
                    local h = 2 * S / a
                end
            end,
            VGUI_mod = function()
                if not misc.other.console_mod:get() then
                    if self.var.override.VGUI_on_enable then
                        local clr = color()
                        for k, v in pairs(self.var.materials.VGUI) do
                            materials.get_materials(v)[1]:color_modulate(clr)
                            materials.get_materials(v)[1]:alpha_modulate(clr.a / 255)
                        end
                        self.var.override.VGUI_on_enable = false
                    end
                    return
                end

                local clr = misc.other.console_mod_gear.clr:get()
                if self.var.override.VGUI_clr_cached ~= clr or not self.var.override.VGUI_on_enable then
                    self.var.override.VGUI_clr_cached = clr
                    self.override('VGUIcolor', true)
                end; self.var.override.VGUI_on_enable = true

                if self.get_raw_override('VGUIcolor').state then
                    for k, v in pairs(self.var.materials.VGUI) do
                        materials.get_materials(v)[1]:color_modulate(clr)
                        materials.get_materials(v)[1]:alpha_modulate(clr.a / 255)
                    end
                end
                self.override('VGUIcolor')
            end,
        }

        events.render:set(function()
            for _, v in pairs(f) do
                v()
            end
        end)
    end,
    createmove = function(self)
        local f = {
            update_choke = function()
                if globals.choked_commands == 0 then
                    assistant.choke.f = not assistant.choke.f
                end
            end,
            antiaim = function(cmd)
                if antiaim.general.mode:get() ~= 'Builder' then
                    for _, v in pairs(ref.antiaim) do
                        if v:get_override() ~= nil then
                            v:override(nil)
                        end
                    end
                    return
                end
                if self.var.edge_yaw.is_working or self.var.legit_aa.is_working then
                    return
                end

                local condition = assistant.get_condition():lower()
                local override = antiaim.builder.el[condition].override:get()

                local el, gear = {}, {}; do
                    for k, v in pairs(antiaim.builder.el[condition]) do
                        el[k] = override and v or antiaim.builder.el['global'][k]
                    end
                    for k, v in pairs(antiaim.builder.gear[condition]) do
                        gear[k] = override and v or antiaim.builder.gear['global'][k]
                    end
                end

                if globals.choked_commands == 0 then assistant.choke.aa = not assistant.choke.aa end

                local inverter_f = function(start, final, inverter, inverter_value1, inverter_value2)
                    if inverter == 'Choke' then
                        return assistant.choke.aa
                    elseif inverter == 'Tick' then
                        return (globals.tickcount % math.max(inverter_value1, inverter_value2) < math.min(inverter_value1, inverter_value2)) and true or false
                    elseif inverter == 'Speedable' then
                        return (assistant.choke.aa and (globals.tickcount % math.max(inverter_value1, inverter_value2) < math.min(inverter_value1, inverter_value2))) and true or false
                    elseif inverter == 'Random' then
                        return (math.random(1, math.max(inverter_value1, inverter_value2)) < math.min(inverter_value1, inverter_value2)) and true or false
                    end
                end

                local set_desync = function(value)
                    value = value * -1
                    local fval = math.flerp_inverse(0, 60, value)
                    value = math.abs(value)
                    ref.antiaim.desync_left:set(value)
                    ref.antiaim.desync_right:set(value)

                    rage.antiaim:inverter(fval <= 0)
                end

                do -- pitch
                    ref.antiaim.pitch:override(el.pitch:get())
                end

                do -- desync
                    ref.antiaim.desync:override(el.desync:get())
                    if not el.desync:get() then
                        goto proceed
                    else
                        ref.antiaim.desync_options:override(gear.desync_options:get())
                        ref.antiaim.desync_freestand:override(gear.desync_freestand:get())
                    end

                    local start, final = el.desync_start:get(), el.desync_end:get()
                    local desync = start

                    local mode = gear.desync_mode:get()
                    local mode_type = gear.desync_mode_type:get()
                    local mode_value = gear.desync_mode_value:get()


                    if mode == 'Start/End' then
                        local inverter = inverter_f(start, final, gear.desync_adjuster:get(), gear.desync_adjuster_value1:get(), gear.desync_adjuster_value2:get())

                        if mode_type == '<->' then
                            desync = inverter and start or final
                        elseif mode_type == 'N-Way' then
                            desync = assistant.nWay('antiaim.desync.nWay.'..condition, final, start, inverter, mode_value)
                        elseif mode_type == 'Rotate' then
                            desync = math.interval(globals.tickcount, start, final, mode_value)
                            desync = assistant.update_value('antiaim.desync.rotate.'..condition, inverter, desync)
                        elseif mode_type == 'Sway' then
                            desync = math.interval(globals.tickcount, start, final, mode_value, true)
                            desync = assistant.update_value('antiaim.desync.sway.'..condition, inverter, desync)
                        elseif mode_type == 'Random' then
                            desync = assistant.update_value('antiaim.desync.random.'..condition, inverter, math.random(start, final))
                        end
                    end; set_desync(desync)
                    ::proceed::
                end

                do -- yaw
                    if el.yaw:get() == 'Disabled' then
                        ref.antiaim.yaw:override('Disabled')
                        goto proceed
                    else
                        ref.antiaim.yaw:override('Backward')
                        ref.antiaim.yaw_base:override(el.yaw:get())
                        ref.antiaim.yaw_modifier:override(el.yaw_modifier:get())
                        ref.antiaim.yaw_modifier_offset:override(gear.yaw_offset:get())
                    end

                    local start, final = el.yaw_start:get(), el.yaw_end:get()
                    local yaw = start

                    local mode = gear.yaw_mode:get()
                    local mode_type = gear.yaw_mode_type:get()
                    local mode_value = gear.yaw_mode_value:get()

                    if mode == 'Start/End' then
                        local inverter = inverter_f(start, final, gear.yaw_adjuster:get(), gear.yaw_adjuster_value1:get(), gear.yaw_adjuster_value2:get())

                        if mode_type == '<->' then
                            -- yaw = inverter and start or final
                            -- if gear.yaw_adjuster:get() == 'Choke' and gear.desync_adjuster:get() == 'Choke' and gear.desync_mode:get() == 'Start/End' then
                            -- end
                            yaw = inverter and start or final -- rage.antiaim:inverter()
                        elseif mode_type == 'N-Way' then
                            yaw = assistant.nWay('antiaim.yaw.nWay.'..condition, final, start, inverter, mode_value)
                        elseif mode_type == 'Rotate' then
                            yaw = math.interval(globals.tickcount, start, final, mode_value)
                            yaw = assistant.update_value('antiaim.yaw.rotate.'..condition, inverter, yaw)
                        elseif mode_type == 'Sway' then
                            yaw = math.interval(globals.tickcount, start, final, mode_value, true)
                            yaw = assistant.update_value('antiaim.yaw.sway.'..condition, inverter, yaw)
                        elseif mode_type == 'Random' then
                            yaw = assistant.update_value('antiaim.yaw.random.'..condition, inverter, math.random(start, final))
                        end
                    end; ref.antiaim.yaw_offset:override(yaw)
                    ::proceed::
                end

                if el.force_defensive:get() then
                    cmd.force_defensive = true
                    ref.antiaim.hidden:override(true)
                    do -- hiddenYaw
                        if el.hiddenConYaw:get() == false then
                            goto proceed
                        end

                        local start, final = el.hiddenYaw_start:get(), el.hiddenYaw_end:get()
                        local hiddenYaw = start

                        local mode = gear.hiddenYaw_mode:get()
                        local mode_type = gear.hiddenYaw_mode_type:get()
                        local mode_value = gear.hiddenYaw_mode_value:get()

                        if mode == 'Start/End' then
                            local inverter = inverter_f(start, final, gear.hiddenYaw_adjuster:get(), gear.hiddenYaw_adjuster_value1:get(), gear.hiddenYaw_adjuster_value2:get())

                            if mode_type == '<->' then
                                hiddenYaw = inverter and start or final
                            elseif mode_type == 'N-Way' then
                                hiddenYaw = assistant.nWay('antiaim.hiddenYaw.nWay.'..condition, final, start, inverter, mode_value)
                            elseif mode_type == 'Rotate' then
                                hiddenYaw = math.interval(globals.tickcount, start, final, mode_value)
                                hiddenYaw = assistant.update_value('antiaim.hiddenYaw.rotate.'..condition, inverter, hiddenYaw)
                            elseif mode_type == 'Sway' then
                                hiddenYaw = math.interval(globals.tickcount, start, final, mode_value, true)
                                hiddenYaw = assistant.update_value('antiaim.hiddenYaw.sway.'..condition, inverter, hiddenYaw)
                            elseif mode_type == 'Random' then
                                hiddenYaw = assistant.update_value('antiaim.hiddenYaw.random.'..condition, inverter, math.random(start, final))
                            end
                        end; rage.antiaim:override_hidden_yaw_offset(-hiddenYaw)
                        ::proceed::
                    end
                    do -- hiddenPitch
                        if el.hiddenConPitch:get() == false then
                            goto proceed
                        end

                        local start, final = el.hiddenPitch_start:get(), el.hiddenPitch_end:get()
                        local hiddenPitch = start

                        local mode = gear.hiddenPitch_mode:get()
                        local mode_type = gear.hiddenPitch_mode_type:get()
                        local mode_value = gear.hiddenPitch_mode_value:get()

                        if mode == 'Start/End' then
                            local inverter = inverter_f(start, final, gear.hiddenPitch_adjuster:get(), gear.hiddenPitch_adjuster_value1:get(), gear.hiddenPitch_adjuster_value2:get())

                            if mode_type == '<->' then
                                hiddenPitch = inverter and start or final
                            elseif mode_type == 'N-Way' then
                                hiddenPitch = assistant.nWay('antiaim.hiddenPitch.nWay.'..condition, final, start, inverter, mode_value)
                            elseif mode_type == 'Rotate' then
                                hiddenPitch = math.interval(globals.tickcount, start, final, mode_value)
                                hiddenPitch = assistant.update_value('antiaim.hiddenPitch.rotate.'..condition, inverter, hiddenPitch)
                            elseif mode_type == 'Sway' then
                                hiddenPitch = math.interval(globals.tickcount, start, final, mode_value, true)
                                hiddenPitch = assistant.update_value('antiaim.hiddenPitch.sway.'..condition, inverter, hiddenPitch)
                            elseif mode_type == 'Random' then
                                hiddenPitch = assistant.update_value('antiaim.hiddenPitch.random.'..condition, inverter, math.random(start, final))
                            end
                        end; rage.antiaim:override_hidden_pitch(hiddenPitch)
                        ::proceed::
                    end
                end
            end,
            antiaim_additions = function()
                local tweak = antiaim.general.tweaks -- 'Fast ladder', 'No fall damage'

                local lp = entity.get_local_player()
                if not lp then
                    return
                end

                ref.antiaim.avoid_backstab:set(tweak:get('Avoid backstab'))
            end,
            legit_aa = function()
                self.var.legit_aa.is_working = false

                local lp = entity.get_local_player()
                if not lp then
                    self.var.legit_aa.override = false
                    return
                end

                if antiaim.general.legit_aa:get() then
                    ref.antiaim.pitch:override('Disabled')
                    ref.antiaim.yaw:override('Disabled')
                    ref.antiaim.desync:override(true)
                    ref.antiaim.desync_freestand:override('Peek Real')
                    ref.antiaim.desync_left:override(60)
                    ref.antiaim.desync_right:override(60)
                    ref.antiaim.desync_options:override({'Avoid Overlap'})

                    self.var.legit_aa.is_working = true
                    self.var.legit_aa.override = true

                    local exceptions = lp['m_bIsDefusing'] or lp['m_bIsGrabbingHostage']
                    if exceptions then utils.console_exec('+use') else utils.console_exec('-use') end
                else
                    if self.var.legit_aa.override then
                        for _, v in pairs(ref.antiaim) do
                            if v:get_override() ~= nil then
                                v:override(nil)
                            end
                        end
                        utils.console_exec('-use')
                        self.var.legit_aa.override = false
                    end
                end
            end,
            edge_yaw = function()
                self.var.edge_yaw.is_working = false
                if not antiaim.general.edge_yaw:get() then
                    return
                end

                if self.var.legit_aa.is_working then
                    return
                end

                local lp = entity.get_local_player()
                if not lp then
                    return
                end

                if assistant.get_choke().int == 0 then
                    self.var.edge_yaw.start = lp:get_eye_position()
                end

                local info = {}; for yaw = 0, 360, 45 do
                    local edge_angle = math.angle_to_forward(vector(0, math.normalize(yaw), 0))
                    local final = self.var.edge_yaw.start + edge_angle * 198

                    local trace = utils.trace_line(self.var.edge_yaw.start, final, lp, 0x46004003, 1)
                    if trace.entity and trace.fraction < 0.3 then
                        table.insert(info, final)
                    end
                end

                if #info == 0 then
                    if ref.antiaim.yaw:get_override() ~= nil then
                        ref.antiaim.yaw:override(nil)
                        ref.antiaim.yaw_offset:override(nil)
                    end
                    return
                end

                if #info ~= 1 then
                    self.var.edge_yaw.is_working = true

                    local center = info[1]:lerp(info[#info], 0.5)
                    local angle = (self.var.edge_yaw.start - center):angles()

                    ref.antiaim.yaw:override('Static')
                    ref.antiaim.yaw_offset:override(angle.y - 180)
                end
            end,
            aspect_ratio = function()
                if not misc.other.aspect_ratio:get() then
                    cvar.r_aspectratio:float(0)
                    return
                end

                local ratio = misc.other.aspect_ratio_gear.ratio:get() / 100
                cvar.r_aspectratio:float(ratio)
            end,
            exploit = function()
                -- rage.exploit:allow_charge(false)
                -- rage.exploit:force_charge()
                -- rage.exploit:force_teleport()
            end,
            no_fall_damage = function(cmd)
                if not misc.move.no_fall_damage:get() then
                    return
                end

                local lp = entity.get_local_player()
                if lp == nil then
                    return
                end

                local origin = lp:get_origin()

                if lp['m_vecVelocity'].z <= -500 then
                    local pre_land = utils.trace_line(origin, origin - vector(0, 0, 50))
                    local post_land = utils.trace_line(origin, origin - vector(0, 0, 15))

                    if post_land.fraction ~= 1 then
                        cmd.in_duck = 0
                    elseif pre_land.fraction ~= 1 then
                        cmd.in_duck = 1
                    end
                end
            end,
            fast_ladder = function(cmd)
                if not misc.move.fast_ladder:get() then
                    return
                end

                local lp = entity.get_local_player()
                if lp == nil then
                    return
                end

                local m_MoveType = lp['m_MoveType']

                if m_MoveType == 9 then
                    if cmd.sidemove == 0 then
                        cmd.view_angles.y = cmd.view_angles.y + 45
                    end

                    if cmd.in_forward then
                        if cmd.sidemove > 0 then
                            cmd.view_angles.y = cmd.view_angles.y - 1
                        end

                        if cmd.sidemove < 0 then
                            cmd.view_angles.y = cmd.view_angles.y + 90
                        end

                        cmd.in_moveleft = true
                        cmd.in_moveright = true
                    end

                    if cmd.in_back then
                        if cmd.sidemove < 0 then
                            cmd.view_angles.y = cmd.view_angles.y - 1
                        end

                        if cmd.sidemove > 0 then
                            cmd.view_angles.y = cmd.view_angles.y + 90
                        end

                        cmd.in_moveleft = true
                        -- cmd.in_moveright = true
                    end
                end
            end,
            avoid_collision = function(cmd)
                if not misc.move.avoid_collision:get() then
                    return
                end

                local lp = entity.get_local_player()
                if lp == nil then
                    return
                end
                local camera = render.camera_angles()
                camera.z = 0

                local origin = lp:get_origin()
                origin.z = origin.z + 20
                local m_vecVelocity = lp['m_vecVelocity']

                local angle = m_vecVelocity:angles()
                local forward = vector():angles(angle); forward.z = 0

                local start = origin
                local final = origin + forward * 120

                local trace = utils.trace_line(start, final, lp, 0x46004003)
                render.line(render.world_to_screen(start), render.world_to_screen(final), color(0))

                local pos_end = {}; for i = -90, 90, 45 do
                    local start = origin
                    local final = origin + vector():angles(vector(0, angle.y + i, 0)) * 100
                    local trace = utils.trace_line(start, final, lp, 0x46004003)
                    render.line(render.world_to_screen(start), render.world_to_screen(final), color())

                    if trace.fraction ~= 1 then
                        table.insert(pos_end, trace.end_pos)
                    end
                end

                if #pos_end >= 2 then
                    render.line(render.world_to_screen(pos_end[1]), render.world_to_screen(pos_end[2]), color(0, 0, 255))
                    local a, b, c = pos_end[1]:dist(pos_end[2]), origin:dist(pos_end[1]),  origin:dist(pos_end[2])
                    local p = (a + b + c) / 2
                    local S = math.sqrt(p * (p - a) * (p - b) * (p - c))
                    local h = 2 * S / a

                    if h < 30 then
                        cmd.move_yaw = angle.y
                    end
                end
            end,
            grenade_fix = function()
                if not misc.rage.grenade_fix:get() then
                    if self.override('nade_fix').state then
                        rage.exploit:allow_defensive(true)
                    end
                    return
                end

                local lp = entity.get_local_player()
                if lp == nil then
                    if self.override('nade_fix').state then
                        rage.exploit:allow_defensive(true)
                    end
                    return
                end

                self.override('nade_fix', true)
                if not self.override('nade_fix').state then
                    rage.exploit:allow_defensive(true)
                end

                local weapon = lp:get_player_weapon()
                if weapon == nil then
                    return
                end

                if string.match(weapon:get_classname(), 'Grenade') then
                    rage.exploit:allow_defensive(false)
                end
            end,
            jumpscout = function()
                if not misc.rage.jump_scout:get() then
                    if ref.misc.air_strafe:get_override() ~= nil then ref.misc.air_strafe:override() ref.rage.ssg08.hitchance:override() end
                    return
                end

                local lp = entity.get_local_player()
                if lp == nil then
                    if ref.misc.air_strafe:get_override() ~= nil then ref.misc.air_strafe:override() ref.rage.ssg08.hitchance:override() end
                    return
                end

                local m_vecVelocity = lp['m_vecVelocity']
                m_vecVelocity.z = 0

                local weapon = lp:get_player_weapon()
                if weapon == nil then
                    if ref.misc.air_strafe:get_override() ~= nil then ref.misc.air_strafe:override() ref.rage.ssg08.hitchance:override() end
                    return
                end

                if weapon:get_weapon_info().console_name == 'weapon_ssg08' and m_vecVelocity:length() < 10 then
                    ref.misc.air_strafe:override(false)
                    if not assistant.player_in_air(lp) then
                        ref.rage.ssg08.hitchance:override(misc.rage.jump_scout_gear.hc:get())
                    else
                        ref.rage.ssg08.hitchance:override()
                    end
                else
                    ref.rage.ssg08.hitchance:override()
                    ref.misc.air_strafe:override()
                end
            end,
            on_enemy_lethal = function()
                local value = misc.rage.on_enemy_lethal
                if not value:get('Force body aim') and not value:get('Force safe points') then
                    if self.override('on enemy lethal', true).state then
                        for _, v in ipairs(self.var.weapon.group) do
                            if nui.find('Aimbot', 'Ragebot', 'Safety', v, 'Body Aim'):get_override() ~= nil then
                                nui.find('Aimbot', 'Ragebot', 'Safety', v, 'Body Aim'):override()
                            end
                            if nui.find('Aimbot', 'Ragebot', 'Safety', v, 'Safe Points'):get_override() ~= nil then
                                nui.find('Aimbot', 'Ragebot', 'Safety', v, 'Safe Points'):override()
                            end
                        end
                    end
                    return
                end

                local lp = entity.get_local_player()
                if lp == nil then
                    if self.override('on enemy lethal', true).state then
                        for _, v in ipairs(self.var.weapon.group) do
                            if nui.find('Aimbot', 'Ragebot', 'Safety', v, 'Body Aim'):get_override() ~= nil then
                                nui.find('Aimbot', 'Ragebot', 'Safety', v, 'Body Aim'):override()
                            end
                            if nui.find('Aimbot', 'Ragebot', 'Safety', v, 'Safe Points'):get_override() ~= nil then
                                nui.find('Aimbot', 'Ragebot', 'Safety', v, 'Safe Points'):override()
                            end
                        end
                    end
                    return
                end

                local threat = entity.get_threat()

                if threat == nil then
                    if self.override('on enemy lethal', true).state then
                        for _, v in ipairs(self.var.weapon.group) do
                            if nui.find('Aimbot', 'Ragebot', 'Safety', v, 'Body Aim'):get_override() ~= nil then
                                nui.find('Aimbot', 'Ragebot', 'Safety', v, 'Body Aim'):override()
                            end
                            if nui.find('Aimbot', 'Ragebot', 'Safety', v, 'Safe Points'):get_override() ~= nil then
                                nui.find('Aimbot', 'Ragebot', 'Safety', v, 'Safe Points'):override()
                            end
                        end
                    end
                    return
                end

                local weapon = assistant.get_current_group_weapon(lp)
                if weapon == nil then
                    if self.override('on enemy lethal', true).state then
                        for _, v in ipairs(self.var.weapon.group) do
                            if nui.find('Aimbot', 'Ragebot', 'Safety', v, 'Body Aim'):get_override() ~= nil then
                                nui.find('Aimbot', 'Ragebot', 'Safety', v, 'Body Aim'):override()
                            end
                            if nui.find('Aimbot', 'Ragebot', 'Safety', v, 'Safe Points'):get_override() ~= nil then
                                nui.find('Aimbot', 'Ragebot', 'Safety', v, 'Safe Points'):override()
                            end
                        end
                    end
                    return
                end

                if not misc.rage.on_enemy_lethal_gear.weapon:get(weapon) then
                    return
                end

                local specified_dmg = {
                    ['AutoSnipers'] = 70,
                    ['SSG-08'] = 90,
                    ['AWP'] = 0,
                    ['Desert Eagle'] = 45,
                    ['R8 Revolver'] = 90,
                    ['Pistols'] = 0,
                }

                if not (threat['m_iHealth'] <= specified_dmg[weapon]) then
                    if nui.find('Aimbot', 'Ragebot', 'Safety', weapon, 'Body Aim'):get_override() ~= nil then
                        nui.find('Aimbot', 'Ragebot', 'Safety', weapon, 'Body Aim'):override()
                    end
                    if nui.find('Aimbot', 'Ragebot', 'Safety', weapon, 'Safe Points'):get_override() ~= nil then
                        nui.find('Aimbot', 'Ragebot', 'Safety', weapon, 'Safe Points'):override()
                    end
                    return
                end

                self.override('on enemy lethal', true)

                if value:get('Force body aim') then
                    print('arar')
                    nui.find('Aimbot', 'Ragebot', 'Safety', weapon, 'Body Aim'):override('Force')
                else
                    nui.find('Aimbot', 'Ragebot', 'Safety', weapon, 'Body Aim'):override()
                end
                if value:get('Force safe points') then
                    nui.find('Aimbot', 'Ragebot', 'Safety', weapon, 'Safe Points'):override('Force')
                else
                    nui.find('Aimbot', 'Ragebot', 'Safety', weapon, 'Safe Points'):override()
                end
            end,
            viewmodel = function()
                if not misc.other.view_model:get() then
                    -- print(self.override('viewmodel').state)
                    -- print()
                    if self.get_raw_override('viewmodel') ~= nil then
                        if self.get_raw_override('viewmodel').state then
                            local vm = misc.other.view_model_gear.vm
                            cvar.viewmodel_fov:int(vm.fov, true)
                            cvar.viewmodel_offset_x:int(vm.x, true)
                            cvar.viewmodel_offset_y:int(vm.y, true)
                            cvar.viewmodel_offset_z:int(vm.z, true)
                            self.override('viewmodel')
                        end
                    end
                    return
                end
                local vm = misc.other.view_model_gear

                cvar.viewmodel_fov:int(vm.fov:get(), true)
                cvar.viewmodel_offset_x:int(vm.x:get(), true)
                cvar.viewmodel_offset_y:int(vm.y:get(), true)
                cvar.viewmodel_offset_z:int(vm.z:get(), true)
                self.override('viewmodel', true)
            end
        }

        events.createmove:set(function(cmd)
            for _, v in pairs(f) do
                v(cmd)
            end
        end)
    end,
    clientside_animation = function(self)
        local f = {
            pre = {
            },
            post = {
                animation_breakers = function(player)
                    if not antiaim.general.anim_breakers:get() then
                        if ref.antiaim.leg_movement:get_override() then
                            ref.antiaim.leg_movement:override()
                        end
                        return
                    end

                    local lp = entity.get_local_player()
                    if not lp then
                        return
                    end
                    if lp ~= player then
                        return
                    end

                    local gear = antiaim.general.anim_breakers_gear

                    do -- legs
                        if gear.legs:get() == 'Backward' then
                            ref.antiaim.leg_movement:override('Sliding')
                            lp.m_flPoseParameter[0] = 0
                        elseif gear.legs:get() == 'Jitter' then
                            ref.antiaim.leg_movement:override('Sliding')
                            lp.m_flPoseParameter[0] = globals.tickcount % 4 < 2 and 0 or 0.5
                        elseif gear.legs:get() == 'Running' then
                            ref.antiaim.leg_movement:override('Walking')
                            lp.m_flPoseParameter[7] = 0
                        elseif gear.legs:get() == 'Static' then
                            ref.antiaim.leg_movement:override('Walking')
                            lp.m_flPoseParameter[10] = 0
                        end
                    end
                    do -- in air
                        if gear.in_air:get() == 'Static legs' then
                            lp.m_flPoseParameter[6] = 1
                        end
                    end
                    do -- crouch
                        if gear.crouch:get() == 'Static legs' then
                            lp.m_flPoseParameter[8] = 0
                        end
                    end
                end,
            }
        }

        -- events.pre_update_clientside_animation:set(function(player)
        --     for k, v in pairs(f.pre) do
        --         v(player)
        --     end
        -- end)
        events.post_update_clientside_animation:set(function(player)
            for k, v in pairs(f.post) do
                v(player)
            end
        end)
    end,
    level_init = function(self)
        local f = {
            update_NETChannel = function()
                net = utils.net_channel()
            end,
            clear_logs = function()
                self.var.logs.aimbot = {}
            end
        }
        events.level_init:set(function()
            for _, v in pairs(f) do
                v()
            end
        end)
    end,
    aim_ack = function(self)
        do -- helper
            self.insert_log = function(data, speed)
                self.var.logs.stamp = self.var.logs.stamp + 1

                table.insert(self.var.logs.aimbot, {
                    data = data,
                    time = globals.curtime + (speed or 3),
                    stamp = self.var.logs.stamp,
                    is_max = false,
                    speed = (speed or 3)
                })
            end
        end

        local f = {
            -- test = function(log)
            --     local dmg = log.damage
            --     local health = log.target['m_iHealth']
            --     if dmg == nil or health == nil then
            --         return
            --     end
            --     if dmg > health then
            --         utils.console_exec(string.format('say %s', self.var.shittalk[math.random(1, #self.var.shittalk)]))
            --     end
            -- end,
            logs = function(log)
                local name = log.target:get_name()
                local dmg = log.damage
                local state = log.state
                state = state or 'hit'
                local bt = log.backtrack
                local hc = log.hitchance
                local hitgroup = self.var.hitgroup[log.hitgroup]
                local wanted_hitgroup = self.var.hitgroup[log.wanted_hitgroup]

                local text = nil
                local t_clr = color()
                local a_clr = color()

                if state == 'hit' then
                    t_clr = color(160, 160, 160)
                    a_clr = color(112, 255, 135)

                    text = assistant.color_text({
                        {nui.get_icon('bullseye-arrow'), a_clr},
                        {' Hit ', t_clr},
                        {name, a_clr},
                        {' in ', t_clr},
                        {hitgroup, a_clr},
                        {' for ', t_clr},
                        {dmg, a_clr},
                        {' hp ', t_clr},
                    })
                else
                    t_clr = color(160)
                    a_clr = color(112, 255, 135)

                    local states = {
                        ['spread'] = {
                            icon = 'chart-network',
                            a_clr = color(255, 159, 70)
                        },
                        ['correction'] = {
                            icon = 'puzzle-piece',
                            a_clr = color(255, 0, 0)
                        },
                        ['misprediction'] = {
                            icon = 'chart-line',
                            a_clr = color(255, 75, 102)
                        },
                        ['prediction error'] = {
                            icon = 'chart-line',
                            a_clr = color(255, 75, 102)
                        },
                        ['backtrack failure'] = {
                            icon = 'backward-fast',
                            a_clr = color(148, 54, 255)
                        },
                        ['damage rejection'] = {
                            icon = 'square-dashed',
                            a_clr = color(245, 106, 120)
                        },
                        ['unregistered shot'] = {
                            icon = 'square-dashed',
                            a_clr = color(180)
                        },
                        ['player death'] = {
                            icon = 'person-falling-burst',
                            a_clr = color(140)
                        },
                        ['death'] = {
                            icon = 'skull-crossbones',
                            a_clr = color(130)
                        },
                    }

                    local icon = states[state].icon
                    a_clr = states[state].a_clr

                    if icon == nil then
                        print(string.format('[DEBUG] state - "%s" is nil', state))
                    end

                    text = assistant.color_text({
                        {nui.get_icon(icon), a_clr},
                        {' Missed ', t_clr},
                        {name, a_clr},
                        {'`s ', t_clr},
                        {wanted_hitgroup, a_clr},
                        {' due to ', t_clr},
                        {state, a_clr},
                        {' ', a_clr}
                    })
                end

                if misc.rage.aimbot_logs:get() and misc.rage.aimbot_logs_gear.events:get('Aimbot fire') then
                    local output = misc.rage.aimbot_logs_gear.output
                    local text = text:sub(3, text:len())
                    local icon = text:find('[^%w .]'); if icon then
                        text = text:sub(icon + 3, text:len() - 1)
                    end

                    text = string.format('[\a%saqua\a]%s %s', misc.rage.aimbot_logs_gear.clr:get():to_hex(), text, string.format('\a%s[aimed:%s hc:%s bt:%s]', t_clr:to_hex(), wanted_hitgroup, hc, bt))

                    if output:get('Console') then
                        print_raw(text)
                    end
                    if output:get('Event') then
                        text = text:gsub(t_clr:to_hex(), color():to_hex())
                        common.add_event(text:sub(text:find('aqua') + 6, text:len()))
                    end
                end

                if misc.visuals.aimbot_logs:get() then
                    self.insert_log({
                        text = text,
                        clr = a_clr,
                        state = state
                    })
                end
            end
        }
        events.aim_ack:set(function(log)
            for _, v in pairs(f) do
                v(log)
            end
        end)
    end,
    events = function(self)
        local f = {
            player_hurt = {
                aimbot_log = function(e)
                    local lp = entity.get_local_player()
                    if not lp then
                        return
                    end

                    -- print(e.userid)
                    local damaged_player = entity.get(e.userid, true)
                    local attacker = entity.get(e.attacker, true)

                    if damaged_player == lp and attacker ~= lp then
                        if misc.rage.aimbot_logs:get() and misc.rage.aimbot_logs_gear.events:get('Damage dealt') then
                            local t_clr = color(160, 160, 160)
                            local a_clr = color(255, 76, 154)

                            local s = assistant.color_text({
                                {nui.get_icon('heart-crack'), a_clr},
                                {' Harmed by ', t_clr},
                                {attacker:get_name(), a_clr},
                                {' in ', t_clr},
                                {self.var.hitgroup[e.hitgroup], a_clr},
                                {' for ', t_clr},
                                {tostring(e.dmg_health), a_clr},
                                {' hp', t_clr}
                            })

                            if misc.visuals.aimbot_logs:get() then
                                self.insert_log({
                                    text = s,
                                    clr = a_clr
                                }, 2)
                            end

                            if misc.rage.aimbot_logs:get() and misc.rage.aimbot_logs_gear.events:get('Damage dealt') then
                                local output = misc.rage.aimbot_logs_gear.output
                                local text = s

                                if output:get('Console') then
                                    local text = text:sub(3, text:len())
                                    local icon = text:find('[^%w .]'); if icon then
                                        text = text:sub(icon + 3, text:len())
                                    end

                                    text = string.format('[\a%saqua\a]%s', misc.rage.aimbot_logs_gear.clr:get():to_hex(), text)
                                    print_raw(text)
                                end

                                if output:get('Event') then
                                    text = text:gsub(t_clr:to_hex(), color():to_hex())
                                    common.add_event(text)
                                end
                            end
                        end
                    elseif damaged_player ~= lp and attacker == lp then
                        local weapon, nade, time = e.weapon, nil, 2

                        local t_clr = color(160, 160, 160)
                        local a_clr = color(112, 255, 135)

                        if weapon == 'inferno' then
                            a_clr = color(255, 115, 0)
                            nade = 'fire'
                            time = 1
                        elseif weapon == 'hegrenade' then
                            a_clr = color(176, 0, 0)
                            nade = 'bomb'
                        end

                        if nade then
                            local s = assistant.color_text({
                                {nui.get_icon(nade), a_clr},
                                {' Naded ', t_clr},
                                {damaged_player:get_name(), a_clr},
                                {'`s for ', t_clr},
                                {tostring(e.dmg_health), a_clr},
                                {' hp', t_clr}
                            })

                            if misc.visuals.aimbot_logs:get() then
                                self.insert_log({
                                    text = s,
                                    clr = a_clr
                                }, time)
                            end
                            if misc.rage.aimbot_logs:get() and misc.rage.aimbot_logs_gear.events:get('Aimbot fire') then
                                local output = misc.rage.aimbot_logs_gear.output
                                local text = s

                                if output:get('Console') then
                                    local text = text:sub(3, text:len())
                                    local icon = text:find('[^%w .]'); if icon then
                                        text = text:sub(icon + 3, text:len())
                                    end

                                    text = string.format('[\a%saqua\a]%s', misc.rage.aimbot_logs_gear.clr:get():to_hex(), text)
                                    print_raw(text)
                                end

                                if output:get('Event') then
                                    text = text:gsub(t_clr:to_hex(), color():to_hex())
                                    common.add_event(text)
                                end
                            end
                        end
                    end
                end
            },
            item_purchase = {
                logs = function(e)
                    local lp = entity.get_local_player()
                    local who_bought_smth = entity.get(e.userid, true)

                    if lp['m_iTeamNum'] ~= who_bought_smth['m_iTeamNum'] then
                        if misc.rage.aimbot_logs:get() and misc.rage.aimbot_logs_gear.events:get('Purchases') then
                            local output = misc.rage.aimbot_logs_gear.output

                            local t_clr = color(160, 160, 160)
                            local a_clr = color(77, 255, 255)
                            local text = assistant.color_text({
                                {nui.get_icon('cart-shopping')..' '..who_bought_smth:get_name(), a_clr},
                                {' bought ', t_clr},
                                {e.weapon:gsub('weapon_', ''):gsub('item_', ''), a_clr}
                            })

                            if output:get('Console') then
                                local text = text:sub(3, text:len())
                                local icon = text:find('[^%w .]'); if icon then
                                    text = text:sub(icon + 3, text:len())
                                end

                                text = string.format('[\a%saqua\a]%s', misc.rage.aimbot_logs_gear.clr:get():to_hex(), text)
                                print_raw(text)
                            end

                            if output:get('Event') then
                                text = text:gsub(t_clr:to_hex(), color():to_hex())
                                common.add_event(text)
                            end
                        end
                    end
                end
            }
        }

        events.player_hurt:set(function(e)
            for k, v in pairs(f.player_hurt) do
                v(e)
            end
        end)
        events.item_purchase:set(function(e)
            for k, v in pairs(f.item_purchase) do
                v(e)
            end
        end)
    end,
    net_update_start = function(self)
        local f = {
            clantag = function()
                if not misc.other.clantag:get() then
                    if self.var.clantag.override == false then
                        common.set_clan_tag('')
                        self.var.clantag.override = true
                    end
                    return
                end; self.var.clantag.override = false

                local lp = entity.get_local_player()
                if lp == nil then
                    return
                end

                if bit.band(lp['m_fFlags'], literal.FL_FROZEN) ~= 0 then
                    if not self.var.clantag.on_frozen then
                        common.set_clan_tag('水aqua club')
                        self.var.clantag.on_frozen = true
                    end
                else
                    self.var.clantag.on_frozen = false
                end

                if not assistant.check() then return end
                local curtime = math.floor(globals.curtime * 1.8)

                local tag = {
                    ['Aqua Club'] = self.var.clantag.aqua,
                    ['1700888 gang'] = self.var.clantag.gang1700888,
                }; tag = tag[misc.other.clantag_gear.tag:get()]

                local anim = tag[curtime % #tag + 1]
                if self.var.clantag.old_time ~= curtime and (globals.tickcount % 2) == 1 then
                    common.set_clan_tag(anim)
                    self.var.clantag.old_time = curtime
                end
            end,
        }
        events.net_update_start:set(function(log)
            for _, v in pairs(f) do
                v(log)
            end
        end)
    end,
    buttons = function(self)
        do -- aimbot_logs
            misc.visuals.aimbot_logs_gear.debug:set_callback(function()
                local text = nil
                local icon = nil
                local t_clr = color()
                local a_clr = color()

                t_clr = color(160, 160, 160)
                a_clr = color(112, 255, 135)

                do
                    text = assistant.color_text({
                        {nui.get_icon('bullseye-arrow'), a_clr},
                        {' Hit ', t_clr},
                        {'never', a_clr},
                        {' in ', t_clr},
                        {'head', a_clr},
                        {' for ', t_clr},
                        {'1700', a_clr},
                        {' hp ', t_clr},
                    })
                    self.insert_log({
                        text = text,
                        clr = a_clr,
                        state = 'hit'
                    })
                end
                do
                    local states = {
                        [1] = {
                            icon = 'chart-network',
                            a_clr = color(255, 159, 70),
                            state = 'spread',
                        },
                        [2] = {
                            icon = 'puzzle-piece',
                            a_clr = color(255, 0, 0),
                            state = 'correction'
                        },
                        [3] = {
                            icon = 'chart-line',
                            a_clr = color(255, 75, 102),
                            state = 'misprediction'
                        },
                        [4] = {
                            icon = 'chart-line',
                            a_clr = color(255, 75, 102),
                            state = 'prediction error'
                        },
                        [5] = {
                            icon = 'backward-fast',
                            a_clr = color(148, 54, 255),
                            state = 'backtrack failure'
                        },
                        [6] = {
                            icon = 'square-dashed',
                            a_clr = color(245, 106, 120),
                            state = 'damage rejection'
                        },
                        [7] = {
                            icon = 'square-dashed',
                            a_clr = t_clr,
                            state = 'unregistered shot'
                        },
                        [8] = {
                            icon = 'person-falling-burst',
                            a_clr = t_clr,
                            state = 'player death'
                        },
                        [9] = {
                            icon = 'skull-crossbones',
                            a_clr = t_clr,
                            state = 'death'
                        },
                    }
                    local state_t = states[math.random(1, #states)]

                    icon = state_t.icon
                    a_clr = state_t.a_clr
                    local state = state_t.state

                    text = assistant.color_text({
                        {nui.get_icon(icon), a_clr},
                        {' Missed ', t_clr},
                        {'never', a_clr},
                        {'`s ', t_clr},
                        {'head', a_clr},
                        {' due to ', t_clr},
                        {state, a_clr},
                        {' ', a_clr}
                    })

                    self.insert_log({
                        text = text,
                        clr = a_clr,
                        state = state
                    })
                end
            end)
        end
        do -- config system
            home.config.default:set_callback(function()
                local link = 'https://raw.githubusercontent.com/pullyfy/logins/main/aqua%20club/neverlose/config'
                http.task:get(link, function(response)
                    if response:success() then
                        local owner = nui.load(nui.decode('AQUA', response.body))
                        if owner ~= nil then
                            common.add_notify('Config', 'Default loaded.')
                        end
                    else
                        common.add_notify('Config', 'Something went wrong with HTTP.')
                    end
                end)
            end)
            home.config.export:set_callback(function()
                nui.export()
                common.add_notify('Config', 'Exported.')
            end)
            home.config.import:set_callback(function()
                local owner = nui.import()
                if owner ~= nil then
                    common.add_notify('Config', string.format('Imported from %s.', nui.import()))
                end
            end)
            home.config.reset:set_callback(function()
                nui.reset()
                common.add_notify('Config', 'Reseted.')
            end)
            antiaim.builder.import:set_callback(function()
                local owner = nui.import('anti-aim')
                if owner ~= nil then
                    common.add_notify('Config', string.format('Imported anti-aims from %s.', owner))
                end
            end)
        end
    end,
    shutdown = function(self)
        local f = {
        }

        events.shutdown:set(function()
            for k, v in pairs(f) do
                v()
            end
        end)
    end,
    setup = function(self)
        self:var()
        self:level_init()
        self:events()
        self:pre_render()
        self:render()
        self:createmove()
        self:clientside_animation()
        -- self:createmove_run()
        self:aim_ack()
        self:net_update_start()
        self:buttons()
        self:shutdown()
    end
}; script:setup()
