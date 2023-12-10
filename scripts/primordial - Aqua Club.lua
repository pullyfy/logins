-- if not (engine.is_in_game() and engine.is_connected()) then
--     return error('[aqua] Load in game pls')
-- end

local ffi = require('ffi')

local http = { state = { ok = 200, no_response = 204, timed_out = 408, unknown = 0 } }

local safecall = function(name, report, f)
    return function(...)
        local s, ret = pcall(f, ...)
        if not s then
            local retmessage = "safe call failed [" .. name .. "] -> " .. ret
            if report then
                print(retmessage)
            end
            return false, retmessage
        else
            return ret, s
        end
    end
end

local FFI = {
    ffi.cdef[[
        typedef int BOOL;
        typedef long LONG;
        typedef unsigned long HANDLE;
        typedef float*(__thiscall* bound)(void*);
        typedef HANDLE HWND;

        // color
        typedef struct {
            uint8_t r, g, b, a;
        } color_t;

        struct c_color {
            unsigned char clr[4];
        };

        // clipboard
        typedef int(__thiscall* get_clipboard_text_count)(void*);
        typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
        typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);

        // create interface
        typedef void* (*get_interface_fn)();

        typedef struct {
            get_interface_fn get;
            char* name;
            void* next;
        } interface;

        // hwid
        typedef struct mask {
            char m_pDriverName[512];
            unsigned int m_VendorID;
            unsigned int m_DeviceID;
            unsigned int m_SubSysID;
            unsigned int m_Revision;
            int m_nDXSupportLevel;
            int m_nMinDXSupportLevel;
            int m_nMaxDXSupportLevel;
            unsigned int m_nDriverVersionHigh;
            unsigned int m_nDriverVersionLow;
            int64_t pad_0;
            union {
                int xuid;
                struct {
                    int xuidlow;
                    int xuidhigh;
                };
            };
            char name[128];
            int userid;
            char guid[33];
            unsigned int friendsid;
            char friendsname[128];
            bool fakeplayer;
            bool ishltv;
            unsigned int customfiles[4];
            unsigned char filesdownloaded;
        };
        typedef int(__thiscall* get_current_adapter_fn)(void*);
        typedef void(__thiscall* get_adapters_info_fn)(void*, int adapter, struct mask& info);
        typedef bool(__thiscall* file_exists_t)(void* this, const char* pFileName, const char* pPathID);
        typedef long(__thiscall* get_file_time_t)(void* this, const char* pFileName, const char* pPathID);

        // clantag
        typedef int(__fastcall* clantag_t) (const char*, const char*);
    ]],
    VMT = function(self)
        self.VMT = {}

        self.VMT.bind = function(vmt_table, func, index)
            local result = ffi.cast(ffi.typeof(func), vmt_table[0][index])
            return function(...)
                return result(vmt_table, ...)
            end
        end
    end,
    HWID = function(self)
        local debugger = false
        local ffi = require("ffi") or error("Failed to require FFI, please make sure Allow unsafe scripts is enabled!", 2)

        -- DONT TOUCH THIS YOU CAN CHANGE THE ERROR CODE--
        ffi.cdef[[
            typedef long(__thiscall* GetRegistryString)(void* this, const char* pFileName, const char* pPathID);
            typedef bool(__thiscall* Wrapper)(void* this, const char* pFileName, const char* pPathID);
        ]]

        local type2 = ffi.typeof("void***")
        local interface = memory.create_interface("filesystem_stdio.dll", "VBaseFileSystem011") or error(debugger and "Error... contact me on discord! ID: 394043716912021505" or "error", 2)
        local system10 = ffi.cast(type2, interface) or error(debugger and "Error... contact me on discord! ID: 394043716912021505" or "error", 2)
        local systemxwrapper = ffi.cast("Wrapper", system10[0][10]) or error(debugger and "Error... contact me on discord! ID: 394043716912021505" or "error", 2)
        local gethwid = ffi.cast("GetRegistryString", system10[0][13]) or error(debugger and "Error... contact me on discord! ID: 394043716912021505" or "error", 2)
        -- DONT TOUCH THIS YOU CAN CHANGE THE ERROR CODE--

        -- LOOKING FOR FILE ON PC DONT TOUCH
        local function filechecker()
            for i = 65, 90 do
                local filecheck = string.char(i)..":\\Windows\\Setup\\State\\State.ini" -- FILE CHECKING FOR HWID
                if systemxwrapper(system10, filecheck, "olympia") then
                    return filecheck
                end
            end
            return nil
        end
        -- LOOKING FOR FILE ON PC DONT TOUCH

        local filecheck = filechecker() or error(debugger and "Error... contact me on discord! ID: 394043716912021505" or "error", 2)

        local normalhwid = gethwid(system10, filecheck, "olympia") or error(debugger and "Error... contact me on discord! ID: 394043716912021505" or "error", 2)
        local obfuscatedhwid = normalhwid * 178 -- CHANGE THIS TO A RANDOM NUMBER (SECURITY)

        self.get_hwid = function()
            return obfuscatedhwid
        end
    end,
    HTTP = function(self)
        local http_mt = { __index = http }
        local requests = {}
        local request = {}
        local request_mt = { __index = request }
        local data = {}
        local data_mt = { __index = data }
        -- #region ffi
        local steam_http_raw = ffi.cast("uint32_t**",
            ffi.cast("char**",
                ffi.cast("char*", memory.find_pattern("client.dll", "B9 ? ? ? ? E8 ? ? ? ? 83 3D ? ? ? ? ? 0F 84")) +
                1)[0] +
            48)[0] or error("steam_http error")
        local steam_http_ptr = ffi.cast("void***", steam_http_raw) or error("steam_http_ptr error")
        local steam_http = steam_http_ptr[0] or error("steam_http_ptr was null")
        -- #endregion

        --#region helper functions
        local function __thiscall(func, this) -- bind wrapper for __thiscall functions
            return function(...)
                return func(this, ...)
            end
        end
        --#endregion

        -- #region native casts
        local createHTTPRequest_native = __thiscall(
            ffi.cast(ffi.typeof("uint32_t(__thiscall*)(void*, uint32_t, const char*)"), steam_http[0]),
            steam_http_raw)
        local sendHTTPRequest_native = __thiscall(
            ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, uint64_t)"), steam_http[5]), steam_http_raw)
        local getHTTPResponseHeaderSize_native = __thiscall(
            ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, const char*, uint32_t*)"), steam_http[9]),
            steam_http_raw)
        local getHTTPResponseHeaderValue_native = __thiscall(
            ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, const char*, char*, uint32_t)"), steam_http[10]),
            steam_http_raw)
        local getHTTPResponseBodySize_native = __thiscall(
            ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, uint32_t*)"), steam_http[11]), steam_http_raw)
        local getHTTPBodyData_native = __thiscall(
            ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, char*, uint32_t)"), steam_http[12]),
            steam_http_raw)
        local setHTTPHeaderValue_native = __thiscall(
            ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, const char*, const char*)"), steam_http[3]),
            steam_http_raw)
        local setHTTPRequestParam_native = __thiscall(
            ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, const char*, const char*)"), steam_http[4]),
            steam_http_raw)
        local setHTTPUserAgent_native = __thiscall(
            ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t, const char*)"), steam_http[21]), steam_http_raw)
        local setHTTPRequestRaw_native = __thiscall(
            ffi.cast("bool(__thiscall*)(void*, uint32_t, const char*, const char*, uint32_t)", steam_http[16]),
            steam_http_raw)
        local releaseHTTPRequest_native = __thiscall(
            ffi.cast(ffi.typeof("bool(__thiscall*)(void*, uint32_t)"), steam_http[14]), steam_http_raw)
        -- #endregion

        function http_get_f()
            for _, instance in ipairs(requests) do
                if globals.cur_time() - (instance.ls or 0) > instance.task_interval then
                    instance:_process_tasks()
                    instance.ls = globals.cur_time()
                end
            end
        end

        -- #region Models
        function request.new(requestHandle, requestAddress, callbackFunction)
            return setmetatable(
                { handle = requestHandle, url = requestAddress, callback = callbackFunction, ticks = 0 },
                request_mt)
        end

        function data.new(state, body, headers)
            return setmetatable({ status = state, body = body, headers = headers }, data_mt)
        end

        function data:success()
            return self.status == 200
        end

        -- #endregion

        -- #region Main
        function http.new(task)
            task = task or {}
            local instance = setmetatable(
                {
                    requests = {},
                    task_interval = task.task_interval or 0.3,
                    enable_debug = task.debug or false,
                    timeout = task.timeout or 10,
                    ls = globals.cur_time()
                }, http_mt)
            table.insert(requests, instance)
            return instance
        end

        local method_t = {
            ["get"] = 1,
            ["head"] = 2,
            ["post"] = 3,
            ["put"] = 4,
            ["delete"] = 5,
            ["options"] = 6,
            ["patch"] = 7
        }
        function http:request(method, url, options, callback)
            -- prepare
            if type(options) == "function" and callback == nil then
                callback = options
                options = {}
            end
            options = options or {}
            local method_num = method_t[tostring(method):lower()]
            local reqHandle = createHTTPRequest_native(method_num, url)
            -- header
            local content_type = "application/text"
            if type(options.headers) == "table" then
                for name, value in pairs(options.headers) do
                    name = tostring(name)
                    value = tostring(value)
                    if name:lower() == "content-type" then
                        content_type = value
                    end
                    setHTTPHeaderValue_native(reqHandle, name, value)
                end
            end
            -- raw
            if type(options.body) == "string" then
                local len = options.body:len()
                setHTTPRequestRaw_native(reqHandle, content_type, ffi.cast("unsigned char*", options.body), len)
            end
            -- params
            if type(options.params) == "table" then
                for k, v in pairs(options.params) do
                    setHTTPRequestParam_native(reqHandle, k, v)
                end
            end
            -- useragent
            if type(options.user_agent_info) == "string" then
                setHTTPUserAgent_native(reqHandle, options.user_agent_info)
            end
            -- send
            if not sendHTTPRequest_native(reqHandle, 0) then
                return
            end
            local reqInstance = request.new(reqHandle, url, callback)
            self:_debug("[HTTP] New %s request to: %s", method:upper(), url)
            table.insert(self.requests, reqInstance)
        end

        function http:get(url, callback)
            local reqHandle = createHTTPRequest_native(1, url)
            if not sendHTTPRequest_native(reqHandle, 0) then
                return
            end
            local reqInstance = request.new(reqHandle, url, callback)
            self:_debug("[HTTP] New GET request to: %s", url)
            table.insert(self.requests, reqInstance)
        end

        function http:post(url, params, callback)
            local reqHandle = createHTTPRequest_native(3, url)
            for k, v in pairs(params) do
                setHTTPRequestParam_native(reqHandle, k, v)
            end
            if not sendHTTPRequest_native(reqHandle, 0) then
                return
            end
            local reqInstance = request.new(reqHandle, url, callback)
            self:_debug("[HTTP] New POST request to: %s", url)
            table.insert(self.requests, reqInstance)
        end

        function http:_process_tasks()
            for k, v in ipairs(self.requests) do
                local data_ptr = ffi.new("uint32_t[1]")
                self:_debug("[HTTP] Processing request #%s", k)
                if getHTTPResponseBodySize_native(v.handle, data_ptr) then
                    local reqData = data_ptr[0]
                    if reqData > 0 then
                        local strBuffer = ffi.new("char[?]", reqData)
                        if getHTTPBodyData_native(v.handle, strBuffer, reqData) then
                            self:_debug("[HTTP] Request #%s finished. Invoking callback.", k)
                            v.callback(data.new(http.state.ok, ffi.string(strBuffer, reqData),
                                setmetatable({}, { __index = function(tbl, val) return http._get_header(v, val) end })))
                            table.remove(self.requests, k)
                            releaseHTTPRequest_native(v.handle)
                        end
                    else
                        v.callback(data.new(http.state.no_response, nil, {}))
                        table.remove(self.requests, k)
                        releaseHTTPRequest_native(v.handle)
                    end
                end
                local timeoutCheck = v.ticks + 1;
                if timeoutCheck >= self.timeout then
                    v.callback(data.new(http.state.timed_out, nil, {}))
                    table.remove(self.requests, k)
                    releaseHTTPRequest_native(v.handle)
                else
                    v.ticks = timeoutCheck
                end
            end
        end

        function http:_debug(...)
            if self.enable_debug then
                client.log_screen(string.format(...))
            end
        end

        function http._get_header(reqInstance, query)
            local data_ptr = ffi.new("uint32_t[1]")
            if getHTTPResponseHeaderSize_native(reqInstance.handle, query, data_ptr) then
                local reqData = data_ptr[0]
                local strBuffer = ffi.new("char[?]", reqData)
                if getHTTPResponseHeaderValue_native(reqInstance.handle, query, strBuffer, reqData) then
                    return ffi.string(strBuffer, reqData)
                end
            end
            return nil
        end

        function http._bind(class, funcName)
            return function(...)
                return class[funcName](class, ...)
            end
        end

        callbacks.add(e_callbacks.PAINT, function()
            http_get_f()
        end)
    end,
    FileSystem = function(self)
        -- * File system
        -- self.pGetModuleHandle_sig = memory.find_pattern('engine.dll', ' FF 15 ? ? ? ? 85 C0 74 0B') or error('Couldn\'t find signature #1')
        -- self.pGetProcAddress_sig = memory.find_pattern('engine.dll', ' FF 15 ? ? ? ? A3 ? ? ? ? EB 05') or error('Couldn\'t find signature #2')
        -- self.pGetProcAddress = ffi.cast('uint32_t**', ffi.cast('uint32_t', self.pGetProcAddress_sig) + 2)[0][0]
        -- self.fnGetProcAddress = ffi.cast('uint32_t(__stdcall*)(uint32_t, const char*)', self.pGetProcAddress)
        -- self.pGetModuleHandle = ffi.cast('uint32_t**', ffi.cast('uint32_t', self.pGetModuleHandle_sig) + 2)[0][0]
        -- self.fnGetModuleHandle = ffi.cast('uint32_t(__stdcall*)(const char*)', self.pGetModuleHandle)

        self.pGetModuleHandle_sig = memory.find_pattern('engine.dll', ' FF 15 ? ? ? ? 85 C0 74 0B') or error('couldn\'t find GetModuleHandle signature')
        self.pGetProcAddress_sig = memory.find_pattern('engine.dll', ' FF 15 ? ? ? ? A3 ? ? ? ? EB 05') or error('Couldn\'t find GetProcAddress signature')

        self.pGetProcAddress = ffi.cast('uint32_t**', ffi.cast('uint32_t', self.pGetProcAddress_sig) + 2)[0][0]
        self.fnGetProcAddress = ffi.cast('void*(__stdcall*)(void*, const char*)', self.pGetProcAddress)

        self.pGetModuleHandle = ffi.cast('uint32_t**', ffi.cast('uint32_t', self.pGetModuleHandle_sig) + 2)[0][0]
        self.fnGetModuleHandle = ffi.cast('void*(__stdcall*)(const char*)', self.pGetModuleHandle)


        self.proc_bind = function(module_name, function_name, typedef)
            local ctype = ffi.typeof(typedef)
            local module_handle = self.fnGetModuleHandle(module_name)
            local proc_address = self.fnGetProcAddress(module_handle, function_name)
            local call_fn = ffi.cast(ctype, proc_address)
            return call_fn
        end
        self.create_interface = function(module, interface_name)
            local create_interface_addr = ffi.cast('int', self.fnGetProcAddress(self.fnGetModuleHandle(module), 'CreateInterface'))
            local interface = ffi.cast('interface***', create_interface_addr + ffi.cast('int*', create_interface_addr + 5)[0] + 15)[0][0]

            while interface ~= ffi.NULL do
                if ffi.string(interface.name):match(interface_name) then
                    return interface.get()
                end

                interface = ffi.cast('interface*', interface.next)
            end
        end

        self.nativeLoadLibraryA4542 = self.proc_bind('kernel32.dll', 'LoadLibraryA', 'intptr_t(__stdcall*)(const char*)')
        self.nativeLoadLibraryA4542('urlmon.dll')
        self.nativeLoadLibraryA4542('gdi32.dll')
        self.nativeURLDownloadToFileA5824 = self.proc_bind('urlmon.dll', 'URLDownloadToFileA', 'void*(__stdcall*)(void* LPUNKNOWN, const char* LPCSTR, const char* LPCSTR2, int a, int LPBINDSTATUSCALLBACK)')

        local function vtable_entry(instance, index, type)
            return ffi.cast(type, (ffi.cast("void***", instance)[0])[index])
        end

        local function vtable_thunk(index, typestring)
            local t = ffi.typeof(typestring)
            return function(instance, ...)
                assert(instance ~= nil)
                if instance then
                    return vtable_entry(instance, index, t)(instance, ...)
                end
            end
        end

        local function vtable_bind(module, interface, index, typestring)
            local instance = self.create_interface(module, interface) or error("invalid interface")
            local fnptr = vtable_entry(instance, index, ffi.typeof(typestring)) or error("invalid vtable")
            return function(...)
                return fnptr(tonumber(ffi.cast("void***", instance)), ...)
            end
        end

        self.filesystem = self.create_interface("filesystem_stdio.dll", "VBaseFileSystem011")
        self.filesystem_class = ffi.cast(ffi.typeof("void***"), self.filesystem)
        self.filesystem_vftbl = self.filesystem_class[0]

        self.func_read_file = ffi.cast("int (__thiscall*)(void*, void*, int, void*)", self.filesystem_vftbl[0])
        self.func_write_file = ffi.cast("int (__thiscall*)(void*, void const*, int, void*)", self.filesystem_vftbl[1])

        self.func_open_file = ffi.cast("void* (__thiscall*)(void*, const char*, const char*, const char*)", self.filesystem_vftbl[2])
        self.func_close_file = ffi.cast("void (__thiscall*)(void*, void*)", self.filesystem_vftbl[3])

        self.func_get_file_size = ffi.cast("unsigned int (__thiscall*)(void*, void*)", self.filesystem_vftbl[7])
        self.func_file_exists = ffi.cast("bool (__thiscall*)(void*, const char*, const char*)", self.filesystem_vftbl[10])

        self.full_filesystem = self.create_interface("filesystem_stdio.dll", "VFileSystem017")
        self.full_filesystem_class = ffi.cast(ffi.typeof("void***"), self.full_filesystem)
        self.full_filesystem_vftbl = self.full_filesystem_class[0]

        self.func_add_search_path = ffi.cast("void (__thiscall*)(void*, const char*, const char*, int)", self.full_filesystem_vftbl[11])
        self.func_remove_search_path = ffi.cast("bool (__thiscall*)(void*, const char*, const char*)", self.full_filesystem_vftbl[12])

        self.func_remove_file = ffi.cast("void (__thiscall*)(void*, const char*, const char*)", self.full_filesystem_vftbl[20])
        self.func_rename_file = ffi.cast("bool (__thiscall*)(void*, const char*, const char*, const char*)", self.full_filesystem_vftbl[21])
        self.func_create_dir_hierarchy = ffi.cast("void (__thiscall*)(void*, const char*, const char*)", self.full_filesystem_vftbl[22])
        self.func_is_directory = ffi.cast("bool (__thiscall*)(void*, const char*, const char*)", self.full_filesystem_vftbl[23])

        self.func_find_first = ffi.cast("const char* (__thiscall*)(void*, const char*, int*)", self.full_filesystem_vftbl[32])
        self.func_find_next = ffi.cast("const char* (__thiscall*)(void*, int)", self.full_filesystem_vftbl[33])
        self.func_find_is_directory = ffi.cast("bool (__thiscall*)(void*, int)", self.full_filesystem_vftbl[34])
        self.func_find_close = ffi.cast("void (__thiscall*)(void*, int)", self.full_filesystem_vftbl[35])

        self.native_GetGameDirectory = vtable_bind("engine.dll", "VEngineClient014", 36, "const char*(__thiscall*)(void*)")

        self.MODES = {
            ["r"] = "r",
            ["w"] = "w",
            ["a"] = "a",
            ["r+"] = "r+",
            ["w+"] = "w+",
            ["a+"] = "a+",
            ["rb"] = "rb",
            ["wb"] = "wb",
            ["ab"] = "ab",
            ["rb+"] = "rb+",
            ["wb+"] = "wb+",
            ["ab+"] = "ab+",
        }
    end,
    render = function(self)
        self.interfaces = {
            new_intptr = ffi.typeof('int[1]'),
            charbuffer = ffi.typeof('char[?]'),
            new_widebuffer = ffi.typeof('wchar_t[?]'),
        }

        self.RawLocalize = memory.create_interface('localize.dll', 'Localize_001')
        self.Localize    = ffi.cast(ffi.typeof('void***'), self.RawLocalize)

        self.FindSafe =             self.VMT.bind(self.Localize, 'wchar_t*(__thiscall*)(void*, const char*)', 12)
        self.ConvertAnsiToUnicode = self.VMT.bind(self.Localize, 'int(__thiscall*)(void*, const char*, wchar_t*, int)', 15)
        self.ConvertUnicodeToAnsi = self.VMT.bind(self.Localize, 'int(__thiscall*)(void*, wchar_t*, char*, int)', 16)

        -- GUI Surface
        self.VGUI_Surface031 = memory.create_interface('vguimatsurface.dll', 'VGUI_Surface031')
        self.g_VGuiSurface = ffi.cast(ffi.typeof('void***'), self.VGUI_Surface031)

        self.native_Surface = {}
        self.native_Surface.FontCreate =       self.VMT.bind(self.g_VGuiSurface, 'unsigned long(__thiscall*)(void*)', 71)
        self.native_Surface.SetFontGlyphSet =  self.VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*, unsigned long, const char*, int, int, int, int, unsigned long, int, int)', 72)
        self.native_Surface.GetTextSize =      self.VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*, unsigned long, const wchar_t*, int&, int&)', 79)
        self.native_Surface.DrawSetTextColor = self.VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*, int, int, int, int)', 25)
        self.native_Surface.DrawSetTextFont =  self.VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*, unsigned long)', 23)
        self.native_Surface.DrawSetTextPos =   self.VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*, int, int)', 26)
        self.native_Surface.DrawPrintText =    self.VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*, const wchar_t*, int, int)', 28)

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
    end,
    setup = function(self)
        self:VMT()
        self:render()
        self:FileSystem()
        self:HTTP(); self:HWID()

        -- * clipboard
        self.VGUI_System_dll =  memory.create_interface('vgui2.dll', 'VGUI_System010')
        self.VGUI_System = ffi.cast(ffi.typeof('void***'), self.VGUI_System_dll)
        self.get_clipboard_text_count = ffi.cast('get_clipboard_text_count', self.VGUI_System[0][7])
        self.get_clipboard_text = ffi.cast('get_clipboard_text', self.VGUI_System[0][11])
        self.set_clipboard_text = ffi.cast('set_clipboard_text', self.VGUI_System[0][9])

        -- * Color stuff
        self.ConsoleColor = ffi.new('struct c_color')
        self.Engine_CVar = ffi.cast('void***', memory.create_interface('vstdlib.dll', 'VEngineCvar007'))
        self.ConsolePrint = ffi.cast('void(__cdecl*)(void*, const struct c_color&, const char*, ...)', self.Engine_CVar[0][25])

        -- * clantag
        local fn_change_clantag = memory.find_pattern('engine.dll', '53 56 57 8B DA 8B F9 FF 15')
        self.set_clantag = ffi.cast('clantag_t', fn_change_clantag)
    end
}; FFI:setup()

