local File_Util_Tempdir = {}
get_os_name = require 'get_os_name'
lfs = require 'lfs'
unistd = require 'posix.unistd'
--bit = require 'bit32'
-- DATE
-- VERSION

local function get_tempdir()
    if get_os_name() == 'Windows' then
        for _, env_var in ipairs{'TMP', 'TEMP', 'TMPDIR', 'TEMPDIR'} do
            if os.getenv(env_var) then
                return os.getenv(env_var)
            end
        end
        for _, dir in ipairs{'C:\\TMP', 'C:\\TEMP'} do
            if lfs.attributes(dir).mode == 'directory' then
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
            if lfs.attributes(dir).mode == 'directory' then
                return dir
            end
        end
    end
    error("Can't find any temporary directory")
end

local function get_user_tempdir()
    if get_os_name() == 'Windows'
    then
        return get_tempdir()
    else
        local uid = unistd.geteuid()
        local dir = os.getenv('XDG_RUNTIME_DIR')
        if dir
        then
            local info = lfs.attributes(dir)
            if info
            then
                if (info.uid==uid) and (info.permissions:sub(0,3)=='rwx')
                then
                    return dir
                end
            end
        end

        dir = get_tempdir()
        local i = 0
        while true do
            local subdir = dir..'/'..uid..(i>0 and ('.'..i) or '')
            local subinfo = lfs.attributes(subdir)
            if not subinfo
            then
                lfs.mkdir(subdir)
                return subdir
            elseif (subinfo.uid==uid) and (subinfo.permissions:sub(0,3)=='rwx')
            then
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
