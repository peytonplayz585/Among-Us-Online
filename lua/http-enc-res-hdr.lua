--Functions: encoding HTTP returns
-- Stage：header_filter_by_lua
-- Remarks：
-- aceh = HTTP Returning to the Head of access-control-expose-headers Field

--Aceh always contains * regardless of browser support
local expose = '*'

-This value is true to indicate that the browser does not support aceh: * and returns a detailed list of heads
local detail = ngx.ctx._acehOld


local function addHdr(k, v)
  ngx.header[k] = v
  if detail then
    expose = expose .. ',' .. k
  end
end


local function flushHdr()
  if detail then
    if status ~= 200 then
      expose = expose .. ',--s'
    end
    - This field is not in aceh and supports * wildcards if the browser can read to
    ngx.header['--t'] = '1'
  end

  ngx.header['access-control-expose-headers'] = expose
  ngx.header['access-control-allow-origin'] = '*'

  local status = ngx.status

  --The front end preferentially uses the field as the status code
  if status ~= 200 then
    ngx.header['--s'] = status
  end

 - Keep the original status code for console debugging
- For example, 404 displays red, and if set to 200 uniformly, there is no color distinction
- Need to escape 30X redirection or not meet cors standards
  if
    status == 301 or
    status == 302 or
    status == 303 or
    status == 307 or
    status == 308
  then
    status = status + 10
  end
  ngx.status = status
end


local function nodeSwitched()
  local status = ngx.status
  if status ~= 200 and status ~= 206 then
    return false
  end

  local level = ngx.ctx._level
  if level == nil or level == 0 then
    return false
  end

  if ngx.req.get_method() ~= 'GET' then
    return false
  end

  if ngx.header['set-cookie'] ~= nil then
    return false
  end

  local resLenStr = ngx.header['content-length']
  if resLenStr == nil then
    return false
  end

  -- Resources less than 2KB do not accelerate
  local resLenNum = tonumber(resLenStr)
  if resLenNum == nil or resLenNum < 1000 * 400 then
    return false
  end


  local addr = ngx.var.upstream_addr or ''
  local etag = ngx.header['etag'] or ''
  local last = ngx.header['last-modified'] or ''

  local info = addr .. '|' .. resLenStr .. '|' .. etag .. '|' .. last

  -- clear all res headers
  local h, err = ngx.resp.get_headers()
  for k, v in pairs(h) do
    ngx.header[k] = nil
  end

  addHdr('--raw-info', info)
  addHdr('--switched', '1')

  ngx.header['cache-control'] = 'no-cache'
  ngx.var._switched = resLenStr
  ngx.ctx._switched = true

  flushHdr()
  return true
end

-- Node switching, currently in test (opened in demo)
-- if nodeSwitched() then
--  return
-- end


local h, err = ngx.resp.get_headers()
for k, v in pairs(h) do
  if
    These heads have special significance and need to be escaped --
    k == 'access-control-allow-origin' or
    k == 'access-control-expose-headers' or
    k == 'location' or
    k == 'set-cookie'
  then
    if type(v) == 'table' then
      -Repetitive fields, such as Set-Cookie
-- Converted to 1-Set-Cookie, 2-Set-Cookie, ...
      for i = 1, #v do
        addHdr(i .. '-' .. k, v[i])
      end
    else
      addHdr('--' .. k, v)
    end
    ngx.header[k] = nil

  elseif detail and
    - Non-simple headers cannot be read by fetch and need to be added to the aceh list --
    -- https://developer.mozilla.org/en-US/docs/Glossary/Simple_response_header
    k ~= 'cache-control' and
    k ~= 'content-language' and
    k ~= 'content-type' and
    k ~= 'expires' and
    k ~= 'last-modified' and
    k ~= 'pragma'
  then
    expose = expose .. ',' .. k
  end
end

-- Not caching non-GET requests
if ngx.req.get_method() ~= 'GET' then
  ngx.header['cache-control'] = 'no-cache'
end

flushHdr()
