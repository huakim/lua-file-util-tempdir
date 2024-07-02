
package = 'file-util-tempdir'
version = '0.0.1-1'
source = {
  url = "git://github.com/huakim/lua-file-util-tempdir.git",
 }
description = {
  detailed = "  ",
  homepage = "https://github.com/huakim/lua-file-util-tempdir",
  license = "LGPL",
  summary = "Get OS temporary directory",
 }
build = {
  modules = {
   ["file.util.tempdir"] = "file/util/tempdir.lua",
  },
  type = "builtin",
 }
dependencies = {
  "lua >= 5.1",
  "get_os_name",
  "luafilesystem",
  "bit32",
  "posix",
 }
