local ffi = require('ffi'); local FFI = {
    ffi.cdef[[
        typedef int BOOL;
        typedef long LONG;
        typedef unsigned long HANDLE;
        typedef float*(__thiscall* bound)(void*);
        typedef HANDLE HWND;
        typedef uintptr_t (__thiscall* GetClientEntity_4242425_t)(void*, int);

        typedef struct {
            LONG x, y;
        } POINT, *LPPOINT;

        typedef struct {
            uint8_t r;
            uint8_t g;
            uint8_t b;
            uint8_t a;
        } color_struct_t;

        typedef struct {
            float x,y;
        } vec2_t;

        typedef struct {
            vec2_t m_Position;
            vec2_t m_TexCoord;
        } Vertex_t;

        typedef struct {
            char   pad_0000[24];                    //0x0000
            int    m_nOutSequenceNr;                //0x0018
            int    m_nInSequenceNr;                 //0x001C
            int    m_nOutSequenceNrAck;             //0x0020
            int    m_nOutReliableState;             //0x0024
            int    m_nInReliableState;              //0x0028
            int    m_nChokedPackets;                //0x002C
            char   pad_0030[108];                   //0x0030
            int    m_Socket;                        //0x009C
            int    m_StreamSocket;                  //0x00A0
            int    m_MaxReliablePayloadSize;        //0x00A4
            char   pad_00A8[100];                   //0x00A8
            float  last_received;                   //0x010C
            float  connect_time;                    //0x0110
            char   pad_0114[4];                     //0x0114
            int    m_Rate;                          //0x0118
            char   pad_011C[4];                     //0x011C
            float  m_fClearTime;                    //0x0120
            char   pad_0124[16688];                 //0x0124
            char   m_Name[32];                      //0x4254
            size_t m_ChallengeNr;                   //0x4274
            float  m_flTimeout;                     //0x4278
            char   pad_427C[32];                    //0x427C
            float  m_flInterpolationAmount;         //0x429C
            float  m_flRemoteFrameTime;             //0x42A0
            float  m_flRemoteFrameTimeStdDeviation; //0x42A4
            int    m_nMaxRoutablePayloadSize;       //0x42A8
            int    m_nSplitPacketSequence;          //0x42AC
            char   pad_42B0[40];                    //0x42B0
            bool   m_bIsValveDS;                    //0x42D8
            char   pad_42D9[65];                    //0x42D9
        } INetChannel_t;

        typedef struct c_animstate
        {
            char         pad0[0x60];
            void*        pEntity;
            void*        pActiveWeapon;
            void*        pLastActiveWeapon;
            float        flLastUpdateTime;
            int          iLastUpdateFrame;
            float        flLastUpdateIncrement;
            float        flEyeYaw;
            float        flEyePitch;
            float        flGoalFeetYaw;
            float        flLastFeetYaw;
            float        flMoveYaw;
            float        flLastMoveYaw;
            float        flLeanAmount;
            char         pad1[0x4];
            float        flFeetCycle;
            float        flMoveWeight;
            float        flMoveWeightSmoothed;
            float        flDuckAmount;
            float        flHitGroundCycle;
            float        flRecrouchWeight;
            float        flVelocityLenght2D;
            float        flJumpFallVelocity;
            float        flSpeedNormalized;
            float        flRunningSpeed;
            float        flDuckingSpeed;
            float        flDurationMoving;
            float        flDurationStill;
            bool         bOnGround;
            bool         bHitGroundAnimation;
            char         pad2[0x2];
            float        flNextLowerBodyYawUpdateTime;
            float        flDurationInAir;
            float        flLeftGroundHeight;
            float        flHitGroundWeight;
            float        flWalkToRunTransition;
            char         pad3[0x4];
            float        flAffectedFraction;
            char         pad4[0x208];
            float        flMinBodyYaw;
            float        flMaxBodyYaw;
            float        flMinPitch;
            float        flMaxPitch;
            float        m_flFeetSpeedForwardsOr;
            int          iAnimsetVersion;
        } CCSGOPlayerAnimationState_534535_t;

        struct animation_layer_t {
            bool m_bClientBlend;
            float m_flBlendIn;
            void * m_pStudioHdr;
            int m_nDispatchSequence;
            int m_nDispatchSequence_2;
            uint32_t m_nOrder;
            uint32_t m_nSequence;
            float m_flPrevCycle;
            float m_flWeight;
            float m_flWeightDeltaRate;
            float m_flPlaybackRate;
            float m_flCycle;
            void * m_pOwner;
            char pad_0038 [4];
        };

        // Render region
        typedef struct {
            uint8_t r;
            uint8_t g;
            uint8_t b;
            uint8_t a;
        } color_struct_t;

        typedef struct {
            float x,y;
        } vec2_t;

        typedef struct {
            vec2_t m_Position;
            vec2_t m_TexCoord;
        } Vertex_t;

        struct c_color {
            unsigned char clr[4];
        };
        // end


        // * clipboard
        typedef int(__thiscall* get_clipboard_text_count)(void*);
        typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
        typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
        // * end

        int GetCursorPos(LPPOINT);
        short GetAsyncKeyState(int);

        HWND GetActiveWindow(void);
        HWND GetForegroundWindow();
        HWND FindWindowA(const char* lpClassName, const char* lpWindowName);

        BOOL IsChild(HWND hWndParent, HWND hWnd);
        BOOL ScreenToClient(HWND hWnd, LPPOINT lpPoint);

        void* VirtualAlloc(void* lpAddress, HANDLE dwSize, HANDLE flAllocationType, HANDLE flProtect);
        BOOL VirtualProtect(void* lpAddress, HANDLE dwSize, HANDLE flNewProtect, HANDLE* lpflOldProtect);
        BOOL VirtualFree(void* lpAddress, HANDLE dwSize, HANDLE, HANDLE dwFreeType);
        BOOL DeleteFileA(const char* lpPathName);

        void* CreateFileA(const char* lpFileName, HANDLE dwDesiredAccess, HANDLE dwShareMode, HANDLE lpSecurityAttributes, HANDLE dwCreationDisposition, HANDLE dwFlagsAndAttributes, void* hTemplateFile);
        void* __stdcall URLDownloadToFileA(void* LPUNKNOWN, const char* LPCSTR, const char* LPCSTR2, int a, int LPBINDSTATUSCALLBACK);
        int AddFontResourceA(const char* path);

        bool PathFileExistsA(const char* pszPath);
        bool DeleteUrlCacheEntryA(const char* lpszUrlName);
        bool CreateDirectoryA(const char* lpPathName, void* lpSecurityAttributes);
    ]],
    FFIload = function(self)
        self.load = {}

        self.load.win_inet = ffi.load('WinInet')
        self.load.url_mon  = ffi.load('UrlMon')
        self.load.gdi32    = ffi.load('Gdi32')
        self.load.shlw_api = ffi.load('SHLWApi')
    end,
    VMT = function(self)
        self.VMT = {}

        self.VMT.entry = function(instance, index, type)
            return ffi.cast(type, (ffi.cast('void***', instance)[0])[index])
        end
        self.VMT.thunk = function(index, typestring) -- instance will be passed to the function at runtime
            local t = ffi.typeof(typestring)
            return function(instance, ...)
                assert(instance ~= nil)
                if instance then
                    return self.VMT.entry(instance, index, t)(instance, ...)
                end
            end
        end
        self.VMT.bind = function(module, interface, index, typestring) -- instance is bound to the callback as an upvalue
            local instance = utils.create_interface(module, interface) or error('invalid interface')
            local typeof = ffi.typeof(typestring) or error('unknown typeof')
            local fnptr = self.VMT.entry(instance, index, typeof) or error('invalid vtable')
            return function(...)
                return fnptr(ffi.cast('void***', instance), ...)
            end
        end
        self.VMT.copy = function(void, source, length)
            return ffi.copy(ffi.cast("void*", void), ffi.cast("const void*", source), length)
        end
    end,
    Virtual = function(self)
        self.Virtual = {}

        local buff = {
            free = {}
        }

        self.Virtual.Alloc = function(lpAddress, dwSize, flAllocationType, flProtect, blFree)
            local alloc = ffi.C.VirtualAlloc(lpAddress, dwSize, flAllocationType, flProtect)
            blFree = blFree or false
            if blFree then
                table.insert(buff.free, alloc)
            end
            return ffi.cast('intptr_t', alloc)
        end
        self.Virtual.Protect = function(lpAddress, dwSize, flNewProtect, lpflOldProtect)
            return ffi.C.VirtualProtect(ffi.cast('void*', lpAddress), dwSize, flNewProtect, lpflOldProtect)
        end
    end,
    VMThook = function(self)
        self.VMThook = {}
        self.VMThook.list = {}

        self.VMThook.new = function(address)
            local cache = {
                data = {},
                org_func = {},
                old_protection = ffi.new('unsigned long[1]'),
                virtual_table = ffi.cast('intptr_t**', address)[0]
            }

            cache.data.hook = function(cast, __function, method)
                cache.org_func[method] = cache.virtual_table[method]
                self.Virtual.Protect(cache.virtual_table + method, 4, 0x4, cache.old_protection)

                cache.virtual_table[method] = ffi.cast('intptr_t', ffi.cast(cast, __function))
                self.Virtual.Protect(cache.virtual_table + method, 4, cache.old_protection[0], cache.old_protection)

                return ffi.cast(cast, cache.org_func[method])
            end
            cache.data.unhook = function(method)
                self.Virtual.Protect(cache.virtual_table + method, 4, 0x4, cache.old_protection)

                local alloc_addr = self.Virtual.Alloc(nil, 5, 0x1000, 0x40)
                local trampoline_bytes = ffi.new('uint8_t[?]', 5, 0x90)

                trampoline_bytes[0] = 0xE9
                ffi.cast('int32_t*', trampoline_bytes + 1)[0] = cache.org_func[method] - tonumber(alloc_addr) - 5

                self.VMT.copy(alloc_addr, trampoline_bytes, 5)
                cache.virtual_table[method] = ffi.cast('intptr_t', alloc_addr)

                self.Virtual.Protect(cache.virtual_table + method, 4, cache.old_protection[0], cache.old_protection)
                cache.org_func[method] = nil
            end
            cache.data.unhook_all = function()
                for method, _ in pairs(cache.org_func) do
                    cache.data.unhook(method)
                end
            end

            table.insert(self.VMThook.list, cache.data.unhook_all)
            return cache.data
        end

        client.add_callback('unload', function()
            for _, func in ipairs(self.VMThook.list) do
                func()
            end
        end)
    end,
    render = {
        setup = function(self)
            local VMT = {
                bind = function(vmt_table, func, index)
                    local result = ffi.cast(ffi.typeof(func), vmt_table[0][index])
                    return function(...)
                        return result(vmt_table, ...)
                    end
                end
            }
            self.interfaces = {
                new_intptr = ffi.typeof('int[1]'),
                charbuffer = ffi.typeof('char[?]'),
                new_widebuffer = ffi.typeof('wchar_t[?]'),
                new_vert = ffi.typeof('Vertex_t[?]'),
                new_vec2 = ffi.typeof('vec2_t'),
            }
            self.zerovec = self.interfaces.new_vec2()
            self.zerovec.x, self.zerovec.y = 0, 0

            self.corner_angles = {
                {180, 270},
                {270, 360},
                {0, 90},
                {90, 180}
            }

            self.RawLocalize = utils.create_interface('localize.dll', 'Localize_001')
            self.Localize    = ffi.cast(ffi.typeof('void***'), self.RawLocalize)

            self.FindSafe =             VMT.bind(self.Localize, 'wchar_t*(__thiscall*)(void*, const char*)', 12)
            self.ConvertAnsiToUnicode = VMT.bind(self.Localize, 'int(__thiscall*)(void*, const char*, wchar_t*, int)', 15)
            self.ConvertUnicodeToAnsi = VMT.bind(self.Localize, 'int(__thiscall*)(void*, wchar_t*, char*, int)', 16)

            -- GUI Surface
            self.VGUI_Surface031 = utils.create_interface('vguimatsurface.dll', 'VGUI_Surface031')

            self.CastClipping = {}
            self.Cast_m_bClippingEnabled = ffi.cast('int*', self.VGUI_Surface031 + 0x280)
            self.clipCache = {
                x =  self.interfaces.new_intptr(),
                y =  self.interfaces.new_intptr(),
                x1 = self.interfaces.new_intptr(),
                y1 = self.interfaces.new_intptr(),
            }

            self.g_VGuiSurface = ffi.cast(ffi.typeof('void***'), self.VGUI_Surface031)

            self.native_Surface = {}
            self.native_Surface.DrawSetColor =         VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*, color_struct_t)', 14)
            self.native_Surface.DrawTexturedRect =     VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*, int, int, int, int)', 41)
            self.native_Surface.DrawSetTextureRGBA =   VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*, int, const unsigned char*, int, int)', 37)
            self.native_Surface.DrawSetTexture =       VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*, int)', 38)
            self.native_Surface.DrawFilledRectFade =   VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*, int, int, int, int, unsigned int, unsigned int, bool)', 123)
            self.native_Surface.DrawFilledRect =       VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*, int, int, int, int)', 16)
            self.native_Surface.DrawOutlinedRect =     VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*, int, int, int, int)', 18)
            self.native_Surface.CreateNewTextureID =   VMT.bind(self.g_VGuiSurface, 'int(__thiscall*)(void*, bool)', 43)
            self.native_Surface.IsTextureIDValid =     VMT.bind(self.g_VGuiSurface, 'bool(__thiscall*)(void*, int)', 42)
            self.native_Surface.FontCreate =           VMT.bind(self.g_VGuiSurface, 'unsigned long(__thiscall*)(void*)', 71)
            self.native_Surface.SetFontGlyphSet =      VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*, unsigned long, const char*, int, int, int, int, unsigned long, int, int)', 72)
            self.native_Surface.GetTextSize =          VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*, unsigned long, const wchar_t*, int&, int&)', 79)
            self.native_Surface.DrawSetTextColor =     VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*, int, int, int, int)', 25)
            self.native_Surface.DrawSetTextFont =      VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*, unsigned long)', 23)
            self.native_Surface.DrawSetTextPos =       VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*, int, int)', 26)
            self.native_Surface.DrawPrintText =        VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*, const wchar_t*, int, int)', 28)
            self.native_Surface.DrawLine =             VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*, int, int, int, int)', 19)
            self.native_Surface.DrawTexturedPolygon =  VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*, int, Vertex_t*, bool)', 106)
            self.native_Surface.DrawTexturedPolyLine = VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*, const Vertex_t*, int)', 104)
            self.native_Surface.LimitDrawingArea =     VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*, int, int, int, int)', 147)
            self.native_Surface.GetDrawingArea =       VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*, int&, int&, int&, int&)', 146)
            self.native_Surface.UnLockCursor =         VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*)', 66)
            self.native_Surface.LockCursor =           VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*)', 67)

            -- surface_mt.fn_unlock_cursor             = surface_mt.isurface:get_function(66, 'void')
            -- surface_mt.fn_lock_cursor               = surface_mt.isurface:get_function(67, 'void')

            self.EFontFlags = ffi.typeof([[
                enum {
                    NONE,
                    ITALIC		 = 0x001,
                    UNDERLINE	 = 0x002,
                    STRIKEOUT	 = 0x004,
                    SYMBOL		 = 0x008,
                    ANTIALIAS	 = 0x010,
                    GAUSSIANBLUR = 0x020,
                    ROTARY		 = 0x040,
                    DROPSHADOW	 = 0x080,
                    ADDITIVE	 = 0x100,
                    OUTLINE		 = 0x200,
                    CUSTOM		 = 0x400,
                }
            ]])

            self.PrintText = function(text, localized)
                local size = 1024.0
                if localized then
                    local char_buffer = self.interfaces.charbuffer(size)
                    self.ConvertUnicodeToAnsi(text, char_buffer, size)

                    return self.native_Surface.DrawPrintText(text, #ffi.string(char_buffer), 0)
                else
                    local wide_buffer = self.interfaces.new_widebuffer(size)

                    self.ConvertAnsiToUnicode(text, wide_buffer, size)
                    return self.native_Surface.DrawPrintText(wide_buffer, #text, 0)
                end
            end

            self.font_cache = {}
        end
    },
    operate = function(self)
        self.operate = {}

        self.operate.find_window = function(window)
            return ffi.C.FindWindowA(window, nil)
        end
        self.operate.add_font_resource = function(font)
            return self.load.gdi32.AddFontResourceA(string.format('%s/Legendware/Orion Club/menu/resources/%s.ttf', os.getenv('APPDATA'), font))
        end
    end,
    setup = function(self)
        self:FFIload()
        self:VMT()
        self:Virtual()
        self:VMThook()
        self.render:setup()
        self:operate()

        -- * clipboard
        self.VGUI_System_dll =  utils.create_interface('vgui2.dll', 'VGUI_System010')
        self.VGUI_System = ffi.cast(ffi.typeof('void***'), self.VGUI_System_dll)
        self.get_clipboard_text_count = ffi.cast('get_clipboard_text_count', self.VGUI_System[0][7])
        self.get_clipboard_text = ffi.cast('get_clipboard_text', self.VGUI_System[0][11])
        self.set_clipboard_text = ffi.cast('set_clipboard_text', self.VGUI_System[0][9])

        -- * event data
        self.get_event_data = self.VMT.bind('inputsystem.dll', 'InputSystemVersion001', 21, 'const struct {int m_nType, m_nTick, m_nData, m_nData2, m_nData3;}*(__thiscall*)(void*)')

        -- * VGUI Panel
        self.VGUI_Panel009_dll = utils.create_interface('vgui2.dll', 'VGUI_Panel009')
        self.VGUI_Panel009 = ffi.cast(ffi.typeof('void***'), self.VGUI_Panel009_dll)
        self.get_panel_name = ffi.cast('const char*(__thiscall*)(void*, unsigned int vguipanel)', self.VGUI_Panel009[0][36])
        self.operate.get_VGUI_panel_name = function(vpanel)
            return ffi.string(self.get_panel_name(self.VGUI_Panel009, vpanel))
        end

        -- * Color stuff
        self.ConsoleColor = ffi.new('struct c_color')
        self.Engine_CVar = ffi.cast('void***', utils.create_interface('vstdlib.dll', 'VEngineCvar007'))
        self.ConsolePrint = ffi.cast('void(__cdecl*)(void*, const struct c_color&, const char*, ...)', self.Engine_CVar[0][25])

        -- * INetChannel
        self.EngineClient = ffi.cast(ffi.typeof('void***'), utils.create_interface('engine.dll', 'VEngineClient014'))
        self.GetINetChannelInfo = ffi.cast('INetChannel_t*(__thiscall*)(void*)', self.EngineClient[0][78])
        self.INetChannelInfo = function()
            if engine.is_connected() and engine.is_in_game() and entitylist.get_local_player() ~= nil then
                if entitylist.get_local_player():get_team() ~= 0 then
                    local INetChannelInfo = self.GetINetChannelInfo(self.EngineClient)
                    if INetChannelInfo ~= nil then
                        return INetChannelInfo
                    else
                        return nil
                    end
                else
                    return nil
                end
            else
                return nil
            end
        end


        -- * entity list
        self.client_entitylist = ffi.cast('void***', utils.create_interface('client.dll', 'VClientEntityList003'))
        self.get_client_entity = ffi.cast('GetClientEntity_4242425_t', self.client_entitylist[0][3])
        self.get_client_entity_handle = ffi.cast('GetClientEntity_4242425_t', self.client_entitylist[0][4])

        self.get_entity_address = function(ent_index)
            return ffi.cast('GetClientEntity_4242425_t', self.client_entitylist[0][3])(self.client_entitylist, ent_index)
        end
    end
}; FFI:setup()

local cached_func = {
    render_create_image = function(img_data)
        return render.create_image(img_data)
    end,
    render_draw_image = function(x, y, w, h, img_data)
        return render.draw_image(x, y, w, h, img_data)
    end,
    file_append = function(path, data)
        return file.append(path, data)
    end,
    file_write = function(path, data)
        return file.write(path, data)
    end,
    file_read = function(path)
        return file.read(path)
    end
}
local file = {}
local base64 = {}
local color = {}
local vector2 = {}
local render = {}
local override = {}
local ui = {}
local clipboard = {}
local animation = {}
local config = {}
local orion = {}
local font = {}
local popup = {} -- popup:setup(0.03) --# (text_t, duration, start_time, clr_box, clr_text)