local JS = {
    ffi.cdef[[
        // UIEngine
        typedef void*(__thiscall* access_ui_engine_t)(void*, void); // 11
        typedef bool(__thiscall* is_valid_panel_ptr_t)(void*, void*); // 36
        typedef void*(__thiscall* get_last_target_panel_t)(void*); // 56
        typedef int (__thiscall *run_script_t)(void*, void*, char const*, char const*, int, int, bool, bool); // 113

        // IUIPanel
        typedef const char*(__thiscall* get_panel_id_t)(void*, void); // 9
        typedef void*(__thiscall* get_parent_t)(void*); // 25
        typedef void*(__thiscall* set_visible_t)(void*, bool); // 27
    ]],
    setup = function(self)
        local create_interface = FFI.create_interface

        local interface_ptr = ffi.typeof('void***')
        local rawpanoramaengine = create_interface('panorama.dll', 'PanoramaUIEngine001')
        local panoramaengine = ffi.cast(interface_ptr, rawpanoramaengine) -- void***
        local panoramaengine_vtbl = panoramaengine[0] -- void**

        local access_ui_engine = ffi.cast('access_ui_engine_t', panoramaengine_vtbl[11]) -- void*

        local function get_last_target_panel(uiengineptr)
            local vtbl = uiengineptr[0] or error('uiengineptr is nil', 2)
            local func = vtbl[56] or error('uiengineptr_vtbl is nil', 2)
            local fn = ffi.cast('get_last_target_panel_t', func)
            return fn(uiengineptr)
        end

        local function is_valid_panel_ptr(uiengineptr, itr)
            if itr == nil then
                return false --error('itr is nil', 2)
            end
            local vtbl = uiengineptr[0] or error('uiengineptr is nil', 2)
            local func = vtbl[36] or error('uiengineptr_vtbl is nil', 2)
            local fn = ffi.cast('is_valid_panel_ptr_t', func)
            return fn(uiengineptr, itr)
        end

        self.get_panel_id = function(panelptr)
            local vtbl = panelptr[0] or error('panelptr is nil', 2)
            local func = vtbl[9] or error('panelptr_vtbl is nil', 2)
            local fn = ffi.cast('get_panel_id_t', func)
            return ffi.string(fn(panelptr))
        end

        local function set_visible(panelptr, state)
            local vtbl = panelptr[0] or error('panelptr is nil', 2)
            local func = vtbl[27] or error('panelptr_vtbl is nil', 2)
            local fn = ffi.cast('set_visible_t', func)
            fn(panelptr, state)
        end

        local function get_parent(panelptr)
            local vtbl = panelptr[0] or error('panelptr is nil', 2)
            local func = vtbl[25] or error('panelptr_vtbl is nil', 2)
            local fn = ffi.cast('get_parent_t', func)
            return fn(panelptr)
        end

        local function get_root(uiengineptr, custompanel)
            local itr = get_last_target_panel(uiengineptr)
            if itr == nil then
                return
            end
            local ret = nil
            local panelptr = nil
            while itr ~= nil and is_valid_panel_ptr(uiengineptr, itr) do
                panelptr = ffi.cast('void***', itr)
                if custompanel and self.get_panel_id(panelptr) == custompanel then
                    ret = itr
                    break
                elseif self.get_panel_id(panelptr) == 'CSGOHud' then
                    ret = itr
                    break
                elseif self.get_panel_id(panelptr) == 'CSGOMainMenu' then
                    ret = itr
                    break
                end
                itr = get_parent(panelptr)
            end
            return ret
        end

        local uiengine = ffi.cast('void***', access_ui_engine(panoramaengine))
        local run_script = ffi.cast('run_script_t', uiengine[0][113])

        -- local rootpanel = get_root(uiengine)

        local rootpanel

        self.eval = function(code, custompanel, customFile)
            if not (engine.is_in_game() and engine.is_connected() and entity_list.get_local_player() ~= nil and entity_list.get_local_player():is_player() == true) then
                return
            end

            if custompanel then
                rootpanel = custompanel
            else
                if rootpanel == nil then
                    rootpanel = get_root(uiengine)
                end
            end
            local file = customFile or "panorama/layout/base_mainmenu.xml"

            run_script(uiengine, rootpanel, ffi.string(code), file, 8, 10, false, false)
        end
    end
}; -- JS:setup()
-- JS.eval = function(...) end; do
--     local setup = false
--     callbacks.add(e_callbacks.RUN_COMMAND, function()
--         if not setup then
--             JS:setup()
--             setup = true
--         end
--     end)
-- end

local animation = {}
local font = {}
local resource = {}
local base64 = {}
local file = {}; file.__index = file
local clipboard = {}
local database = {}
local blur = {}
local HTTPtask = http.new({
    task_interval = 0.1
})

local c_ui = {}
local ui = { data = {} }

