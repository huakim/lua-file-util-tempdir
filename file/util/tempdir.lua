local File_Util_Tempdir = {}
get_os_name = require 'get_os_name'
-- DATE
-- VERSION
local jit_os = get_os_name()

local function get_tempdir()
    if jit_os == 'Windows' then
        for _, env_var in ipairs{'TMP', 'TEMP', 'TMPDIR', 'TEMPDIR'} do
            if os.getenv(env_var) then
                return os.getenv(env_var)
            end
        end
        for _, dir in ipairs{'C:\\TMP', 'C:\\TEMP'} do
            if lfs.attributes(dir, 'mode') == 'directory' then
                return dir
            end
        end
    else
        for _, env_var in ipairs{'TMPDIR', 'TEMPDIR', 'TMP', 'TEMP'} do
            if os.getenv(env_var) then
                return os.getenv(env_var)
            end
        end
        for _, dir in ipairs{'/tmp', '/var/tmp'} do
            if lfs.attributes(dir, 'mode') == 'directory' then
                return dir
            end
        end
    end
    error("Can't find any temporary directory")
end

local function get_user_tempdir()
    if jit_os == 'Windows' then
        return get_tempdir()
    else
        local dir = os.getenv('XDG_RUNTIME_DIR') or get_tempdir()
        local info = {lfs.attributes(dir)}
        if not info then
            error("Can't stat tempdir '" .. dir .. "': " .. errno())
        end
        if info[5] == os.geteuid() and bit.band(info[3], 0x022) == 0 then
            return dir
        end
        local i = 0
        while true do
            local subdir = dir .. '/' .. os.geteuid() .. (i > 0 and ('.' .. i) or '')
            local subinfo = {lfs.attributes(subdir)}
            if not subinfo then
                lfs.mkdir(subdir, 0x700)
                return subdir
            elseif subinfo[5] == os.geteuid() and bit.band(subinfo[3], 0x022) == 0 then
                return subdir
            else
                i = i + 1
            end
        end
    end
end

File_Util_Tempdir.get_tempdir = get_tempdir
File_Util_Tempdir.get_user_tempdir = get_user_tempdir

return File_Util_Tempdir