local assistant = {
    render = function()
        render.set_clip = function(x, y, w, h)
            FFI.render.Cast_m_bClippingEnabled[0] = true
            FFI.render.native_Surface.GetDrawingArea(FFI.render.clipCache.x, FFI.render.clipCache.y, FFI.render.clipCache.x1, FFI.render.clipCache.y1)
            FFI.render.native_Surface.LimitDrawingArea(x, y, x + w, y + h)
        end
        render.end_clip = function()
            FFI.render.native_Surface.LimitDrawingArea(FFI.render.clipCache.x[0], FFI.render.clipCache.y[0], FFI.render.clipCache.x1[0], FFI.render.clipCache.y1[0])
            FFI.render.Cast_m_bClippingEnabled[0] = false
        end
        render.draw_line = function(x0, y0, x1, y1, clr)
            FFI.render.native_Surface.DrawSetColor(clr)
            return FFI.render.native_Surface.DrawLine(x0, y0, x1, y1)
        end
        render.draw_round_rect = function(x, y, w, h, clr, rounding, filled)
            local vertices = {}

            local w, h = w - 1, h - 1

            local pos = {
                [1] = vector2.new(x + rounding, y + rounding),
                [2] = vector2.new(x + w - rounding, y + rounding),
                [3] = vector2.new(x + w - rounding, y + h - rounding),
                [4] = vector2.new(x + rounding, y + h - rounding),
            }
            local ind = 0
            for _, angles in pairs(FFI.render.corner_angles) do
                ind = ind + 1
                local step = angles[2] >= angles[1] and 15 or -15

                for i = angles[1], angles[2], step do
                    local i_rad = math.rad(i)
                    local point = vector2.new(
                        pos[ind].x + math.cos(i_rad) * rounding,
                        pos[ind].y + math.sin(i_rad) * rounding
                    )
                    vertices[#vertices+1] = point
                end
            end

            if filled then
                return render.draw_polygon(vertices, clr, true)
            end
            render.draw_polyline(vertices, clr)
        end
        render.draw_rect = function(x, y, w, h, clr, rounding)
            local rounding = rounding or 0
            rounding = math.clamp(0, math.min(h, w) / 2, rounding)
            if rounding ~= 0 then
                return render.draw_round_rect(x, y, w, h, clr, rounding, false)
            end
            FFI.render.native_Surface.DrawSetColor(clr)
            return FFI.render.native_Surface.DrawOutlinedRect(x, y, x + w, y + h)
        end
        render.draw_rect_filled = function(x, y, w, h, clr, rounding)
            local rounding = rounding or 0
            rounding = math.clamp(0, math.min(h, w) / 2, rounding)
            if rounding ~= 0 then
                return render.draw_round_rect(x, y, w + 1, h + 1, clr, rounding, true)
            end
            FFI.render.native_Surface.DrawSetColor(clr)
            return FFI.render.native_Surface.DrawFilledRect(x, y, x + w, y + h)
        end
        render.draw_gradient_rect_filled = function(x, y, w, h, clr, clr2, horizontal)
            FFI.render.native_Surface.DrawSetColor(clr)
            FFI.render.native_Surface.DrawFilledRectFade(x, y, x + w, y + h, 255, 0, horizontal)
            FFI.render.native_Surface.DrawSetColor(clr2)
            return FFI.render.native_Surface.DrawFilledRectFade(x, y, x + w, y + h, 0, 255, horizontal)
        end
        render.draw_polygon = function(vertices, clr, clipvertices)
            local numvert = #vertices
            local buf = FFI.render.interfaces.new_vert(numvert)
            local i = 0
            for _, vec in pairs(vertices) do
                buf[i].m_Position = vec
                buf[i].m_TexCoord = FFI.render.zerovec
                i = i + 1
            end
            FFI.render.native_Surface.DrawSetColor(clr)
            FFI.render.native_Surface.DrawSetTexture(-1)
            FFI.render.native_Surface.DrawTexturedPolygon(numvert, buf, clipvertices or false)
        end
        render.draw_polyline = function(vertices, clr)
            local numvert = #vertices
            local buf = FFI.render.interfaces.new_vert(numvert)
            local i = 0
            for _, vec in pairs(vertices) do
                buf[i].m_Position = vec
                buf[i].m_TexCoord = FFI.render.zerovec
                i = i + 1
            end
            FFI.render.native_Surface.DrawSetColor(clr)
            FFI.render.native_Surface.DrawSetTexture(-1)
            FFI.render.native_Surface.DrawTexturedPolyLine(buf, numvert)
        end
        render.draw_circle = function(x, y, radius, clr, filled, start_angle, end_angle)
            local start_angle = start_angle or 0
            local end_angle = end_angle or 360
            local vertices = {}

            local step = 15
            step = end_angle >= start_angle and step or -step

            for i = start_angle, end_angle, step do
                local i_rad = math.rad(i)
                local point = vector2.new(
                    x + math.cos(i_rad) * radius,
                    y + math.sin(i_rad) * radius
                )
                vertices[#vertices+1] = point
            end

            for i = #vertices, 1, -1 do
                vertices[#vertices+1] = vertices[i]
            end
            if filled then
                return render.draw_polygon(vertices, clr, true)
            end
            render.draw_polyline(vertices, clr)
        end
        render.init_rgba = function(data, w, h)
            local returntbl = {}
            local tid = FFI.render.native_Surface.CreateNewTextureID(true)
            if not tid or not FFI.render.native_Surface.IsTextureIDValid(tid) or not data then return end
            FFI.render.native_Surface.DrawSetTextureRGBA(tid, data, w, h)
            returntbl.tid = tid
            returntbl.data = data
            return returntbl
        end
        render.rgba = function(datatbl, x, y, w, h, alpha)
            local tid = datatbl.tid
            FFI.render.native_Surface.DrawSetColor(color.new(255,255,255,alpha))
            FFI.render.native_Surface.DrawSetTexture(tid)
            -- FFI.render.native_Surface.DrawSetTextureRGBA(g_VGuiSurface, tid, data, w, h)
            return FFI.render.native_Surface.DrawTexturedRect(x, y, x + w, y + h)
        end
        render.create_font = function(name, size, flags, blur, weight)
            local flags_t = {}
            for _, Flag in pairs(flags or {'NONE'}) do
                table.insert(flags_t, FFI.render.EFontFlags(Flag))
            end

            local flags_i = 0
            local t = type(flags_t)
            if t == 'number' then
                flags_i = flags_t
            elseif t == 'table' then
                for i = 1, #flags_t do
                    flags_i = flags_i + flags_t[i]
                end
            else
                flags_i = 0x0
            end

            local cache_key = string.format('%s\0%d\0%d\0%d', name, size, weight or 0, flags_i)
            if FFI.render.font_cache[cache_key] == nil then
                FFI.render.font_cache[cache_key] = FFI.render.native_Surface.FontCreate()
                FFI.render.native_Surface.SetFontGlyphSet(FFI.render.font_cache[cache_key], name, size, weight or 0, blur or 0, 0, flags_i, 0, 0)
            end

            return FFI.render.font_cache[cache_key]
        end
        render.get_text_size = function(font, text)
            local wide_buffer = FFI.render.interfaces.new_widebuffer(1024)
            local w_ptr = FFI.render.interfaces.new_intptr()
            local h_ptr = FFI.render.interfaces.new_intptr()

            FFI.render.ConvertAnsiToUnicode(text, wide_buffer, 1024)
            FFI.render.native_Surface.GetTextSize(font, wide_buffer, w_ptr, h_ptr)

            return vector2.new(tonumber(w_ptr[0]), tonumber(h_ptr[0]))
        end
        render.get_multi_text_size = function(font, text_t)
            -- local size = 0; for _, v in pairs(text_t) do
            --     print(v, v[1])
            --     size = size + render.get_text_size(font, v[1])
            -- end; return size

            local t = {}; for _, v in pairs(text_t) do
                table.insert(t, v[1])
            end; return render.get_text_size(font, table.concat(t))
        end
        render.draw_text = function(font, x, y, clr, text, center)
            local x, y = x, y
            if center then
                local text_size = render.get_text_size(font, text)
                if center[1] then
                    x = x - text_size.x / 2
                end
                if center[2] then
                    y = y - text_size.y / 2
                end
            end
            FFI.render.native_Surface.DrawSetTextPos(x, y)
            FFI.render.native_Surface.DrawSetTextFont(font)
            FFI.render.native_Surface.DrawSetTextColor(clr.r, clr.g, clr.b, clr.a)
            return FFI.render.PrintText(text, false)
        end
        render.draw_gradient_text = function(font, x, y, text, clr_left, clr_right, center)
            local _text = string.split(text); local _w = 0; local _space = 0 for i, c in pairs(_text) do
                if c == ' ' then
                    _space = _space + 1
                    goto proceed
                end
                render.draw_text(font,
                    x + _w - (center[1] and render.get_text_size(font, text).x / 2 or 0),
                    y - (center[2] and render.get_text_size(font, text).y / 2 or 0), color.new(
                    math.flerp(clr_left.r, clr_right.r, (i - 1 - _space) / ((#_text - _space) - 1)),
                    math.flerp(clr_left.g, clr_right.g, (i - 1 - _space) / ((#_text - _space) - 1)),
                    math.flerp(clr_left.b, clr_right.b, (i - 1 - _space) / ((#_text - _space) - 1)),
                    math.flerp(clr_left.a, clr_right.a, (i - 1 - _space) / ((#_text - _space) - 1))
                ), c)
                ::proceed::
                _w = _w + render.get_text_size(font, c).x
            end
        end
        render.draw_multi_text = function(font, x, y, text_t, alpha, center)
            center = center or {}; local centered = render.get_multi_text_size(font, text_t)

            for _, v in pairs(text_t) do
                local size = render.get_text_size(font, v[1])
                render.draw_text(font, x + (center[1] and -centered.x /2 or 0), y + (center[2] and centered.y /2 or 0), color.mod_a(v[2] or color.new(255, 255, 255), alpha or 255), v[1])

                x = x + size.x
            end
        end
        render.draw_arc = function(x, y, radius, radius_inner, start_angle, end_angle, segments, clr)
            while 360 % segments ~= 0 do
                segments = segments + 1
            end
            segments = 360 / segments
            do
                local i = start_angle
                while i < start_angle + end_angle do
                    local rad = i * math.pi / 180
                    local rad2 = (i + segments) * math.pi / 180
                    local rad_cos = math.cos(rad)
                    local rad_sin =  math.sin(rad)
                    local rad2_cos = math.cos(rad2)
                    local rad2_sin = math.sin(rad2)
                    local x1_outer = x + rad_cos * radius
                    local y1_outer = y + rad_sin * radius
                    local x2_outer = x + rad2_cos * radius
                    local y2_outer = y + rad2_sin * radius
                    local x1_inner = x + rad_cos * radius_inner
                    local y1_inner = y + rad_sin * radius_inner
                    local x2_inner = x + rad2_cos * radius_inner
                    local y2_inner = y + rad2_sin * radius_inner

                    local vertices = {
                        [1] = {
                            [1] = vector2.new(x1_outer, y1_outer),
                            [2] = vector2.new(x2_outer, y2_outer),
                            [3] = vector2.new(x1_inner, y1_inner),
                        },
                        [2] = {
                            [1] = vector2.new(x1_inner, y1_inner),
                            [2] = vector2.new(x2_outer, y2_outer),
                            [3] = vector2.new(x2_inner, y2_inner),
                        }
                    }
                    render.draw_polygon(vertices[1], clr, true)
                    render.draw_polygon(vertices[2], clr, true)
                    i = i + segments
                end
            end
        end
        render.setup_image_data = function(img_data)
            return cached_func.render_create_image(file.read(img_data))
        end
        render.image = function(x, y, w, h, img_data, centered)
            if centered then
                cached_func.render_draw_image(x - w / 2, y - h / 2, w + w / 2, h + h / 2, img_data)
            else
                cached_func.render_draw_image(x, y, x + w, y + h, img_data)
            end
        end
    end,
    global = function(self)
        -- * 1st call functions
        math.randomseed(globals.get_curtime()) -- for math.random
        menu.set_bool('scripts.allow_file', true) -- allow restrictions
        menu.set_bool('scripts.allow_http', true) -- allow restrictions
        menu.get_key_bind_state('anti_aim.invert_desync_key') -- to fix keybind bug

        -- * clipboard
        clipboard.get = function()
            local clipboard_text_length = FFI.get_clipboard_text_count(FFI.VGUI_System)
            if clipboard_text_length > 0 then
                local buffer = ffi.new('char[?]', clipboard_text_length)
                local size = clipboard_text_length * ffi.sizeof('char[?]', clipboard_text_length)
                FFI.get_clipboard_text(FFI.VGUI_System, 0, buffer, size)
                return tostring(ffi.string(buffer, clipboard_text_length - 1))
            else
                return ''
            end
        end
        clipboard.set = function(text)
            return FFI.set_clipboard_text(FFI.VGUI_System, text, text:len())
        end

        -- * table
        table.contains = function(table, element)
            for _, value in pairs(table) do
                if value == element then
                return true
                end
            end
            return false
        end
        table.val_to_str = function(v)
            if "string" == type(v) then
                v = string.gsub(v, "\n", "\\n")
                if string.match(string.gsub(v, "[^'\"]", ""), '^"+$') then
                    return "'" .. v .. "'"
                end
                return '"' .. string.gsub(v, '"', '\\"') .. '"'
            else
                return "table" == type(v) and table.to_string(v) or tostring(v)
            end
        end
        table.key_to_str = function(k)
            if "string" == type(k) and string.match(k, "^[_%a][_%a%d]*$") then
                return k
            else
                return "[" .. table.val_to_str(k) .. "]"
            end
        end
        table.to_string = function(t)
            local result, done = {}, {}
            for k, v in ipairs(t) do
                table.insert(result, table.val_to_str(v))
                done[k] = true
            end
            for k, v in pairs(t) do
                if not done[k] then
                table.insert( result,
                table.key_to_str(k) .. " = " .. table.val_to_str(v))
                end
            end
            return "{" .. table.concat(result, ", ") .. "}"
        end
        table.extend = function(t)
            return string.format('%s: {\n %s\n}', tostring(t), table.to_string(t):remove(1):remove())
        end

        -- * string
        string.to_table = function(str)
            -- print(str)
            return loadstring('return ' .. str:gsub('(".-"):(.-),','[%1]=%2,\n'))()
        end
        string.insert = function(s, value, pos)
            pos = pos or s:len()
            return s:sub(1, pos) .. value .. s:sub(pos + 1)
        end
        string.remove = function(s, pos)
            pos = pos or s:len()
            local t = {}
            for i = 1, s:len() do
              t[i] = s:sub(i, i)
            end
            table.remove(t, pos)
            return table.concat(t)
        end
        string.split = function(text)
            local t = {}
            for i = 1, text:len() do
                table.insert(t, text:sub(i, i))
            end
            return t
        end
        string.find_in_table = function(table, text)
            for _, v in pairs(table) do
                if string.find(v, text) then
                    return true
                end
            end
            return false
        end

        -- * color
        color.new = function(r, g, b, a)
            return ffi.new('color_struct_t', {r or 255, g or 255, b or 255, a or 255})
        end
        color.mod_a = function(clr, alpha)
            return color.new(clr.r, clr.g, clr.b, alpha)
        end
        color.white = function(alpha)
            return color.new(255, 255, 255, alpha)
        end
        color.black = function(alpha)
            return color.new(0, 0, 0, alpha)
        end
        color._nil = function()
            return color.new(0, 0, 0, 0)
        end
        color.rgb2hsv = function(clr)
            local r, g, b = clr.r / 255, clr.g / 255, clr.b / 255
            local mx = math.max(r, g, b)
            local mn = math.min(r, g, b)

            local h, s, d
            if mx == mn then
                h = 0
                d = 0
            else
                d = mx - mn
                if     mx == r then h = (g - b) / d + (g < b and 6 or 0)
                elseif mx == g then h = (b - r) / d + 2
                elseif mx == b then h = (r - g) / d + 4 end
                h = h / 6
            end

            s = (mx == 0) and 0 or (d / mx)
            return {h = h, s = s, v = mx, a = clr.a}
        end
        color.hsv2rgb = function(hsv)
            local r, g, b
            local i = math.floor(hsv.h * 6)
            local f = hsv.h * 6 - i
            local p = hsv.v * (1 - hsv.s)
            local q = hsv.v * (1 - f * hsv.s)
            local t = hsv.v * (1 - (1 - f) * hsv.s)
            i = i % 6
            if i == 0 then
                r, g, b = hsv.v, t, p
            elseif i == 1 then
                r, g, b = q, hsv.v, p
            elseif i == 2 then
                r, g, b = p, hsv.v, t
            elseif i == 3 then
                r, g, b = p, q, hsv.v
            elseif i == 4 then
                r, g, b = t, p, hsv.v
            elseif i == 5 then
                r, g, b = hsv.v, p, q
            end
            return color.new(math.floor(r * 255), math.floor(g * 255), math.floor(b * 255), hsv.a)
        end

        -- * menu
        menu.get_color = function(clr)
            local clr = menu.get_color(clr)
            return color.new(clr:r(), clr:g(), clr:b(), clr:a())
        end
        menu.is_in_bound = function(pos_t)
            local cur = engine.get_cursor_pos()
            return pos_t.x <= cur.x and cur.x <= pos_t.x + pos_t.w and pos_t.y <= cur.y and cur.y <= pos_t.y + pos_t.h
        end
        menu.is_in_bound_and_interaction = function(pos_t, interaction)
            return menu.is_in_bound(pos_t) and interaction
        end

        -- * vector
        vector2.new = function(x, y)
            return FFI.render.interfaces.new_vec2({x, y})
        end

        -- * math
        math.clamp = function(num, min, max)
            return math.min(math.max(num, min), max)
        end
        math.round = function(value, decimals)
            local multiplier = 10 ^ (decimals or 0)
            return math.floor(value * multiplier + 0.5) / multiplier
        end
        math.lerp = function(start, _end, time, do_extraanim)
            if (not do_extraanim and math.floor(start) == _end) then
                return
                _end
            end
            time = globals.get_frametime() * (time * 175)
            if time < 0 then
                time = 0.01
            elseif time > 1 then
                time = 1
            end
            return (_end - start) * time + start
        end
        math.lerp_color = function(start, _end, time)
            local new = {start.r, start.g, start.b, start.a}
            for i, v in pairs({_end.r, _end.g, _end.b, _end.a}) do
                new[i] = math.lerp(new[i], v, time, false)
            end
            return color.new(math.round(new[1]), math.round(new[2]), math.round(new[3]), math.round(new[4]))
        end
        math.flerp = function(a, b, t)
            return a + t * (b - a)
        end
        math.flerp_inverse = function(a, b, v)
            return (v - a) / (b - a)
        end
        math.flerp_vector = function(vec1, vec2, t)
            return vector.new(math.flerp(vec1.x, vec2.x, t), math.flerp(vec1.y, vec2.y, t), math.flerp(vec1.z, vec2.z, t))
        end
        math.flerp_inverse_vector = function(vec1, vec2, t)
            return vector.new(math.flerp_inverse(vec1.x, vec2.x, t), math.flerp_inverse(vec1.y, vec2.y, t), math.flerp_inverse(vec1.z, vec2.z, t))
        end
        math.flerp_color = function(clr1, clr2, t)
            return color.new(
                math.round(math.flerp(clr1.r, clr2.r, t)),
                math.round(math.flerp(clr1.g, clr2.g, t)),
                math.round(math.flerp(clr1.b, clr2.b, t)),
                math.round(math.flerp(clr1.a, clr2.a, t))
            )
        end
        math.flerp_inverse_color = function(clr1, clr2, t)
            return {
                r = math.flerp_inverse(clr1.r, clr2.r, t),
                g = math.flerp_inverse(clr1.g, clr2.g, t),
                b = math.flerp_inverse(clr1.b, clr2.b, t),
                a = math.flerp_inverse(clr1.a, clr2.a, t),
            }
        end
        math.truncat = function(number, decimals)
            if decimals == nil or decimals == 0 then
                return number - number % 1
            end
            local to_decimals = {'0.'}
            for _ = 2, decimals do
                table.insert(to_decimals, '0')
            end
            table.insert(to_decimals, '1')
            return number - number % tonumber(table.concat(to_decimals))
        end
        math.to_ticks = function(x)
            return math.round(x / globals.get_intervalpertick());
        end
        math.get_closest_player = function(exceptions)
            -- * check if connected to server and in game
            if not engine.is_connected() or not engine.is_in_game() then return end

            -- * exceptions sector create
            if exceptions == nil then exceptions = {} end
            exceptions.Distance = exceptions.Distance or 999999

            -- * check if local player is alive
            local LocalPlayer = entitylist.get_local_player()
            if not LocalPlayer or LocalPlayer:get_health() <= 0 then return end

            -- * cache
            local ClosestPlayer
            local ClosestDistance = exceptions.Distance

            -- * parsing all players
            for Index = 0, globals.get_maxclients() do
                local Entity = entitylist.get_player_by_index(Index)
                if not Entity or not Entity:is_player() then goto skip end

                -- * getting player pointer and check if player is valid
                local _player = entitylist.entity_to_player(Entity)
                if not _player or (_player:get_health() <= 0 and not exceptions.Allow_dead) or (_player:get_dormant() and not exceptions.Allow_dormant) then goto skip end
                if _player == LocalPlayer then goto skip end

                -- * teammate check
                if exceptions.Teammate ~= nil then
                    if not exceptions.Teammate and _player:get_team() == LocalPlayer:get_team() then goto skip end
                end

                -- * enemy check
                if exceptions.Enemy ~= nil then
                    if not exceptions.Enemy and _player:get_team() ~= LocalPlayer:get_team() then goto skip end
                end

                -- * weapon check
                if exceptions.Weapon ~= nil then
                    local Weapon = entitylist.get_weapon_by_player(_player)
                    if not Weapon then return end
                    Weapon = Weapon:get_class_name():lower()

                    if not (Weapon):find (exceptions.Weapon:lower()) then goto skip end
                end

                -- * distance check
                local PlayerOrigin = LocalPlayer:get_origin()
                local _player_origin = _player:get_origin()

                local Distance = PlayerOrigin:dist_to(_player_origin)
                if Distance <= ClosestDistance then
                    ClosestPlayer = _player
                    ClosestDistance = Distance
                end
            ::skip::
            end
            return ClosestPlayer
        end
        math.yaw_to_player = function(player, forward)
            local LocalPlayer = entitylist.get_local_player()
            if not LocalPlayer or not player then return end

            local lOrigin = LocalPlayer:get_origin()
            local ViewAngles = engine.get_view_angles()
            local pOrigin = player:get_origin()

            local Yaw = (-math.atan2(pOrigin.x - lOrigin.x, pOrigin.y - lOrigin.y) / 3.14 * 180 + 180) - ViewAngles.y + (forward and 90 or -90)
            if Yaw >= 180 then
                Yaw = 360 - Yaw
                Yaw = -Yaw
            end
            return Yaw
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
        math.angle_to_forward = function(vec)
            local rad_x = math.rad(vec.x);
            local rad_y = math.rad(vec.y);

            local sp = math.sin(rad_x);
            local sy = math.sin(rad_y);
            local cp = math.cos(rad_x);
            local cy = math.cos(rad_y);

            return vector.new(cp * cy, cp * sy, -sp)
        end
        math.vector_to_angle = function(vec)
            return math.atan(vec.x, vec.y) * (180 / math.pi)
        end

        -- * engine
        engine.get_cursor_pos = function()
            local ActiveWindow = ffi.C.GetForegroundWindow()
            if ActiveWindow == 0 then
                return vector2.new(-1, -1)
            end

            if ActiveWindow ~= self.vars.windowCSGO and not ffi.C.IsChild(ActiveWindow, self.vars.windowCSGO) then
                return vector2.new(-1, -1)
            end

            local PosPoint = ffi.new('POINT[1]')
            if ffi.C.GetCursorPos(PosPoint) == 0 then
                error('Couldn\'t get cursor position!', 2)
                return vector2.new(-1, -1)
            end

            if not ffi.C.ScreenToClient(self.vars.windowCSGO, PosPoint) then
                return vector2.new(-1, -1)
            end

            if PosPoint[0].x > engine.get_screen_width() or PosPoint[0].y > engine.get_screen_height() then
                return vector2.new(-1, -1)
            end

            return vector2.new(PosPoint[0].x, PosPoint[0].y)
        end
        engine.lock_cursor = function(lock)
            self.hk_func.unlock_cursor.lock = lock
        end
        engine.get_INet_channel = function()
            local INetChannelInfo = FFI.INetChannelInfo()
            if INetChannelInfo ~= nil then
                return FFI.INetChannelInfo()
            end
            return nil
        end
        -- engine.get_choked_packets = function()
        --     return engine.get_INet_channel().m_nChokedPackets
        -- end
        engine.get_choked_packets = function()
            return self.update_choke
        end

        -- * entitylist
        function entitylist.player_by_index(i)
            return entitylist.entity_to_player(entitylist.get_player_by_index(i))
        end
        function entitylist.player_by_user_id(event)
            return engine.get_player_for_user_id(event:get_int('userid'))
        end
        function entitylist.get_view_offset(player)
            return vector.new(
                player:get_prop_float('CBasePlayer', 'm_vecViewOffset[0]'),
                player:get_prop_float('CBasePlayer', 'm_vecViewOffset[1]'),
                player:get_prop_float('CBasePlayer', 'm_vecViewOffset[2]')
            )
        end
        function entitylist.get_eye_position(player)
            local origin = player:get_origin()
            local viewoffset = entitylist.get_view_offset(player)
            return vector.new(
                origin.x + viewoffset.x,
                origin.y + viewoffset.y,
                origin.z + viewoffset.z
            )
        end

        -- * other
        local counter = 0
        tester = function()
            print(counter)
            counter = counter + 1
        end
        extend = function(t)
            if t == nil then
                error('table is nil')
            end
            local str = {string.format('%s: {\n', tostring(t))}
            for key, value in pairs(t) do
                table.insert(str, string.format(' [%s] = %s,\n', type(key) == 'string' and string.format('\'%s\'', key) or key, tostring(value)))
            end
            table.insert(str, '}')
            return table.concat(str)
        end
        extract = function(v, from, width)
            return bit.band(bit.rshift(v, from), bit.lshift(1, width) - 1)
        end
        cprint = function(text, clr)
            clr = clr or color.new(255, 255, 255)
            FFI.ConsoleColor.clr[0] = clr.r
            FFI.ConsoleColor.clr[1] = clr.g
            FFI.ConsoleColor.clr[2] = clr.b
            FFI.ConsoleColor.clr[3] = 255
            FFI.ConsolePrint(FFI.Engine_CVar, FFI.ConsoleColor, text)
        end
    end,
    key_state = function(self)
        local keys = {}
        local virtual_keys = {
            [27] = 'esc',
            [112] = 'f1',
            [113] = 'f2',
            [114] = 'f3',
            [115] = 'f4',
            [116] = 'f5',
            [117] = 'f6',
            [118] = 'f7',
            [119] = 'f8',
            [120] = 'f9',
            [121] = 'f10',
            [122] = 'f11',
            [123] = 'f12',
            [192] = '`',
            [48] = '0',
            [49] = '1',
            [50] = '2',
            [51] = '3',
            [52] = '4',
            [53] = '5',
            [54] = '6',
            [55] = '7',
            [56] = '8',
            [57] = '9',
            [187] = '=',
            [189] = '-',
            [9] = 'tab',
            [20] = 'caps',
            [16] = 'shift',
            [17] = 'ctrl',
            [18] = 'alt',
            [91] = 'win',
            [32] = 'space',
            [93] = 'idk',
            [8] = 'backspace',
            [220] = '\\',
            [81] = 'q',
            [87] = 'w',
            [69] = 'e',
            [82] = 'r',
            [84] = 't',
            [89] = 'y',
            [85] = 'u',
            [73] = 'i',
            [79] = 'o',
            [80] = 'p',
            [65] = 'a',
            [83] = 's',
            [68] = 'd',
            [70] = 'f',
            [71] = 'g',
            [72] = 'h',
            [74] = 'j',
            [75] = 'k',
            [76] = 'l',
            [90] = 'z',
            [88] = 'x',
            [67] = 'c',
            [86] = 'v',
            [66] = 'b',
            [78] = 'n',
            [77] = 'm',
            [219] = '[',
            [221] = ']',
            [186] = ';',
            [222] = '\'',
            [188] = ',',
            [190] = '.',
            [191] = '/',
            [255] = 'prtsc',
            [45] = 'ins',
            [36] = 'home',
            [33] = 'pgup',
            [46] = 'del',
            [35] = 'end',
            [34] = 'pgdn',
            [37] = 'al',
            [40] = 'ad',
            [39] = 'ar',
            [38] = 'af'
        }
        local scroll = {
            prevtick = 0,
            scroll_state = 0
        }

        for i = 1, 255 do
            if keys[i] == nil then
                keys[i] = {
                    holded = false,
                    clicked = false,
                    toggled = false,
                    virtual = virtual_keys[i] or '',
                    override = false,
                }
            end
        end

        engine.get_key_state = function(keycode)
            return keys[keycode]
        end
        engine.get_mouse_scroll = function()
            return scroll.scroll_state
        end

        table.insert(self._function, function()
            for key_code, key_t in pairs(keys) do
                local active = ffi.C.GetAsyncKeyState(key_code) ~= 0 and engine.get_cursor_pos().x ~= -1
                key_t.holded = active

                if active then
                    if not key_t.override then
                        key_t.toggled = not key_t.toggled

                        key_t.clicked = true
                        key_t.override = true
                    else
                        key_t.clicked = false
                    end
                else
                    key_t.clicked = false
                    key_t.override = false
                end
            end

            local data = FFI.get_event_data()
            scroll.scroll_state = 0
            if data.m_nTick ~= scroll.prev_tick then
                scroll.prev_tick = data.m_nTick;
                if data.m_nData == 112 then
                    -- return 1
                    scroll.scroll_state = 1
                elseif data.m_nData == 113 then
                    -- return -1
                    scroll.scroll_state = -1
                end
            end
            -- return 0
        end)
    end,
    drag_system = function(self)
        self.drags_t = {}
        self.drags = {
            holded = false,
        }

        self.drag_object_setup = function(name, pos_t)
            if self.drags_t[name] == nil then
                self.drags_t[name] = pos_t
            end

            table.insert(self.drags, self.drags_t[name])
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
            local cursor = engine.get_cursor_pos()
            for index, drag in pairs(self.drags) do
              if type(drag) == 'table' then
                if not drag[index] then drag[index] = {} end
                if not drag[index].x then drag[index].x = 0.0 end
                if not drag[index].y then drag[index].y = 0.0 end
                if not drag[index].backup then drag[index].backup = false end

                if cursor.x >= drag.x and cursor.x <= drag.x + drag.w and cursor.y >= drag.y and cursor.y <= drag.y + drag.h then
                  if not drag[index].backup and engine.get_key_state(0x01).holded and not self.drags.holded then
                    drag[index].x = drag.x - cursor.x
                    drag[index].y = drag.y - cursor.y
                    drag[index].backup = true
                    self.drags.holded = true
                  end
                end
                if not engine.get_key_state(0x01).holded then
                  drag[index].backup = false
                  self.drags.holded = false
                end
                if drag[index].backup then
                  drag.x = math.min(math.max(cursor.x + drag[index].x, 0.0), engine.get_screen_width() - drag.w)
                  drag.y = math.min(math.max(cursor.y + drag[index].y, 0.0), engine.get_screen_height() - drag.h)
                end
                table.remove(self.drags, index)
              end
            end
        end)
    end,
    override_system = function(self)
        override = {}
        override.cache = {}
        override.system = function(name, condition, variable_t)
            if override.cache[name] == nil then
                override.cache[name] = {}
                override.cache[name].override = false
                override.cache[name].value = {}
            end
            if condition then
                if not override.cache[name].override then
                    for Path, Value in pairs(variable_t) do
                        if type(Value) == 'number' then
                            override.cache[name].value[Path] = menu.get_int(Path)
                        elseif type(Value) == 'boolean' then
                            override.cache[name].value[Path] = menu.get_bool(Path)
                        end
                    end
                    override.cache[name].override = true
                end
                for Path, Value in pairs(variable_t) do
                    if type(Value) == 'number' then
                        menu.set_int(Path, Value)
                    elseif type(Value) == 'boolean' then
                        menu.set_bool(Path, Value)
                    end
                end
            else
                if override.cache[name].override then
                    for Path, Value in pairs(variable_t) do
                        if type(Value) == 'number' then
                            menu.set_int(Path, override.cache[name].value[Path])
                        elseif type(Value) == 'boolean' then
                            menu.set_bool(Path, override.cache[name].value[Path])
                        end
                    end
                    override.cache[name].override = false
                end
            end
        end
    end,
    animation = function(self)
        animation.data = {}
        animation.new = function(name, start, value, time, do_extraanim)
            if animation.data[name] == nil then animation.data[name] = start end
            animation.data[name] = type(start) == 'number' and math.lerp(animation.data[name], value, time, do_extraanim) or math.lerp_color(animation.data[name], value, time)
            return animation.data[name]
        end
        animation.condition_new = function(name, condition, time)
            if animation.data[name] == nil then animation.data[name] = 0 end
            animation.data[name] = math.lerp(animation.data[name], condition and 1 or 0, time, true)
            return animation.data[name]
        end
        animation.on_enable = function(name, condition, time)
            if animation.data[name] == nil then animation.data[name] = 0 end
            animation.data[name] = math.lerp(animation.data[name], condition and 1 or 0, time, true)
            if animation.data[name] < 0.01 then
                return false
            end
            return animation.data[name]
        end
    end,
    handler = function(self)
        self._function = {}; client.add_callback('on_paint', function()
            for _, _function in pairs(self._function) do
                _function(self)
            end
        end)

        self.update_choke = {choke = 0, choked = false}; client.add_callback('create_move', function(cmd)
            self.update_choke.choke = engine.get_INet_channel().m_nChokedPackets
            if self.update_choke.choke == 0 then
                self.update_choke.choked = not self.update_choke.choked
            end
        end)

        -- update_choke = function()
        --     local packets = engine.get_choked_packets()
        --     self.var.choke = packets
        --     if self.var.choke == 0 then
        --         self.var.choked = not self.var.choked
        --     end
        -- end,
    end,
    popup = function(self, animation_speed)
        local screen = {
            x = engine.get_screen_width(),
            y = engine.get_screen_height()
        }
        local data = {}
        local font = render.create_font('SF UI Display Bold', 14, {'ANTIALIAS'})
        animation_speed = animation_speed or 0.05
        table.insert(self._function, function()
            local add_y = 0
            for i, log in pairs(data) do
                if globals.get_realtime() > log.time + log.start_time then
                    if globals.get_realtime() - log.time > log.duration then
                        log.anim = math.lerp(log.anim, 0, animation_speed, true)
                        if log.anim < 0.01 then
                            table.remove(data, i)
                        end
                    else
                        log.anim = math.lerp(log.anim, 1, animation_speed, true)
                    end
                    -- if log.anim == nil or log.color == nil or log.text == nil then goto next end
                    local gap = 5
                    local size = {x = gap * 2, y = gap * 2}
                    for _, value in pairs(log.text) do
                        local text_size = render.get_text_size(font, value)
                        if text_size.x > size.x then
                            size.x = gap * 2 + text_size.x
                        end
                        -- size.x = size.x + text_size.x
                        size.y = size.y + text_size.y + 1
                    end
                    render.draw_rect_filled(screen.x - 15 - size.x, screen.y - size.y - math.round(15 * log.anim) - add_y, size.x, size.y, color.new(log.clr_box.r, log.clr_box.g, log.clr_box.b, math.clamp(math.round(log.anim * 255), 0, log.clr_box.a)), 5)
                    for i, value in pairs(log.text) do
                        local text_size = render.get_text_size(font, value)
                        render.draw_text(font, screen.x - size.x - 15 + gap, screen.y - size.y - 5 - math.round(gap * log.anim) - add_y + ((i - 1) * 15), color.new(log.clr_text.r, log.clr_text.g, log.clr_text.b, math.clamp(math.round(log.anim * 255), 0, log.clr_text.a)), value)
                    end
                    -- ::next::
                    add_y = add_y + (size.y + 5) * log.anim
                end
            end
        end)

        popup.show = function(text_t, duration, start_time, clr_box, clr_text)
            return table.insert(data, {
                text = text_t,
                clr_text = clr_text or color.new(255, 255, 255),
                clr_box = clr_box or color.new(0, 0, 0, 180),
                duration = duration or 3,
                start_time = start_time or 0,
                time = globals.get_realtime(),
                anim = 0,
            })
        end
    end,
    ui = function(self)
        ui = {
            show = false,
            show_anim = 0,
            pos = {
                x = 0,
                y = 0,
                w = 500,
                h = 500
            },
            animation = {
                speed = 0.05,
                default = {
                    value = 0,
                    color = color.white()
                },
                gap = {},
                clip = 0,
                reset = true,
            },
            font = render.create_font('SF UI Display Bold', 12, {'ANTIALIAS'}),
            icon = {
                tab = render.create_font('Orion-Club-Project-Menu', 33, {'ANTIALIAS'}),
                tab_glow = render.create_font('Orion-Club-Project-Menu', 33, {'NONE'}, 3),
                tab_place = render.create_font('Orion-Club-Project-Menu', 45, {'ANTIALIAS'}),
                element = render.create_font('Orion-Club-Project-Menu', 20, {'ANTIALIAS'}),
                KPicons = render.create_font('Orion-Club-Project-Menu', 17, {'ANTIALIAS'}),
                small = render.create_font('Orion-Club-Project-Menu', 12, {'ANTIALIAS'}),
                combobox_place = render.create_font('Orion-Club-Project-Menu', 70, {'ANTIALIAS'}),
                keybind_place = render.create_font('Orion-Club-Project-Menu', 24, {'ANTIALIAS'})
            },
            color = {
                accent = color.new(150, 0, 255),
                secondary = color.new(30, 30, 45),
                division = color.new(100, 90, 150),
                name_text = color.new(255, 255, 255),
                background = color.new(10, 10, 25),
                tab_background = color.new(25, 25, 40),
                subtab_background = color.black(),
                tab_icon = color.white(),
                some_elements = color.white(),
                some_text_elements = color.white(),
                clipboard = color.white()
            },
            tab = { -- ui.checkbox = function(tab, subtab, name, value)
                {
                    tab_name = 'rage',
                    icon = '1',
                    scroll = 0,
                    active = true,
                    subtab = {}
                },
                {
                    tab_name = 'anti-aim',
                    icon = '2',
                    scroll = 0,
                    active = false,
                    subtab = {}
                },
                {
                    tab_name = 'visual',
                    icon = '3',
                    scroll = 0,
                    active = false,
                    subtab = {}
                },
                {
                    tab_name = 'misc',
                    icon = '4',
                    scroll = 0,
                    active = false,
                    subtab = {}
                },
                {
                    tab_name = 'setting',
                    icon = '5',
                    scroll = 0,
                    active = false,
                    subtab = {}
                },
                {
                    tab_name = 'script',
                    icon = '6',
                    scroll = 0,
                    active = false,
                    subtab = {}
                }
            },
            g_operate = {
                dragged = {
                    slider = false,
                    picker = false,
                }, -- slider
                opened_index = nil, -- combobox & textbox & colorpicker
                opened = {
                    element_index = nil,
                    subtab_index = nil,
                },
                op_qty = 0, -- textbox
            },
        }

        local reset_active = function(path_t)
            for i = 1, #path_t do
                path_t[i].active = false
            end
        end
        local item_insert = function(tab_name, subtab_name, value)
            local path = nil
            for _, tab_v in pairs(ui.tab) do
                if tab_v.tab_name == tab_name then
                    local allow = true
                    for _, exist in pairs(tab_v.subtab) do
                        if exist.subtab_name == subtab_name then
                            allow = false
                        end
                    end

                    if allow then
                        table.insert(tab_v.subtab, #tab_v.subtab + 1, {
                            subtab_name = subtab_name,
                            item = {}
                        })
                    end

                    for _, subtab_v in pairs(tab_v.subtab) do
                        if subtab_v.subtab_name == subtab_name then
                            table.insert(subtab_v.item, value)
                        end
                    end
                end
            end
        end

        table.insert(self._function, function() -- active menu handler
            for i = 1, #ui.tab do
                local tab_index = i
                local tab_value = ui.tab[i]
                for i = 1, #tab_value.subtab do
                    local subtab_index = i
                    local subtab_value = tab_value.subtab[i]
                    for i = 1, #subtab_value.item do
                        local item = subtab_value.item[i]
                        if item.type == 'keybind' then
                            for i = 1, 255 do
                                local key = engine.get_key_state(i)
                                if key.virtual == item.key then
                                    -- print('s')

                                    if item.bind_type == 'hold' then
                                        item.value = key.holded
                                    elseif item.bind_type == 'toggle' then
                                        if not item.on_start then
                                            if item.value then
                                                key.toggled = true
                                            end
                                            item.on_start = true
                                        end
                                        item.value = key.toggled
                                    elseif item.bind_type == 'click' then
                                        item.value = key.clicked
                                    elseif item.bind_type == 'always' then
                                        item.value = true
                                    elseif item.bind_type == 'none' then
                                        item.value = false
                                    end
                                end
                            end
                        end


                        if not ui.show then -- for unshow
                            if not ui.animation.reset then
                                ui.animation.reset = true
                            end
                            if item.allow_index ~= nil then
                                self._function[item.allow_index] = nil
                                item.allow_index = nil
                            end
                            ui.g_operate.opened.element_index = nil
                            ui.g_operate.opened.subtab_index = nil
                            if item.active ~= nil then
                                item.active = false
                            end
                        end

                        if ui.animation.reset then
                            -- ui.animation.gap = {}
                            ui.animation.clip = 0
                            -- local universal_index = string.format('%s.%s.%s', tab_index, subtab_index, i)
                            -- ui.animation.gap[universal_index] = 0

                            ui.animation.reset = false
                        end

                    end
                end
            end
        end)
        table.insert(self._function, function() -- menu handler

            -- engine.lock_cursor(ui.show)
            ui.show_anim = animation.condition_new('ui.show', ui.show, ui.animation.speed)
            if ui.show_anim < 0.01 then
                return
            end
            ui.pos = self.drag_object_setup('UI', {
                x = 0,
                y = 0,
                w = 60,
                -- h = 264,
                -- h = #ui.tab * 52
                h = 400
            })
            ui_anim = function(clr)
                return color.new(clr.r, clr.g, clr.b, math.clamp(clr.a, 0, ui.show_anim * 255))
            end


            -- render.blur('menu', ui.pos.x, ui.pos.y, 610 * ui.show_anim, ui.pos.h + ui.show_anim, 3)

            -- if ui.color.background.a == 0 then
            --     render.blur('ui.background', ui.pos.x, ui.pos.y, 610, ui.pos.h, 3)
            -- end
            render.draw_rect_filled(ui.pos.x, ui.pos.y, 610, ui.pos.h, ui_anim(ui.color.background), 10) -- round = 15
            render.draw_rect(ui.pos.x + ui.pos.w, ui.pos.y, 1, ui.pos.h, ui_anim(ui.color.division))
            -- render.draw_gradient_rect_filled(ui.pos.x + ui.pos.w - 20, ui.pos.y, 20, ui.pos.h, color._nil(), ui_anim(ui.color.division), true)
            -- render.draw_gradient_rect_filled(ui.pos.x + ui.pos.w, ui.pos.y, 20, ui.pos.h, ui_anim(ui.color.division), color._nil(), true)

            for i = 1, #ui.tab do -- tab
                local tab_value = ui.tab[i]
                local tab_index = i
                local gap = (i - 1) * (36 + 15)

                local button = {
                    x = ui.pos.x + 10,
                    y = ui.pos.y + gap + 10,
                    w = 40,
                    h = 40
                }

                render.draw_text(ui.icon.tab_place, button.x - 3, button.y - 4, ui_anim(ui.color.tab_background), 'T')
                render.draw_text(ui.icon.tab_glow, button.x + button.w / 2, button.y + button.h / 2 - 1,
                ui_anim(color.mod_a(animation.new(string.format('anim.tab[%s]', i), ui.color.tab_icon, tab_value.active and ui.color.accent or ui.color.tab_icon, ui.animation.speed), 120 * ui.show_anim)),
                tab_value.icon, {true, true})

                render.draw_text(ui.icon.tab, button.x + button.w / 2, button.y + button.h / 2 - 1,
                ui_anim(animation.new(string.format('anim.tab[%s]', i), ui.color.tab_icon, tab_value.active and ui.color.accent or ui.color.tab_icon, ui.animation.speed)),
                tab_value.icon, {true, true})

                if menu.is_in_bound_and_interaction(button, engine.get_key_state(1).clicked) and ui.g_operate.opened.element_index == nil then
                    reset_active(ui.tab)
                    ui.animation.reset = true
                    tab_value.active = true
                end

                if not tab_value.active then
                    goto proceed
                end

                -- render.draw_rect(ui.pos.x + 60, ui.pos.y + 5, 600 - 60, ui.pos.h - 10, color.white(50)) -- clip zone

                local scroll_box = {
                    x = ui.pos.x + 602,
                    y = ui.pos.y + 15 + tab_value.scroll,
                    w = 5,
                    h = 60,
                }
                local scroll_value = 15
                if menu.is_in_bound(scroll_box) then
                    if engine.get_key_state(1).clicked then
                        if tab_value.dragged == nil then
                            tab_value.dragged = false
                        end
                        tab_value.dragged = true
                    end
                end
                if engine.get_key_state(1).holded and tab_value.dragged then
                    tab_value.scroll = (ui.pos.y + 15 - engine.get_cursor_pos().y) * -1 - 30
                    -- print('s')
                else
                    tab_value.dragged = false
                end
                if menu.is_in_bound({x = ui.pos.x + 602, y = ui.pos.y + 15, w = 5, h = ui.pos.h - 15}) then
                    tab_value.scroll = tab_value.scroll + engine.get_mouse_scroll() * -scroll_value
                end
                tab_value.scroll = math.clamp(tab_value.scroll, 0, ui.pos.h - 90)
                local anim = {} do
                    anim.scroll = animation.new(string.format('anim.tab[%s].scroll', i), tab_value.scroll, tab_value.scroll, ui.animation.speed)
                end
                render.draw_rect_filled(ui.pos.x + 602, ui.pos.y + 15 + anim.scroll, 5, 60, ui_anim(ui.color.accent), 3)

                for i = 1, #tab_value.subtab do -- subtab
                    local subtab_value = tab_value.subtab[i]
                    local subtab_index = i
                    if tab_value.subtab[i].size == nil then
                        tab_value.subtab[i].size = 0
                    end
                    local gap = {
                        x = 0,
                        y = 0,
                    }
                    if i % 2 == 1 then
                        -- left
                        if tab_value.subtab[i - 1] ~= nil then
                            gap.y = tab_value.subtab[i - 2].size + 20
                        end
                    else
                        -- right
                        if tab_value.subtab[i - 2] ~= nil then
                            gap.y = tab_value.subtab[i - 2].size + 20
                        end
                        gap.x = 270
                    end

                    local pos = {
                        x = ui.pos.x + ui.pos.w + 10 + gap.x,
                        y = ui.pos.y + 10 + gap.y - anim.scroll,
                        w = 250,
                        h = (#tab_value.subtab[i].item) * 30 + 10
                    }
                    for j = 1, #subtab_value.item do
                        if not subtab_value.item[j].visible then
                            pos.h = pos.h - 30
                        end
                    end
                    tab_value.subtab[i].size = pos.h

                    -- animation.new(string.format('anim.tab[%s].clip', tab_index), 0, 540)
                    ui.animation.clip = math.lerp(ui.animation.clip, 1, ui.animation.speed / 3, true)
                    render.set_clip(ui.pos.x + 60, ui.pos.y + 6, math.round(540 * ui.animation.clip), math.round((ui.pos.h - 10) * ui.animation.clip))
                    render.draw_rect_filled(pos.x, pos.y, pos.w, 15 + pos.h, ui_anim(ui.color.subtab_background), 10)
                    render.draw_text(ui.font, pos.x + 10, pos.y + 5, ui_anim(ui.color.accent), subtab_value.subtab_name)
                    render.draw_rect(pos.x, pos.y + 19, pos.w, 1, ui_anim(ui.color.division))

                    local not_visible_item = 1
                    for i = 1, #subtab_value.item do -- item
                        local item = subtab_value.item[i]
                        if not item.visible then
                            not_visible_item = not_visible_item + 1
                        end

                        local universal_index = string.format('%s.%s.%s', tab_index, subtab_index, i)
                        if ui.animation.gap[universal_index] == nil then
                            ui.animation.gap[universal_index] = 0
                        end
                        -- ui.animation.gap[universal_index] = math.lerp(ui.animation.gap[universal_index], (i - not_visible_item) * 30, ui.animation.speed)
                        -- local gap = ui.animation.gap[universal_index] + 30
                        local gap = (i - not_visible_item) * 30 + 30
                        local animation_path = string.format('anim.tab[%s].subtab[%s].item[%s].', tab_index, subtab_index, i)

                        if item.type == 'checkbox' then
                            if not item.visible then
                                goto item_proceed
                            end

                            local checkbox = {
                                x = pos.x + 220,
                                y = pos.y + gap,
                                w = 20,
                                h = 11,
                            }
                            -- render.draw_rect(checkbox.x - 210, checkbox.y, 60, 1, color.new(255, 0, 0, 50))

                            local anim = {} do
                                anim.on_active = animation.condition_new(animation_path..'on_active', item.value, ui.animation.speed)
                                anim.color = animation.new(animation_path..'color', ui.color.secondary, item.value and ui.color.accent or ui.color.secondary, ui.animation.speed)
                            end

                            -- render.set_clip(checkbox.x - 220 + 5, checkbox.y - 3, 220 - 10, 20)
                                render.draw_text(ui.font, checkbox.x - 220 + 7, checkbox.y, ui_anim(ui.color.name_text), item.name)
                            -- render.end_clip()
                            -- render.draw_rect(checkbox.x - 220 + 5, checkbox.y - 3, 220 - 10, 20, color.white(50)) -- show clip text zone

                            render.draw_text(ui.icon.element, checkbox.x - 5, checkbox.y - 4, ui_anim(anim.color), 'c') -- checkbox place
                            render.draw_text(ui.icon.element, checkbox.x - 5 + math.round(anim.on_active * 11), checkbox.y - 4, ui_anim(ui.color.some_elements), 'C') -- checkbox circle
                            -- render.draw_rect(checkbox.x, checkbox.y, checkbox.w, checkbox.h, color.new(255, 0, 0)) -- interact value


                            if menu.is_in_bound_and_interaction(checkbox, engine.get_key_state(1).clicked) and ui.g_operate.opened.element_index == nil then
                                item.value = not item.value
                            end

                            ::item_proceed::
                        end

                        if item.type == 'slider' then
                            if not item.visible then
                                goto item_proceed
                            end

                            local slider = {
                                x = pos.x + 145 - 1,
                                y = pos.y + gap,
                                w = 96,
                                h = 10,
                            }
                            -- render.draw_rect(slider.x - 120, slider.y, 60, 1, color.new(255, 0, 0, 50))

                            local anim = {} do
                                local item_value = math.flerp_inverse(item.minimum, item.maximum, item.value)
                                anim.value = animation.new(animation_path..'value', item_value, item_value, ui.animation.speed, true)
                            end

                            -- render.set_clip(slider.x - 145 + 5, slider.y - 3, 145 - render.get_text_size(ui.font, tostring(item.value)).x - 20, 20)
                                render.draw_text(ui.font, slider.x - 145 + 7, slider.y, ui_anim(ui.color.name_text), item.name)
                            -- render.end_clip()
                            -- render.draw_rect(slider.x - 145 + 5, slider.y - 3, 145 - render.get_text_size(ui.font, tostring(item.value)).x - 20, 20, color.white(50)) -- show clip text zone

                            render.draw_rect_filled(slider.x, slider.y + 4, slider.w, 2, ui_anim(ui.color.secondary)) -- slider place
                            render.draw_rect_filled(slider.x, slider.y + 4, math.round(anim.value * slider.w), 2, ui_anim(ui.color.accent)) -- slider place filled
                            render.draw_text(ui.icon.element, slider.x + math.round(anim.value * slider.w) - 10, slider.y - 5, ui_anim(ui.color.some_elements), 'C') -- slider circle
                            -- render.draw_rect(slider.x, slider.y, slider.w, slider.h, color.new(255, 0, 0, 20)) -- interact value

                            local cur = engine.get_cursor_pos()

                            item.value = math.clamp(item.value, item.minimum, item.maximum)
                            item.value = math.flerp_inverse(item.minimum, item.maximum, item.value + (engine.get_key_state(17).holded and engine.get_mouse_scroll() or 0))
                            if engine.get_key_state(1).holded and ui.g_operate.opened.element_index == nil then
                                if menu.is_in_bound(slider) and not item.dragged and not ui.g_operate.dragged.slider then
                                    item.dragged = true
                                    ui.g_operate.dragged.slider = true
                                end
                                if item.dragged then
                                    item.value = math.clamp((cur.x - slider.x) / slider.w, 0, 1)
                                end
                            else
                                item.dragged = false
                                ui.g_operate.dragged.slider = false
                            end

                            item.value = math.flerp(item.minimum, item.maximum, item.value)
                            item.value = item.float and math.truncat(item.value, 2) or math.round(item.value)
                            render.draw_text(ui.font, slider.x - 10 - render.get_text_size(ui.font, tostring(item.value)).x, slider.y - 2, ui_anim(ui.color.some_text_elements), tostring(item.value))

                            ::item_proceed::
                        end

                        if item.type == 'button' then
                            if not item.visible then
                                goto item_proceed
                            end
                            if item.anim_clr == nil then
                                item.anim_clr = ui.color.secondary
                            end
                            item.anim_clr = math.lerp_color(item.anim_clr, ui.color.secondary, ui.animation.speed)

                            local text_size = render.get_text_size(ui.font, item.name)
                            local button = {
                                x = pos.x + 5,
                                y = pos.y + gap - 10 + 5,
                                w = 240,
                                h = 25,
                            }
                            render.draw_rect_filled(button.x, button.y, button.w, button.h, ui_anim(item.anim_clr), 10)
                            render.draw_text(ui.font, pos.x + 250 / 2, button.y + 10 - 5 + 1, ui_anim(ui.color.name_text), item.name, {true})

                            item.value = false
                            if menu.is_in_bound_and_interaction(button, engine.get_key_state(1).clicked) and ui.g_operate.opened.element_index == nil then
                                item.value = true
                                item.anim_clr = ui.color.accent
                            end

                            ::item_proceed::
                        end

                        if item.type == 'combobox' then
                            if not item.visible then
                                goto item_proceed
                            end

                            local combobox = {
                                x = pos.x + 160,
                                y = pos.y + gap,
                                w = 80,
                                h = 12,
                            }
                            -- render.draw_rect(combobox.x - 150, combobox.y, 60, 1, color.new(255, 0, 0, 50))

                            local anim = {} do
                                anim.on_active = animation.condition_new(animation_path..'on_active', item.active, ui.animation.speed)
                                anim.alpha_on_active = (math.round(anim.on_active) * 255)
                                anim.color_on_active = (animation.new(animation_path..'color_on_active', ui.color.some_elements, item.active and ui.color.accent or ui.color.some_elements, ui.animation.speed))
                            end


                            -- render.set_clip(combobox.x - 160 + 5, combobox.y - 3, 160 - 10, 20)
                                render.draw_text(ui.font, combobox.x - 160 + 7, combobox.y, ui_anim(ui.color.name_text), item.name)
                            -- render.end_clip()
                            -- render.draw_rect(combobox.x - 160 + 5, combobox.y - 3, 160 - 10, 20, color.white(50)) -- show clip text zone

                            if item.active and ui.g_operate.opened.element_index ~= nil and ui.g_operate.opened.subtab_index ~= nil and not menu.is_in_bound({x = combobox.x, y = combobox.y, w = combobox.w, h = combobox.h + #item.elements * 15 + 20}) and engine.get_key_state(1).clicked then
                                reset_active(subtab_value.item)
                            end
                            -- render.draw_rect(combobox.x, combobox.y, combobox.w, combobox.h + #item.elements * 15 + 5, color.new(255, 0, 0, 50)) -- interact active window

                            if menu.is_in_bound_and_interaction(combobox, engine.get_key_state(1).clicked) and (ui.g_operate.opened.element_index == nil or ui.g_operate.opened.element_index == i) and (ui.g_operate.opened.subtab_index == nil or ui.g_operate.opened.subtab_index == subtab_index) then
                                item.active = not item.active
                                if item.active then
                                    if ui.g_operate.opened.element_index == nil and ui.g_operate.opened.subtab_index == nil then
                                        ui.g_operate.opened.subtab_index = subtab_index
                                        ui.g_operate.opened.element_index = i
                                    end
                                end
                            end
                            if ui.g_operate.opened.subtab_index == subtab_index then
                                if ui.g_operate.opened.element_index ~= nil and subtab_value.item[ui.g_operate.opened.element_index].type == 'combobox' then
                                    if not subtab_value.item[ui.g_operate.opened.element_index].active then
                                        ui.g_operate.opened.element_index = nil
                                        ui.g_operate.opened.subtab_index = nil
                                    end
                                end
                            end

                            render.draw_text(ui.icon.combobox_place, combobox.x - 34, combobox.y - 30, ui_anim(ui.color.secondary), 'b') -- combobox place
                            render.draw_text(ui.icon.small, combobox.x + combobox.w - 15, combobox.y, ui_anim(anim.color_on_active), 'C') -- combobox circle indicator of active
                            -- render.draw_rect(combobox.x, combobox.y, combobox.w, combobox.h, color.new(255, 0, 0, 50)) -- interact box

                            local active_value = {}

                            for i, v in pairs(item.elements) do
                                if v.active then
                                    table.insert(active_value, v.name)
                                end
                            end

                            -- render.set_clip(combobox.x, combobox.y, combobox.w - 15, combobox.h)
                                render.draw_text(ui.font, combobox.x + 5, combobox.y, ui_anim(ui.color.some_text_elements), table.concat(active_value, ','):sub(1, 12) or '')
                            -- render.end_clip()
                            -- render.draw_rect(combobox.x, combobox.y, combobox.w - 15, combobox.h, color.white(50))

                            if item.multi then
                                item.value = {}
                                for _, v in pairs(item.elements) do
                                    item.value[v.name] = v.active
                                end
                            end

                            if item.active and ui.g_operate.opened.element_index == i and ui.g_operate.opened.subtab_index == subtab_index then
                                if item.allow_index == nil then
                                    item.allow_index = #self._function + 1
                                end
                                self._function[item.allow_index] = function()
                                    render.draw_rect_filled(combobox.x, combobox.y + combobox.h + 5, combobox.w, #item.elements * 15, color.mod_a(ui.color.secondary, math.round(anim.on_active * 255)), 3)

                                    -- render.set_clip(combobox.x, combobox.y + combobox.h + 5, combobox.w - 3, #item.elements * 15)
                                    for i, v in pairs(item.elements) do
                                        local gap = (i - 1) * 15
                                        local element = {
                                            x = combobox.x,
                                            y = combobox.y + gap + 17,
                                            w = combobox.w,
                                            h = combobox.h + 2,
                                        }
                                        if menu.is_in_bound_and_interaction(element, engine.get_key_state(1).clicked) then
                                            if item.multi then
                                                v.active = not v.active
                                            else
                                                reset_active(item.elements)
                                                v.active = true
                                                item.value = v.name
                                            end
                                        end

                                        anim.on_value_active = animation.new(string.format('%svalue[%s]', animation_path, i), v.active and ui.color.accent or ui.color.some_text_elements, v.active and ui.color.accent or ui.color.some_text_elements, ui.animation.speed)
                                        render.draw_text(ui.font, element.x + 5, element.y + 1, color.mod_a(anim.on_value_active, anim.alpha_on_active), v.name)

                                        -- render.draw_rect(element.x, element.y, element.w, element.h, color.new(255, 0, 0, 50)) -- interact value
                                    end
                                    -- render.end_clip()
                                    -- render.draw_rect(combobox.x, combobox.y + combobox.h + 5, combobox.w - 3, #item.elements * 15, color.white(50))
                                end
                            else
                                if item.allow_index ~= nil then
                                    table.remove(self._function, item.allow_index)
                                    item.allow_index = nil
                                end
                            end

                            ::item_proceed::
                        end

                        if item.type == 'textbox' then
                            if not item.visible then
                                goto item_proceed
                            end

                            local textbox = {
                                x = pos.x + 160,
                                y = pos.y + gap,
                                w = 80,
                                h = 12,
                            }
                            -- render.draw_rect(textbox.x - 150, textbox.y, 60, 1, color.new(255, 0, 0, 50))

                            local anim = {} do
                                anim.text_gap_size = animation.new(animation_path..'text_gap_size', render.get_text_size(ui.font, item.value).x, render.get_text_size(ui.font, item.value).x, ui.animation.speed) + 2
                            end
                            -- render.set_clip(textbox.x - 160 + 5, textbox.y - 3, 160 - 10, 20)
                                render.draw_text(ui.font, textbox.x - 160 + 7, textbox.y, ui_anim(ui.color.name_text), item.name)
                            -- render.end_clip()
                            -- render.draw_rect(textbox.x - 160 + 5, textbox.y - 3, 160 - 10, 20, color.white(50)) -- show clip text zone

                            render.draw_text(ui.icon.combobox_place, textbox.x - 34, textbox.y - 30, ui_anim(ui.color.secondary), 'b')

                            item.value = item.value:sub(1, 12)
                            render.draw_text(ui.font, textbox.x + 5, textbox.y, ui_anim(ui.color.some_text_elements), item.value)
                            -- render.set_clip(textbox.x, textbox.y, textbox.w - 3, textbox.h)
                            -- render.end_clip()
                            -- render.draw_rect(textbox.x, textbox.y, textbox.w, textbox.h, color.new(255, 0, 0, 50)) -- interact writing

                            if ui.g_operate.opened.element_index == i and ui.g_operate.opened.subtab_index == subtab_index then
                                for i = 1, 255 do
                                    local key = engine.get_key_state(i)

                                    if key.clicked and key.virtual ~= '~' and not engine.get_key_state(17).holded then
                                        if key.virtual == 'space' then
                                            key.virtual = ' '
                                        end


                                        if key.virtual:len() == 1 then
                                            item.value = string.insert(item.value, engine.get_key_state(16).holded and key.virtual:upper() or key.virtual)
                                        end
                                        if key.virtual == 'backspace' then
                                            item.value = string.remove(item.value)
                                        end
                                    end
                                end
                                if engine.get_key_state(8).holded then
                                    ui.g_operate.op_qty = ui.g_operate.op_qty + 1

                                    if ui.g_operate.op_qty >= 50 then
                                        if ui.g_operate.op_qty % 15 < 1 then
                                            item.value = string.remove(item.value)
                                        end
                                    end
                                else
                                    ui.g_operate.op_qty = 0
                                end
                                if engine.get_key_state(17).holded then
                                    if engine.get_key_state(86).clicked then
                                        item.value = string.insert(item.value, clipboard.get())
                                        popup.show({
                                            'Menu',
                                            'Text pasted.'
                                        })
                                    end
                                    if engine.get_key_state(67).clicked then
                                        clipboard.set(item.value)
                                        popup.show({
                                            'Menu',
                                            string.format('Text(%s) copied.', item.value)
                                        })
                                    end
                                end

                                -- render.set_clip(textbox.x, textbox.y, textbox.w - 3, textbox.h)
                                render.draw_rect_filled(textbox.x + 5 + anim.text_gap_size, textbox.y + 2, 1, 9, ui_anim(ui.color.accent))
                                -- render.end_clip()

                                if not menu.is_in_bound(textbox) and engine.get_key_state(1).clicked or engine.get_key_state(13).clicked then
                                    if ui.g_operate.opened.element_index ~= nil and ui.g_operate.opened.subtab_index ~= nil then
                                        ui.g_operate.opened.element_index = nil
                                        ui.g_operate.opened.subtab_index = nil
                                    end
                                    -- if ui.g_operate.opened.subtab_index == subtab_index
                                    -- if ui.g_operate.opened.element_index == i
                                    -- ui.g_operate.opened.element_index = nil
                                end
                            end


                            if menu.is_in_bound_and_interaction(textbox, engine.get_key_state(1).clicked) then
                                if ui.g_operate.opened.element_index == nil and ui.g_operate.opened.subtab_index == nil then
                                    ui.g_operate.opened.element_index = i
                                    ui.g_operate.opened.subtab_index = subtab_index
                                end
                            end

                            -- ui.g_operate.opened.subtab_index = subtab_index
                            -- ui.g_operate.opened.element_index = i

                            ::item_proceed::
                        end

                        if item.type == 'colorpicker' then
                            if not item.visible then
                                goto item_proceed
                            end

                            local colorpicker = {
                                x = pos.x + 185,
                                y = pos.y + gap - 3,
                                w = 55,
                                h = 20,
                            }
                            -- render.draw_rect(colorpicker.x - 175, colorpicker.y + 3, 60, 1, color.new(255, 0, 0, 50))
                            local anim = {} do
                                -- anim.alpha_on_active = animation.new(animation_path..'alpha_on_active', )
                                anim.on_active = animation.new(animation_path..'on_active', ui.color.some_elements, item.active and ui.color.accent or ui.color.some_elements, ui.animation.speed)
                                anim.alpha_on_active = math.round(animation.condition_new(animation_path..'alpha_on_active', item.active, ui.animation.speed) * 255)
                            end

                            -- render.set_clip(colorpicker.x - 185 + 5, colorpicker.y, 185 - 10, 20)
                                render.draw_text(ui.font, colorpicker.x - 185 + 7, colorpicker.y + 3, ui_anim(ui.color.name_text), item.name)
                            -- render.end_clip()
                            -- render.draw_rect(colorpicker.x - 185 + 5, colorpicker.y, 185 - 10, 20, color.white(50)) -- show clip text zone

                            render.draw_text(ui.icon.keybind_place, colorpicker.x - 3, colorpicker.y - 6 + 4, ui_anim(ui.color.secondary), 'k')

                            render.draw_text(ui.icon.element, colorpicker.x + 2, colorpicker.y, ui_anim(color.mod_a(item.value, 255)), 'C')
                            render.draw_text(ui.icon.KPicons, colorpicker.x + colorpicker.w - 22, colorpicker.y + 2, ui_anim(anim.on_active), 'P')

                            -- render.draw_rect(colorpicker.x, colorpicker.y, colorpicker.w, colorpicker.h, color.new(255, 0, 0, 50)) -- interact change color

                            -- if item.active and ui.g_operate.opened.element_index ~= nil and () and engine.get_key_state(1).clicked then
                            --     reset_active(subtab_value.item)
                            -- end
                            if menu.is_in_bound(colorpicker) then
                                if engine.get_key_state(17).holded then
                                    if engine.get_key_state(86).clicked then
                                        item.value = ui.color.clipboard
                                        popup.show({
                                            'Menu',
                                            'Color pasted.'
                                        })
                                        item.allow_edit = true
                                    end
                                    if engine.get_key_state(67).clicked then
                                        ui.color.clipboard = item.value
                                        popup.show({
                                            'Menu',
                                            string.format('Color(%s, %s, %s) copied.', ui.color.clipboard.r, ui.color.clipboard.g, ui.color.clipboard.b)
                                        })
                                    end
                                end
                            end
                            if menu.is_in_bound_and_interaction(colorpicker, engine.get_key_state(1).clicked) then
                                if ui.g_operate.opened.element_index ~= nil and ui.g_operate.opened.subtab_index ~= nil then
                                    if subtab_value.item[ui.g_operate.opened.element_index].type ~= 'colorpicker' then
                                        goto item_proceed
                                    end
                                end
                                item.active = not item.active
                                if item.active then
                                    if ui.g_operate.opened.element_index == nil and ui.g_operate.opened.subtab_index == nil then
                                        ui.g_operate.opened.subtab_index = subtab_index
                                        ui.g_operate.opened.element_index = i
                                    end
                                end
                            end
                            if ui.g_operate.opened.subtab_index == subtab_index then
                                if ui.g_operate.opened.element_index ~= nil and subtab_value.item[ui.g_operate.opened.element_index].type == 'colorpicker' then
                                    if not subtab_value.item[ui.g_operate.opened.element_index].active then
                                        ui.g_operate.opened.element_index = nil
                                        ui.g_operate.opened.subtab_index = nil
                                    end
                                end
                            end

                            if item.active and ui.g_operate.opened.element_index == i then
                                if item.allow_index == nil then
                                    item.allow_index = #self._function + 1
                                end

                                self._function[item.allow_index] = function()
                                    -- print('clr', item.value.r, item.value.g, item.value.b)
                                    item.value = color.rgb2hsv(item.value)
                                    -- print('hsv', item.value.h, item.value.s, item.value.v)
                                    if not (menu.is_in_bound({x = colorpicker.x + 60, y = colorpicker.y, w = 120, h = 120}) or menu.is_in_bound(colorpicker)) and engine.get_key_state(1).clicked then
                                        reset_active(subtab_value.item)
                                        if item.allow_index ~= nil then
                                            table.remove(self._function, item.allow_index)
                                            ui.g_operate.opened.element_index = nil
                                            ui.g_operate.opened.subtab_index = nil
                                            item.allow_index = nil
                                        end
                                    end
                                    colorpicker.x = colorpicker.x + 60
                                    -- print((menu.is_in_bound({x = colorpicker.x + 60, y = colorpicker.y, w = 120, h = 120}) or menu.is_in_bound(colorpicker)))
                                    -- if not menu.is_in_bound({x = colorpicker.x, y = colorpicker.y, w = 120, h = 120}) and engine.get_key_state(1).clicked then
                                    --     reset_active(subtab_value.item)
                                    --     print('reseted')
                                    -- end
                                    -- print(colorpicker.x)


                                    render.draw_rect_filled(colorpicker.x, colorpicker.y, 120, 120, color.mod_a(ui.color.secondary, anim.alpha_on_active), 3)

                                    local picker = {}
                                    picker.square = {
                                        x = colorpicker.x + 5,
                                        y = colorpicker.y + 5,
                                        w = 95,
                                        h = 95,
                                    }
                                    picker.alpha = {
                                        x = picker.square.x,
                                        y = picker.square.y + picker.square.h + 5,
                                        w = picker.square.w,
                                        h = 10
                                    }
                                    picker.hue = {
                                        x = picker.square.x + picker.square.w + 5,
                                        y = picker.square.y,
                                        w = 10,
                                        h = picker.square.h + picker.alpha.h + 5
                                    }

                                    if item.allow_edit then
                                        item.pos = {
                                            square_picker = {
                                                x = item.value.s * picker.square.w,
                                                y = (1 - item.value.v) * picker.square.h,
                                            },
                                            hue_picker_y = item.value.h * picker.hue.h,
                                            alpha_picker_x = item.value.a / 255 * picker.alpha.w,
                                        }
                                        item.allow_edit = false
                                    end
                                    if engine.get_key_state(1).holded then
                                        if menu.is_in_bound(picker.square) and not ui.g_operate.dragged.picker then
                                            item.dragged.square = true
                                            ui.g_operate.dragged.picker = true
                                        end
                                        if menu.is_in_bound(picker.hue) and not ui.g_operate.dragged.picker then
                                            item.dragged.hue = true
                                            ui.g_operate.dragged.picker = true
                                        end
                                        if menu.is_in_bound(picker.alpha) and not ui.g_operate.dragged.picker then
                                            item.dragged.alpha = true
                                            ui.g_operate.dragged.picker = true
                                        end


                                        if item.dragged.square then
                                            local cur = engine.get_cursor_pos()
                                            local delta = {
                                                x = math.clamp(cur.x - picker.square.x, 0, picker.square.w),
                                                y = math.clamp(cur.y - picker.square.y, 0, picker.square.h),
                                            }
                                            item.pos.square_picker = delta

                                            -- item.value.s = delta.x / picker.square.w
                                            -- item.value.v = 1 - (delta.y / picker.square.h)
                                        end
                                        if item.dragged.hue then
                                            local cur = engine.get_cursor_pos()
                                            local delta = math.clamp(cur.y - picker.hue.y, 0, picker.hue.h)
                                            item.pos.hue_picker_y = delta
                                            -- item.value.h = delta / picker.hue.h
                                        end
                                        if item.dragged.alpha then
                                            local cur = engine.get_cursor_pos()
                                            local delta = math.clamp(cur.x - picker.alpha.x, 0, picker.alpha.w)
                                            item.pos.alpha_picker_x = delta
                                            -- item.value.a = delta / picker.alpha.w * 255
                                        end
                                    else
                                        item.dragged.square = false
                                        item.dragged.hue = false
                                        item.dragged.alpha = false
                                        ui.g_operate.dragged.picker = false
                                    end

                                    -- square picker
                                    item.value.s = item.pos.square_picker.x / picker.square.w
                                    item.value.v = 1 - (item.pos.square_picker.y / picker.square.h)

                                    -- hue
                                    item.value.h = item.pos.hue_picker_y / picker.hue.h

                                    -- alpha
                                    item.value.a = item.pos.alpha_picker_x / picker.alpha.w * 255

                                    -- render.draw_rect_filled(picker.square.x, picker.square.y, picker.square.w, picker.square.h, color.black()) -- square
                                    local drawHUE_color = color.hsv2rgb({
                                        h = item.value.h,
                                        s = 1,
                                        v = 1,
                                        a = 255
                                    })
                                    render.draw_gradient_rect_filled(picker.square.x, picker.square.y, picker.square.w, picker.square.h, color.mod_a(color.white(), anim.alpha_on_active), color.mod_a(drawHUE_color, anim.alpha_on_active), true)
                                    render.draw_gradient_rect_filled(picker.square.x, picker.square.y, picker.square.w, picker.square.h, color._nil(), color.mod_a(color.black(), anim.alpha_on_active), false)
                                    render.draw_gradient_rect_filled(picker.square.x, picker.square.y, picker.square.w, picker.square.h, color._nil(), color.mod_a(color.black(), math.clamp(anim.alpha_on_active, 0, 200)), false)

                                    -- render.draw_rect(picker.hue.x, picker.hue.y, picker.hue.w, picker.hue.h, color.black()) -- hue
                                    local HUE_colors = {
                                        color.new(255, 0, 0),
                                        color.new(255, 255, 0),
                                        color.new(0, 255, 0),
                                        color.new(0, 255, 255),
                                        color.new(0, 0, 255),
                                        color.new(255, 0, 255),
                                        color.new(255, 0, 0),
                                    }

                                    local fill_nil_places = 19
                                    for i = 1, #HUE_colors do
                                        local gap = (i - 1) * (picker.hue.h + fill_nil_places) / (#HUE_colors)
                                        if HUE_colors[i + 1] ~= nil then
                                            render.draw_gradient_rect_filled(picker.hue.x, picker.hue.y + gap, picker.hue.w, (picker.hue.h + fill_nil_places) / #HUE_colors, color.mod_a(HUE_colors[i], anim.alpha_on_active), color.mod_a(HUE_colors[i + 1], anim.alpha_on_active), false)
                                        end
                                    end

                                    render.draw_rect_filled(picker.alpha.x, picker.alpha.y, picker.alpha.w, picker.alpha.h, color.mod_a(color.black(), anim.alpha_on_active)) -- alpha
                                    for i = 1, picker.alpha.w / 5 do
                                        local gap = {
                                            x = (i - 1) * 5,
                                            y = i % 2 == 0 and 0 or 5
                                        }
                                        render.draw_rect_filled(picker.alpha.x + gap.x, picker.alpha.y + gap.y, 5, 5, color.mod_a(color.white(), anim.alpha_on_active))
                                    end
                                    render.draw_gradient_rect_filled(picker.alpha.x, picker.alpha.y, picker.alpha.w, picker.alpha.h, color._nil(), color.mod_a(color.hsv2rgb(item.value), anim.alpha_on_active), true)

                                    -- render.draw_rect(picker.square.x + item.pos.square_picker.x, picker.square.y + item.pos.square_picker.y, 5, 5, color.mod_a(color.white(), anim.alpha_on_active)) -- square picker
                                    render.draw_text(ui.icon.small, picker.square.x + item.pos.square_picker.x, picker.square.y + item.pos.square_picker.y, color.mod_a(color.white(), anim.alpha_on_active), 'O', {true, true})

                                    render.draw_rect_filled(picker.hue.x, math.min(picker.hue.y + item.pos.hue_picker_y, picker.hue.y + picker.hue.h - 2), picker.hue.w, 2, color.mod_a(color.white(), anim.alpha_on_active)) -- hue slider
                                    render.draw_rect_filled(math.min(picker.alpha.x + item.pos.alpha_picker_x, picker.alpha.x + picker.alpha.w - 2), picker.alpha.y, 2, picker.alpha.h, color.mod_a(color.white(), anim.alpha_on_active)) -- alpha slider

                                    item.value = color.hsv2rgb(item.value)
                                    -- print(item.value.r, item.value.g, item.value.b, item.value.a)
                                end
                            else
                                if item.allow_index ~= nil then
                                    table.remove(self._function, item.allow_index)
                                    item.allow_index = nil
                                end
                            end

                            ::item_proceed::
                        end

                        if item.type == 'keybind' then
                            if not item.visible then
                                goto item_proceed
                            end

                            local keybind = {
                                x = pos.x + 185,
                                y = pos.y + gap - 3,
                                w = 55,
                                h = 20,
                            }
                            -- render.draw_rect(keybind.x - 175, keybind.y + 3, 60, 1, color.new(255, 0, 0, 50))
                            local anim = {} do
                                anim.alpha_on_active = math.round(animation.condition_new(animation_path..'alpha_on_active', item.allow_index ~= nil, ui.animation.speed) * 255)
                                anim.color_on_active = animation.new(animation_path..'color_on_active', ui.color.some_elements, item.active and ui.color.accent or ui.color.some_elements, ui.animation.speed)
                            end

                            -- render.set_clip(keybind.x - 185 + 5, keybind.y, 185 - 10, 20)
                                render.draw_text(ui.font, keybind.x - 185 + 7, keybind.y + 3, ui_anim(ui.color.name_text), item.name)
                            -- render.end_clip()
                            -- render.draw_rect(keybind.x - 185 + 5, keybind.y, 185 - 10, 20, color.white(50)) -- show clip text zone

                            render.draw_text(ui.icon.keybind_place, keybind.x - 3, keybind.y - 2, ui_anim(ui.color.secondary), 'k')
                            render.draw_text(ui.icon.KPicons, keybind.x + keybind.w - 22, keybind.y + 2, ui_anim(anim.color_on_active), 'K')

                            render.draw_text(ui.font, keybind.x + 13, keybind.y + 10, ui_anim(anim.color_on_active), item.key, {true, true})
                            -- render.draw_rect(keybind.x, keybind.y, keybind.w, keybind.h, color.new(255, 0, 0, 50)) -- interact set bind & open mode chooser

                            if item.key == '' or item.bind_type == 'none' then
                                item.key = '...'
                            end
                            if item.active then
                                for i = 1, 255 do
                                    local key = engine.get_key_state(i)

                                    if key.clicked then
                                        item.key = key.virtual
                                        item.active = false
                                        ui.g_operate.opened.element_index = nil
                                    end
                                end
                            end
                            if menu.is_in_bound_and_interaction(keybind, engine.get_key_state(2).clicked) then
                                if item.allow_index == nil then
                                    item.allow_index = #self._function + 1
                                end
                                if ui.g_operate.opened.element_index == nil then
                                    ui.g_operate.opened.element_index = i
                                end
                            end

                            if item.allow_index ~= nil then
                                self._function[item.allow_index] = function()
                                    local bind = {
                                        x = keybind.x - 5,
                                        y = keybind.y + keybind.h,
                                        w = 30 + 10,
                                        h = 59,
                                    }
                                    render.draw_rect_filled(bind.x + bind.w / 3, bind.y + 5, bind.w, bind.h + 2, color.mod_a(ui.color.secondary, anim.alpha_on_active), 3)

                                    if not menu.is_in_bound(bind) then
                                        if engine.get_key_state(1).clicked then
                                            table.remove(self._function, item.allow_index)
                                            item.allow_index = nil
                                            ui.g_operate.opened.element_index = nil
                                        end
                                    end

                                    for i, v in pairs({'none', 'hold', 'toggle', 'click', 'always'}) do
                                        local gap = (i - 1) * 12
                                        local type = {
                                            x = bind.x + bind.w / 3,
                                            y = bind.y + gap + 5,
                                            w = bind.w,
                                            h = 12
                                        }
                                        -- anim.on_value_active = animation.new(string.format('%svalue[%s]', animation_path, i), item.bind_type == v and ui.color.accent or color.white(), item.bind_type == v and ui.color.accent or color.white(), ui.animation.speed)
                                        render.draw_text(ui.font, type.x + type.w / 2 + 1, type.y, color.mod_a(item.bind_type == v and ui.color.accent or ui.color.some_text_elements, anim.alpha_on_active), v, {true})

                                        -- render.draw_rect(type.x, type.y, type.w, type.h, color.new(255, 0, 0, 50)) -- interact value
                                        if menu.is_in_bound_and_interaction(type, engine.get_key_state(1).clicked) and item.allow_index ~= nil then
                                            item.bind_type = v
                                            table.remove(self._function, item.allow_index)
                                            item.allow_index = nil
                                            ui.g_operate.opened.element_index = nil
                                        end
                                    end
                                end
                            end
                            if menu.is_in_bound_and_interaction(keybind, engine.get_key_state(1).clicked) and ui.g_operate.opened.element_index == nil then
                                item.active = not item.active
                                if item.bind_type == 'none' then
                                    item.bind_type = 'hold'
                                end
                                ui.g_operate.opened.element_index = i
                            end

                            ::item_proceed::
                        end

                        if item.type == 'label' then
                            if not item.visible then
                                goto item_proceed
                            end

                            local label = {
                                x = pos.x + 250 / 2,
                                y = pos.y + gap + 5,
                            }

                            render.draw_text(ui.font, label.x, label.y, color.mod_a(ui.color.accent, 255 * ui.show_anim), item.value, {true, true})

                            ::item_proceed::
                        end
                    end
                    render.end_clip()
                end
                ::proceed::
            end

        end)

        local c_item = {}; do
            c_item.__index = c_item;

            function c_item:get(arg1)
                if self.type == 'combobox' then
                    if self.multi then
                        return self.value[arg1]
                    end
                end; return self.value
            end

            function c_item:set(value, arg1, arg2)
                if self.type == 'combobox' then
                    if self.multi then

                        self.value[arg1] = value
                        for _, v in pairs(self.elements) do
                            if arg1 == v.name then
                                v.active = value
                            end
                        end
                    else
                        reset_active(self.elements)
                        for _, v in pairs(self.elements) do
                            if value == v.name then
                                v.active = true
                            end
                        end
                        self.value = value
                    end; return
                end
                if self.type == 'colorpicker' then
                    self.allow_edit = true
                    self.value = value
                    return
                end
                if self.type == 'keybind' then
                    self.value = value
                    self.key = arg1 or self.key
                    self.bind_type = arg2 or self.bind_type
                    return
                end
                self.value = value
            end

            function c_item:set_visible(value)
                self.visible = value
            end

            function c_item:change(index, value)
                assert(self.type == 'combobox', 'Not combobox.')
                self.elements[index].name = value
            end

            function c_item:get_active_name()
                assert(self.type == 'combobox', 'Not combobox.')
                for _, v in pairs(self.elements) do
                    if v.active then; return v.name; end
                end
            end

            function c_item:add_to(name, value)
                assert(self.type == 'combobox', 'Not combobox.')
                if value and not self.multi then
                    reset_active(self.elements)
                end; table.insert(self.elements, {
                    name = name,
                    active = value or false,
                })
            end

            function c_item:delete(name)
                assert(self.type == 'combobox', 'Not combobox.')
                for i, v in pairs(self.elements) do
                    if v.name == name then
                        table.remove(self.elements, i)
                    end
                end
            end
        end

        ui.checkbox = function(tab, subtab, name, value)
            local item = {
                type = 'checkbox',
                name = name,
                value = value or false,
                visible = true,
            }

            item_insert(tab, subtab, item)
            return setmetatable(item, c_item)
        end
        ui.slider = function(tab, subtab, name, float, value, minimum, maximum)
            local item = {
                type = 'slider',
                name = name,
                float = float,
                value = value,
                minimum = minimum or 0,
                maximum = maximum or 100,
                visible = true,
                dragged = false,
            }

            item_insert(tab, subtab, item)
            return setmetatable(item, c_item)
        end
        ui.button = function(tab, subtab, name)
            local item = {
                type = 'button',
                name = name,
                value = false,
                visible = true,
            }

            item_insert(tab, subtab, item)
            return setmetatable(item, c_item)
        end
        ui.combobox = function(tab, subtab, name, multi, elements, value)
            if not multi then
                value = value or elements[1]
            else
                if value == nil then
                    value = {}
                    for _, v in pairs(elements) do
                        value[v] = false
                    end
                end
            end
            local elements_t = {}
            for i, v in pairs(elements) do
                elements_t[i] = {
                    name = v,
                    active = multi and value[v] or v == value
                }
            end
            local item = {
                type = 'combobox',
                name = name,
                value = value,
                multi = multi,
                elements = elements_t,
                active = false,
                allow_index = nil,
                visible = true,
            }

            item_insert(tab, subtab, item)
            return setmetatable(item, c_item)
        end
        ui.textbox = function(tab, subtab, name, value)
            local item = {
                type = 'textbox',
                name = name,
                value = value or '',
                visible = true,
            }

            item_insert(tab, subtab, item)
            return setmetatable(item, c_item)
        end
        ui.keybind = function(tab, subtab, name, key, type)
            local item = {
                type = 'keybind',
                name = name,
                key = key or '',
                value = false,
                active = false,
                allow_index = nil,
                bind_type = type or 'none',
                on_start = false,
                visible = true,
            }

            item_insert(tab, subtab, item)
            return setmetatable(item, c_item)
        end
        ui.colorpicker = function(tab, subtab, name, value)
            local item = {
                type = 'colorpicker',
                name = name,
                value = value or color.white(),
                active = false,
                allow_index = nil,
                allow_edit = true,
                dragged = {
                    picker = false,
                    alpha = false,
                    hue = false,
                },
                visible = true,
            }

            item_insert(tab, subtab, item)
            return setmetatable(item, c_item)
        end
        ui.label = function(tab, subtab, value)
            local item = {
                type = 'label',
                value = value or 'Orion Club',
                visible = true,
            }

            item_insert(tab, subtab, item)
            return setmetatable(item, c_item)
        end
    end,
    blur = function(self)
        panorama.run_script([[
            if (true) {
                invoke = function(gauss) {
                    let _root_panel = $.GetContextPanel()
                    let _panel = $.CreatePanel("Panel", _root_panel, "Leaf")
                    let _info = { visibility: gauss, res: { x: 0, y: 0, w: 0, h: 0 } }
                    let co_r = function(res, or) { return (res/or)*100 }

                    if(!_panel)
                        return

                    let layout = `
                        <root>
                            <styles>
                                <include src='file://{resources}/styles/csgostyles.css' />
                                <include src='file://{resources}/styles/hud/hud.css' />
                            </styles>
                            <Panel class='full-width full-height' hittest='false' hittestchildren='false'>
                                <CSGOBlurTarget id='HudBlurG' style='width:100%;height:100%;-s2-mix-blend-mode:opaque;blur:fastgaussian(${gauss},${gauss},${gauss});'>
                                    <CSGOBackbufferImagePanel class='full-width full-height' />
                                </CSGOBlurTarget>
                            </Panel>
                        </root>
                    `

                    if(!_panel.BLoadLayoutFromString(layout, false, false))
                        return

                    _panel.visible = true
                    _panel.style.clip = null
                    _panel.style.clip = `rect(0%, 0%, 0%, 0%)`

                    return {
                        visibility: function(value) {
                            if (_panel == null || _info.visibility === value)
                                return;

                            value = value === false ? 0 : value
                            value = value === true ? 1 : value

                            let res = (gauss - 1) * value + 1

                            _panel.visible = value > 0.000
                            _panel.GetChild(0).style.blur = `fastgaussian(${res},${res},${res})`

                            _info.visibility = value
                        },

                        set_position: function(x, y, w, h) {
                            let res = { x: x, y: y, w: w, h: h }

                            if (_panel == null || _info.res === res || (_root_panel.contentwidth == 0 || _root_panel.contentheight == 0))
                                return;

                            _x = co_r(x, _root_panel.contentwidth)
                            _y = co_r(y, _root_panel.contentheight)
                            w =  co_r(x+w, _root_panel.contentwidth)
                            h =  co_r(y+h, _root_panel.contentheight)

                            _panel.style.clip = null
                            _panel.style.clip = `rect( ${_y}%, ${_x}%, ${h}%, ${w}% )`

                            _info.res = res
                        },

                        release: function() {
                            if (_panel == null)
                                return;

                            _panel.RemoveAndDeleteChildren()
                            _panel.DeleteAsync(0.0)
                            _panel = null
                        },

                        panel: _panel
                    }
                }
            }
        ]])

        local data = {}

        self.invoke = function(name, radius)
            panorama.run_script(string.format([[
                %s = invoke(%s);
            ]], name, radius))
        end
        self.set_position = function(name, pos)
            panorama.run_script(string.format([[
                %s.set_position(%s, %s, %s, %s)
            ]], name, pos[1], pos[2], pos[3], pos[4]))
        end
        self.reset = function(name)
            panorama.run_script(string.format([[
                %s.release()
            ]], name))
        end
        render.blur = function(name, x, y, w, h, radius)
            if data[name] == nil then
                data[name] = {
                    pos = {x, y, w, h},
                    radius = radius,
                    allow_invoke = false,
                    execute = true,
                    recover = false,
                }
                self.invoke(name, radius)
                self.set_position(name, {x, y, w, h})
            end

            local current = {
                pos = {x, y, w, h},
                radius = radius
            }

            -- allow invoke if position changed
            for i = 1, 4 do
                if data[name].pos[i] ~= current.pos[i] then
                    data[name].allow_invoke = true
                end
                data[name].pos[i] = current.pos[i]
            end

            -- allow invoke if radius changed
            if data[name].radius ~= current.radius then
                data[name].allow_invoke = true
            end
            data[name].radius = current.radius

            data[name].execute = true
        end
        table.insert(self._function, function()
            for k, v in pairs(data) do
                if v.allow_invoke then
                    self.set_position(k, v.pos)
                    v.allow_invoke = false
                end

                local _execute = v.execute
                v.execute = false

                if not _execute then
                    v.recover = true
                    self.reset(k)
                else
                    if v.recover then
                        self.invoke(k, v.radius)
                        self.set_position(k, v.pos)
                        v.recover = false
                    end
                end
            end
        end)
        client.add_callback('unload', function()
            for k, _ in pairs(data) do
                self.reset(k)
            end
        end)
    end,
    base64 = function(self)
        base64 = {}

        base64.makeencoder = function(alphabet)
            local encoder = {}
            local t_alphabet = {}
            for i = 1, #alphabet do
                t_alphabet[i - 1] = alphabet:sub(i, i)
            end
            for b64code, char in pairs(t_alphabet) do
                encoder[b64code] = char:byte()
            end
            return encoder
        end
        base64.makedecoder = function(alphabet)
            local decoder = {}
            for b64code, charcode in pairs(base64.makeencoder(alphabet)) do
                decoder[charcode] = b64code
            end
            return decoder
        end

        base64.DEFAULT_ENCODER = base64.makeencoder('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=')
        base64.DEFAULT_DECODER = base64.makedecoder('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=')
        base64.CUSTOM_ENCODER  = base64.makeencoder('KmAWpuFBOhdbI1orP2UN5vnSJcxVRgazk97ZfQqL0yHCl84wTj3eYXiD6stEGM+/=')
        base64.CUSTOM_DECODER  = base64.makedecoder('KmAWpuFBOhdbI1orP2UN5vnSJcxVRgazk97ZfQqL0yHCl84wTj3eYXiD6stEGM+/=')

        base64.encode = function(str, encoder, usecaching)
            str = tostring(str)

            encoder = encoder or base64.CUSTOM_ENCODER
            local t, k, n = {}, 1, #str
            local lastn = n % 3
            local cache = {}
            for i = 1, n - lastn, 3 do
                local a, b, c = str:byte(i, i + 2)
                local v = a * 0x10000 + b * 0x100 + c
                local s
                if usecaching then
                    s = cache[v]
                    if not s then
                        s = string.char(encoder[extract(v, 18, 6)], encoder[extract(v, 12, 6)], encoder[extract(v, 6, 6)], encoder[extract(v, 0, 6)])
                        cache[v] = s
                    end
                else
                    s = string.char(encoder[extract(v, 18, 6)], encoder[extract(v, 12, 6)], encoder[extract(v, 6, 6)], encoder[extract(v, 0, 6)])
                end
                t[k] = s
                k = k + 1
            end
            if lastn == 2 then
                local a, b = str:byte(n - 1, n)
                local v = a * 0x10000 + b * 0x100
                t[k] = string.char(encoder[extract(v, 18, 6)], encoder[extract(v, 12, 6)], encoder[extract(v, 6, 6)], encoder[64])
            elseif lastn == 1 then
                local v = str:byte(n) * 0x10000
                t[k] = string.char(encoder[extract(v, 18, 6)], encoder[extract(v, 12, 6)], encoder[64], encoder[64])
            end
            return table.concat(t)
        end
        base64.decode = function(b64, decoder, usecaching)
            decoder = decoder or base64.CUSTOM_DECODER
            local pattern = "[^%w%+%/%=]"
            if decoder then
                local s62, s63
                for charcode, b64code in pairs(decoder) do
                    if b64code == 62 then
                        s62 = charcode
                    elseif b64code == 63 then
                        s63 = charcode
                    end
                end
                pattern = ("[^%%w%%%s%%%s%%=]"):format(string.char(s62), string.char(s63))
            end
            b64 = b64:gsub(pattern, "")
            local cache = usecaching and {}
            local t, k = {}, 1
            local n = #b64
            local padding = b64:sub(-2) == "==" and 2 or b64:sub(-1) == "=" and 1 or 0
            for i = 1, padding > 0 and n - 4 or n, 4 do
                local a, b, c, d = b64:byte(i, i + 3)
                local s
                if usecaching then
                    local v0 = a * 0x1000000 + b * 0x10000 + c * 0x100 + d
                    s = cache[v0]
                    if not s then
                        local v = decoder[a] * 0x40000 + decoder[b] * 0x1000 + decoder[c] * 0x40 + decoder[d]
                        s = string.char(extract(v, 16, 8), extract(v, 8, 8), extract(v, 0, 8))
                        cache[v0] = s
                    end
                else
                    if decoder[a] == nil or decoder[b] == nil or decoder[c] == nil or decoder[d] == nil then
                        return nil
                    end
                    local v = decoder[a] * 0x40000 + decoder[b] * 0x1000 + decoder[c] * 0x40 + decoder[d]
                    s = string.char(extract(v, 16, 8), extract(v, 8, 8), extract(v, 0, 8))
                end
                t[k] = s
                k = k + 1
            end
            if padding == 1 then
                local a, b, c = b64:byte(n - 3, n - 1)
                local v = decoder[a] * 0x40000 + decoder[b] * 0x1000 + decoder[c] * 0x40
                t[k] = string.char(extract(v, 16, 8), extract(v, 8, 8))
            elseif padding == 2 then
                local a, b = b64:byte(n - 3, n - 2)
                local v = decoder[a] * 0x40000 + decoder[b] * 0x1000
                t[k] = string.char(extract(v, 16, 8))
            end
            return table.concat(t)
        end
    end,
    file = function(self)
        file = {}

        file.download = function(url, path, _file)
            FFI.load.win_inet.DeleteUrlCacheEntryA(url)
            FFI.load.url_mon.URLDownloadToFileA(nil, url, string.format('%s\\%s', path, _file), 0, 0)
        end
        file.create_folder = function(path, folder)
            ffi.C.CreateDirectoryA(string.format('%s\\%s', path, folder), nil)
        end
        -- file.create_file = function(path, _file)
        --     ffi.C.CreateFileA(string.format('%s\\%s', path, _file), 0xC0000000, 0x3, 0, 0x4, 0x80, nil)
        -- end
        file.create_file = function(path, _file)
            cached_func.file_write(string.format('%s\\%s', path, _file), '')
        end
        file.is_file_exists = function(path, _file)
            return FFI.load.shlw_api.PathFileExistsA(string.format('%s\\%s', path, _file))
        end
        file.add_font_resource = function(path, font)
            FFI.load.gdi32.AddFontResourceA(string.format('%s%s.ttf', path:gsub('\\', '/'), font))
        end
        file.read_files_name = function(path)
            local files = {}
            for line in io.popen('dir \"' .. path .. '\" /a /b', 'r'):lines() do
                files[#files+1] = line
            end
            return files
        end
        file.append = function(path, _file, data)
            return cached_func.file_append(string.format('%s\\%s', path, _file), data)
        end
        file.write = function(path, _file, data)
            return cached_func.file_write(string.format('%s\\%s', path, _file), data)
        end
        file.read = function(path, _file)
            return cached_func.file_read(string.format('%s\\%s', path, _file))
        end
        file.delete = function(path, _file)
            ffi.C.DeleteFileA(string.format('%s\\%s', path, _file))
        end
    end,
    config = function(self)
        config = {}

        config.load = function(path, load)
            -- print('================LOAD================')
            if load ~= 'default' and load ~= 'clipboard' then
                local cfg = file.read(orion.config, load)
                config[load] = string.to_table(base64.decode(cfg))
            end

            for _, tab_value in pairs(path) do
                for subtab, subtab_value in pairs(tab_value) do
                    for key, item in pairs(subtab_value) do
                        key = subtab..'.'..key

                        if item.type == 'checkbox' then
                            if config[load]['checkbox'][key] == nil then
                                goto proceed_checkbox
                            end

                            item:set(config[load]['checkbox'][key])
                        end; ::proceed_checkbox::

                        if item.type == 'slider' then
                            if config[load]['slider'][key] == nil then
                                goto proceed_slider
                            end

                            item:set(config[load]['slider'][key])
                        end; ::proceed_slider::

                        if item.type == 'textbox' then
                            if config[load]['textbox'][key] == nil then
                                goto proceed_textbox
                            end

                            item:set(config[load]['textbox'][key])
                        end; ::proceed_textbox::

                        if item.type == 'keybind' then
                            if config[load]['keybind'][key] == nil then
                                goto proceed_keybind
                            end
                            item.key = config[load]['keybind'][key].bind
                            item.bind_type = config[load]['keybind'][key].bind_type
                        end; ::proceed_keybind::

                        if item.type == 'colorpicker' then
                            if config[load]['colorpicker'][key] == nil then
                                goto proceed_colorpicker
                            end

                            local clr = config[load]['colorpicker'][key]
                            item:set(color.new(clr.r, clr.g, clr.b, clr.a))
                        end; ::proceed_colorpicker::

                        if item.type == 'combobox' then
                            if config[load]['combobox']['multi'][key] == nil then
                                goto proceed_combobox
                            end


                            if not item.multi then
                                item:set(config[load]['combobox']['single'][key])
                            else
                                for _, v in pairs(item.elements) do
                                    item:set(config[load]['combobox']['multi'][key][v.name], v.name)
                                end
                            end
                        end; ::proceed_combobox::

                        if item.type == 'label' then
                            if config[load]['label'] == nil then
                                goto proceed_label
                            end
                            if config[load]['label'][key] == nil then
                                goto proceed_label
                            end

                            item:set(config[load]['label'][key])
                        end; ::proceed_label::

                        if item['options'] ~= nil then -- anti aims
                            for k, v in pairs(item) do
                                k = key..'.'..k

                                if v.type == 'checkbox' then
                                    if config[load]['anti_aim_builder']['checkbox'][k] == nil then
                                        goto proceed_aa_checkbox
                                    end

                                    v:set(config[load]['anti_aim_builder']['checkbox'][k])
                                end; ::proceed_aa_checkbox::

                                if v.type == 'slider' then
                                    -- print(k, config[load]['anti_aim_builder']['slider'][k])
                                    if config[load]['anti_aim_builder']['slider'][k] == nil then
                                        goto proceed_aa_slider
                                    end

                                    v:set(config[load]['anti_aim_builder']['slider'][k])
                                end; ::proceed_aa_slider::

                                if v.type == 'combobox' then
                                    if not v.multi then
                                        if config[load]['anti_aim_builder']['single'][k] == nil then
                                            goto proceed_aa_combobox
                                        end

                                        v:set(config[load]['anti_aim_builder']['single'][k])
                                    else
                                        if config[load]['anti_aim_builder']['multi'][k] == nil then
                                            goto proceed_aa_combobox
                                        end

                                        for _, c_v in pairs(v.elements) do
                                            -- print(c_v.name, config[load]['anti_aim_builder']['multi'][k][c_v.name])
                                            v:set(config[load]['anti_aim_builder']['multi'][k][c_v.name], c_v.name)
                                        end
                                    end
                                end; ::proceed_aa_combobox::

                            end
                        end
                    end
                end

                ::proceed::
            end

            if load ~= 'clipboard' then
                path.setting.configs_system.config:set(load)
                file.write(orion.config, 'on_load.ini', load)
                popup.show({
                    'CFG',
                    'Config '..load..' loaded'
                }, 6)
            end
        end
        config.save = function(path, save)
            config[save] = {}
            -- print('================SAVE================')

            for _, tab_value in pairs(path) do
                for subtab, subtab_value in pairs(tab_value) do
                    for key, item in pairs(subtab_value) do
                        key = subtab..'.'..key

                        if item.type == 'checkbox' then
                            if config[save]['checkbox'] == nil then
                                config[save]['checkbox'] = {}
                            end
                            config[save]['checkbox'][key] = item:get()
                        end
                        if item.type == 'slider' then
                            if config[save]['slider'] == nil then
                                config[save]['slider'] = {}
                            end
                            config[save]['slider'][key] = item:get()
                        end
                        if item.type == 'textbox' then
                            if config[save]['textbox'] == nil then
                                config[save]['textbox'] = {}
                            end
                            config[save]['textbox'][key] = item:get()
                        end
                        if item.type == 'keybind' then
                            if config[save]['keybind'] == nil then
                                config[save]['keybind'] = {}
                            end
                            config[save]['keybind'][key] = {
                                bind = item.key,
                                bind_type = item.bind_type
                            }
                        end
                        if item.type == 'combobox' then
                            if config[save]['combobox'] == nil then
                                config[save]['combobox'] = {
                                    ['multi'] = {},
                                    ['single'] = {}
                                }
                            end

                            if not item.multi then
                                config[save]['combobox']['single'][key] = item:get()
                            else
                                if config[save]['combobox']['multi'][key] == nil then
                                    config[save]['combobox']['multi'][key] = {}
                                end; for _, v in pairs(item.elements) do
                                    config[save]['combobox']['multi'][key][v.name] = v.active
                                end
                            end

                        end
                        if item.type == 'colorpicker' then
                            if config[save]['colorpicker'] == nil then
                                config[save]['colorpicker'] = {}
                            end

                            config[save]['colorpicker'][key] = {
                                r = item:get().r,
                                g = item:get().g,
                                b = item:get().b,
                                a = item:get().a,
                            }
                        end
                        if item.type == 'label' then
                            if config[save]['label'] == nil then
                                config[save]['label'] = {}
                            end
                            config[save]['label'] = item:get()
                        end
                        if item['options'] ~= nil then
                            if config[save]['anti_aim_builder'] == nil then
                                config[save]['anti_aim_builder'] = {
                                    ['checkbox'] = {},
                                    ['slider'] = {},
                                    ['single'] = {},
                                    ['multi'] = {},
                                }
                            end

                            for k, v in pairs(item) do
                                k = key..'.'..k

                                if v.type == 'checkbox' then
                                    config[save]['anti_aim_builder']['checkbox'][k] = v:get()
                                end
                                if v.type == 'slider' then
                                    config[save]['anti_aim_builder']['slider'][k] = v:get()
                                end
                                if v.type == 'combobox' then
                                    if not v.multi then
                                        config[save]['anti_aim_builder']['single'][k] = v:get()
                                    else
                                        if config[save]['anti_aim_builder']['multi'][k] == nil then
                                            config[save]['anti_aim_builder']['multi'][k] = {}
                                        end; for _, c_v in pairs(v.elements) do
                                            config[save]['anti_aim_builder']['multi'][k][c_v.name] = c_v.active
                                            -- print(c_v.name, c_v.active)
                                        end

                                    end
                                end
                            end
                        end
                    end
                end
            end

            if save ~= 'default' and save ~= 'clipboard' then
                file.write(orion.config, save, base64.encode(table.to_string(config[save])))
                popup.show({
                    'CFG',
                    'Config '..save..' saved'
                }, 6)
            end
        end

        local on_load = file.read(orion.config, 'on_load.ini')
        config.on_load = 'default'

        config.files = {'default'}
        for _, v in pairs(file.read_files_name(orion.config)) do
            if v ~= 'on_load.ini' then
                table.insert(config.files, v)
                if v == on_load then
                    config.on_load = on_load
                end
            end
        end
    end,
    orion = function(self)
        orion = {}
        orion.lw = string.format('%s\\Legendware\\', os.getenv('APPDATA'))
        orion.link = {
            Orion_Club_Menu_Project = 'https://github.com/pullyfy/logins/raw/main/Orion%20Club%20Project%20Menu.ttf',
            SF_UI_Display = 'https://github.com/pullyfy/logins/raw/main/SF%20UI%20Display%20Bold.ttf',
            Museo_Sans_700 = 'https://github.com/pullyfy/logins/raw/main/Museo%20Sans%20Cyrl%20700.ttf',
        }

        if not file.is_file_exists(orion.lw, 'Orion Club') then
            file.create_folder(orion.lw, 'Orion Club')
            popup.show({
                '[FILE]',
                'Orion Club folder created'
            })
        end; orion.path = orion.lw .. 'Orion Club\\'

        if not file.is_file_exists(orion.path, 'resolver') then
            file.create_folder(orion.path, 'resolver')
            popup.show({
                '[FILE]',
                'resolver folder created'
            })
        end; orion.resolver = orion.path .. 'resolver\\'

        -- if not file.is_file_exists(orion.path, 'data')

        if not file.is_file_exists(orion.path, 'menu') then
            file.create_folder(orion.path, 'menu')
            popup.show({
                '[FILE]',
                'menu folder created'
            })
        end; orion.menu = orion.path .. 'menu\\'

        if not file.is_file_exists(orion.menu, 'configs') then
            file.create_folder(orion.menu, 'configs')
            popup.show({
                '[FILE]',
                'config folder created'
            })
        end; orion.config = orion.menu .. 'configs\\'

        if not file.is_file_exists(orion.menu, 'resources') then
            file.create_folder(orion.menu, 'resources')
            popup.show({
                '[FILE]',
                'resource folder created'
            })
        end; orion.resource = orion.menu .. 'resources\\'

        if not file.is_file_exists(orion.menu, 'scripts') then
            file.create_folder(orion.menu, 'scripts')
            popup.show({
                '[FILE]',
                'script folder created'
            })
        end; orion.script = orion.menu .. 'scripts\\'

        -- * configurations
        if not file.is_file_exists(orion.config, 'on_load.ini') then
            file.create_file(orion.config, 'on_load.ini')
            file.write(orion.config, 'on_load.ini', 'default')
            popup.show({
                '[FILE]',
                'on_load.ini file created'
            })
        end

        -- * resources
        if not file.is_file_exists(orion.resource, 'OrionClubMenuProject.ttf') then
            file.download(orion.link.Orion_Club_Menu_Project, orion.resource, 'OrionClubMenuProject.ttf')
            popup.show({
                '[FILE]',
                'OrionClubMenuProject.ttf font downloaded'
            })
        end
        if not file.is_file_exists(orion.resource, 'SFUIDisplay.ttf') then
            file.download(orion.link.SF_UI_Display, orion.resource, 'SFUIDisplay.ttf')
            popup.show({
                '[FILE]',
                'SFUIDisplay.ttf font downloaded'
            })
        end
        if not file.is_file_exists(orion.resource, 'MuseoSans700.ttf') then
            file.download(orion.link.Museo_Sans_700, orion.resource, 'MuseoSans700.ttf')
            popup.show({
                '[FILE]',
                'MuseoSans700.ttf font downloaded'
            })
        end

        do -- setup fonts
            FFI.operate.add_font_resource('SFUIDisplay')
            FFI.operate.add_font_resource('MuseoSans700')
            FFI.operate.add_font_resource('OrionClubMenuProject')
        end
    end,
    hook = function(self)
        local unload = false

        self.hk_t = {
            lock_cursor = {
                func = nil,
                lock = false,
            },
            remove_scope = {
                func = nil,
                HUDzoom = nil,
                remove = false,
            }
        }

        local hook = {
            lock_cursor = function(thisptr, edx)
                if unload then
                    self.hk_t.lock_cursor.func(thisptr, edx)
                    return
                end

                if self.hk_func.lock_cursor.lock then
                    self.hk_func.lock_cursor.func(thisptr, edx)
                    return
                end

                FFI.render.native_Surface.UnLockCursor()
            end,
            remove_scope = function(ecx, edx, panel, forcerepaint, allowforce)
                if not self.hk_t.remove_scope.HUDzoom then
                    if FFI.operate.get_VGUI_panel_name(panel) == 'HudZoom' then
                        self.hk_t.remove_scope.HUDzoom = panel
                    end
                end
                if panel == self.hk_t.remove_scope.HUDzoom and self.hk_t.remove_scope.remove then
                    return
                end

                self.hk_t.remove_scope.func(ecx, edx, panel, forcerepaint, allowforce)
            end
        }
        -- self.hk_t.remove_scope.func = FFI.VMThook.new(FFI.VGUI_Panel009_dll).hook('void*(__fastcall*)(void* ecx, void* edx, unsigned int vguipanel, bool forcerepaint, bool allowforce)', hook.remove_scope, 41)

        -- self.hk_t.unlock_cursor.func = FFI.VMThook.new(FFI.render.VGUI_Surface031):hookMethod('void(__fastcall*)(void*, void*)', hook.lock_cursor, 67)

        popup.show({
            '[Debug]',
            'Hooks(function) setuped.'
        })
    end,
    font = function(self)
        font = {}

        font.global_ui = ui.font
        font.MuseoSans700 = render.create_font('MuseoSansCyrl-700', 14, {'ANTIALIAS'})
        font.MuseoSans700_glow = render.create_font('MuseoSansCyrl-700', 14, {'NONE'}, 3)
        font.SF_UI_Display_13 = render.create_font('SF UI Display Bold', 13, {'ANTIALIAS'})
        font.Verdana12 = render.create_font('Verdana', 12)
        -- font.Verdana12_Bold = render.create_font('Calibri Bold', 16, {'OUTLINE'})
        font.KPicons_glow = render.create_font('Orion-Club-Project-Menu', 17, {'NONE'}, 3)
        font.Calibri_Bold16 = render.create_font('Calibri Bold', 16, {'OUTLINE'})
        font.Calibri_Bold14 = render.create_font('Calibri Bold', 14, {'OUTLINE'})
        font.Calibri_Bold_glow = render.create_font('Calibri Bold', 16, {'NONE'}, 3)
        font.Verdana_Bold = render.create_font('Verdana', 12, {'OUTLINE'}, 0, 900)
        font.SmallestPixel_7 = render.create_font('Smallest Pixel-7', 10, {'OUTLINE'})
    end,
    setup = function(self)
        self:global()
        self:handler()
        self:base64()
        self:file()
        self:render()
        self:popup()
        self:orion()
        self:config()
        self:key_state()
        self:drag_system()
        self:override_system()
        self:animation()
        -- self:blur()
        self:ui()
        self:font()
        self:hook()

        self.vars = {
            windowCSGO = FFI.operate.find_window('Valve001'),
            keycode = {},
            folder = string.format('%s\\Legendware\\Orion Club', os.getenv('APPDATA')),
            weapon_list = {
                ['Deagle']    = 0,
                ['Glock']     = 1,
                ['HKP2000']   = 1,
                ['P250']      = 1,
                ['Elite']     = 1,
                ['Tec9']      = 1,
                ['FiveSeven'] = 1,
                ['SCAR20']    = 2,
                ['G3SG1']     = 2,
                ['SSG08']     = 3,
                ['AWP']       = 4,
                ['AK47']      = 5,
                ['M4A1']      = 5,
                ['SG556']     = 5,
                ['Aug']       = 5,
                ['GalilAR']   = 5,
                ['Famas']     = 5,
                ['MAC10']     = 6,
                ['UMP45']     = 6,
                ['MP7']       = 6,
                ['MP9']       = 6,
                ['P90']       = 6,
                ['Bizon']     = 6,
                ['NOVA']      = 7,
                ['XM1014']    = 7,
                ['Sawedoff']  = 7,
                ['Mag7']      = 7,
                ['M249']      = 8,
                ['Negev']     = 8,
            },
            desync_choke = {},
            air_tick = 0,
        }

        self.player_is_scoped = function(player)
            return player:get_prop_int('CCSPlayer', 'm_bIsScoped') == 1
        end
        self.remove_scope_overlay = function(remove)
            self.hk_t.remove_scope.remove = remove
        end
        self.get_condition = function()
            local local_player = entitylist.get_local_player()
            if not local_player then
                return
            end

            local flag = local_player:get_prop_int('CBasePlayer', 'm_fFlags')

            local info = {
                slow_walk = menu.get_key_bind_state('misc.slow_walk_key'),
                ducked   = local_player:get_prop_bool('CBasePlayer', 'm_bDucked'),
                speed    = local_player:get_velocity():length_2d(),
                -- in_air   = flag == 256 or flag == 262,
                -- LegitAA =  menu.get_key_bind_state('Legit Anti-Aim'),
                -- Roll = menu.get_key_bind_state('Enable Roll')
            }

            if flag == 256 or flag == 262 then
                info.in_air = true
                self.vars.air_tick = globals.get_tickcount() + 3
            else
                info.in_air = (self.vars.air_tick > globals.get_tickcount()) and true or false
            end

            -- if Info.LegitAA then
            --     return 'USING'
            -- end

            -- if Info.Roll then
            --     return 'ROLL'
            -- end

            if info.in_air and info.ducked then
                return 'AIR-C'
            end

            if info.in_air then
                return 'AIR'
            end

            if info.ducked then
                return 'CROUCH'
            end

            if info.slow_walk then
                return 'SLOWWALK'
            end

            if info.speed < 8 then
                return 'STAND'
            else
                return 'WALK'
            end
        end
        self.get_binds = function(path_b, animation_speed)
            local bind_t = {}

            for k, v in pairs(path_b) do
                if k == 'counter' then
                    goto proceed
                end

                if type(v.path) == 'table' then
                    v.active = v.path:get()
                else
                    v.active = menu.get_key_bind_state(v.path)
                end -- v.active = type(v.path) == 'table' and v.path:get() or menu.get_key_bind_state(v.path)

                v.anim = animation.on_enable(string.format('visual.keybinds.%s', v.name), v.active, animation_speed or 0.05)
                v.secondary = 'on' do -- values proccesing
                    if v.name == 'Damage override' then
                        local local_player = entitylist.get_local_player()
                        if not local_player then
                            goto proceed
                        end

                        local weapon = self.vars.weapon_list[self.get_active_weapon(local_player)]
                        if weapon == nil then
                            v = nil
                            goto proceed
                        end

                        local damage = menu.get_int(string.format('rage.weapon[%s].%s', weapon, menu.get_key_bind_state('rage.force_damage_key') and 'force_damage_value' or 'minimum_damage'))
                        v.secondary = tostring(damage)
                    end
                end

                if v.anim then
                    if not v.stamp then
                        if path_b.counter == nil then
                            path_b.counter = 0
                        end
                        path_b.counter = path_b.counter + 1
                        v.stamp = path_b.counter
                    end
                else
                    v.stamp = nil
                end

                table.insert(bind_t, {
                    name = v.name,
                    anim = v.anim or 0,
                    active = v.active,
                    secondary = v.secondary,
                    stamp = v.stamp or 0
                })

                ::proceed::
            end

            table.sort(bind_t, function(a, b)
                return (a.stamp > b.stamp)
            end)

            return bind_t
        end
        self.get_active_weapon = function(player)
            local weapon = entitylist.get_weapon_by_player(player)
            if not weapon then return end

            weapon = weapon:get_class_name():gsub('CWeapon', ''):gsub('CDE', 'De'):gsub('CAK', 'AK'):gsub('CK', 'K'):gsub('CHEGrenade', 'HE'):gsub('CSmokeGrebade', 'Smoke'):gsub('CDecoyGrenade', 'Decoy'):gsub('CFlashbang', 'FlashBang'):gsub('CMolotovGrenade', 'Molotov'):gsub('CIncendiaryGrenade', 'Molotov')

            return weapon
        end
        self.get_ping = function()
            if not engine.is_in_game() then
                return 'offline'
            end

            if globals.get_server_address() == 'Local server' then
                return 'local'
            end

            return globals.get_ping() .. 'ms'
        end
        self.get_animation_state = function(entity)
            return ffi.cast('struct c_animstate**', FFI.get_entity_address(entity:get_index()) + 0x9960)[0]
        end
        self.get_animation_layers = function(entity, layer)
            return ffi.cast('struct animation_layer_t**', FFI.get_entity_address(entity:get_index()) + 0x2990)[0][layer]
        end
        self.get_desync = function(player)
            if self.vars.desync_choke[player:get_index()] == nil then
                self.vars.desync_choke[player:get_index()] = {
                    FeetYaw = 0,
                    EyeYaw = 0,
                }
            end

            if engine.get_INet_channel() == nil then
                return
            end; if engine.get_INet_channel().m_nChokedPackets == 0 then
                self.vars.desync_choke[player:get_index()].FeetYaw = math.normalize(self.get_animation_state(player).flGoalFeetYaw)
                self.vars.desync_choke[player:get_index()].EyeYaw = self.get_animation_state(player).flEyeYaw
            end

            local FeetYaw = self.vars.desync_choke[player:get_index()].FeetYaw
            local EyeYaw = self.vars.desync_choke[player:get_index()].EyeYaw

            local Angle = EyeYaw - FeetYaw

            if EyeYaw <= -122 and FeetYaw >= 0 then
                Angle = 360 + Angle
            end
            if EyeYaw >= 122 and FeetYaw <= 0 then
                Angle = 360 - Angle
                Angle = -Angle
            end

            return math.round(math.clamp(Angle, -57.4, 57.4), 1)
        end
        self.defensive = {}; do
            self.defensive.tick = 0
            self.defensive.duration = 0
            self.defensive.old_simtime = 0

            self.defensive.update = function()
                local local_player = entitylist.get_local_player()
                if not local_player then
                    return
                end

                local simtime = local_player:get_prop_float('CBasePlayer', 'm_flSimulationTime')
                local delta = self.defensive.old_simtime - simtime

                if delta > 0 then
                    self.defensive.tick = globals.get_tickcount();
                    self.defensive.duration = math.to_ticks(delta);
                end

                self.defensive.old_simtime = simtime
            end
            self.defensive.get = function()
                return globals.get_tickcount() < (self.defensive.tick + self.defensive.duration)
            end
            self.defensive.reset = function()
                self.defensive.tick = 0
                self.defensive.duration = 0
                self.defensive.old_simtime = 0
            end

            local reseted = false; table.insert(self._function, function()
                if not engine.is_connected() or not engine.is_in_game() then
                    if not reseted then
                        self.defensive.reset()
                        reseted = true
                    end
                else
                    reseted = false
                end
            end)

            client.add_callback('net_update_end', function()
                self.defensive.update()
            end)
        end
    end
}; assistant:setup()


local script = {
    menu = function(self)
        self.menu = {}

        self.menu.rage = {
            general = {
                tweaks = ui.combobox('rage', 'General', 'Tweaks', true, {'Reduce on shot'})
            }
        }
        self.menu.aa = {
            general = {
                enable = ui.checkbox('anti-aim', 'General', 'Enable', true),
                tweaks = ui.combobox('anti-aim', 'General', 'Tweaks', true, {'Anti-BackStab'}),
                legit_aa = ui.keybind('anti-aim', 'General', 'Legit Anti-Aim', 'e', 'hold'),
                freestand = ui.keybind('anti-aim', 'General', 'Freestand'),
                edge_yaw = ui.keybind('anti-aim', 'General', 'Edge yaw'),
            },
            anti_aim = {
                condition = ui.combobox('anti-aim', 'Anti-Aim Builder', 'Condition', false, {'Global', 'Stand', 'Walk', 'Slow Walk', 'Air', 'Crouch', 'Crouch Air', 'Defensive'})
            },
        }
        self.menu.visual = {
            windows = {
                type_w = ui.combobox('visual', 'General', 'Windows', true, {'Watermark', 'Keybinds', 'Indicators'}),
                accent = ui.colorpicker('visual', 'General', 'Accent', color.new(150, 0, 255)),
                watermark_text = ui.textbox('visual', 'General', 'Watermark text', 'orion'),
                indicator_color = ui.colorpicker('visual', 'General', 'Indicator Inverted'),
                bind_pos_x = ui.label('visual', 'General', '0'),
                bind_pos_y = ui.label('visual', 'General', '0'),
            },
            -- other = {
            --     custom_scope = ui.combobox('visual', 'Other', 'Custom Scope', false, {'none', 'default'}),
            --     custom_scope_clr = ui.colorpicker('visual', 'Other', 'Custom Scope Color'),
            -- }
        } -- ; self.menu.visual.windows.test:set(true, 'second')
        self.menu.misc = {
            general = {
                logs = ui.combobox('misc', 'General', 'Logs output', true, {'Console', 'On Left'})
            },
        }
        self.menu.setting = {
            configs_system = {
                config = ui.combobox('setting', 'Configs System', 'Config', false, config.files),
                name = ui.textbox('setting', 'Configs System', 'Name'),

                load = ui.button('setting', 'Configs System', 'load'),
                save = ui.button('setting', 'Configs System', 'save'),

                refresh = ui.button('setting', 'Configs System', 'refresh'),

                create = ui.button('setting', 'Configs System', 'create'),
                delete = ui.button('setting', 'Configs System', 'delete'),

                import = ui.button('setting', 'Configs System', 'clipboard: import'),
                export = ui.button('setting', 'Configs System', 'clipboard: export'),
            },
            customize = {
                accent = ui.colorpicker('setting', 'Customize', 'Accent', ui.color.accent),
                background = ui.colorpicker('setting', 'Customize', 'Menu background', ui.color.background),
                subtab_background = ui.colorpicker('setting', 'Customize', 'Child background', ui.color.subtab_background),
                tabBG = ui.colorpicker('setting', 'Customize', 'Tab background', ui.color.tab_background),
                elementBG = ui.colorpicker('setting', 'Customize', 'Element background', ui.color.secondary),
                nameText = ui.colorpicker('setting', 'Customize', 'Element name', ui.color.name_text),
                someElements = ui.colorpicker('setting', 'Customize', 'Element parts', ui.color.some_elements),
                someTextElements = ui.colorpicker('setting', 'Customize', 'Element text parts', ui.color.some_text_elements),
                tabText = ui.colorpicker('setting', 'Customize', 'Tab Icon', ui.color.tab_icon),
                division = ui.colorpicker('setting', 'Customize', 'Division', ui.color.division),
                animation_speed = ui.slider('setting', 'Customize', 'Anim speed', false, 50, 1, 100),
                func_animation_speed = ui.slider('setting', 'Customize', 'Func anim speed', false, 50, 1, 100),
                theme = ui.combobox('setting', 'Customize', 'Theme', false, {'Orion', 'Aqua', 'Brand Orange'}),
                update = ui.button('setting', 'Customize', 'Theme Update')
            },
            interaction = {
                open_on_cheat = ui.checkbox('setting', 'Interaction', 'Open with LW menu', true),
                open_menu = ui.keybind('setting', 'Interaction', 'Open on key', 'ins', 'toggle'),
            },
        } --; self.menu.setting.customize.update:set(true)
        self.menu.script = {
            soon = {
                soon = ui.label('script', 'Soon', 'soon...')
            }
        }

        do
            self.menu.visual.windows.bind_pos_x:set_visible(false)
            self.menu.visual.windows.bind_pos_y:set_visible(false)
        end

        do -- add menu anti-aim conditions
            for _, v in pairs({'Global', 'Stand', 'Walk', 'Slow Walk', 'Air', 'Crouch', 'Crouch Air', 'Defensive'}) do
                if self.menu.aa.anti_aim[v] == nil then
                    self.menu.aa.anti_aim[v] = {
                        override = ui.checkbox('anti-aim', 'Anti-Aim Builder', 'Override '..v),
                        yaw_base = ui.combobox('anti-aim', 'Anti-Aim Builder', 'Yaw Base', false, {'Local View', 'At Targets'}),
                        pitch = ui.combobox('anti-aim', 'Anti-Aim Builder', 'Pitch', false, {'None', 'Down', 'Up'}, 'Down'),
                        yaw_add_left = ui.slider('anti-aim', 'Anti-Aim Builder', 'Yaw Add Left', false, 0, -180, 180),
                        yaw_add_right = ui.slider('anti-aim', 'Anti-Aim Builder', 'Yaw Add Right', false, 0, -180, 180),
                        yaw_modifier_type = ui.combobox('anti-aim', 'Anti-Aim Builder', 'Yaw Modifier Base', false, {'Center', 'Offset'}),
                        yaw_modifier = ui.slider('anti-aim', 'Anti-Aim Builder', 'Yaw Modifier', false, 0, -180, 180),
                        desync_left = ui.slider('anti-aim', 'Anti-Aim Builder', 'Desync Left', false, 60, 0, 60),
                        desync_right = ui.slider('anti-aim', 'Anti-Aim Builder', 'Desync Right', false, 60, 0, 60),
                        options = ui.combobox('anti-aim', 'Anti-Aim Builder', 'Options', true, {'Jitter'}), -- {'Jitter', 'Freestand', 'Anti-Brute'}
                        jitter_speed_adjust = ui.slider('anti-aim', 'Anti-Aim Builder', 'Jitter Speed Adjust', false, 1, 1, 18),
                        yaw_speed_adjust = ui.slider('anti-aim', 'Anti-Aim Builder', 'Yaw Speed Adjust', false, 1, 1, 18),
                        -- speed_adjust_on = ui.checkbox('anti-aim', 'Anti-Aim Builder', 'Enable speed adjust')

                        -- option_jitter_speed_adjust = ui.
                        -- on_shot = ui.combobox('anti-aim', 'Anti-Aim Builder', 'On Shot', false, {'None', 'Same', 'Reversed'})
                    }
                end
            end

            self.menu.aa.anti_aim['Global'].override:set(true)
            self.menu.aa.anti_aim['Global'].override:set_visible(false)
        end

        do -- save default config and load startup config
            config.save(self.menu, 'default')
            config.load(self.menu, config.on_load)
        end
    end,
    var = function(self)
        self.var = {
            func_animation_speed = 0.05,
            screen = {
                x = engine.get_screen_width(),
                y = engine.get_screen_height(),
            },
            choked = false,
            choke = 0,
            is_AntiBackStab_work = false,
            override_legit_aa = false,
            stamp_reduce_on_shot = 0,
            keybinds = {
                paths = {
                    {
                        name = 'Double tap',
                        path = 'rage.double_tap_key',
                    },
                    {
                        name = 'Hide shots',
                        path = 'rage.hide_shots_key',
                    },
                    {
                        name = 'Slow walk',
                        path = 'misc.slow_walk_key',
                    },
                    {
                        name = 'Auto peek',
                        path = 'misc.automatic_peek_key',
                    },
                    {
                        name = 'Fake duck',
                        path = 'anti_aim.fake_duck_key',
                    },
                    {
                        name = 'Edge jump',
                        path = 'misc.edge_jump_key',
                    },
                    {
                        name = 'Damage override',
                        path = 'rage.force_damage_key',
                    },
                    {
                        name = 'Yaw forward',
                        path = 'anti_aim.manual_forward_key',
                    },
                    {
                        name = 'Yaw left',
                        path = 'anti_aim.manual_left_key',
                    },
                    {
                        name = 'Yaw right',
                        path = 'anti_aim.manual_right_key',
                    },
                    {
                        name = 'Yaw back',
                        path = 'anti_aim.manual_back_key',
                    },
                    {
                        name = 'Aim',
                        path = 'legit.enable_key',
                    },
                    {
                        name = 'Auto wall',
                        path = 'legit.automatic_wall_key',
                    },
                    {
                        name = 'Auto fire',
                        path = 'legit.automatic_fire_key',
                    },
                    {
                        name = 'Legit anti-aim',
                        path = self.menu.aa.general.legit_aa
                    },
                    {
                        name = 'Yaw freestand',
                        path = self.menu.aa.general.freestand
                    },
                },
                anim = {
                    gap = {},
                    max_width = 0,
                },
            },
            indicators = {
                paths = { -- dt hs dmg freestand fakeduck auto peek
                    {
                        name = 'DT',
                        path = 'rage.double_tap_key',
                    },
                    {
                        name = 'HS',
                        path = 'rage.hide_shots_key',
                    },
                    {
                        name = 'FS',
                        path = self.menu.aa.general.freestand,
                    },
                    {
                        name = 'FD',
                        path = 'anti_aim.fake_duck_key',
                    },
                    {
                        name = 'AP',
                        path = 'misc.automatic_peek_key',
                    },
                    {
                        name = 'DMG',
                        path = 'rage.force_damage_key',
                    },
                }
            },
            logs_handler = {},
            edge_yaw = {
                start = vector.new(0, 0, 0),
                is_working = false,
            }
        }
    end,
    on_paint = function(self)
        self.on_paint = {
            customize_and_interaction = function()
                -- local theme = self.menu.setting.customize.theme:get()
                local theme = {
                    type = self.menu.setting.customize.theme:get(),
                    update = self.menu.setting.customize.update:get(),
                    orion = {

                    }
                }
                if theme.update then
                    if theme.type == 'Orion' then
                        self.menu.setting.customize.accent:set(color.new(150, 0, 255))
                        self.menu.setting.customize.background:set(color.new(10, 10, 25))
                        self.menu.setting.customize.subtab_background:set(color.black())
                        self.menu.setting.customize.tabBG:set(color.new(25, 25, 40))
                        self.menu.setting.customize.elementBG:set(color.new(30, 30, 45))
                        self.menu.setting.customize.nameText:set(color.new(255, 255, 255))
                        self.menu.setting.customize.someElements:set(color.white())
                        self.menu.setting.customize.someTextElements:set(color.white())
                        self.menu.setting.customize.tabText:set(color.white())
                        self.menu.setting.customize.division:set(color.new(100, 90, 150))
                    elseif theme.type == 'Aqua' then
                        self.menu.setting.customize.accent:set(color.new(0, 185, 255))
                        self.menu.setting.customize.background:set(color.new(0, 56, 77))
                        self.menu.setting.customize.subtab_background:set(color.new(0, 76, 96))
                        self.menu.setting.customize.tabBG:set(color.new(0, 76, 96))
                        self.menu.setting.customize.elementBG:set(color.new(80, 134, 155))
                        self.menu.setting.customize.nameText:set(color.new(158, 228, 255))
                        self.menu.setting.customize.someElements:set(color.new(158, 228, 255))
                        self.menu.setting.customize.someTextElements:set(color.new(158, 228, 255))
                        self.menu.setting.customize.tabText:set(color.new(158, 228, 255))
                        self.menu.setting.customize.division:set(color.new(158, 228, 255))
                    elseif theme.type == 'Brand Orange' then
                        self.menu.setting.customize.accent:set(color.new(255, 139, 0))
                        self.menu.setting.customize.background:set(color.new(42, 42, 42))
                        self.menu.setting.customize.subtab_background:set(color.new(53, 53, 53))
                        self.menu.setting.customize.tabBG:set(color.new(53, 53, 53))
                        self.menu.setting.customize.elementBG:set(color.new(69, 69, 69))
                        self.menu.setting.customize.nameText:set(color.new(255, 234, 209))
                        self.menu.setting.customize.someElements:set(color.new(255, 234, 209))
                        self.menu.setting.customize.someTextElements:set(color.new(255, 234, 209))
                        self.menu.setting.customize.tabText:set(color.new(255, 234, 209))
                        self.menu.setting.customize.division:set(color.new(255, 139, 0))
                    -- elseif theme.type == '' then
                    --     self.menu.setting.customize.accent:set()
                    --     self.menu.setting.customize.background:set()
                    --     self.menu.setting.customize.subtab_background:set()
                    --     self.menu.setting.customize.tabBG:set()
                    --     self.menu.setting.customize.elementBG:set()
                    --     self.menu.setting.customize.nameText:set()
                    --     self.menu.setting.customize.someElements:set()
                    --     self.menu.setting.customize.someTextElements:set()
                    --     self.menu.setting.customize.tabText:set()
                    --     self.menu.setting.customize.division:set()
                    end
                end

                ui.color.accent             = self.menu.setting.customize.accent:get()
                ui.color.background         = self.menu.setting.customize.background:get()
                ui.color.subtab_background  = self.menu.setting.customize.subtab_background:get()
                ui.color.tab_background     = self.menu.setting.customize.tabBG:get()
                ui.color.secondary          = self.menu.setting.customize.elementBG:get()
                ui.color.some_elements      = self.menu.setting.customize.someElements:get()
                ui.color.some_text_elements = self.menu.setting.customize.someTextElements:get()
                ui.color.name_text          = self.menu.setting.customize.nameText:get()
                ui.color.tab_icon           = self.menu.setting.customize.tabText:get()
                ui.color.division           = self.menu.setting.customize.division:get()

                ui.animation.speed = self.menu.setting.customize.animation_speed:get() / 1000
                self.var.func_animation_speed = self.menu.setting.customize.func_animation_speed:get() / 1000

                self.menu.setting.interaction.open_menu:set_visible(not self.menu.setting.interaction.open_on_cheat:get())

                -- print(self.menu.setting.interaction.open_menu:get())
                if self.menu.setting.interaction.open_on_cheat:get() then
                    ui.show = menu.get_visible()
                else
                    ui.show = self.menu.setting.interaction.open_menu:get()
                end
            end,
            windows_render = function()
                local anim = {} do
                    anim.keybind = animation.on_enable('visual.keybind', self.menu.visual.windows.type_w:get('Keybinds'), self.var.func_animation_speed)
                    anim.watermark = animation.on_enable('visual.watermark', self.menu.visual.windows.type_w:get('Watermark'), self.var.func_animation_speed)
                    anim.indicators = animation.on_enable('visual.indicators', self.menu.visual.windows.type_w:get('Indicators'), self.var.func_animation_speed)
                end

                local binds = {}; do
                    binds.color = self.menu.visual.windows.accent:get()
                    binds.table = assistant.get_binds(self.var.keybinds.paths, self.var.func_animation_speed)
                    if anim.keybind ~= false then
                        local pos = assistant.drag_object_setup('Binds', {
                            x = tonumber(self.menu.visual.windows.bind_pos_x:get()),
                            y = tonumber(self.menu.visual.windows.bind_pos_y:get()),
                            w = 70,
                            h = 20
                        }); local width = 70; local is_active = false

                        self.menu.visual.windows.bind_pos_x:set(tostring(assistant.get_drag_object('Binds').x))
                        self.menu.visual.windows.bind_pos_y:set(tostring(assistant.get_drag_object('Binds').y))

                        for _, v in pairs(binds.table) do
                            if v.active then
                                local size = render.get_text_size(font.MuseoSans700, string.format('%s', v.name)).x + 12 + 28 + 5
                                if size > width then
                                    width = size
                                end
                                is_active = true
                            end
                        end; self.var.keybinds.anim.max_width = math.lerp(self.var.keybinds.anim.max_width, width, self.var.func_animation_speed)

                        for i, v in pairs(binds.table) do
                            if v.anim > 0.01 then
                                if self.var.keybinds.anim.gap[v.name] == nil then
                                    self.var.keybinds.anim.gap[v.name] = 0
                                end; self.var.keybinds.anim.gap[v.name] = math.lerp(self.var.keybinds.anim.gap[v.name], (i) * 15, self.var.func_animation_speed)

                                render.draw_text(font.MuseoSans700, pos.x + 5, (pos.y + 23) + self.var.keybinds.anim.gap[v.name] - 15, color.new(255, 255, 255, 255 * v.anim * anim.keybind), v.name)
                                render.draw_text(font.MuseoSans700, pos.x + self.var.keybinds.anim.max_width - render.get_text_size(font.MuseoSans700, v.secondary).x - 5, (pos.y + 23) + self.var.keybinds.anim.gap[v.name] - 15, color.new(255, 255, 255, 255 * v.anim * anim.keybind), v.secondary)
                            else; self.var.keybinds.anim.gap[v.name] = 0; end
                        end; anim.keybind_is_active = animation.on_enable('visual.keybind.on_active', is_active or ui.show, self.var.func_animation_speed)

                        if anim.keybind_is_active == false then
                            goto proceed
                        end

                        render.draw_rect_filled(pos.x, pos.y, self.var.keybinds.anim.max_width, pos.h, color.new(10, 10, 25, 180 * anim.keybind_is_active * anim.keybind), 3)
                        render.draw_text(ui.icon.KPicons, pos.x + 7, pos.y + pos.h / 2 + 1, color.mod_a(binds.color, 255 * anim.keybind_is_active * anim.keybind), 'K', {false, true})
                        render.draw_text(font.KPicons_glow, pos.x + 7, pos.y + pos.h / 2 + 1, color.mod_a(binds.color, 255 * anim.keybind_is_active * anim.keybind * (binds.color.a / 255)), 'K', {false, true})
                        -- font.KPicons_glow
                        render.draw_text(font.MuseoSans700, pos.x + 40 + 5, pos.y + pos.h / 2 + 1, color.new(255, 255, 255, 255 * anim.keybind_is_active * anim.keybind), 'binds', {true, true})

                        ::proceed::
                    end
                end

                local watermark = {}; do
                    watermark.color = self.menu.visual.windows.accent:get()
                    self.menu.visual.windows.watermark_text:set_visible(self.menu.visual.windows.type_w:get('Watermark'))
                    watermark.text = self.menu.visual.windows.watermark_text:get()

                    if anim.watermark ~= false then
                        local dev = globals.get_username() == 'pullyfy'
                        local text = {string.format('%s%s', watermark.text, dev and ' [dev]' or ''), globals.get_username(), assistant.get_ping(), os.date('%H:%M')}
                        text = table.concat(text, '  ')
                        local size = render.get_text_size(font.MuseoSans700, text).x

                        local pos = {
                            x = self.var.screen.x - 7,
                            y = 7,
                            w = size + 7 * 2,
                            h = 20,
                        }

                        render.draw_rect_filled(pos.x - pos.w, pos.y, pos.w, pos.h, color.new(10, 10, 25, 180 * anim.watermark), 3)

                        -- # developer club
                        if dev then
                            render.draw_text(font.MuseoSans700_glow, pos.x - pos.w + 39, pos.y + pos.h / 2, color.hsv2rgb({h = globals.get_tickcount() % 100 / 100, s = 1, v = 1, a = 255 * anim.watermark}), '[dev]', {false, true})
                        end

                        render.draw_text(font.MuseoSans700_glow, pos.x - pos.w + 7, pos.y + pos.h / 2, color.mod_a(watermark.color, 255 * anim.watermark * (watermark.color.a / 255)), watermark.text, {false, true}) -- orion glowed
                        render.draw_text(font.MuseoSans700, pos.x - pos.w + 7, pos.y + pos.h / 2, color.new(255, 255, 255, 255 * anim.watermark), text, {false, true})
                    end
                end

                local indicators = {}; do
                    indicators.color = self.menu.visual.windows.accent:get()
                    indicators.color_inverted = self.menu.visual.windows.indicator_color:get()
                    indicators.table = assistant.get_binds(self.var.indicators.paths, self.var.func_animation_speed)

                    self.menu.visual.windows.indicator_color:set_visible(self.menu.visual.windows.type_w:get('Indicators'))

                    if anim.indicators ~= false then
                        local lp = entitylist.get_local_player()
                        if not lp then
                            return
                        end; local is_scoped = animation.new('visual.indicators.on_scope', assistant.player_is_scoped(lp) and 1 or 0, assistant.player_is_scoped(lp) and 1 or 0, self.var.func_animation_speed, true)

                        local pos = {
                            x = self.var.screen.x / 2 + is_scoped * 40,
                            y = self.var.screen.y / 2 + 15,
                        }

                        local side = false; local desync = assistant.get_desync(lp); if desync ~= nil then
                            side = desync > 0
                        end

                        local col1 = animation.new('visual.indicators.side', side and indicators.color or indicators.color_inverted, side and indicators.color or indicators.color_inverted, self.var.func_animation_speed)
                        local col2 = animation.new('visual.indicators.side_inverted', side and indicators.color_inverted or indicators.color, side and indicators.color_inverted or indicators.color, self.var.func_animation_speed)

                        render.draw_gradient_text(font.Calibri_Bold_glow, pos.x, pos.y, 'orion club', color.mod_a(col1, 255 * anim.indicators * (indicators.color.a / 255)), color.mod_a(col2, 255 * anim.indicators * (indicators.color.a / 255)), {true})
                        render.draw_gradient_text(font.Calibri_Bold16, pos.x, pos.y, 'orion club', color.mod_a(col1, 255 * anim.indicators), color.mod_a(col2, 255 * anim.indicators), {true})

                        render.draw_text(font.Verdana_Bold, pos.x, pos.y + 13, color.new(255, 255, 255, 255 * anim.indicators), assistant.get_condition():lower(), {true})

                        for i, v in pairs(indicators.table) do
                            -- if v.active
                            if v.anim > 0.01 then
                                local gap = (i - 1) * 8
                                render.draw_text(font.SmallestPixel_7, pos.x, pos.y + 24 + gap, color.new(200, 200, 200, 255 * v.anim * anim.indicators), v.name, {true})
                            end
                        end
                    end
                end
            end,
            logs_handler = function()
                local anim = {} do
                    anim.on_screen = animation.on_enable('misc.logs', self.menu.misc.general.logs:get('On Left'), self.var.func_animation_speed)
                end

                local logs = {} do
                    if anim.on_screen ~= false then
                        table.sort(self.var.logs_handler, function (a, b)
                            return (a.stamp > b.stamp)
                        end)

                        for i, v in pairs(self.var.logs_handler) do
                            if v.anim == nil or v.anim_exit == nil then
                                v.anim = 0
                                v.anim_exit = 0
                            end

                            if v.stamp <= globals.get_curtime() then
                                v.anim_exit = math.lerp(v.anim_exit, 1, self.var.func_animation_speed, true)
                            end; v.anim = math.lerp(v.anim, v.stamp >= globals.get_curtime() and (i < 6 and 1 or 0) or 0, self.var.func_animation_speed, true)

                            if v.anim < 0.01 then
                                table.remove(self.var.logs_handler, i)
                            end

                            local size = render.get_multi_text_size(font.Verdana12, v.content); local pos = {
                                x = 0 - v.anim_exit * 100,
                                y = self.var.screen.y / 2,
                                w = size.x + 8,
                                h = 15,
                            }

                            local gap = i * 40; if v.gap == nil then
                                v.gap = 0
                            end; v.gap = math.lerp(v.gap, gap, 0.05)
                            gap = v.gap

                            if i == 2 then gap = gap + 7 end
                            if i == 4 then gap = gap - 7 end

                            local radius = 60
                            local degree = math.rad(120 - gap)

                            pos.x = pos.x + (math.cos(degree) * radius)
                            pos.y = pos.y + (math.sin(degree) * radius)

                            local fix = 14
                            if i == 2 then fix = 16 end
                            if i == 5 then fix = 16 end

                            render.draw_rect_filled(math.round((pos.x - 3)), math.round(pos.y + size.y / 2 - 16), pos.w, pos.h, color.new(20, 20, 20, 150 * v.anim * anim.on_screen), 3)
                            render.draw_multi_text(font.Verdana12, math.round(pos.x + 1), math.round(pos.y - fix), v.content, 255 * v.anim * anim.on_screen, {false, true})
                        end
                    end
                end
            end,
            UI_visible_management = function()
                do -- Anti-Aim Builder
                    local menu_condition = self.menu.aa.anti_aim.condition:get()

                    for k, v in pairs(self.menu.aa.anti_aim) do
                        if k ~= 'condition' then
                            for var_name, item in pairs(v) do
                                if k == 'Global' and var_name == 'override' then
                                    item:set(true)
                                    goto proceed
                                end

                                -- item:set_visible(v.override:get() and k == menu_condition)
                                if v.override:get() and k == menu_condition then
                                    item:set_visible(true)

                                    v.jitter_speed_adjust:set_visible(v.options:get('Jitter'))
                                else
                                    item:set_visible(false)
                                end
                                -- options
                                -- jitter_speed_adjust
                                ::proceed::
                            end
                            if k ~= 'Global' and k == menu_condition then
                                v.override:set_visible(true)
                            end
                        end
                    end
                end
            end,
            config_system = function()
                local option = {
                    config = self.menu.setting.configs_system.config,
                    name   = self.menu.setting.configs_system.name,

                    load  = self.menu.setting.configs_system.load,
                    save  = self.menu.setting.configs_system.save,

                    refresh = self.menu.setting.configs_system.refresh,

                    create = self.menu.setting.configs_system.create,
                    delete = self.menu.setting.configs_system.delete,

                    import = self.menu.setting.configs_system.import,
                    export = self.menu.setting.configs_system.export,
                }

                if option.load:get() then
                    config.load(self.menu, option.config:get_active_name())

                end; if option.save:get() then
                    if option.config:get_active_name() == 'default' then
                        popup.show({
                            'CFG',
                            'Restricted to save default config'
                        }, 6)
                        return
                    end

                    config.save(self.menu, option.config:get_active_name())
                end

                if option.create:get() then
                    for _, v in pairs(file.read_files_name(orion.config)) do
                        if v == option.name:get() then
                            -- print('This config already exists.')
                            popup.show({
                                'CFG',
                                'This config '..option.name:get()..' already exists.'
                            }, 6)
                            return
                        end
                    end
                    if option.name:get() == '' then
                        popup.show({
                            'CFG',
                            'Restricted to save nil config'
                        }, 6)
                        return
                    end
                    self.menu.setting.configs_system.config:add_to(option.name:get(), false)

                    file.create_file(orion.config, option.name:get())
                    file.write(orion.config, option.name:get(), base64.encode(table.to_string(config['default'])))

                    popup.show({
                        'CFG',
                        'Config '..option.name:get()..' created'
                    }, 6)

                    self.menu.setting.configs_system.name:set('')
                end; if option.delete:get() and option.config:get_active_name() ~= 'default' then
                    config[option.config:get_active_name()] = nil

                    file.delete(orion.config, option.config:get_active_name())
                    popup.show({
                        'CFG',
                        'Config '..option.config:get_active_name()..' deleted'
                    }, 6)

                    self.menu.setting.configs_system.config:delete(option.config:get_active_name())
                    self.menu.setting.configs_system.config:set('default')
                    file.write(orion.config, 'on_load.ini', 'default')
                end

                if option.refresh:get() then
                    self.menu.setting.configs_system.config:set('default')
                    for _, v in pairs(option.config.elements) do
                        if v.name ~= 'default' then
                            self.menu.setting.configs_system.config:delete(v.name)
                        end
                    end

                    for _, v in pairs(file.read_files_name(orion.config)) do
                        if v ~= 'on_load.ini' then
                            self.menu.setting.configs_system.config:add_to(v)
                        end
                    end

                    popup.show({
                        'CFG',
                        'Configs refreshed'
                    }, 6)
                end

                if option.import:get() then
                    local raw = clipboard.get(); if not raw:find('orion_config:') then
                        return popup.show({
                            'CFG',
                            'Invalid config (raw)'
                        })
                    end; raw = clipboard.get():gsub('orion_config:', '')

                    local decoded = base64.decode(raw); if decoded == nil then
                        return popup.show({
                            'CFG',
                            'Invalid config (decoded)'
                        })
                    end

                    config['clipboard'] = string.to_table(decoded); popup.show({
                        'CFG',
                        'Config imported'
                    }, 6); config.load(self.menu, 'clipboard')

                    config['clipboard'] = nil
                end; if option.export:get() then
                    clipboard.set('orion_config:'..base64.encode(table.to_string(config[option.config:get_active_name()])))
                    popup.show({
                        'CFG',
                        'Config '..option.config:get_active_name()..' exported'
                    }, 6)
                end
            end
            -- custom_scope = function()
            --     local anim = animation.on_enable('visual.custom_scope', self.menu.visual.other.custom_scope:get() == 'default', self.var.func_animation_speed)

            --     if not anim then
            --         assistant.remove_scope_overlay(false)
            --         return
            --     end
            --     assistant.remove_scope_overlay(true)

            --     local local_player = entitylist.get_local_player()
            --     if not local_player then return end

            --     local pos = {
            --         x = self.var.screen.x / 2,
            --         y = self.var.screen.y / 2,
            --         length = animation.new('visual.custom_scope.lines', 0, local_player:is_scoped() and 100 or 0, self.var.func_animation_speed),
            --         gap = 15
            --     }
            --     local clr = self.menu.visual.other.custom_scope_clr:get()

            --     render.draw_gradient_rect_filled(pos.x + pos.gap, pos.y, pos.length, 1, clr, color._nil(), true) -- right
            --     render.draw_gradient_rect_filled(pos.x - pos.gap - pos.length, pos.y, pos.length, 1, color._nil(), clr, true) -- left

            --     render.draw_gradient_rect_filled(pos.x, pos.y + pos.gap, 1, pos.length, clr, color._nil(), false) -- down
            --     render.draw_gradient_rect_filled(pos.x, pos.y - pos.gap - pos.length, 1, pos.length, color._nil(), clr, false) -- up
            -- end,
        }

        client.add_callback('on_paint', function()
            for _, func in pairs(self.on_paint) do
                func()
            end
        end)
    end,
    create_move = function(self)
        self.create_move = {
            anti_aim_builder = function()
                if not self.menu.aa.general.enable:get() then
                    return
                end; if self.var.is_AntiBackStab_work then
                    return
                end; if self.menu.aa.general.legit_aa:get() then
                    return
                end
                if self.var.edge_yaw.is_working then
                    return
                end

                local set_condition = function(condition)
                    if assistant.defensive.get() then
                        return 'Defensive'
                    end
                    if condition == 'AIR-C' then
                        return 'Crouch Air'
                    elseif condition == 'AIR' then
                        return 'Air'
                    elseif condition == 'CROUCH' then
                        return 'Crouch'
                    elseif condition == 'SLOWWALK' then
                        return 'Slow Walk'
                    elseif condition == 'STAND' then
                        return 'Stand'
                    elseif condition == 'WALK' then
                        return 'Walk'
                    end
                end

                local info = {
                    current_condition = set_condition(assistant.get_condition()),
                    choked = engine.get_choked_packets().choked,
                }

                info.override = self.menu.aa.anti_aim[info.current_condition].override:get()
                local current = {}; do
                    for k, v in pairs(self.menu.aa.anti_aim[info.current_condition]) do
                        current[k] = info.override and v:get() or self.menu.aa.anti_aim['Global'][k]:get()
                    end

                    current.options = info.override and self.menu.aa.anti_aim[info.current_condition].options or self.menu.aa.anti_aim['Global'].options
                end

                -- local current = {
                --     yaw_base          = info.override and self.menu.aa.anti_aim[info.current_condition].yaw_base:get() or self.menu.aa.anti_aim['Global'].yaw_base:get(),
                --     pitch             = info.override and self.menu.aa.anti_aim[info.current_condition].pitch:get() or self.menu.aa.anti_aim['Global'].pitch:get(),
                --     yaw_add_left      = info.override and self.menu.aa.anti_aim[info.current_condition].yaw_add_left:get() or self.menu.aa.anti_aim['Global'].yaw_add_left:get(),
                --     yaw_add_right     = info.override and self.menu.aa.anti_aim[info.current_condition].yaw_add_right:get() or self.menu.aa.anti_aim['Global'].yaw_add_right:get(),
                --     yaw_modifier_type = info.override and self.menu.aa.anti_aim[info.current_condition].yaw_modifier_type:get() or self.menu.aa.anti_aim['Global'].yaw_modifier_type:get(),
                --     yaw_modifier      = info.override and self.menu.aa.anti_aim[info.current_condition].yaw_modifier:get() or self.menu.aa.anti_aim['Global'].yaw_modifier:get(),
                --     desync_left       = info.override and self.menu.aa.anti_aim[info.current_condition].desync_left:get() or self.menu.aa.anti_aim['Global'].desync_left:get(),
                --     desync_right      = info.override and self.menu.aa.anti_aim[info.current_condition].desync_right:get() or self.menu.aa.anti_aim['Global'].desync_right:get(),
                --     options           = info.override and self.menu.aa.anti_aim[info.current_condition].options or self.menu.aa.anti_aim['Global'].options,
                --     -- jitter_speed_adjust = info.override and self.menu.aa.anti_aim[info.current_condition].jitter_speed_adjust
                --     -- on_shot           = info.override and self.menu.aa.anti_aim[info.current_condition].on_shot:get() or self.menu.aa.anti_aim['Global'].on_shot:get(),
                -- }

                -- Yaw Base set
                local yaw_base do
                    if current.yaw_base == 'Local View' then
                        yaw_base = 0
                    elseif current.yaw_base == 'At Targets' then
                        yaw_base = 1
                    end
                end; menu.set_int('anti_aim.target_yaw', yaw_base)

                -- Pitch set
                local pitch do
                    if current.pitch == 'None' then
                        pitch = 0
                    elseif current.pitch == 'Down' then
                        pitch = 1
                    elseif current.pitch == 'Up' then
                        pitch = 2
                    end
                end; menu.set_int('anti_aim.pitch', pitch)

                -- Yaw Offset set
                local yaw_add do
                    local state = info.choked
                    if current.yaw_speed_adjust > 1 then
                        state = info.choked and (globals.get_tickcount() % (current.yaw_speed_adjust + 1) > 1)
                    end


                    if current.yaw_modifier_type == 'Center' then
                        current.yaw_modifier = current.yaw_modifier / 2
                        yaw_add = state and current.yaw_modifier or -current.yaw_modifier
                    elseif current.yaw_modifier_type == 'Offset' then
                        yaw_add = state and current.yaw_modifier or 0
                    end

                    yaw_add = yaw_add + (state and current.yaw_add_left or current.yaw_add_right)
                    yaw_add = math.round(yaw_add)
                end; menu.set_int('anti_aim.yaw_offset', yaw_add)

                -- Desync length set
                local desync_left, desync_right do
                    desync_left = current.desync_left
                    desync_right = current.desync_right

                    menu.set_int('anti_aim.desync_type', (desync_left == 0 and desync_right == 0) and 0 or 1)
                end; menu.set_int('anti_aim.desync_range', desync_left); menu.set_int('anti_aim.desync_range_inverted', desync_right)

                -- Options set
                local option do
                    if current.options:get('Jitter') then
                        option = info.choked

                        if current.jitter_speed_adjust > 1 then
                            option = info.choked and (globals.get_tickcount() % (current.jitter_speed_adjust + 1) > 1)
                        end
                    end
                end; if option ~= nil then menu.set_bool('anti_aim.invert_desync_key', not option) end
            end,
            anti_backstab = function()
                if not self.menu.aa.general.enable:get() then
                    return
                end

                if self.menu.aa.general.legit_aa:get() then
                    return
                end

                local closest_enemy = math.get_closest_player({
                    Distance = 175,
                    Teammate = false,
                    Enemy = true,
                    Allow_dead = false,
                    Allow_dormant = false,
                    Weapon = 'knife',
                })

                local yaw = 0

                if closest_enemy then
                    yaw = math.round(math.yaw_to_player(closest_enemy, true))
                    self.var.is_AntiBackStab_work = true
                else
                    self.var.is_AntiBackStab_work = false
                end

                override.system('AntiBackStab', closest_enemy ~= nil and self.menu.aa.general.tweaks:get('Anti-BackStab'), {
                    ['anti_aim.target_yaw'] = 0,
                    ['anti_aim.yaw_offset'] = yaw,
                })
            end,
            edge_yaw = function()
                if not self.menu.aa.general.enable:get() then
                    return
                end

                if not self.menu.aa.general.edge_yaw:get() then
                    return
                end

                if self.var.is_AntiBackStab_work then
                    return
                end

                local lp = entitylist.get_local_player()
                if not lp then
                    return
                end

                if engine.get_choked_packets().choke == 0 then
                    self.var.edge_yaw.start = entitylist.get_eye_position(lp)
                end

                local info = {}; for yaw = 0, 360, 45 do
                    local edge_angle = math.angle_to_forward(vector.new(0, math.normalize(yaw), 0))
                    -- local final = self.var.edge_yaw.start + vector.new(edge_angle.x * 198, edge_angle.y * 198, edge_angle.z * 198)
                    local final = vector.new(self.var.edge_yaw.start.x + edge_angle.x * 198, self.var.edge_yaw.start.y + edge_angle.y * 198, self.var.edge_yaw.start.z + edge_angle.z * 198)

                    local trace = engine.trace_line(self.var.edge_yaw.start, final, lp, 0x46004003)
                    if trace.entity and trace.entity:get_class_name() == 'CWorld' and trace.fraction < 0.2 then
                        table.insert(info, final)
                    end
                end

                if #info == 0 then
                    return
                end

                if #info ~= 1 then
                    self.var.edge_yaw.is_working = true
                    local center = math.flerp_vector(info[1], info[#info], 0.5)
                    local edge_angle = vector.new(self.var.edge_yaw.start.x - center.x, self.var.edge_yaw.start.y - center.y, self.var.edge_yaw.start.z - center.z)
                    edge_angle = math.vector_to_angle(edge_angle) - 180

                    menu.set_int('anti_aim.yaw_offset', math.round(edge_angle))
                end
            end,
            legit_anti_aim = function()
                if not self.menu.aa.general.enable:get() then
                    return
                end

                local local_player = entitylist.get_local_player()
                if not local_player then return end

                local option = {
                    key = self.menu.aa.general.legit_aa:get(),
                    is_using = local_player:get_prop_bool('CCSPlayer', 'm_bIsDefusing') or local_player:get_prop_bool('CCSPlayer', 'm_bIsGrabbingHostage'),
                }

                if option.key then
                    if option.is_using then
                        console.execute('+use')
                    else
                        console.execute('-use')
                    end
                    self.var.override_legit_aa = false
                else
                    if not self.var.override_legit_aa then
                        console.execute('-use')
                        self.var.override_legit_aa = true
                    end
                end

                override.system('LegitAntiAim', option.key, {
                    ['anti_aim.yaw_offset'] = 180,
                    ['anti_aim.target_yaw'] = 0,
                    ['anti_aim.pitch'] = 0,
                    -- ['anti_aim.desync_type'] = Info.Type,
                    ['anti_aim.desync_range'] = 60,
                    ['anti_aim.desync_range_inverted'] = 60,
                })
            end,
            override_handler = function()
                do -- Reduce on shot
                    if self.menu.rage.general.tweaks:get('Reduce on shot') then
                        override.system('Reduce on shot', globals.get_tickcount() - self.var.stamp_reduce_on_shot <= 3, {
                            ['anti_aim.enable_fake_lag'] = false,
                        })
                    end
                end

                do -- freestand
                    override.system('Freestand', self.menu.aa.general.freestand:get(), {
                        ['anti_aim.freestanding'] = true
                    })
                end
            end,
        }

        client.add_callback('create_move', function(cmd)
            for _, func in pairs(self.create_move) do
                func(cmd)
            end
        end)
    end,
    on_shot = function(self)
        self.on_shot = {
            custom_logs = function(log)
                self.input_log = function(t, stamp)
                    t.stamp = globals.get_curtime() + (stamp or 4)
                    table.insert(self.var.logs_handler, t)
                end

                local index = log.target_index
                local name = engine.get_player_info(index).name
                local player = entitylist.player_by_index(index)

                local hitbox_c = tostring(log.client_hitbox)
                local hitbox_s = tostring(log.server_hitbox)

                local damage_c = tostring(log.client_damage)
                local damage_s = tostring(log.server_damage)

                local safe = tostring(log.safe)
                local hitchance = tostring(log.hitchance)
                local backtrack = tostring(log.backtrack_ticks)

                if self.menu.misc.general.logs:get('Console') then
                    cprint('[debug]', color.black()); cprint(' trying to reach '); cprint(name, color.black()); cprint(' (hb:'); cprint(hitbox_c, color.black()); cprint(' dmg:'); cprint(damage_c, color.black()); cprint(' safe:'); cprint(safe, color.black()); cprint(')\n')
                    if not entitylist.get_local_player() then
                        cprint('[debug]', color.black()); cprint(' death')
                        return
                    end
                end

                local result = string.lower(log.result)

                local clr = self.menu.setting.customize.accent:get()


                if self.menu.misc.general.logs:get('On Left') then
                    if result == 'hit' then
                        local weapon = assistant.get_active_weapon(entitylist.get_local_player())
                        if not weapon then
                            cprint('[debug]', color.black()); cprint(' local death')
                            return
                        end

                        if self.menu.misc.general.logs:get('Console') then
                            cprint('[orion] ', clr); cprint('reached ', color.new()); cprint(name, color.new(0, 255, 100)); cprint(' into '); cprint(hitbox_s, color.new(0, 255, 100)); cprint(' for '); cprint(damage_s, color.new(0, 255, 100)); cprint('dmg with '); cprint(weapon .. '\n', color.new(0, 255, 100))
                        end
                        self.input_log({
                            content = {
                                {'reached '}, {name, color.new(0, 255, 100)}, {' into '}, {hitbox_s, color.new(0, 255, 100)}, {' for '}, {damage_s, color.new(0, 255, 100)}, {'dmg'}
                            }
                        })
                    else
                        if result == 'none' then
                            result = 'unregistered'
                        end
                        if self.menu.misc.general.logs:get('Console') then
                            cprint('[orion] ', clr); cprint(result .. ' ', color.new(255, 0, 150)); cprint(name); cprint(' into '); cprint(hitbox_c, color.new(255, 0, 150)); cprint(' ['); cprint(hitchance, color.new(255, 0, 150)); cprint('hc '); cprint(backtrack, color.new(255, 0, 150)); cprint('bt]\n')
                        end
                        self.input_log({
                            content = {
                                {result .. ' ', color.new(255, 0, 150)}, {name .. ' into '}, {hitbox_c, color.new(255, 0, 150)}, {' ['}, {hitchance, color.new(255, 0, 150)}, {'hc '}, {backtrack, color.new(255, 0, 150)}, {'bt]'}
                            }
                        })
                    end
                end
            end,
        } -- self.menu.visual.general.logs:get('On Left')


        client.add_callback('on_shot', function(log)
            for _, func in pairs(self.on_shot) do
                func(log)
            end
        end)
    end,
    event = function(self)
        self.event = {
            weapon_fire = function(event)
                if self.menu.rage.general.tweaks:get('Reduce on shot') then
                    if entitylist.player_by_user_id(event) == engine.get_local_player_index() then
                        self.var.stamp_reduce_on_shot = globals.get_tickcount()
                    end
                end
            end,
        }

        for k, func in pairs(self.event) do
            events.register_event(k, function(event)
                func(event)
            end)
        end
    end,
    setup = function(self)
        self:menu()
        self:var()
        self:create_move()
        self:on_paint()
        self:on_shot()
        self:event()
    end
}; script:setup()

-- local checkbox = ui.checkbox('rage', 'Introduction', 'checkbox')
-- local slider = ui.slider('rage', 'Introduction', 'slider', false, 0, 0, 100)
-- local button = ui.button('rage', 'Introduction', 'button')
-- local combobox = ui.combobox('rage', 'Introduction', 'combobox', false, {'1', '2', '3'})
-- local textbox = ui.textbox('rage', 'Introduction', 'textbox')
-- local colorpicker = ui.colorpicker('rage', 'Introduction', 'colorpicker')
-- local keybind = ui.keybind('rage', 'Introduction', 'keybind')