local assistant = {
    global = function()
        -- * setup
        math.randomseed(globals.cur_time())

        -- * table
        table.to_string = function(tbl)
            local result = "{"
            for k, v in pairs(tbl) do
                if type(k) == "string" then
                    result = result..'[\''..k..'\']'..'='
                end

                if type(v) == "table" then
                    result = result..table.to_string(v)
                elseif type(v) == "boolean" then
                    result = result..tostring(v)
                elseif type(v) == "number" then
                    result = result..tostring(v)
                else
                    result = result..'\''..v..'\''
                end
                result = result..','
            end

            if result ~= "" then
                result = result:sub(1, result:len()-1)
            end
            return result.."}"
        end
        table.get_new_index = function(t, type)
            local new_i = #t; if t[new_i + 1] == nil then
                t = type or 0
                return new_i + 1
            end
        end

        -- * string
        string.to_table = function(s)
            return loadstring('return '..s:gsub('(\'.-\'):(.-),', '[%1]=%2,\n'))()
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
            time = globals.frame_time() * (time * 175)
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
            return color_t(math.round(new[1]), math.round(new[2]), math.round(new[3]), math.round(new[4]))
        end
        math.flerp = function(a, b, t)
            return a + t * (b - a)
        end
        math.flerp_inverse = function(a, b, v)
            return (v - a) / (b - a)
        end
        math.flerp_vector = function(vec1, vec2, t)
            return vec3_t(math.flerp(vec1.x, vec2.x, t), math.flerp(vec1.y, vec2.y, t), math.flerp(vec1.z, vec2.z, t))
        end
        math.flerp_inverse_vector = function(vec1, vec2, t)
            return vec3_t(math.flerp_inverse(vec1.x, vec2.x, t), math.flerp_inverse(vec1.y, vec2.y, t), math.flerp_inverse(vec1.z, vec2.z, t))
        end
        math.flerp_color = function(clr1, clr2, t)
            return color_t(
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
        math.to_ticks = function(x)
            return math.round(x / globals.interval_per_tick());
        end
        math.random_float = function(value_start, value_end, decimals)
            local dec = {}; for i = 1, decimals do
                dec[i] = 0
            end
            dec = '1'..table.concat(dec)
            dec = tonumber(dec)
            return math.random(value_start * dec, value_end * dec) / dec
        end
        math.is_nan = function(n)
            return tostring(n) == 'nan' or tostring(n) == '-nan'
        end
        math.move_lerp = function(start, final, speed, sway)
            local diff = math.abs(start - final)

            local val = (globals.tick_count() * speed / 5) % (sway and diff * 2 or diff)
            if math.is_nan(val) then val = 0 end

            if sway then
                val = val < diff and val or diff - (val - diff)
            end

            local fval = math.flerp_inverse(0, diff, val)
            if math.is_nan(fval) then fval = 0 end

            return math.flerp(start, final, fval)
        end
        math.yaw_to_player = function(player, forward)
            local LocalPlayer = entity_list.get_local_player()
            if not LocalPlayer or not player then return 0 end

            local lOrigin = LocalPlayer:get_render_origin()
            local ViewAngles = engine.get_view_angles()
            local pOrigin = player:get_render_origin()
            local Yaw = (-math.atan2(pOrigin.x - lOrigin.x, pOrigin.y - lOrigin.y) / 3.14 * 180 + 180) - (forward and 90 or -90)-- - ViewAngles.y +(forward and 0 or -180)
            if Yaw >= 180 then
                Yaw = 360 - Yaw
                Yaw = -Yaw
            end
            return Yaw
        end
        math.get_closest_player = function(exceptions)
            -- * check if connected to server and in game
            if not engine.is_connected() or not engine.is_in_game() then return end

            -- * exceptions sector create
            if exceptions == nil then exceptions = {} end
            exceptions.Distance = exceptions.Distance or 999999

            -- * check if local player is alive
            local LocalPlayer = entity_list.get_local_player()
            if not LocalPlayer or LocalPlayer:get_prop("m_iHealth") <= 0 then return end

            -- * cache
            local ClosestPlayer
            local ClosestDistance = exceptions.Distance

            local players = entity_list.get_players(false)
            -- * parsing all players
            for _, Entity in pairs(players) do
                if not Entity or not Entity:is_player() then goto skip end

                -- * getting player pointer and check if player is valid
                local _player = Entity
                if not _player or (_player:get_prop("m_iHealth") <= 0 and not exceptions.Allow_dead) or (_player:is_dormant() and not exceptions.Allow_dormant) then goto skip end
                if _player:get_index() == LocalPlayer:get_index() then goto skip end

                -- * teammate check
                if exceptions.Teammate ~= nil then
                    if not exceptions.Teammate and not _player:is_enemy() then goto skip end
                end

                -- * enemy check
                if exceptions.Enemy ~= nil then
                    if not exceptions.Enemy and _player:is_enemy() then goto skip end
                end

                -- * weapon check
                if exceptions.Weapon ~= nil then
                    local wep = _player:get_active_weapon()
                    local Weapon = _player:get_active_weapon()
                    if not Weapon then return end
                    Weapon = Weapon:get_name():lower()

                    if not (Weapon):find(exceptions.Weapon:lower()) then goto skip end
                end

                if exceptions.OnlyDormant ~= nil then
                    if exceptions.OnlyDormant then
                        if not _player:is_dormant() then
                            goto skip
                        end
                    end
                end


                -- * distance check
                local PlayerOrigin = LocalPlayer:get_render_origin()
                local _player_origin = _player:get_render_origin()

                local Distance = PlayerOrigin:dist(_player_origin)
                if Distance <= ClosestDistance then
                    ClosestPlayer = _player
                    ClosestDistance = Distance
                end
                ::skip::
            end
            return ClosestPlayer
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
        math.nway = function(start, final, way)
            local val_t = {}; for i = 0, 1, 1 / (way - 1) do
                table.insert(val_t, math.flerp(start, final, i))
            end
            return val_t
        end
        math.angle_to_forward = function(vec)
            local rad_x = math.rad(vec.x);
            local rad_y = math.rad(vec.y);

            local sp = math.sin(rad_x);
            local sy = math.sin(rad_y);
            local cp = math.cos(rad_x);
            local cy = math.cos(rad_y);

            return vec3_t(cp * cy, cp * sy, -sp)
        end

        -- * other
        cprint = function(str, clr)
            clr = clr or color_t(255, 255, 255)
            FFI.ConsoleColor.clr[0] = clr.r
            FFI.ConsoleColor.clr[1] = clr.g
            FFI.ConsoleColor.clr[2] = clr.b
            FFI.ConsoleColor.clr[3] = 255
            FFI.ConsolePrint(FFI.Engine_CVar, FFI.ConsoleColor, str)
        end
        extract = function(v, from, width)
            return bit.band(bit.rshift(v, from), bit.lshift(1, width) - 1)
        end
    end,
    clipboard = function()
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
    end,
    blur = function(self)
        JS.eval([[
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
                                <CSGOBlurTarget id='HudBlurG' style='width:100%; height:100%; -s2-mix-blend-mode:opaque; blur:fastgaussian(${gauss},${gauss},${gauss});'>
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

        blur.data = {}

        blur.invoke = function(name, radius)
            JS.eval(string.format([[
                %s = invoke(%s);
            ]], name, radius))
        end
        blur.set_position = function(name, pos)
            JS.eval(string.format([[
                %s.set_position(%s, %s, %s, %s)
            ]], name, pos[1], pos[2], pos[3], pos[4]))
        end
        blur.reset = function(name)
            JS.eval(string.format([[
                %s.release()
            ]], name))
        end

        table.insert(self._function, function()
            for k, v in pairs(blur.data) do
                if not (engine.is_in_game() and engine.is_connected() and entity_list.get_local_player() ~= nil and entity_list.get_local_player():is_player() == true) then
                    v.allow_invoke_pos = true
                    v.allow_invoke_rad = true
                    v.recover = true
                    goto proceed
                end

                if v.allow_invoke_pos then
                    blur.set_position(k, v.pos)

                    v.allow_invoke_pos = false
                end
                if v.allow_invoke_rad then
                    blur.reset(k)

                    blur.invoke(k, v.radius)
                    blur.set_position(k, v.pos)

                    v.allow_invoke_rad = false
                end

                local _execute = v.execute
                v.execute = false

                if not _execute then
                    v.recover = true
                    blur.reset(k)
                else
                    if v.recover then
                        blur.invoke(k, v.radius)
                        blur.set_position(k, v.pos)
                        v.recover = false
                    end
                end

                ::proceed::
            end
        end)

        callbacks.add(e_callbacks.SHUTDOWN, function()
            for k, _ in pairs(blur.data) do
                blur.reset(k)
            end
        end)
    end,
    render = function()
        render.surface_create_font = function(name, size, weight, flags, blur)
            local flags_t = {}
            for _, Flag in pairs(flags or {'NONE'}) do
                table.insert(flags_t, FFI.EFontFlags(Flag))
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

            -- local cache_key = string.format('%s\0%d\0%d\0%d', name, size, weight or 0, flags_i)
            local cache_key = string.format('%s\0%d\0%d\0%d', name, size, weight or 0, blur or 0)
            if FFI.font_cache[cache_key] == nil then
                FFI.font_cache[cache_key] = FFI.native_Surface.FontCreate()
                FFI.native_Surface.SetFontGlyphSet(FFI.font_cache[cache_key], name, size, weight or 0, blur or 0, 0, flags_i, 0, 0)
            end

            return FFI.font_cache[cache_key]
        end
        render.surface_get_text_size = function(font, text)
            local wide_buffer = FFI.interfaces.new_widebuffer(1024)
            local w_ptr = FFI.interfaces.new_intptr()
            local h_ptr = FFI.interfaces.new_intptr()

            FFI.ConvertAnsiToUnicode(text, wide_buffer, 1024)
            FFI.native_Surface.GetTextSize(font, wide_buffer, w_ptr, h_ptr)

            return vec2_t(tonumber(w_ptr[0]), tonumber(h_ptr[0]))
        end
        render.surface_text = function(font, text, pos, clr, center)
            local x, y = pos.x, pos.y
            if center then
                local text_size = render.surface_get_text_size(font, text)
                if center[1] then
                    x = x - text_size.x / 2
                end
                if center[2] then
                    y = y - text_size.y / 2
                end
            end
            FFI.native_Surface.DrawSetTextPos(x, y)
            FFI.native_Surface.DrawSetTextFont(font)
            FFI.native_Surface.DrawSetTextColor(clr.r, clr.g, clr.b, clr.a)
            return FFI.PrintText(text, false)
        end
        render.gradient_text = function(font, text, vec, clr_left, clr_right, custom, center)
            local render_text_f = custom and render.surface_text or render.text
            local render_get_text_size_f = custom and render.surface_get_text_size or render.get_text_size
            local _text = string.split(text); local _w = 0; local _space = 0
            for i, c in pairs(_text) do
                if c == ' ' then
                    _space = _space + 1
                    goto proceed
                end
                render_text_f(font, c, vec2_t(vec.x + _w - (center and render_get_text_size_f(font, text).x / 2 or 0), vec.y), color_t(
                        math.round(math.flerp(clr_left.r, clr_right.r, (i - 1 - _space) / ((#_text - _space) - 1))),
                        math.round(math.flerp(clr_left.g, clr_right.g, (i - 1 - _space) / ((#_text - _space) - 1))),
                        math.round(math.flerp(clr_left.b, clr_right.b, (i - 1 - _space) / ((#_text - _space) - 1))),
                        math.round(math.flerp(clr_left.a, clr_right.a, (i - 1 - _space) / ((#_text - _space) - 1)))
                    ))
                ::proceed::
                _w = _w + (custom and render.surface_get_text_size(font, c).x or render.get_text_size(font, c).x)
            end
        end
        render.get_multi_text_size = function(font, text_t)
            local t = {}; for _, v in pairs(text_t) do
                table.insert(t, v[1])
            end; return render.get_text_size(font, table.concat(t))
        end
        render.multi_text = function(font, pos, text_t, alpha, center)
            center = center or {}; local centered = render.get_multi_text_size(font, text_t)

            for _, v in pairs(text_t) do
                local size = render.get_text_size(font, v[1])
                render.text(font, v[1], vec2_t(pos.x + (center[1] and -centered.x /2 or 0), pos.y + (center[2] and centered.y /2 or 0)), v[2] or color_t(255, 255, 255))
                pos.x = pos.x + size.x
            end
        end
        render.blur = function(name, x, y, w, h, radius)
            if blur.data[name] == nil then
                blur.data[name] = {
                    pos = {x, y, w, h},
                    radius = radius,
                    allow_invoke_pos = false,
                    allow_invoke_rad = false,
                    execute = true,
                    recover = false,
                }
                blur.invoke(name, radius)
                blur.set_position(name, {x, y, w, h})
            end

            local current = {
                pos = {x, y, w, h},
                radius = radius
            }

            -- allow invoke if position changed
            for i = 1, 4 do
                if blur.data[name].pos[i] ~= current.pos[i] then
                    blur.data[name].allow_invoke_pos = true
                end
                blur.data[name].pos[i] = current.pos[i]
            end

            -- allow invoke if radius changed
            if blur.data[name].radius ~= current.radius then
                blur.data[name].allow_invoke_rad = true
            end

            blur.data[name].radius = current.radius

            blur.data[name].execute = true
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
    font = function()
        font.SFUIDisplay = render.create_font('SF UI Display Bold', 13, 400, e_font_flags.ANTIALIAS) -- e_font_flags.ANTIALIAS -- primordial\\aqua_club\\resource\\MuseoSans700
        font.Arial = render.create_font('Arial', 12, 400) -- Primordial font
        font.SmallPixel710 = render.create_font('Smallest Pixel-7', 10, 0, e_font_flags.OUTLINE)
        font.Verdana12 = render.create_font('Verdana', 12, 0)

        font.sCalibriBold16 = render.surface_create_font('Calibri Bold', 16, nil, {'OUTLINE'})
        font.sCalibriBold16Glow = render.surface_create_font('Calibri Bold', 16, nil, nil, 3)
        font.sVerdanaBold12 = render.surface_create_font('Verdana', 12, 900, {'OUTLINE'})
        font.sSmallPixel710 = render.surface_create_font('Smallest Pixel-7', 10, 0, {'OUTLINE'})
        -- render.create_font('Smallest Pixel-7', 10, {'OUTLINE'})
    end,
    ui = function()
        do -- methods
            c_ui.__index = c_ui

            -- * get
            function c_ui:get(value)
                return self.item:get(value)
            end

            function c_ui:get_item_name()
                assert(self.type == 'multi_selection', string.format('The %s does not have this method.', self.type))
                return self.item:get_item_name()
            end
            function c_ui:get_items()
                assert(self.type == 'multi_selection', string.format('The %s does not have this method.', self.type))
                return self.item:get_items()
            end
            function c_ui:get_items_value()
                assert(self.type == 'multi_selection', string.format('The %s does not have this method.', self.type))
                local new_v = {}; for _, v in pairs(self.item:get_items()) do
                    new_v[v] = self.item:get(v)
                end
                return new_v
            end

            function c_ui:get_clr_t()
                local v = self.item:get()
                return {
                    r = v.r,
                    g = v.g,
                    b = v.b,
                    a = v.a
                }
            end

            function c_ui:get_type()
                return self.type
            end
            function c_ui:get_class()
                return self.class
            end

            function c_ui:get_active_item_name()
                return self.item:get_active_item_name()
            end

            -- * set
            function c_ui:set(value)
                return self.item:set(value)
            end
            function c_ui:set_visible(value)
                return self.item:set_visible(value)
            end

            function c_ui:set_items(value)
                assert(self.type == 'multi_selection', string.format('The %s does not have this method.', self.type))
                return self.item:set_items(value)
            end
            function c_ui:add_item(value)
                assert(self.type == 'multi_selection', string.format('The %s does not have this method.', self.type))
                return self.item:add_item(value)
            end
            function c_ui:set_items_value(value_t)
                assert(self.type == 'multi_selection', string.format('The %s does not have this method.', self.type))

                for k, v in pairs(value_t) do
                    self.item:set(k, v)
                end
            end

            function c_ui:set_class(class)
                class = class or 'all'
                if not self.class then
                    return
                end

                self.uniq = string.gsub(self.uniq, 'cLss'..self.class, 'cLss'..class)
                self.class = class

                -- print(self.uniq)
            end

            function c_ui:set_clr_t(value_t)
                -- local v =
                self.item:set(value_t)
                -- return {
                --     r = v.r,
                --     g = v.g,
                --     b = v.b,
                --     a = v.a
                -- }
            end


            function c_ui:alpha_modulate(value)
                assert(self.type == 'color_picker', 'The element is not a colorpicker.')
                local v = self.item:get()
                self.item:set(color_t(v.r, v.g, v.b, value or v.a))
            end
        end
        -- * elements
        ui.checkbox = function(child, name, value)
            return ui.new({
                type = 'checkbox',
                class = 'all',
                item = menu.add_checkbox(child, name, value or false),
                uniq = string.format('%s:%s:%s:%s', 'checkbox', 'cLssall', child, name)
            })
        end

        ui.selection = function(child, name, value_t)
            return ui.new({
                type = 'selection',
                class = 'all',
                item = menu.add_selection(child, name, value_t or {'el 1', 'el 2', 'el 3'}),
                uniq = string.format('%s:%s:%s:%s', 'selection', 'cLssall', child, name)
            })
        end

        ui.multi_selection = function(child, name, value_t)
            return ui.new({
                type = 'multi_selection',
                class = 'all',
                item = menu.add_multi_selection(child, name, value_t or {'el 1', 'el 2', 'el 3'}),
                uniq = string.format('%s:%s:%s:%s', 'multi_selection', 'cLssall', child, name)
            })
        end

        ui.slider = function(child, name, value, min, max, step, precision, suffix)
            min, max, step, precision, suffix = min or 0, max or 100, step or 1, precision or 0, suffix or ''
            local data = ui.new({
                type = 'slider',
                class = 'all',
                item = menu.add_slider(child, name, min, max, step, precision, suffix),
                uniq = string.format('%s:%s:%s:%s', 'slider', 'cLssall', child, name)
            }); data:set(value or min)
            return data
        end

        ui.button = function(child, name, callback)
            return setmetatable({
                item = menu.add_button(child, name, callback or function()
                    print('Hi!')
                end)
            }, c_ui)
        end

        ui.separator = function(child)
            return menu.add_separator(child)
        end

        ui.list = function(child, name, value_t)
            return ui.new({
                type = 'list',
                class = 'all',
                item = menu.add_list(child, name, value_t or {'el 1', 'el 2', 'el 3'}),
                uniq = string.format('%s:%s:%s:%s', 'list', 'cLssall', child, name)
            })
        end

        ui.text_input = function(child, name)
            return setmetatable({
                item = menu.add_text_input(child, name)
            }, c_ui)
        end

        ui.text = function(child, name)
            return setmetatable({
                item = menu.add_text(child, name)
            }, c_ui)
        end

        function c_ui:keybind(name)
            return self.item:add_keybind(name or '')
        end

        function c_ui:color_picker(name)
            return ui.new({
                type = 'color_picker',
                class = 'all',
                item = self.item:add_color_picker(''),
                uniq = string.format('%s:%s:%s:%s', 'color_picker', 'cLssall', name, 'CFG')
            })
        end

        -- * base
        ui.new = function(data)
            local i = table.get_new_index(ui.data)
            ui.data[i] = data
            return setmetatable(ui.data[i], c_ui)
        end

        ui.set_visible = function(value)
            for _, v in pairs(ui.data) do
                v:set_visible(value)
                print(_, v)
            end
        end;

        ui.save = function(type, class)
            type = type or nil

            local data = {}; for _, v in pairs(ui.data) do
                if v.type == 'button' then
                    goto proceed
                end

                if ((type == nil) and true or (v.type == type)) and ((class == nil) and true or (v.class == class)) then
                    local value
                    if v.type == 'multi_selection' then
                        value = v:get_items_value()
                    elseif v.type == 'color_picker' then
                        value = v:get_clr_t()
                    else
                        value = v.item:get()
                    end
                    table.insert(data, {
                        type = v.type,
                        class = v.class,
                        value = value,
                        uniq = v.uniq
                    })
                end

                ::proceed::
            end

            print('SAVE size -', #data)

            return data
        end

        ui.load = function(data, type, class, rewrite_class)
            type = type or nil

            local count = 0
            for _, ui_v in pairs(ui.data) do
                if ui_v.type == 'button' then
                    goto proceed
                end


                for _, s_v in pairs(data) do
                    if rewrite_class ~= nil then -- slider:cLssAntiAim_Global_pitch:Pitch
                        local item_name = s_v.uniq:sub(s_v.uniq:find(':', s_v.uniq:find(':') + 1) + 1, s_v.uniq:len(s_v.uniq))
                        s_v.uniq = string.format('%s:cLss%s:%s', s_v.type, rewrite_class, item_name)

                        s_v.class = rewrite_class
                        class = rewrite_class
                    end

                    -- if ui_v.uniq:find('pitch') then -- важнаяя штука для фикса проблем
                    --     print(ui_v.uniq == s_v.uniq, s_v.class == class)
                    -- end

                    if ((ui_v.uniq == s_v.uniq) and ((type == nil) and true or (s_v.type == type)) and ((class == nil) and true or (s_v.class == class))) then
                        if ui_v.type == 'multi_selection' then
                            ui_v:set_items_value(s_v.value)
                        elseif ui_v.type == 'color_picker' then
                            local v = s_v.value
                            ui_v.item:set(color_t(v.r, v.g, v.b, v.a))
                        else
                            ui_v.item:set(s_v.value)
                        end
                        count = count + 1
                    end
                end

                ::proceed::
            end

            print('LOAD size -', count)
        end

        ui.reset = function()
        end

        ui.text_alignment = function(text, alignment)
            alignment = alignment or 'center'
            if alignment == 'center' then
                local space = '                                '
                local size = render.get_text_size(font.Arial, text)
                return string.format('%s%s', space:sub(1, space:len() - math.round(size.x / 5.5)), text)
            elseif alignment == 'left' then
                return 'left'
            elseif alignment == 'right' then
                local space = '                                                           '
                return string.format('%s%s', space:sub(1, space:len() - text:len()), text)
            end
        end

        ui.save_as_string = function(type, class)
            return base64.encode(string.format('CFG:%s', table.to_string(ui.save(type, class))))
        end

        ui.load_string = function(string, type, class, rewrite_class)
            local str = string
            if not str then
                return print('Clipboard is nil.')
            end; str = base64.decode(str)

            if not string.find(str, 'CFG:') then
                return print('Invalid clipboard.')
            end

            str = string.gsub(str, 'CFG:', '')
            ui.load(string.to_table(str), type, class, rewrite_class)
        end

        ui.export = function(type, class)
            -- local str = string.format('CFG:%s', table.to_string(ui.save(type, class)))
            -- print(str)
            -- str = base64.encode(str)
            -- clipboard.set(str)
            clipboard.set(ui.save_as_string(type, class))
        end

        ui.import = function(type, class, rewrite_class)
            ui.load_string(clipboard.get(), type, class, rewrite_class)
            -- local str = clipboard.get()
            -- if not str then
            --     return print('Clipboard is nil.')
            -- end; str = base64.decode(str)

            -- if not string.find(str, 'CFG:') then
            --     return print('Invalid clipboard.')
            -- end

            -- str = string.gsub(str, 'CFG:', '')
            -- ui.load(string.to_table(str), type, class, rewrite_class)
        end

    end,
    resource = function()
        resource.aqua_path = 'csgo\\aqua_club\\'
        local resource_path = resource.aqua_path..'resource\\'
        local icons = resource_path..'icons\\'

        resource.icon = {
            logo_small = render.load_image(icons .. 'logo_small.png'),
            hold = render.load_image(icons .. 'hold.png'),
            hold_off = render.load_image(icons .. 'hold_off.png'),
            toggle = render.load_image(icons .. 'toggle.png'),
            always_on = render.load_image(icons .. 'always_on.png'),
            bounds = render.load_image(icons .. 'bounds.png'),
            clock = render.load_image(icons .. 'clock.png'),
            extrapolation = render.load_image(icons .. 'extrapolation.png'),
            hit = render.load_image(icons .. 'hit.png'),
            molotov = render.load_image(icons .. 'molotov.png'),
            signal = render.load_image(icons .. 'signal.png'),
            spread = render.load_image(icons .. 'spread.png'),
            he_grenade = render.load_image(icons .. 'he_grenade.png'),
            jitter = render.load_image(icons .. 'jitter.png'),
            resolver = render.load_image(icons .. 'resolver.png'),
            skull = render.load_image(icons .. 'skull.png'),
            headshot = render.load_image(icons .. 'headshot.png'),
            clock_arrows = render.load_image(icons .. 'clock_arrows.png'),
            harmed = render.load_image(icons .. 'harmed.png'),
            occlusion = render.load_image(icons .. 'occlusion.png'),
            warning = render.load_image(icons .. 'warning.png')
        }
    end,
    handler = function(self)
        self._function = {}; callbacks.add(e_callbacks.PAINT, function()
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

        local screen = render.get_screen_size()
        table.insert(self._function, function()
            local cursor = input.get_mouse_pos()
            for index, drag in pairs(self.drags) do
                if type(drag) == 'table' then
                    if not drag[index] then drag[index] = {} end
                    if not drag[index].x then drag[index].x = 0.0 end
                    if not drag[index].y then drag[index].y = 0.0 end
                    if not drag[index].backup then drag[index].backup = false end

                    if cursor.x >= drag.x and cursor.x <= drag.x + drag.w and cursor.y >= drag.y and cursor.y <= drag.y + drag.h then
                        if not drag[index].backup and input.is_key_held(e_keys.MOUSE_LEFT) and not self.drags.holded then
                        drag[index].x = drag.x - cursor.x
                        drag[index].y = drag.y - cursor.y
                        drag[index].backup = true
                        self.drags.holded = true
                        end
                    end

                    if not input.is_key_held(e_keys.MOUSE_LEFT) then
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
        file.download_from_url = function(url, path, name)
            return ffi.cast('void(__stdcall*)()', FFI.nativeURLDownloadToFileA5824(nil, url, path..name, 0, 0))
        end
        function file.exists(_file, path_id)
            return FFI.func_file_exists(FFI.filesystem_class, _file, path_id)
        end
        function file.rename(old_path, new_path, path_id)
            FFI.func_rename_file(FFI.full_filesystem_class, old_path, new_path, path_id)
        end
        function file.remove(_file, path_id)
            FFI.func_remove_file(FFI.full_filesystem_class, _file, path_id)
        end
        function file.create_directory(path, path_id)
            FFI.func_create_dir_hierarchy(FFI.full_filesystem_class, path, path_id)
        end
        function file.is_directory(path, path_id)
            return FFI.func_is_directory(FFI.full_filesystem_class, path, path_id)
        end
        function file.find_first(path)
            local handle = ffi.new("int[1]")
            local file = FFI.func_find_first(FFI.full_filesystem_class, path, handle)
            if file == ffi.NULL then return nil end
            return handle, ffi.string(file)
        end
        function file.find_next(handle)
            local file = FFI.func_find_next(FFI.full_filesystem_class, handle)
            if file == ffi.NULL then return nil end

            return ffi.string(file)
        end
        function file.find_is_directory(handle)
            return FFI.func_find_is_directory(FFI.full_filesystem_class, handle)
        end
        function file.find_close(handle)
            FFI.func_find_close(FFI.full_filesystem_class, handle)
        end
        function file.add_search_path(path, path_id, type)
            FFI.func_add_search_path(FFI.full_filesystem_class, path, path_id, type)
        end
        function file.remove_search_path(path, path_id)
            FFI.func_remove_search_path(FFI.full_filesystem_class, path, path_id)
        end
        function file.get_game_dir()
            return ffi.string(FFI.native_GetGameDirectory()):gsub('csgo', '')
        end
        function file.open(_file, mode, path_id)
            if not FFI.MODES[mode] then error("Invalid mode!") end
            local self = setmetatable({
                file = _file,
                mode = mode,
                path_id = path_id,
                handle = FFI.func_open_file(FFI.filesystem_class, _file, mode, path_id)
            }, file)
            return self
        end
        function file:get_size()
            return FFI.func_get_file_size(FFI.filesystem_class, self.handle)
        end
        function file:write(buffer)
            FFI.func_write_file(FFI.filesystem_class, buffer, #buffer, self.handle)
        end
        function file:read()
            local size = self:get_size()
            local output = ffi.new("char[?]", size + 1)
            FFI.func_read_file(FFI.filesystem_class, output, size, self.handle)
            return ffi.string(output)
        end
        function file:close()
            FFI.func_close_file(FFI.filesystem_class, self.handle)
        end
    end,
    aqua = function(self)
        local path = file.get_game_dir()..'\\csgo\\aqua_club'; if not file.is_directory(path) then
            file.create_directory(path)
        end

        local resource = path..'\\resource\\'; if not file.is_directory(resource) then
            file.create_directory(resource)
        end

        local icons = resource..'icons\\'; if not file.is_directory(icons) then
            file.create_directory(icons)
        end

        local fonts = resource..'fonts\\'if not file.is_directory(fonts) then
            file.create_directory(fonts)
        end

        local config = path..'\\config'; if not file.is_directory(config) then
            file.create_directory(config)
        end

        local url_icons = {
            { name = 'resolver',  link = 'https://github.com/pullyfy/logins/blob/main/aqua%20club/icons/resolver.png?raw=true' },
            { name = 'spread',    link = 'https://github.com/pullyfy/logins/blob/main/aqua%20club/icons/spread.png?raw=true' },
            { name = 'occlusion', link = 'https://github.com/pullyfy/logins/blob/main/aqua%20club/icons/occlusion.png?raw=true' },
            { name = 'jitter',    link = 'https://github.com/pullyfy/logins/blob/main/aqua%20club/icons/jitter.png?raw=true' },
            { name = 'extrapolation', link = 'https://github.com/pullyfy/logins/blob/main/aqua%20club/icons/extrapolation.png?raw=true' },
            { name = 'bounds',        link = 'https://github.com/pullyfy/logins/blob/main/aqua%20club/icons/bounds.png?raw=true' },
            { name = 'signal',        link = 'https://github.com/pullyfy/logins/blob/main/aqua%20club/icons/signal.png?raw=true' },

            { name = 'molotov',    link = 'https://github.com/pullyfy/logins/blob/main/aqua%20club/icons/molotov.png?raw=true' },
            { name = 'he_grenade', link = 'https://github.com/pullyfy/logins/blob/main/aqua%20club/icons/he_grenade.png?raw=true' },

            { name = 'clock'       , link = 'https://github.com/pullyfy/logins/blob/main/aqua%20club/icons/clock.png?raw=true' },
            { name = 'clock_arrows', link = 'https://github.com/pullyfy/logins/blob/main/aqua%20club/icons/clock_arrows.png?raw=true' },

            { name = 'harmed',   link = 'https://github.com/pullyfy/logins/blob/main/aqua%20club/icons/harmed.png?raw=true' },
            { name = 'hit',      link = 'https://github.com/pullyfy/logins/blob/main/aqua%20club/icons/hit.png?raw=true' },
            { name = 'skull',    link = 'https://github.com/pullyfy/logins/blob/main/aqua%20club/icons/skull.png?raw=true' },
            { name = 'headshot', link = 'https://github.com/pullyfy/logins/blob/main/aqua%20club/icons/headshot.png?raw=true' },

            { name = 'hold_off',  link = 'https://github.com/pullyfy/logins/blob/main/aqua%20club/icons/hold_off.png?raw=true' },
            { name = 'always_on', link = 'https://github.com/pullyfy/logins/blob/main/aqua%20club/icons/always_on.png?raw=true' },
            { name = 'toggle',    link = 'https://github.com/pullyfy/logins/blob/main/aqua%20club/icons/toggle.png?raw=true' },
            { name = 'hold',      link = 'https://github.com/pullyfy/logins/blob/main/aqua%20club/icons/hold.png?raw=true' },

            { name = 'warning', link = 'https://github.com/pullyfy/logins/blob/main/aqua%20club/icons/warning.png?raw=true'},

            { name = 'logo_small',    link = 'https://github.com/pullyfy/logins/blob/main/aqua%20club/icons/logo_small.png?raw=true' },
            { name = 'logo_original', link = 'https://github.com/pullyfy/logins/blob/main/aqua%20club/icons/logo_original.png?raw=true' },
            -- { name = '', link = '' },
        }; for _, v in pairs(url_icons) do
            if not file.exists(icons..v.name..'.png') then
                file.download_from_url(v.link, icons, v.name..'.png')
            end
        end

        local add_font_resource = function(font)
            AddFontResourceA = FFI.proc_bind('gdi32.dll', 'AddFontResourceA', 'void*(__stdcall*)(const char* path)')
            path = string.format('%scsgo/aqua_club/resource/fonts/%s.ttf', file.get_game_dir():gsub('\\', '/'), font)

            return AddFontResourceA(path)
        end
        -- local url_fonts = {
        --     { name = 'SFUIDisplay', link = 'https://github.com/pullyfy/logins/raw/main/SF%20UI%20Display%20Bold.ttf' },
        -- }; for _, v in pairs(url_fonts) do
        --     if not file.exists(fonts..v.name..'.ttf') then
        --         -- file.download_from_url(v.link, 'C:\\Windows\\arar\\', v.name..'.ttf')
        --     end
        --     -- add_font_resource(v.name)
        -- end

    end,
    setup = function(self)
        self:clipboard();
        self:global(); self:file(); self:aqua(); self:resource(); self:handler()
        self:base64()
        self:ui()
        self:render(); self:font()
        -- self:blur()
        render.blur = function(a1, a2, a3, a4, a5, a6)

        end
        self:animation()
        self:drag_system()

        self.get_velocity = function(player)
            return vec3_t(player:get_prop('m_vecVelocity[0]'), player:get_prop('m_vecVelocity[1]'), player:get_prop('m_vecVelocity[2]'))
        end
        local air_tick = 0; self.get_condition = function()
            local local_player = entity_list.get_local_player()
            if local_player == nil then
                return
            end
            if not local_player then
                return
            end

            if not self.check() then
                return
            end

            local flag = local_player:get_prop('m_fFlags')
            local vel = self.get_velocity(local_player)
            if not vel then
                return
            end

            local info = {
                slow_walk = menu.find('misc', 'main', 'movement', 'slow walk')[2]:get(),
                ducked   = local_player:get_prop('m_bDucked') == 1,
                speed    = vel:length2d(),
            }

            if flag == 256 or flag == 262 then
                info.in_air = true
                air_tick = globals.tick_count() + 3
            else
                info.in_air = (air_tick > globals.tick_count()) and true or false
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
        self.check = function()
            return engine.is_in_game() and engine.is_connected()
        end
        self.get_ping = function()
            if not engine.is_in_game() then
                return 'offline'
            end

            local ping = math.round(engine.get_latency(e_latency_flows.OUTGOING) * 900)
            if ping <= 4 then
                return 'local'
            end

            return ping .. 'ms'
        end
        self.get_local_time = function()
            local h, m, s = client.get_local_time()
            return string.format('%s:%s%s', h, m < 10 and '0' or '', m)
        end
        self.get_binds = function(path_b, animation_speed)
            local bind_t = {}

            for k, v in pairs(path_b) do
                if k == 'counter' then
                    goto proceed
                end

                if v.path_uniq ~= nil and self.get_menu_weapon() == nil then
                    goto proceed
                end

                if v.path_uniq ~= nil then
                    v.path = menu.find('aimbot', self.get_menu_weapon(), v.path_uniq[1], v.path_uniq[2])
                end

                if v.path_script ~= nil then
                    v.path = v.path_script
                end

                if v.path_script ~= nil then
                    v.active = v.path:get()
                    v.mode = v.path:get_mode()
                else
                    v.active = v.path[2]:get()
                    v.mode = v.path[2]:get_mode()
                end

                v.anim = animation.on_enable(string.format('visual.keybinds.%s', v.name), v.active, animation_speed or 0.05)

                v.secondary = nil; do
                    if v.name == 'Double Tap' then
                        v.secondary = 'circle-show'
                    end

                    if v.name == 'Force Damage' then
                        local default = menu.find('aimbot', self.get_menu_weapon(), 'targeting', 'min. damage'):get()
                        local override = menu.find('aimbot', self.get_menu_weapon(), 'target overrides', 'min. damage')[1]:get()

                        v.secondary = animation.new('visual.keybinds.force_damage.'..self.get_menu_weapon(), default, v.active and override or default, 0.1)
                        v.secondary = tostring(math.round(v.secondary))
                    end

                    if v.name == 'Hitchance Override' then
                        local default = menu.find('aimbot', self.get_menu_weapon(), 'targeting', 'hitchance'):get()
                        local override = menu.find('aimbot', self.get_menu_weapon(), 'target overrides', 'hitchance')[1]:get()

                        v.secondary = animation.new('visual.keybinds.hitchance_override'..self.get_menu_weapon(), default, v.active and override or default, 0.1)
                        v.secondary = tostring(math.round(v.secondary))
                    end

                    if v.name == 'Auto Peek' then
                        if not self.check() then
                            return
                        end
                        local lp = entity_list.get_local_player()
                        if not lp:is_player() then
                            return
                        end
                        if not lp:is_alive() then
                            goto proceed
                        end
                        -- if not v.active then
                        --     goto proceed
                        -- end

                        local autopeek_origin = ragebot.get_autopeek_pos()
                        if autopeek_origin ~= nil then
                            local origin = lp:get_render_origin()
                            origin = vec3_t(origin.x, origin.y, origin.z)
                            v.secondary = tostring(math.round(origin:dist(autopeek_origin)))..'u'
                        end

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
                    mode = v.mode,
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
        self.get_weapon_group = function(player)
            local weapon = player:get_active_weapon() -- :gsub('ssg08', 'scout'):gsub('scar20', 'auto'):gsub('g3sg1', 'auto'):gsub('', ''):gsub('', ''):gsub('', ''):gsub('', '')
            if weapon == nil then
                return
            end; weapon = weapon:get_name()

            local weapon_t = {
                ['auto'] = {'scar20', 'g3sg1'},
                ['scout'] = {'ssg08'},
                ['awp'] = {'awp'},
                ['deagle'] = {'deagle'},
                ['revolver'] = {'revolver'},
                ['pistols'] = {'glock', 'cz75a', 'p250', 'fiveseven', 'elite', 'tec9', 'usp-s', 'p2000'},
                ['other'] = {'mac10', 'mp9', 'mp7', 'ump45', 'bizon', 'p90', 'galilar', 'famas', 'ak47', 'm4a1', 'm4a1-s', 'sg556', 'aug', 'nova', 'xm1014', 'sawedoff', 'mag7', 'm249', 'negev'}
            }

            for key, value in pairs(weapon_t) do
                for _, wep in pairs(value) do
                    if weapon == wep then
                        return key
                    end
                end
            end

            return nil
        end
        self.get_menu_weapon = function()
            if not self.check() then
                return
            end

            local local_player = entity_list.get_local_player()
            if not local_player:is_player() then
                return
            end
            if not local_player:is_valid() then
                return
            end
            if not local_player:is_alive() then
                return
            end

            local weapon = self.get_weapon_group(local_player)

            return weapon
        end
        self.defensive = {}; do
            self.defensive.tick = 0
            self.defensive.duration = 0
            self.defensive.old_simtime = 0

            self.defensive.update = function()
                if not self.check() then
                    return
                end

                local local_player = entity_list.get_local_player()
                if not local_player:is_player() then
                    return
                end
                if not local_player:is_alive() or not local_player:is_valid() then
                    return
                end

                local simtime = local_player:get_prop('m_flSimulationTime')
                local delta = self.defensive.old_simtime - simtime

                if delta > 0 then
                    self.defensive.tick = globals.tick_count();
                    self.defensive.duration = math.to_ticks(delta);
                end

                self.defensive.old_simtime = simtime
            end
            self.defensive.get = function()
                return (globals.tick_count() < self.defensive.tick + (self.defensive.duration - math.to_ticks(engine.get_latency(e_latency_flows.INCOMING)))) and exploits.get_charge() == exploits.get_max_charge()
            end
            -- e_latency_flows.OUTGOING
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

            callbacks.add(e_callbacks.NET_UPDATE, function()
                self.defensive.update()
            end)
        end
        self.choke_b = false; self.get_choke_bool = function()
            return self.choke_b
        end
        local nWay = {}; self.nWay = function(name, start, final, condition, ways)
            if nWay[name] == nil then
                nWay[name] = 1
            end; local val_t = math.nway(start, final, ways)

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
    end
}; assistant:setup()

ui.button('Config', 'load default', function()
    HTTPtask:get('https://raw.githubusercontent.com/pullyfy/logins/main/aqua%20club/default.aqua', function(response)
        if response:success() then
            ui.load_string(response.body)
            client.log_screen('[aqua] default config succesfully loaded.')
        else
            client.log_screen('[aqua] something wrong (HTTP), try again later.')
        end
    end)
end)
ui.button('Config', 'load own', function()
    if file.exists('aqua_club/config/own.aqua') then
        local cfg = file.open('aqua_club/config/own.aqua', 'r')
        ui.load_string(cfg:read())
        cfg:close()
        client.log_screen('[aqua] Own config succesfully loaded.')
    else
        print('[aqua] Own config does`nt exists.')
        client.log_screen('[aqua] Own config does`nt exists.')
    end
end)
ui.button('Config', 'save as own', function()
    local cfg = file.open('aqua_club/config/own.aqua', 'w')
    cfg:write(ui.save_as_string())
    cfg:close()
end)
ui.button('Config', 'clipboard: export ', function()
    ui.export()
    client.log_screen('[aqua] config exported.')
end)
ui.button('Config', 'clipboard: import', function()
    ui.import()
    client.log_screen('[aqua] config imported.')
end)
-- local extended_cfg = ui.checkbox('Config', 'Show extended configs')

local force_baim_lethal = ui.checkbox('Aimbot', 'Force baim if lethal')

local watermark = ui.checkbox('Visuals', 'Watermark')
local watermark_name = ui.text_input('Visuals', 'Watermark name')
local fl_indicator = ui.checkbox('Visuals', 'FL indicator')
local fake_indicator = ui.checkbox('Visuals', 'Fake indicator')
local keybinds = ui.checkbox('Visuals', 'Keybinds')
-- local enabled_binds = ui.multi_selection()
local logs = ui.checkbox('Visuals', 'Logs')
local min_dmg_indicator = ui.checkbox('Visuals', 'Min dmg at crosshair')
local slowed_down_indicator = ui.checkbox('Visuals', 'Slowed down indicator')
local manual_arrows = ui.checkbox('Visuals', 'Manual arrows indicator')
local manual_arrows_clr = manual_arrows:color_picker('manual_arrows_clr')
local indicators_crosshair = ui.checkbox('Visuals', 'Indicators under crosshair')
local indicators_crosshair_clr = indicators_crosshair:color_picker('indicators_crosshair_clr')
local accent_clr = ui.text('Visuals', 'Accent Color'):color_picker('accent_clr')

local clantag = ui.checkbox('Misc', 'Clantag')
local animbreakers = ui.multi_selection('Misc', 'Animation breakers', {'Pitch 0 on land', 'Backwards legs', 'Static legs in air', 'Move lean'})
local autostrafe = ui.checkbox('Misc', 'Better auto-strafe')
local autostrafe_smooth = ui.slider('Misc', 'Auto-strafe smooth', 120, 20, 220)

-- local test1 = ui.slider('Misc', 'test1', 0, -1, 10)
-- local test2 = ui.slider('Misc', 'test2', 0, -1, 10)

local states = {'Global', 'Stand', 'Walk', 'Slow Walk', 'Air', 'Crouch', 'Crouch Air', 'Defensive'}

local aa_tweaks = ui.multi_selection('Anti Aim', 'Anti-aim tweaks', {'Avoid backstab'})
local edge_yaw_bind = ui.text('Anti Aim', 'Edge Yaw'):keybind('edge yaw key')
local enable_aa = ui.checkbox('Anti Aim', 'Enable conditions')
local condition = ui.list('Anti Aim', 'Condition', states)
ui.separator('Anti Aim')

local aa = {}; do
    for _, state in pairs(states) do
        if aa[state] == nil then

            local state_name = function(text)
                if state == 'Slow Walk' then
                    return '[SW] '..text
                elseif state == 'Crouch Air' then
                    return '[CA] '..text
                end
                return string.format('[%s] ', state:sub(1, 1))..text
            end

            aa[state] = {
                force_defensive = ui.checkbox('Anti Aim', state_name('Force defensive')),
                override = ui.checkbox('Anti Aim', state_name('Override ')),
                -- cfg_separator = ui.text('Anti Aim Conditions', '________________________________________________'),
                -- cfg_export = ui.button('Anti Aim Conditions', 'export', function() ui.export(nil, string.format('AntiAim_%s_%s', state, 'pitch')) end),
                -- cfg_import = ui.button('Anti Aim Conditions', 'import', function() ui.import(nil, string.format('AntiAim_%s_%s', state, 'pitch')) end)
            }; for k, v in pairs(aa[state]) do
                -- v:set_class
            end

            local pitch = {
                pitch_start = ui.slider('Pitch settings', state_name('Start'), 89, -89, 89),
                pitch_end = ui.slider('Pitch settings', state_name('End'), 89, -89, 89),
                pitch_option = ui.selection('Pitch settings', state_name('Option'), {'None', 'Start', 'Start/End', 'nWay', 'Rotate', 'Sway', 'Random'}),
                pitch_option_value = ui.slider('Pitch settings', state_name('- option value'), 3, 2, 32),
                pitch_inverter = ui.selection('Pitch settings', state_name('Inverter'), {'Choke', 'Adjustable', 'Tick', 'Random'}),
                pitch_inverter_value1 = ui.slider('Pitch settings', state_name('- inverter value 1'), 1, 3, 36),
                pitch_inverter_value2 = ui.slider('Pitch settings', state_name('- inverter value 2'), 1, 2, 36),
                -- cfg_pitch_export = ui.button('Pitch settings', 'export: '..string.format('%s %s', state:lower(), 'pitch'), function()
                --     ui.export(nil, string.format('AntiAim_%s_%s', state, 'pitch'))
                -- end),
                -- cfg_pitch_import = ui.button('Pitch settings', 'import: '..'pitch', function()
                --     ui.import(nil, nil, string.format('AntiAim_%s_%s', state, 'pitch'))
                -- end)
            }; for k, v in pairs(pitch) do
                v:set_class('pitch')
                aa[state][k] = v
            end

            local yaw = {
                yaw_base = ui.selection('Yaw settings', state_name('Base'), {'Viewangle', 'At Target (Crosshair)', 'At Target (Distance)', 'Velocity'}),
                yaw_start = ui.slider('Yaw settings', state_name('Start'), 0, -180, 180),
                yaw_end = ui.slider('Yaw settings', state_name('End'), 0, -180, 180),
                yaw_option = ui.selection('Yaw settings', state_name('Option'), {'None', 'Start', 'Start/End', 'nWay', 'Rotate', 'Sway', 'Random'}),
                yaw_option_value = ui.slider('Yaw settings', state_name('- option value'), 3, 2, 100),
                yaw_inverter = ui.selection('Yaw settings', state_name('Inverter'), {'Choke', 'Adjustable', 'Tick', 'Random'}),
                yaw_inverter_value1 = ui.slider('Yaw settings', state_name('- inverter value 1'), 3, 2, 36),
                yaw_inverter_value2 = ui.slider('Yaw settings', state_name('- inverter value 2'), 3, 2, 36),
                -- cfg_yaw_export = ui.button('Yaw settings', 'export: '..string.format('%s %s', state:lower(), 'yaw'), function() ui.export(nil, string.format('AntiAim_%s_%s', state, 'yaw')) end),
                -- cfg_yaw_import = ui.button('Yaw settings', 'import: '..'yaw', function() ui.import(nil, string.format('AntiAim_%s_%s', state, 'yaw')) end)
            }; for k, v in pairs(yaw) do
                v:set_class('yaw')
                aa[state][k] = v
            end

            local desync = {
                desync_direction = ui.selection('Desync settings', state_name('Auto-direction'), {'None', 'Peek fake', 'Peek real'}),
                desync_anti_bruteforce = ui.checkbox('Desync settings', state_name('Anti-bruteforce')),
                desync_on_shot = ui.selection('Desync settings', state_name('On shot'), {'Off', 'Opposite', 'Same side', 'Random'}),
                desync_start = ui.slider('Desync settings', state_name('Start'), 0, -100, 100),
                desync_end = ui.slider('Desync settings', state_name('End'), 0, -100, 100),
                desync_option = ui.selection('Desync settings', state_name('Option'), {'None', 'Start', 'Start/End', 'nWay', 'Rotate', 'Sway', 'Random'}),
                desync_option_value = ui.slider('Desync settings', state_name('- option value'), 3, 2, 32),
                desync_inverter = ui.selection('Desync settings', state_name('Inverter'), {'Choke', 'Adjustable', 'Tick', 'Random'}),
                desync_inverter_value1 = ui.slider('Desync settings', state_name('- inverter value 1'), 3, 2, 36),
                desync_inverter_value2 = ui.slider('Desync settings', state_name('- inverter value 2'), 3, 2, 36),
                -- cfg_desync_export = ui.button('Desync settings', 'export: '..string.format('%s %s', state:lower(), 'desync'), function() ui.export(nil, string.format('AntiAim_%s_%s', state, 'desync')) end),
                -- cfg_desync_import = ui.button('Desync settings', 'import: '..'desync', function() ui.import(nil, string.format('AntiAim_%s_%s', state, 'desync')) end)
            }; for k, v in pairs(desync) do
                v:set_class('desync')
                aa[state][k] = v
            end

            local fakelag = {
                break_lc = ui.checkbox('Fakelag settings', state_name('Break LC')),
                fakelag_start = ui.slider('Fakelag settings', state_name('Start'), 1, 0, 15),
                fakelag_end = ui.slider('Fakelag settings', state_name('End'), 1, 0, 15),
                fakelag_option = ui.selection('Fakelag settings', state_name('Option'), {'None', 'Start', 'Start/End', 'Random'}),
                fakelag_inverter = ui.selection('Fakelag settings', state_name('Inverter'), {'Choke', 'Adjustable', 'Tick', 'Random'}),
                fakelag_inverter_value1 = ui.slider('Fakelag settings', state_name('- inverter value 1'), 3, 2, 36),
                fakelag_inverter_value2 = ui.slider('Fakelag settings', state_name('- inverter value 2'), 3, 2, 36),
            }; for k, v in pairs(fakelag) do
                v:set_class('fakelag')
                aa[state][k] = v
            end
        end
    end

    for _, state in pairs(states) do
        for _, v in pairs(aa[state]) do
            v:set_class(string.format('AntiAim_%s_%s', state, v:get_class()))
        end
    end

    aa['Global'].override:set_visible(false)
end

menu.set_group_column('Yaw settings', 3)
menu.set_group_column('Pitch settings', 2)
menu.set_group_column('Desync settings', 3)
menu.set_group_column('Fakelag settings', 3)
menu.set_group_column('Anti Aim', 2)

menu.set_group_column('Config', 1)
menu.set_group_column('Visuals', 1)
menu.set_group_column('Aimbot', 1)

local primo_ui = {
    antiaim = {
        yaw_add  = menu.find('antiaim', 'main', 'angles', 'yaw add'),
        yaw_base = menu.find('antiaim', 'main', 'angles', 'yaw base'),
        pitch    = menu.find('antiaim', 'main', 'angles', 'pitch'),
        desync_left_amount       = menu.find('antiaim', 'main', 'desync', 'left amount'),
        desync_right_amount      = menu.find('antiaim', 'main', 'desync', 'right amount'),
        desync_side              = menu.find('antiaim', 'main', 'desync', 'side'),
        desync_peek_side         = menu.find('antiaim', 'main', 'desync', 'default side'),
        desync_antibrute         = menu.find('antiaim', 'main', 'desync', 'anti bruteforce'),
        desync_on_shot           = menu.find('antiaim', 'main', 'desync', 'on shot'),
        move_desync_override     = menu.find('antiaim', 'main', 'desync', 'override stand#move'),
        slowwalk_desync_override = menu.find('antiaim', 'main', 'desync', 'override stand#slow walk'),
        fakelag_amount = menu.find('antiaim', 'main', 'fakelag', 'amount'),
        break_lc = menu.find('antiaim', 'main', 'fakelag', 'break lag compensation'),
    },
    rage = {
        hideshots = menu.find('aimbot', 'general', 'exploits', 'hideshots', 'enable'),
        doubletap = menu.find('aimbot', 'general', 'exploits', 'doubletap', 'enable')
    }
}
-- local glow_enabled,glow_color = unpack(menu.find("visuals", "esp", "models","glow#enemy"))

local screen = render.get_screen_size()
local kb_x, kb_y = menu.add_slider('ARAR', 'Kebinds: x', 0, screen.x), menu.add_slider('ARAR', 'Kebinds: y', 0, screen.y); kb_x:set_visible(false); kb_y:set_visible(false)

local script = {
    PAINT = function(self)
        local f = {
            windows_render = function()
                local anim = {}; do
                    anim.watermark = animation.on_enable('visual.watermark', watermark:get(), 0.05)
                    anim.keybinds = animation.on_enable('visual.keybinds', keybinds:get(), 0.05)
                    anim.fl_indicator = animation.on_enable('visual.fl_indicator', fl_indicator:get() and assistant.check() or fl_indicator:get() and menu.is_open(), 0.05)
                    anim.fake_indicator = animation.on_enable('visual.fake_indicator', fake_indicator:get() and assistant.check() or fake_indicator:get() and menu.is_open(), 0.05)

                    anim.on_watermark = animation.condition_new('visual.on_watermark', anim.watermark ~= false, 0.05)
                end

                local watermark = {}; do
                    -- entity_list.get_local_player():get_name()
                    if anim.watermark ~= false then
                        local script = 'aqua club'; local script_size = render.get_text_size(font.SFUIDisplay, script)

                        local lp = entity_list.get_local_player()
                        local name = 'lobby'
                        if lp ~= nil then
                            name = lp:get_name()
                            local wname = watermark_name:get()
                            if wname ~= '' then
                                name = wname
                            end
                        end

                        local text = {string.format('%s%s', '', ''), tostring(name), assistant.get_ping(), assistant.get_local_time()}
                        text = table.concat(text, '  ')

                        local size = render.get_text_size(font.SFUIDisplay, text)
                        local logo = resource.icon.logo_small
                        -- logo.size.x, logo.size.y = 20, 20

                        local gap_text = 18
                        local top_gap_text = 4

                        local pos = {
                            x = self.var.screen.x - 7,
                            y = 7,
                            w = (size.x + script_size.x + 7 * 2 + gap_text) * anim.watermark,
                            h = 20,
                        }

                        render.push_alpha_modifier(anim.watermark)
                        local round = 4
                        render.blur('visual_watermak_top_bottom', pos.x - pos.w + round - 1, pos.y, pos.w - round/2 - 4, pos.h, math.round(3 * anim.watermark))
                        render.blur('visual_watermak_left_right', pos.x - pos.w, pos.y + round, pos.w, pos.h - round/2 - 4,     math.round(3 * anim.watermark))

                        render.rect_filled(vec2_t(pos.x - pos.w, pos.y), vec2_t(pos.w, pos.h), color_t(0, 0, 0, 180), round)

                        render.push_clip(vec2_t(pos.x - pos.w, pos.y), vec2_t(pos.w, pos.h))

                        render.gradient_text(font.SFUIDisplay, script, vec2_t(pos.x - pos.w + 7 + gap_text, pos.y + top_gap_text), accent_clr:get(), color_t(255, 255, 255))
                        -- render.gradient_text(font.MuseoSans700_glow, script, vec2_t(pos.x - pos.w + 7 + gap_text, pos.y + top_gap_text+15), accent_clr, color_t(255, 255, 255), true)

                        render.text(font.SFUIDisplay, text, vec2_t(pos.x - pos.w + 7 + gap_text + script_size.x, pos.y + top_gap_text), color_t(255, 255, 255))
                        -- render.surface_text(font.MuseoSans700_glow, text, vec2_t(pos.x - pos.w + 7 + gap_text + script_size.x, pos.y + top_gap_text + 15), color_t(255, 255, 255))

                        render.texture(logo.id, vec2_t(pos.x - pos.w + 3, pos.y + pos.h / 2 - logo.size.y / 2), vec2_t(20, 20), accent_clr:get())

                        render.pop_clip()

                        render.pop_alpha_modifier()

                    end
                end

                local binds = {}; do
                    if anim.keybinds ~= false then
                        binds.max_h = 0
                        binds.max_w = 68
                        binds.is_not_nil = false
                        binds.anim_speed = 0.08
                        binds.table = assistant.get_binds(self.var.binds.path, binds.anim_speed)


                        local pos = assistant.drag_object_setup('Binds', {
                            x = kb_x:get(),
                            y = kb_y:get(),
                            w = 68,
                            h = 27
                        }); kb_x:set(pos.x); kb_y:set(pos.y)

                        if binds.table ~= nil then
                            for i, v in pairs(binds.table) do
                                if v.active then
                                    binds.is_not_nil = true
                                    local size = render.get_text_size(font.SFUIDisplay, string.format('%s', v.name)).x + 90
                                    if size > binds.max_w then
                                        binds.max_w = size
                                    end
                                    binds.max_h = i * 22 + 4
                                end
                            end
                        end

                        self.var.binds.anim.max_h = math.lerp(self.var.binds.anim.max_h, binds.max_h, binds.anim_speed)
                        self.var.binds.anim.max_w = math.lerp(self.var.binds.anim.max_w, binds.max_w, binds.anim_speed)
                        assistant.drag_object_change_size('Binds', self.var.binds.anim.max_w, 27)

                        local show = binds.is_not_nil or menu.is_open()
                        local show_anim = animation.condition_new('visual.keybinds.show', show, binds.anim_speed)
                        render.push_alpha_modifier(show_anim * anim.keybinds)

                        local round = 6
                        render.blur('visual_keybinds_division_top_bottom', pos.x + round, pos.y, math.round(self.var.binds.anim.max_w) - round*2, 27 + math.round(self.var.binds.anim.max_h), math.round(show_anim * 3 * anim.keybinds))
                        render.blur('visual_keybinds_division_right_left', pos.x, pos.y + round, math.round(self.var.binds.anim.max_w), 27 + math.round(self.var.binds.anim.max_h) - round*2, math.round(show_anim * 3 * anim.keybinds))

                        render.rect_filled(vec2_t(pos.x, pos.y), vec2_t(math.round(self.var.binds.anim.max_w), 27 + math.round(self.var.binds.anim.max_h)), color_t(0, 0, 0, 180), round)
                        local division_anim = animation.condition_new('visual.keybinds.division', binds.is_not_nil, binds.anim_speed / 1.5)
                        render.rect_filled(vec2_t(pos.x + math.round(self.var.binds.anim.max_w) / 2 - math.round((self.var.binds.anim.max_w / 2) * division_anim), pos.y + 26), vec2_t(math.round(self.var.binds.anim.max_w * division_anim), 1), color_t(255, 255, 255, math.round(division_anim * 60)))
                        render.texture(resource.icon.logo_small.id, vec2_t(pos.x + 4, pos.y + 3), vec2_t(20, 20), accent_clr:get())
                        render.gradient_text(font.SFUIDisplay, 'Binds', vec2_t(pos.x + 27, pos.y + 8), accent_clr:get(), color_t(255, 255, 255))

                        render.pop_alpha_modifier()

                        render.push_clip(vec2_t(pos.x, pos.y + 27), vec2_t(math.round(self.var.binds.anim.max_w), math.round(self.var.binds.anim.max_h)))
                        if binds.table ~= nil then
                            for i, v in pairs(binds.table) do
                                if v.anim > 0.01 then
                                    if self.var.binds.anim.gap[v.name] == nil then
                                        self.var.binds.anim.gap[v.name] = 0
                                    end; self.var.binds.anim.gap[v.name] = math.lerp(self.var.binds.anim.gap[v.name], (i) * 22, binds.anim_speed)

                                    do -- mode
                                        local icon, ipos, size

                                        if v.mode == 1 then
                                            icon = resource.icon.hold.id
                                            ipos = vec2_t(pos.x + math.round(8 * v.anim), pos.y + 13 + math.round(self.var.binds.anim.gap[v.name]))
                                            size = vec2_t(10, 10)
                                        elseif v.mode == 0 then
                                            icon = resource.icon.toggle.id
                                            ipos = vec2_t(pos.x + math.round(6 * v.anim), pos.y + 12 + math.round(self.var.binds.anim.gap[v.name]))
                                            size = vec2_t(14, 12)
                                        elseif v.mode == 2 then
                                            icon = resource.icon.hold_off.id
                                            ipos = vec2_t(pos.x + math.round(8 * v.anim), pos.y + 13 + math.round(self.var.binds.anim.gap[v.name]))
                                            size = vec2_t(10, 10)
                                        elseif v.mode == 3 then
                                            icon = resource.icon.always_on.id
                                            ipos = vec2_t(pos.x + math.round(8 * v.anim), pos.y + 13 + math.round(self.var.binds.anim.gap[v.name]))
                                            size = vec2_t(10, 10)
                                        end

                                        if icon ~= nil then
                                            local clr = accent_clr:get()
                                            render.texture(icon, ipos, size, color_t(clr.r, clr.g, clr.b, math.round(v.anim * 255 * anim.keybinds)))
                                        end
                                    end

                                    do -- secondary
                                        local right_gap = 2
                                        if v.secondary == nil then
                                            v.secondary = 'on'

                                            local size = render.get_text_size(font.SFUIDisplay, v.secondary)
                                            render.text(font.SFUIDisplay, v.secondary, vec2_t(pos.x + math.round(self.var.binds.anim.max_w) - size.x - 5 - right_gap, pos.y + 12 + math.round(self.var.binds.anim.gap[v.name])), color_t(255, 255, 255, math.round(v.anim * 255 * anim.keybinds)))
                                        elseif v.secondary == 'circle-show' then
                                            local fill = 0

                                            if v.name == 'Double Tap' then
                                                fill = exploits.get_charge() / exploits.get_max_charge()
                                                if math.is_nan(fill) then
                                                    fill = 0
                                                end
                                            end

                                            fill = fill or 0

                                            render.circle(vec2_t(pos.x + math.round(self.var.binds.anim.max_w) - 10 - right_gap, pos.y + 12 + math.round(self.var.binds.anim.gap[v.name]) + 7), 4, color_t(60, 70, 75, math.round(v.anim * 255 * anim.keybinds)), 2)
                                            render.progress_circle(vec2_t(pos.x + math.round(self.var.binds.anim.max_w) - 10 - right_gap, pos.y + 12 + math.round(self.var.binds.anim.gap[v.name]) + 7), 4, color_t(255 - math.round(155 * fill), 100 + math.round(155 * fill), 100, math.round(v.anim * 255 * anim.keybinds)), 2, fill)
                                        else
                                            local size = render.get_text_size(font.SFUIDisplay, v.secondary)
                                            render.text(font.SFUIDisplay, v.secondary, vec2_t(pos.x + math.round(self.var.binds.anim.max_w) - size.x - 5 - right_gap, pos.y + 12 + math.round(self.var.binds.anim.gap[v.name])), color_t(255, 255, 255, math.round(v.anim * 255 * anim.keybinds)))
                                        end
                                    end

                                    do -- division
                                        if i ~= 1 then
                                            render.rect_filled(vec2_t(pos.x + 10 + 16, pos.y + 12 + math.round(self.var.binds.anim.gap[v.name]) - 5), vec2_t(math.round(self.var.binds.anim.max_w * v.anim * self.var.binds.anim.start_index_division), 1), color_t(255, 255, 255, math.round(v.anim * 25 * self.var.binds.anim.start_index_division * anim.keybinds)))
                                        else
                                            self.var.binds.anim.start_index_division = v.anim
                                        end
                                    end

                                    render.text(font.SFUIDisplay, v.name, vec2_t(pos.x + 10 + math.round(16 * v.anim + 0.1), pos.y + 12 + math.round(self.var.binds.anim.gap[v.name])), color_t(255, 255, 255, math.round(v.anim * 255 * anim.keybinds)))
                                end
                            end
                        end
                        render.pop_clip()

                    end
                end

                local FL_indicator = {}; do
                    if anim.fl_indicator ~= false then
                        local state = 'GANG'
                        local ticking = 888
                        if assistant.check() then
                            if (primo_ui.rage.hideshots[2]:get() or primo_ui.rage.doubletap[2]:get()) then
                                state = 'CHARGING->>'
                                ticking = exploits.get_charge()
                                if (ticking == exploits.get_max_charge()) then
                                    state = 'SHIFTING'
                                end
                            else
                                state = 'FAKELAG'
                                ticking = engine.get_choked_commands()
                            end
                        end

                        local text_t = {
                            {'FL: '},
                            {tostring(ticking), accent_clr:get()},
                            {' | '},
                            {tostring(state)}
                        }
                        -- local text = {'FL: ', ticking, ' | ', state}
                        -- text = table.concat(text)
                        -- local tsize = render.get_text_size(font.SFUIDisplay, text)
                        local tsize = render.get_multi_text_size(font.SFUIDisplay, text_t)
                        self.var.windows.fl_indicator_max_w = tsize.x

                        local pos = {
                            x = self.var.screen.x - 18 - tsize.x,
                            y = math.round((7 + 20) * anim.on_watermark) + 7,
                            w = tsize.x,
                            h = 20,
                        }; local tgap = 5

                        render.push_alpha_modifier(anim.fl_indicator)
                        render.rect_filled(vec2_t(pos.x, pos.y), vec2_t(pos.w + tgap * 2, pos.h), color_t(0, 0, 0, 180), 4)
                        -- render.text(font.SFUIDisplay, text, vec2_t(pos.x, pos.y + 4), color_t(255, 255, 255))
                        render.multi_text(font.SFUIDisplay, vec2_t(pos.x + tgap, pos.y + 4), text_t)
                        render.pop_alpha_modifier()
                    else
                        self.var.windows.fl_indicator_max_w = 0
                    end
                end

                local FAKE_indicator = {}; do
                    if anim.fake_indicator ~= false then
                        -- local text = string.format('FAKE: (%s)', antiaim.get_max_desync_range())
                        local text_t = {
                            {'FAKE: ('},
                            {tostring(assistant.check() and antiaim.get_max_desync_range() or 1700), accent_clr:get()},
                            {'°)'},
                        }
                        -- local tsize = render.get_text_size(font.SFUIDisplay, text)
                        local tsize = render.get_multi_text_size(font.SFUIDisplay, text_t)

                        local pos = {
                            x = self.var.screen.x - 13 - animation.new('visuals.fake_indicator.fix_jittering', self.var.windows.fl_indicator_max_w, self.var.windows.fl_indicator_max_w, 0.05) - tsize.x - (anim.fl_indicator ~= false and 15 or 0),
                            y = math.round((7 + 20) * anim.on_watermark) + 7,
                            w = tsize.x,
                            h = 20,
                        }; local tgap = 5

                        render.push_alpha_modifier(anim.fake_indicator)
                        render.rect_filled(vec2_t(pos.x - tgap, pos.y), vec2_t(pos.w + tgap * 2, pos.h), color_t(0, 0, 0, 180), 4)
                        render.multi_text(font.SFUIDisplay, vec2_t(pos.x, pos.y + 4), text_t)
                        render.pop_alpha_modifier()
                    end
                end
            end,
            indicators_crosshair = function()
                local anim = animation.on_enable('visual.indicators_under_crosshair', indicators_crosshair:get(), 0.05)
                if not anim then
                    return
                end

                local lp = entity_list.get_local_player()
                if not lp then
                    return
                end
                local is_scoped = animation.condition_new('visual.indicators.is_scoped', lp:get_prop('m_bIsScoped') ~= 0, 0.05)

                local pos = {
                    x = self.var.screen.x / 2 + math.round(is_scoped * 32),
                    y = self.var.screen.y / 2 + 20,
                }

                local side = antiaim.get_desync_side() or 0

                local clr_l = side ~= 0 and (side == 1 and accent_clr:get() or indicators_crosshair_clr:get()) or accent_clr:get()
                local clr_r = side ~= 0 and (side == 1 and indicators_crosshair_clr:get() or accent_clr:get()) or accent_clr:get()

                clr_l = animation.new('visual.indicators.side', clr_l, clr_l, 0.05)
                clr_r = animation.new('visual.indicators.side_inverted', clr_r, clr_r, 0.05)

                render.push_alpha_modifier(anim)

                render.gradient_text(font.sCalibriBold16Glow, 'aqua club', vec2_t(pos.x + 1, pos.y), clr_l, clr_r, true, true)
                render.gradient_text(font.sCalibriBold16, 'aqua club', vec2_t(pos.x + 1, pos.y), clr_l, clr_r, true, true)

                local condition = assistant.get_condition()
                if not condition then
                    condition = 'gang'
                end

                render.surface_text(font.sVerdanaBold12, condition:lower(), vec2_t(pos.x, pos.y + 14), color_t(255, 255, 255), {true})

                for i, v in pairs(assistant.get_binds(self.var.indicators.path, 0.1)) do
                    -- if v.active
                    if v.anim > 0.01 then
                        render.surface_text(font.sSmallPixel710, v.name, vec2_t(pos.x, pos.y + 24 + (i - 1) * 8), color_t(255, 255, 255, math.round(255 * v.anim)), {true})
                    end
                end
                render.pop_alpha_modifier()
            end,
            log_handler = function()
                local logs = animation.on_enable('visual.logs', logs:get() and assistant.check(), 0.05)
                if not logs then
                    return
                end

                local pos = {
                    x = self.var.screen.x / 2,
                    y = self.var.screen.y / 2 + 180,
                }

                local anim_speed = 0.08
                local max_logs = 5 + 1

                for i, v in pairs(self.var.log_t.data) do
                    local anim = animation.on_enable('misc.logs.'..v.stamp, v.time > globals.cur_time() and not v.is_max, v.is_max and (anim_speed * 2) or anim_speed)

                    -- if anim
                    if max_logs == i then
                        if i == 1 then
                            table.remove(self.var.log_t.data, i)
                        end
                    end
                    if not anim then
                        table.remove(self.var.log_t.data, i)
                        self.var.log_t.anim[v.stamp] = nil
                        goto proceed
                    end

                    if max_logs == i then
                        self.var.log_t.data[1].is_max = true
                    end

                    render.push_alpha_modifier(anim * logs)

                    local gap = (i - 1) * 30 * anim
                    if self.var.log_t.anim[v.stamp] == nil then
                        self.var.log_t.anim[v.stamp] = (i ~= 1 and self.var.log_t.anim[v.stamp - 1] or 0)
                    end; self.var.log_t.anim[v.stamp] = math.lerp(self.var.log_t.anim[v.stamp], gap, anim_speed)

                    local text_t = v.data.text_t
                    local size = render.get_multi_text_size(font.SFUIDisplay, text_t)

                    local rect = {}; do
                        rect.size = { x = 10, y = 7 }
                        rect.pos = {
                            x = pos.x - size.x / 2 - rect.size.x / 2,
                            y = pos.y - size.y / 2 - rect.size.y / 2
                        }
                        rect.size = {
                            x = rect.size.x + size.x,
                            y = rect.size.y + size.y
                        }
                    end
                    local free_place = 18
                    local on_start = math.round(anim * 10)
                    local pfix = 3

                    render.rect_filled(vec2_t(rect.pos.x + on_start - free_place - on_start / 2 + pfix, rect.pos.y + math.round(self.var.log_t.anim[v.stamp])), vec2_t(rect.size.x + free_place, rect.size.y), color_t(0, 0, 0, 180), 6)

                    render.multi_text(font.SFUIDisplay, vec2_t(pos.x + on_start - on_start / 2 + pfix, pos.y + math.round(self.var.log_t.anim[v.stamp]) - 12), text_t, math.round(anim * 255), {true, true})
                    render.texture(v.data.icon.id, vec2_t(rect.pos.x - 11 + on_start - 10 + pfix + 3, rect.pos.y + 3 + math.round(self.var.log_t.anim[v.stamp])), vec2_t(14 + (v.data.icon.size.x == 24 and 0 or 2), 14), v.data.clr)

                    render.pop_alpha_modifier()
                    ::proceed::
                end
            end,
            UIVisibleManagement = function()
                do -- aa builer
                    menu.set_group_visibility('Pitch settings', enable_aa:get())
                    menu.set_group_visibility('Yaw settings', enable_aa:get())
                    menu.set_group_visibility('Desync settings', enable_aa:get())
                    menu.set_group_visibility('Fakelag settings', enable_aa:get())
                    for k, v in pairs(aa) do
                        if k ~= 'condition' then
                            for var_name, item in pairs(v) do
                                if k == 'Global' and var_name == 'override' then
                                    item:set(true)
                                    goto proceed
                                end

                                if v.override:get() and k == condition:get_active_item_name() then
                                    item:set_visible(true)

                                    do -- yaw
                                        local yaw_option = v.yaw_option:get(); v.yaw_option_value:set_visible(yaw_option ~= 1 and yaw_option ~= 2 and yaw_option ~= 3 and yaw_option ~= 7)
                                        v.yaw_base:set_visible(yaw_option ~= 1)
                                        v.yaw_start:set_visible(yaw_option ~= 1)
                                        v.yaw_end:set_visible(yaw_option ~= 1 and yaw_option ~= 2)
                                        v.yaw_inverter:set_visible(yaw_option ~= 1 and yaw_option ~= 2 and yaw_option ~= 5 and yaw_option ~= 6 and yaw_option ~= 7)
                                        local yaw_inverter = v.yaw_inverter:get()
                                        v.yaw_inverter_value1:set_visible(yaw_option ~= 1 and yaw_option ~= 2 and yaw_option ~= 5 and yaw_option ~= 6 and yaw_option ~= 7 and yaw_inverter ~= 1)
                                        v.yaw_inverter_value2:set_visible(yaw_option ~= 1 and yaw_option ~= 2 and yaw_option ~= 5 and yaw_option ~= 6 and yaw_option ~= 7 and yaw_inverter ~= 1 and yaw_inverter ~= 2)
                                    end

                                    do -- pitch
                                        local pitch_option = v.pitch_option:get(); v.pitch_option_value:set_visible(pitch_option ~= 1 and pitch_option ~= 2 and pitch_option ~= 3 and pitch_option ~= 7)
                                        v.pitch_start:set_visible(pitch_option ~= 1)
                                        v.pitch_end:set_visible(pitch_option ~= 1 and pitch_option ~= 2)
                                        v.pitch_inverter:set_visible(pitch_option ~= 1 and pitch_option ~= 2 and pitch_option ~= 5 and pitch_option ~= 6 and pitch_option ~= 7)
                                        local pitch_inverter = v.pitch_inverter:get()
                                        v.pitch_inverter_value1:set_visible(pitch_option ~= 1 and pitch_option ~= 2 and pitch_option ~= 5 and pitch_option ~= 6 and pitch_option ~= 7 and pitch_inverter ~= 1)
                                        v.pitch_inverter_value2:set_visible(pitch_option ~= 1 and pitch_option ~= 2 and pitch_option ~= 5 and pitch_option ~= 6 and pitch_option ~= 7 and pitch_inverter ~= 1 and pitch_inverter ~= 2)
                                    end

                                    do -- desync
                                        local desync_option = v.desync_option:get(); v.desync_option_value:set_visible(desync_option ~= 1 and desync_option ~= 2 and desync_option ~= 3 and desync_option ~= 7)
                                        v.desync_direction:set_visible(desync_option ~= 1)
                                        v.desync_anti_bruteforce:set_visible(desync_option ~= 1)
                                        v.desync_on_shot:set_visible(desync_option ~= 1)
                                        v.desync_start:set_visible(desync_option ~= 1)
                                        v.desync_end:set_visible(desync_option ~= 1 and desync_option ~= 2)
                                        v.desync_inverter:set_visible(desync_option ~= 1 and desync_option ~= 2 and desync_option ~= 5 and desync_option ~= 6 and desync_option ~= 7)
                                        local desync_inverter = v.desync_inverter:get()
                                        v.desync_inverter_value1:set_visible(desync_option ~= 1 and desync_option ~= 2 and desync_option ~= 5 and desync_option ~= 6 and desync_option ~= 7 and desync_inverter ~= 1)
                                        v.desync_inverter_value2:set_visible(desync_option ~= 1 and desync_option ~= 2 and desync_option ~= 5 and desync_option ~= 6 and desync_option ~= 7 and desync_inverter ~= 1 and desync_inverter ~= 2)
                                    end

                                    do -- fakelag
                                        local fakelag_option = v.fakelag_option:get()
                                        v.fakelag_start:set_visible(fakelag_option ~= 1)
                                        v.fakelag_end:set_visible(fakelag_option ~= 1 and fakelag_option ~= 2)
                                        v.break_lc:set_visible(fakelag_option ~= 1)
                                        v.fakelag_inverter:set_visible(fakelag_option == 3)
                                        local fakelag_inverter = v.fakelag_inverter:get()
                                        v.fakelag_inverter_value1:set_visible(fakelag_option == 3 and fakelag_inverter ~= 1)
                                        v.fakelag_inverter_value2:set_visible(fakelag_option == 3 and fakelag_inverter ~= 1)
                                    end
                                else
                                    item:set_visible(false)
                                end

                                if k == condition:get_active_item_name() then
                                    v.force_defensive:set_visible(k ~= 'Defensive')
                                end

                                ::proceed::
                            end

                            if k ~= 'Global' and k == condition:get_active_item_name() then
                                v.override:set_visible(true)
                            end
                        end
                    end
                end
                do -- windows
                    watermark_name:set_visible(watermark:get())
                end
                do -- autostrafe
                    autostrafe_smooth:set_visible(autostrafe:get())
                end
            end,
            some_updates = function()
                -- entity_list.get_local_player_or_spectating()
            end,
            clantag = function()
                if not clantag:get() then
                    if self.var.clantag_t.override == false then
                        FFI.set_clantag(' ', ' ')
                        self.var.clantag_t.override = true
                    end
                    return
                end -- check checkbox
                self.var.clantag_t.override = false

                if not assistant.check() then return end
                local curtime = math.floor(globals.cur_time() * 1.8)
                local anim = self.var.clantag_t.aqua[curtime % #self.var.clantag_t.aqua + 1]
                if self.var.clantag_t.old_time ~= curtime and (globals.tick_count() % 2) == 1 then
                    FFI.set_clantag(anim, anim)
                    self.var.clantag_t.old_time = curtime
                end
            end,
            min_dmg_indicator = function()
                local weapon = assistant.get_menu_weapon()
                local anim = animation.on_enable('visual.min_dmg_indicator', min_dmg_indicator:get() and weapon, 0.05)
                if not anim then
                    return
                end

                if weapon then
                    local default = menu.find('aimbot', weapon, 'targeting', 'min. damage'):get()
                    local override = menu.find('aimbot', weapon, 'target overrides', 'min. damage')

                    animation.new('visual.min_dmg_indicator.force_damage', default, override[2]:get() and override[1]:get() or default, 0.1)
                end

                local pos = {
                    x = self.var.screen.x / 2 + 10,
                    y = self.var.screen.y / 2 - 20 - ((animation.data['visual.indicators.is_scoped'] ~= nil and manual_arrows:get()) and math.round(animation.data['visual.indicators.is_scoped'] * 10) or 0),
                }

                render.text(font.Verdana12, tostring(math.round(animation.data['visual.min_dmg_indicator.force_damage'])), vec2_t(pos.x, pos.y), color_t(255, 255, 255, math.round(255 * anim)))
            end,
            slowed_down_indicator = function()
                local anim = animation.on_enable('visual.slowed_down_indicator', slowed_down_indicator:get(), 0.05)
                if not anim then
                    return
                end

                local lp = entity_list.get_local_player()
                if not lp then
                    return
                end

                local m_flVelocityModifier = lp:get_prop('m_flVelocityModifier') or 1
                local vm_anim = animation.condition_new('visual.slowed_down_indicator.m_flVelocityModifier', m_flVelocityModifier ~= 1 or menu.is_open(), 0.05)

                local pos = {
                    x = 300,
                    y = math.round(10 * vm_anim),
                    w = 105,
                    h = 20
                }

                render.push_alpha_modifier(vm_anim * anim) -- anim
                local rg = math.flerp_color(color_t(255, 0, 0), color_t(96, 214, 102), m_flVelocityModifier)

                render.rect_filled(vec2_t(pos.x, pos.y), vec2_t(pos.w, pos.h), color_t(0, 0, 0, 180), 5)
                render.texture(resource.icon.warning.id, vec2_t(pos.x + 5, pos.y + 3), vec2_t(14, 14), rg)
                render.rect_filled(vec2_t(pos.x + 25, pos.y + 3), vec2_t(52 * m_flVelocityModifier, pos.h - 6), color_t(255, 255, 255, 180), 4)

                local val = tostring(math.round(m_flVelocityModifier * 100)) .. '%'
                render.text(font.SmallPixel710, val, vec2_t(pos.x + 82, pos.y + 5), color_t(255, 255, 255))

                render.pop_alpha_modifier()

                -- render.rect_filled(vec2_t(pos.x, pos.y), vec2_t(pos.w, pos.h), color_t(0, 0, 0, 180), 6)

                -- render.push_clip(vec2_t(pos.x, pos.y), vec2_t(pos.w * m_flVelocityModifier, pos.h))
                -- render.rect_filled(vec2_t(pos.x, pos.y), vec2_t(pos.w, pos.h), color_t(255, 255, 255, 255 ), 6)
                -- render.pop_clip()

                -- local val = tostring(math.round(m_flVelocityModifier * 100)) .. '%'
                -- render.text(font.SmallPixel710, val, vec2_t(pos.x + pos.w * m_flVelocityModifier - render.get_text_size(font.SmallPixel710, val).x, pos.y + 5), math.flerp_color(color_t(255, 0, 0), color_t(0, 255, 0), m_flVelocityModifier))

                -- render.texture(resource.icon.warning.id, vec2_t(pos.x + 5, pos.y + 3), vec2_t(14, 14), accent_clr:get())
            end,
            manual_arrows = function()
                local anim = animation.on_enable('visual.manual_arrows', manual_arrows:get(), 0.05)
                if not anim then
                    return
                end

                local lp = entity_list.get_local_player()
                if not lp then
                    return
                end
                local manual = antiaim.get_manual_override()
                local side = antiaim.get_desync_side()
                local is_scoped = animation.condition_new('visual.indicators.is_scoped', lp:get_prop('m_bIsScoped') ~= 0, 0.05)

                local pos = {
                    x = self.var.screen.x / 2,
                    y = self.var.screen.y / 2 - math.round(is_scoped * 10)
                }; local gap, size = 26, 10

                render.push_alpha_modifier(anim)

                render.triangle_filled(vec2_t.new(pos.x - gap, pos.y), size, manual == 1 and manual_arrows_clr:get() or color_t.new(0, 0, 0, 200), -90)
                render.rect_filled(vec2_t(pos.x - gap + 3, pos.y - (size + 2) / 2), vec2_t(2, size + 2), side == 1 and accent_clr:get() or color_t(0, 0, 0, 200))

                render.triangle_filled(vec2_t.new(pos.x + gap, pos.y), size, manual == 3 and manual_arrows_clr:get() or color_t.new(0, 0, 0, 200), 90)
                render.rect_filled(vec2_t(pos.x + gap - 5, pos.y - (size + 2) / 2), vec2_t(2, size + 2), side == 2 and accent_clr:get() or color_t(0, 0, 0, 200))

                render.pop_alpha_modifier()
            end,
        }

        callbacks.add(e_callbacks.PAINT, function()
            for _, f in pairs(f) do
                f()
            end
        end)
    end,
    ON_SHOT = function(self)
        do -- helper
            self.insert_log = function(data, speed)
                self.var.log_t.stamp = self.var.log_t.stamp + 1
                table.insert(self.var.log_t.data, {
                    data = data,
                    time = globals.cur_time() + (speed or 4),
                    stamp = self.var.log_t.stamp,
                    is_max = false,
                })
            end
        end

        local f_hit = {
            log_shoot = function(log)
                local player = log.player

                local name = player:get_name()
                local hitgroup = self.var.hitgroup_t[log.hitgroup]
                local damage = tostring(log.damage)
                local safepoint = tostring(log.safepoint)

                local backtrack = tostring(log.backtrack_ticks)
                local aim_hitgroup = self.var.hitgroup_t[log.aim_hitgroup]
                local aim_safepoint = tostring(log.aim_safepoint)
                local aim_damage = tostring(log.aim_damage)

                local t_clr = color_t(160, 160, 160)
                local a_clr = color_t(112, 255, 135)

                local icon = resource.icon.hit

                if not player:is_alive() then
                    icon = resource.icon.skull
                end
                if hitgroup == 'head' and not player:is_alive() then
                    icon = resource.icon.headshot
                end

                cprint('['); cprint('aqua', accent_clr:get()); cprint(']')
                if player:is_alive() then
                    cprint(' Hit '); cprint(name, a_clr); cprint(' in '); cprint(hitgroup, a_clr); cprint(' for '); cprint(damage, a_clr); cprint(' hp [')
                    cprint('aimed at '); cprint(aim_hitgroup, a_clr); cprint(' with '); cprint(aim_damage, a_clr); cprint(' hp to '); cprint(backtrack, a_clr); cprint(' bt]\n')
                    self.insert_log({
                        text_t = {
                            {'Hit ', t_clr},
                            {name, a_clr},
                            {' in ', t_clr},
                            {hitgroup, a_clr},
                            {' for ', t_clr},
                            {damage, a_clr},
                            {' hp', t_clr}
                        },
                        clr = a_clr,
                        icon = icon
                    }, 3)
                else
                    cprint(' Killed '); cprint(name, a_clr); cprint(' in '); cprint(hitgroup, a_clr)
                    cprint(' [aimed at '); cprint(aim_hitgroup, a_clr); cprint(' with '); cprint(aim_damage, a_clr); cprint(' hp to '); cprint(backtrack, a_clr); cprint(' bt]\n')
                    self.insert_log({
                        text_t = {
                            {'Killed ', t_clr},
                            {name, a_clr},
                            {' in ', t_clr},
                            {hitgroup, a_clr},
                        },
                        clr = a_clr,
                        icon = icon
                    }, 3)
                end
            end
        }
        local f_miss = {
            log_shoot = function(log)
                local player = log.player
                if not player then
                    return
                end

                local name = player:get_name()
                local reason = log.reason_string

                local backtrack = tostring(log.backtrack_ticks)
                local aim_hitbox = self.var.hitgroup_t[log.aim_hitgroup]
                local aim_safepoint = tostring(log.aim_safepoint)
                local aim_hitchance = tostring(log.aim_hitchance)

                local t_clr = color_t(160, 160, 160)
                local a_clr = color_t(112, 255, 135)
                local icon = resource.icon.logo_small
                --server rejection

                cprint('['); cprint('aqua', accent_clr:get()); cprint(']')
                if reason == 'spread' then
                    a_clr = color_t(255, 159, 70)
                    icon = resource.icon.spread
                elseif reason == 'spread (missed safe)' then
                    a_clr = color_t(255, 159, 70)
                    icon = resource.icon.spread
                elseif reason == 'dormant aimbot' then
                    a_clr = color_t(97, 0, 255)
                    icon = resource.icon.occlusion
                elseif reason == 'resolver' then
                    a_clr = color_t(255, 0, 0)
                    icon = resource.icon.resolver
                elseif reason == 'extrapolation' then
                    a_clr = color_t(255, 75, 102)
                    icon = resource.icon.extrapolation
                elseif reason == 'out of reach' then
                    a_clr = color_t(153, 230, 255)
                    icon = resource.icon.bounds
                elseif reason == 'ping (local death)' then
                    a_clr = color_t(255, 255, 255)
                    icon = resource.icon.signal
                elseif reason == 'ping (target death)' then
                    a_clr = color_t(255, 255, 255)
                    icon = resource.icon.signal
                elseif reason == 'jitter' then
                    a_clr = color_t(254, 95, 76)
                    icon = resource.icon.jitter
                elseif reason == 'occlusion' then
                    a_clr = color_t(148, 54, 255)
                    icon = resource.icon.occlusion
                end

                cprint(' Miss '); cprint(name, a_clr); cprint('`s '); cprint(aim_hitbox, a_clr); cprint(' due to '); cprint(reason, a_clr)
                cprint(' [safe: '); cprint(aim_safepoint, a_clr); cprint(' bt: '); cprint(backtrack, a_clr); cprint(' hc: '); cprint(aim_hitchance, a_clr); cprint(']\n')

                self.insert_log({
                    text_t = {
                        {'Missed ', t_clr},
                        {name, a_clr},
                        {'`s ', t_clr},
                        {aim_hitbox, a_clr},
                        {' due to ', t_clr},
                        {reason, a_clr}
                    },
                    clr = a_clr,
                    icon = icon,
                }, 3)
            end
        }
        -- local f_shoot = {
        --     -- log_shoot = function(log)
        --     --     local player = log.player

        --     --     local name = player:get_name()
        --     --     local hitbox = self.var.hitboxes_t[log.hitbox]
        --     --     local damage = tostring(log.damage)

        --     --     self.insert_log({
        --     --         log = 'hit',
        --     --         name = name,
        --     --         hitbox = hitbox,
        --     --         damage = damage,
        --     --         icon = resource.icon.hit
        --     --     })

        --     --     local clr = color_t(112, 255, 135)

        --     --     cprint('['); cprint('aqua', accent_clr:get()); cprint('] ')

        --     --     cprint('reached ')
        --     --     cprint(name, clr)
        --     --     cprint(' in ')
        --     --     cprint(hitbox, clr)
        --     --     cprint(' for ')
        --     --     cprint(damage, clr)
        --     --     cprint('hp')

        --     --     cprint('\n')
        --     -- end
        -- } -- hit (112, 255, 135) miss (255, 98, 131)


        callbacks.add(e_callbacks.AIMBOT_HIT, function(log)
            for _, v in pairs(f_hit) do
                v(log)
            end
        end)
        callbacks.add(e_callbacks.AIMBOT_MISS, function(log)
            for _, v in pairs(f_miss) do
                v(log)
            end
        end)
        -- callbacks.add(e_callbacks.AIMBOT_SHOOT, function(log)
        --     for _, v in pairs(f_shoot) do
        --         v(log)
        --     end
        -- end)
    end,
    EVENT = function(self)
        local f = {
            log_shoot = function(e)
                if e.name == 'player_hurt' then
                    local logs = animation.on_enable('visual.logs', logs:get() and assistant.check(), 0.05)
                    if not logs then
                        return
                    end

                    local lp = entity_list.get_local_player()
                    local hit_player = entity_list.get_player_from_userid(e.userid)
                    local attacker = entity_list.get_player_from_userid(e.attacker)

                    -- print(player, attacker)
                    if not hit_player then
                        return
                    end
                    if not attacker then
                        return
                    end

                    if not hit_player:is_player() then
                        return
                    end
                    if not attacker:is_player() then
                        return
                    end

                    -- if (attacker:get_index() == entity_list.get_local_player():get_index() and entity:get_index() ~= entity_list.get_local_player():get_index()) then

                    local name = hit_player:get_name()
                    local at_name = attacker:get_name()
                    local damage = tostring(e.dmg_health)
                    local hitgroup = self.var.hitgroup_t[e.hitgroup]

                    local item = e.weapon
                    local text_t = {}
                    local icon = resource.icon.logo_small
                    local t_clr = color_t(160, 160, 160)
                    local a_clr = color_t(112, 255, 135)

                    local nade

                    if hit_player == lp and attacker ~= lp then
                        cprint('['); cprint('aqua', accent_clr:get()); cprint(']')
                        cprint(' Harmed by '); cprint(at_name, a_clr); cprint(' in '); cprint(hitgroup, a_clr); cprint(' for '); cprint(damage, a_clr); cprint(' hp\n')
                        a_clr = color_t(219, 83, 69)
                        icon = resource.icon.harmed
                        text_t = {
                            {'Harmed by ', t_clr},
                            {at_name, a_clr},
                            {' in ', t_clr},
                            {hitgroup, a_clr},
                            {' for ', t_clr},
                            {damage, a_clr},
                            {' hp', t_clr}
                        }

                        goto proceed
                    end

                    if attacker == lp and hit_player ~= lp then
                        if item == 'inferno' then
                            icon = resource.icon.molotov
                            a_clr = color_t(255, 218, 0)
                            nade = true
                        elseif item == 'hegrenade' then
                            icon = resource.icon.he_grenade
                            a_clr = color_t(164, 15, 0)
                            nade = true
                        end
                        if nade then
                            cprint('['); cprint('aqua', accent_clr:get()); cprint(']')
                            cprint(' Naded '); cprint(name, a_clr); cprint('`s for '); cprint(damage, a_clr); cprint(' hp\n')
                            text_t = {
                                {'Naded ', t_clr},
                                {name, a_clr},
                                {'`s for ', t_clr},
                                {damage, a_clr},
                                {' hp', t_clr}
                            }
                        end

                        goto proceed
                    end

                    ::proceed::
                    if #text_t == 0 then
                        return
                    end


                    self.insert_log({
                        text_t = text_t,
                        clr = a_clr,
                        icon = icon
                    }, 1.5)
                end
            end
        }

        callbacks.add(e_callbacks.EVENT, function(event)
            for _, v in pairs(f) do
                -- v(event)
                -- safecall('arar', true, v, event)
                v(event)
            end
        end)
    end,
    CREATE_MOVE = function(self)
        local f = {
            update_choke = function()
                if engine.get_choked_commands() == 0 then
                    assistant.choke_b = not assistant.choke_b
                end
            end,
            autostrafe_smooth_h = function(cmd)
                if not autostrafe:get() then
                    return
                end

                local lp = entity_list.get_local_player()
                if not lp then
                    return
                end

                local flag = lp:get_prop('m_fFlags')
                if flag == 256 or flag == 262 then -- in air
                    local speed =  assistant.get_velocity(lp):length2d() / autostrafe_smooth:get()

                    if input.is_key_held(e_keys.KEY_W) then
                        cmd.move.x = cmd.move.x + speed
                    end
                    if input.is_key_held(e_keys.KEY_A) then
                        cmd.move.y = cmd.move.y - speed
                    end
                    if input.is_key_held(e_keys.KEY_D) then
                        cmd.move.y = cmd.move.y + speed
                    end
                    if input.is_key_held(e_keys.KEY_S) then
                        cmd.move.x = cmd.move.x - speed
                    end
                end

            end
        }

        callbacks.add(e_callbacks.SETUP_COMMAND, function(cmd)
            for _, v in pairs(f) do
                v(cmd)
            end
        end)
    end,
    ANTI_AIM = function(self)
        local f = {
            animation_breakers = function(ctx)
                local on = animbreakers -- {'Pitch 0 on land', 'Backwards legs', 'Static legs in air', 'Move lean'}
                local con = assistant.get_condition()
                -- print(con)

                if on:get(1) then
                    if con == 'AIR' or con == 'AIR-C' then
                        self.var.animation_breakers.ticks_on_land = globals.tick_count() + 30
                    else
                        if self.var.animation_breakers.ticks_on_land > globals.tick_count() then
                            ctx:set_render_pose(e_poses.BODY_PITCH, 0.5) -- pitch 0
                        end
                    end
                end

                if on:get(2) then
                    ctx:set_render_pose(e_poses.RUN, 0) -- backwards legs
                end

                if on:get(3) then
                    if con == 'AIR' or con == 'AIR-C' then
                        ctx:set_render_pose(e_poses.JUMP_FALL, 1) -- static in air
                    end
                end

                if on:get(4) then
                    if assistant.get_velocity(entity_list.get_local_player()):length2d() ~= 0 then
                        ctx:set_render_animlayer(e_animlayers.LEAN, 1) -- move lean
                    end
                    -- print(assistant.get_velocity(entity_list.get_local_player()))
                end
            end,
            anti_backstab = function(ctx)
                self.var.anti_backstab.is_working = false
                if not aa_tweaks:get(1) then
                    return
                end

                -- math.get_closest_player
                local closest_enemy = math.get_closest_player({
                    Distance = 277,
                    Teammate = false,
                    Enemy = true,
                    Allow_dead = false,
                    Allow_dormant = false,
                    Weapon = 'knife',
                })

                if closest_enemy then
                    ctx:set_yaw(math.yaw_to_player(closest_enemy, true))
                    self.var.anti_backstab.is_working = true
                end
            end,
            edge_yaw = function(ctx)
                if not edge_yaw_bind:get() then
                    return
                end

                if self.var.anti_backstab.is_working then
                    return
                end

                local lp = entity_list.get_local_player()
                if not lp then
                    return
                end

                if engine.get_choked_commands() == 0 then
                    self.var.edge_yaw.start = lp:get_eye_position()
                end

                local info = {}; for yaw = 0, 360, 45 do
                    local edge_angle = math.angle_to_forward(vec3_t(0, math.normalize(yaw), 0))
                    local final = self.var.edge_yaw.start + vec3_t(edge_angle.x * 198, edge_angle.y * 198, edge_angle.z * 198)

                    local trace = trace.line(self.var.edge_yaw.start, final, lp, 0x46004003)
                    if trace.entity and trace.entity:get_class_name() == 'CWorld' and trace.fraction < 0.2 then
                        table.insert(info, final)
                    end
                end

                if #info == 0 then
                    return
                end

                if #info ~= 1 then
                    local center = math.flerp_vector(info[1], info[#info], 0.5)
                    local edge_angle = (self.var.edge_yaw.start - center):to_angle()
                    ctx:set_yaw(edge_angle.y - 180)
                end
            end,
            anti_aim = function(ctx)
                if not enable_aa:get() then
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
                }

                info.override = aa[info.current_condition].override:get()
                info.force_defensive = aa[info.current_condition].force_defensive:get()

                local current, defensive = {}, {}; do
                    for k, v in pairs(aa[info.current_condition]) do
                        current[k] = info.override and v or aa['Global'][k]
                        defensive[k] = info.force_defensive and v or aa['Global'][k]
                    end
                end

                local force_defensive; do
                    force_defensive = defensive.force_defensive:get()
                end; if force_defensive then exploits.force_anti_exploit_shift() end

                local inverter_f = function(start, final, inverter, inverter_value1, inverter_value2)
                    if inverter == 1 then
                        return assistant.get_choke_bool() and true or false
                    elseif inverter == 2 then
                        return (assistant.get_choke_bool() and (globals.tick_count() % inverter_value1 > 1)) and true or false
                    elseif inverter == 3 then
                        return (globals.tick_count() % math.max(inverter_value1, inverter_value2) < math.min(inverter_value1, inverter_value2)) and true or false
                    elseif inverter == 4 then
                        return (math.random(1, math.max(inverter_value1, inverter_value2)) < math.min(inverter_value1, inverter_value2)) and true or false
                    end
                end
                local set_desync = function(value, peek_mode)
                    value = value * -1
                    local fval = math.flerp_inverse(0, 100, value)
                    value = math.abs(value)
                    primo_ui.antiaim.desync_left_amount:set(value)
                    primo_ui.antiaim.desync_right_amount:set(value)

                    if not peek_mode then
                        primo_ui.antiaim.desync_side:set(fval <= 0 and 2 or 3)
                    else
                        primo_ui.antiaim.desync_peek_side:set(fval <= 0 and 1 or 2)
                    end
                end

                do -- pitch
                    local start, final = current.pitch_start:get(), current.pitch_end:get()
                    local pitch = start

                    local option = current.pitch_option:get()
                    if option == 1 then
                        primo_ui.antiaim.pitch:set(1)
                        goto proceed
                    end; local option_value = current.pitch_option_value:get()

                    if option ~= 2 then
                        local inverter = not inverter_f(start, final, current.pitch_inverter:get(), current.pitch_inverter_value1:get(), current.pitch_inverter_value2:get())

                        if option == 3 then
                            pitch = inverter and start or final
                        elseif option == 4 then
                            pitch = assistant.nWay('yaw.'..info.current_condition, final, start, inverter, option_value)
                        elseif option == 5 then
                            pitch = math.move_lerp(start, final, option_value)
                        elseif option == 6 then
                            pitch = math.move_lerp(start, final, option_value, true)
                        elseif option == 7 then
                            pitch = math.random(start, final)
                        end
                    end

                    ctx:set_pitch(pitch)
                    ::proceed::
                end

                do -- yaw
                    local start, final = current.yaw_start:get(), current.yaw_end:get()
                    local yaw = start

                    local option = current.yaw_option:get()
                    if option == 1 then
                        primo_ui.antiaim.yaw_base:set(1)
                        goto proceed
                    end; local option_value = current.yaw_option_value:get()

                    -- yaw_base
                    primo_ui.antiaim.yaw_base:set(current.yaw_base:get() + 1)

                    if option ~= 2 then
                        local inverter = not inverter_f(start, final, current.yaw_inverter:get(), current.yaw_inverter_value1:get(), current.yaw_inverter_value2:get())

                        if option == 3 then
                            yaw = inverter and start or final
                        elseif option == 4 then
                            yaw = assistant.nWay('yaw.'..info.current_condition, final, start, inverter, option_value)
                        elseif option == 5 then
                            yaw = math.move_lerp(start, final, option_value)
                        elseif option == 6 then
                            yaw = math.move_lerp(start, final, option_value, true)
                        elseif option == 7 then
                            yaw = math.random(start, final)
                        end
                    end

                    primo_ui.antiaim.yaw_add:set(yaw)
                    ::proceed::
                end

                do -- desync
                    local start, final = current.desync_start:get(), current.desync_end:get()
                    local desync = start

                    do -- ofaet lishnee
                        primo_ui.antiaim.move_desync_override:set(false)
                        primo_ui.antiaim.slowwalk_desync_override:set(false)
                    end

                    local option = current.desync_option:get()
                    if option == 1 then
                        primo_ui.antiaim.desync_side:set(1)
                        goto proceed
                    end; local option_value = current.desync_option_value:get()

                    if option ~= 2 then
                        local inverter = not inverter_f(start, final, current.desync_inverter:get(), current.desync_inverter_value1:get(), current.desync_inverter_value2:get())

                        if option == 3 then
                            desync = inverter and start or final
                        elseif option == 4 then
                            desync = assistant.nWay('desync.'..info.current_condition, -start, final, inverter, option_value)
                        elseif option == 5 then
                            desync = math.move_lerp(start, final, option_value)
                        elseif option == 6 then
                            desync = math.move_lerp(start, final, option_value, true)
                        elseif option == 7 then
                            desync = math.random_float(start, final, 2)
                        end
                    end

                    if current.desync_direction:get() ~= 1 then
                        primo_ui.antiaim.desync_side:set(current.desync_direction:get() == 2 and 5 or 6)
                    end
                    primo_ui.antiaim.desync_antibrute:set(current.desync_anti_bruteforce:get())
                    primo_ui.antiaim.desync_on_shot:set(current.desync_on_shot:get())

                    set_desync(desync, current.desync_direction:get() ~= 1)
                    ::proceed::
                end

                do -- fakelag
                    local start, final = current.fakelag_start:get(), current.fakelag_end:get()
                    local fakelag = start

                    local option = current.fakelag_option:get()
                    if option == 1 then
                        primo_ui.antiaim.fakelag_amount:set(0)
                        primo_ui.antiaim.break_lc:set(false)
                        goto proceed
                    end; primo_ui.antiaim.break_lc:set(current.break_lc:get())


                    if option ~= 2 then
                        local inverter = not inverter_f(start, final, current.fakelag_inverter:get(), current.fakelag_inverter_value1:get(), current.fakelag_inverter_value2:get())

                        if option == 3 then
                            fakelag = inverter and start or final
                        elseif option == 4 then
                            fakelag = math.random(start, final)
                        end
                    end
                    -- fakelag_start = ui.slider('Fakelag settings', state_name('Start'), 1, 0, 15),
                    -- fakelag_end = ui.slider('Fakelag settings', state_name('End'), 1, 0, 15),
                    -- fakelag_option = ui.selection('Fakelag settings', state_name('Option'), {'None', 'Start', 'Start/End', 'Random'}),
                    -- fakelag_inverter = ui.selection('Fakelag settings', state_name('Inverter'), {'Choke', 'Adjustable', 'Tick', 'Random'}),
                    -- fakelag_inverter_value1 = ui.slider('Fakelag settings', state_name('- inverter value 1'), 3, 2, 36),
                    -- fakelag_inverter_value2 = ui.slider('Fakelag settings', state_name('- inverter value 2'), 3, 2, 36),

                    primo_ui.antiaim.fakelag_amount:set(fakelag)
                    ::proceed::
                end
            end,
        }

        callbacks.add(e_callbacks.ANTIAIM, function(ctx)
            for _, v in pairs(f) do
                v(ctx)
            end
        end)
    end,
    HIT_SCAN = function(self)
        local f = {
            force_baim_lethal = function(ctx, cmd, unpredicted_data)
                if not force_baim_lethal:get() then
                    return
                end

                local lp = entity_list.get_local_player()
                if not lp then
                    return
                end

                local weapon = assistant.get_weapon_group(lp)
                if not weapon then
                    return
                end

                local specified_dmg = {
                    ['auto'] = 70,
                    ['scout'] = 90,
                    ['awp'] = 0,
                    ['deagle'] = 45,
                    ['revolver'] = 90,
                    ['pistols'] = 0,
                    ['other'] = 0,
                }

                if not (ctx.health <= specified_dmg[weapon]) then
                    return
                end

                ctx:set_hitscan_group_state(e_hitscan_groups.HEAD, false)
                ctx:set_hitscan_group_state(e_hitscan_groups.STOMACH, true, true)
            end
        }

        callbacks.add(e_callbacks.HITSCAN, function(ctx, cmd, unpredicted_data)
            for _, v in pairs(f) do
                v(ctx, cmd, unpredicted_data)
            end
        end)
    end,
    var = function(self)
        self.var = {
            screen = render.get_screen_size(),
            animation_breakers = {
                ticks_on_land = 0,
            },
            anti_backstab = {
                is_working = false,
            },
            edge_yaw = {
                start = vec3_t()
            },
            clantag_t = {
                override = true,
                old_time = false,
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
                }
            },
            binds = {
                path = {
                    { name = 'Double Tap',         path = menu.find('aimbot', 'general', 'exploits', 'doubletap', 'enable') },
                    { name = 'Disable DT Charge',  path = menu.find('aimbot', 'general', 'exploits', 'doubletap', 'dont use charge') },
                    { name = 'Instant Recharge',   path = menu.find('aimbot', 'general', 'exploits', 'exploits', 'instant recharge') },
                    { name = 'Hide Shots',         path = menu.find('aimbot', 'general', 'exploits', 'hideshots', 'enable') },
                    { name = 'Auto Peek',          path = menu.find('aimbot', 'general', 'misc', 'autopeek') },
                    { name = 'Roll Resolver',      path = menu.find('aimbot', 'general', 'aimbot', 'body lean resolver') },
                    { name = 'Resolver Override',  path = menu.find('aimbot', 'general', 'aimbot', 'override resolver') },
                    { name = 'Dormant Aimbot',     path = menu.find('aimbot', 'general', 'dormant aimbot', 'enable') },
                    { name = 'Fake Ping',          path = menu.find('aimbot', 'general', 'fake ping', 'enable') },

                    { name = 'Force Damage',       path_uniq = {'target overrides', 'min. damage'} },
                    { name = 'Hitchance Override', path_uniq = {'target overrides', 'hitchance'} },
                    { name = 'Lethal Shot',        path_uniq = {'target overrides', 'lethal shot'} },
                    { name = 'Hitbox Override',    path_uniq = {'target overrides', 'hitbox'} },
                    { name = 'Safe Point',         path_uniq = {'target overrides', 'safepoint'} },
                    { name = 'Roll Safe Point',    path_uniq = {'target overrides', 'body lean safepoint'} },

                    -- { name = 'Extended Angles',   path = menu.find('antiaim', 'main', 'extended angles', 'enable') },
                    { name = 'Yaw Freestand',      path = menu.find('antiaim', 'main', 'auto direction', 'enable') },
                    { name = 'Fake Duck',          path = menu.find('antiaim', 'main', 'general', 'fakeduck') },
                    { name = 'Edge Yaw',           path_script = edge_yaw_bind },
                    -- { name = 'Yaw Left',           path = menu.find('antiaim', 'main', 'manual', 'left') },
                    -- { name = 'Yaw Right',          path = menu.find('antiaim', 'main', 'manual', 'right') },
                    -- { name = 'Yaw Back',           path = menu.find('antiaim', 'main', 'manual', 'back') },
                    { name = 'Invert Desync',      path = menu.find('antiaim', 'main', 'manual', 'invert desync') },
                    { name = 'Invert Roll',        path = menu.find('antiaim', 'main', 'manual', 'invert body lean') },

                    -- { name = 'Thirdperson',        path = menu.find('visuals', 'view', 'thirdperson', 'enable') },

                    { name = 'Slow Walk',          path = menu.find('misc', 'main', 'movement', 'slow walk') },
                    { name = 'Edge Jump',          path = menu.find('misc', 'main', 'movement', 'edge jump') },
                    { name = 'Sneak',              path = menu.find('misc', 'main', 'movement', 'sneak') },
                    { name = 'Edge Bug',           path = menu.find('misc', 'main', 'movement', 'edge bug helper') },
                    { name = 'Jump Bug',           path = menu.find('misc', 'main', 'movement', 'jump bug') },
                    { name = 'GH Auto Throw',      path = menu.find('misc', 'nade helper', 'general', 'autothrow') },
                },
                anim = {
                    gap = {},
                    max_h = 0,
                    max_w = 68,
                    start_index_division = 0
                }
            },
            windows = {
                fl_indicator_max_w = 0,
            },
            indicators = {
                path = {
                    { name = 'DT',         path = menu.find('aimbot', 'general', 'exploits', 'doubletap', 'enable') },
                    { name = 'HS',         path = menu.find('aimbot', 'general', 'exploits', 'hideshots', 'enable') },
                    { name = 'AP',          path = menu.find('aimbot', 'general', 'misc', 'autopeek') },
                    { name = 'DA',     path = menu.find('aimbot', 'general', 'dormant aimbot', 'enable') },
                    { name = 'DMG',       path_uniq = {'target overrides', 'min. damage'} },
                    { name = 'SAFE',         path_uniq = {'target overrides', 'safepoint'} },
                    { name = 'FD',          path = menu.find('antiaim', 'main', 'general', 'fakeduck') },
                }
            },
            log_t = {
                data = {},
                anim = {},
                stamp = 0,
            },
            hitboxes_t = {
                [e_hitboxes.HEAD] = 'head',
                [e_hitboxes.NECK] = 'neck',
                [e_hitboxes.PELVIS] = 'pelvis',
                [e_hitboxes.BODY] = 'body',
                [e_hitboxes.THORAX] = 'thorax',
                [e_hitboxes.CHEST] = 'chest',
                [e_hitboxes.UPPER_CHEST] = 'upper_chest',
                [e_hitboxes.RIGHT_THIGH] = 'right thigh',
                [e_hitboxes.LEFT_THIGH] = 'left thigh',
                [e_hitboxes.RIGHT_CALF] = 'right calf',
                [e_hitboxes.LEFT_CALF] = 'left calf',
                [e_hitboxes.RIGHT_FOOT] = 'right foot',
                [e_hitboxes.LEFT_FOOT] = 'left foot',
                [e_hitboxes.RIGHT_HAND] = 'right hand',
                [e_hitboxes.LEFT_HAND] = 'left hand',
                [e_hitboxes.RIGHT_UPPER_ARM] = 'right upper arm',
                [e_hitboxes.RIGHT_FOREARM] = 'right forearm',
                [e_hitboxes.LEFT_UPPER_ARM] = 'left upper arm',
                [e_hitboxes.LEFT_FOREARM] = 'left forearm',
            },
            hitgroup_t = {
                [e_hitgroups.GENERIC] = 'generic',
                [e_hitgroups.STOMACH] = 'stomach',
                [e_hitgroups.LEFT_LEG] = 'left leg',
                [e_hitgroups.GEAR] = 'gear',
                [e_hitgroups.CHEST] = 'chest',
                [e_hitgroups.RIGHT_ARM] = 'right arm',
                [e_hitgroups.NECK] = 'neck',
                [e_hitgroups.HEAD] = 'head',
                [e_hitgroups.LEFT_ARM] = 'left arm',
                [e_hitgroups.RIGHT_LEG] = 'right leg',
            }
        }
    end,
    setup = function(self)
        self:var()
        self:ANTI_AIM(self)
        self:CREATE_MOVE(self)
        self:PAINT(self)
        self:ON_SHOT(self)
        self:EVENT(self)
        self:HIT_SCAN(self)
    end
}; script:setup()
