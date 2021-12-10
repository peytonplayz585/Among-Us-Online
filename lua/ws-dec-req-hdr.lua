--Functions: Restore the HTTP request header for WebSocket
-- Phase: access_by_lua
- Note: JS cannot set the head of ws, so information is stored in query

local query, err = ngx.req.get_uri_args()

for k, v in pairs(query) do
  if k == 'url__' then
    ngx.var._url = v
  elseif k == 'ver__' then
    ngx.var._ver = v
  else
    ngx.req.set_header(k, v)
  end
end
