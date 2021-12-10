-- ngx.arg[1] => chunk
-- ngx.arg[2] => eof


- Large files return only the first hash (users get content from cheap bandwidth)
if ngx.ctx._switched then
  local chunk = ngx.arg[1]
  ngx.arg[1] = #chunk .. ',' .. ngx.crc32_long(chunk)
  ngx.arg[2] = true
  return
end


-Calculates the hash (for statistics) of HTTP-returned data
if ngx.ctx._sha256 == nil then
  local resty_sha256 = require 'resty.sha256'
  ngx.ctx._sha256 = resty_sha256:new()
end

if ngx.arg[2] then
  local digest = ngx.ctx._sha256:final()
  digest = digest:sub(1, 16)

  local str = require 'resty.string'
  ngx.var._bodyhash = str.to_hex(digest)
else
  ngx.ctx._sha256:update(ngx.arg[1])
end
